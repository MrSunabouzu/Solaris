/obj/structure/roguemachine/questgiver
	name = "grand quest book"
	desc = "A large wooden notice board, carrying postings from all across Sunmarch. A crow's perch sits atop it."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "questgiver"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	///Whether it's the main one, -guild-belonging-, or not. Determines accessibility, reward thresholds and cooldowns.
	var/guild = FALSE
	///Place to deposit completed scrolls or items to pawn off.
	var/input_point
	///Place to spawn scrolls or rewards at.
	var/scroll_point
	///Items that can be sold off directly through the guild.
	var/list/sellable_items = list()

	/// Timer for the quest giving cooldown.
	COOLDOWN_DECLARE(heal_timer)

/obj/structure/roguemachine/questgiver/Initialize()
	. = ..()
	SSroguemachine.questgivers += src
	input_point = locate(x, y - 1, z)
	scroll_point = locate(x, y, z)

	new /obj/effect/decal/marker_export(get_turf(input_point))

/obj/structure/roguemachine/questgiver/examine(mob/user)
	. = ..()
	if(guild)
		. += span_notice("This quest book will give <b>bigger rewards</b> if processed with the help of a <b>local guild handler</b>!")

/obj/structure/roguemachine/questgiver/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	// Main Menu
	var/list/choices = list("Consult Quests", "Turn In Quest", "Abandon Quest")

	if(guild)
		if(user.job == "Guild Handler")
			choices += list("Print Issued Quests")

	var/selection = input(user, "The Excidium listens", src) as null|anything in choices

	switch(selection)

		if("Consult Quests")
			consult_quests(user)

		if("Turn In Quest")
			turn_in_quest(user)

		if("Abandon Quest")
			abandon_quest(user)

		if("Print Issued Quests")
			print_quests(user)

///Quest generator. Requires a small deposit to spawn otherwise.
/obj/structure/roguemachine/questgiver/proc/consult_quests(mob/user)
	var/deposit
	var/scroll_icon
	var/datum/quest/attached_quest = new()

	// Has user a bank account?
	if(!(user in SStreasury.bank_accounts))
		say("You have no bank account.")
		return
	// Has user enough money?
	if(SStreasury.bank_accounts[user] < deposit)
		say("Insufficient balance funds.")
		return
	
	var/list/difficulty_choices = list("Easy", "Medium", "Hard")
	var/difficulty_selection = input(user, "Select quest difficulty", src) as null|anything in difficulty_choices
	if(!difficulty_selection)
		return
	
	// Set deposit and reward based on difficulty
	switch(difficulty_selection)
		if("Easy")
			deposit = 5
			attached_quest.reward_amount = rand(15, 25)
			scroll_icon = "scroll_quest_low"
		if("Medium")
			deposit = 10
			attached_quest.reward_amount = rand(30, 50)
			scroll_icon = "scroll_quest_mid"
		if("Hard")
			deposit = 20
			attached_quest.reward_amount = rand(60, 100)
			scroll_icon = "scroll_quest_high"
		
	// Get available quest types for selected difficulty
	var/list/type_choices
	switch(difficulty_selection)
		if("Easy")
			type_choices = list("Fetch", "Courier", "Kill", "Beacon")
		if("Medium")
			type_choices = list("Kill", "Clear Out", "Beacon")
		if("Hard")
			type_choices = list("Clear Out", "Beacon", "Miniboss")
	
	var/type_selection = input(user, "Select quest type", src) as null|anything in type_choices
	if(!type_selection)
		return
	var/obj/item/paper/scroll/quest/spawned_scroll = new(get_turf(scroll_point))
	spawned_scroll.base_icon_state = scroll_icon
	attached_quest.quest_difficulty = difficulty_selection
	attached_quest.quest_type = type_selection
	
	// Only set quest_giver if not a guild handler
	if(user.job != "Guild Handler")
		attached_quest.quest_giver_name = null
		attached_quest.quest_giver_reference = null
		attached_quest.quest_receiver_reference = WEAKREF(user)
		attached_quest.quest_receiver_name = user.real_name
	else
		attached_quest.quest_giver_name = user.real_name
		attached_quest.quest_giver_reference = WEAKREF(user)
		attached_quest.quest_receiver_reference = null
		attached_quest.quest_receiver_name = null
	
	spawned_scroll.assigned_quest = attached_quest
	attached_quest.quest_scroll_ref = WEAKREF(spawned_scroll)
	attached_quest.quest_scroll = spawned_scroll
	
	// Find an appropriate landmark for this quest
	var/obj/effect/landmark/quest_spawner/chosen_landmark
	for(var/obj/effect/landmark/quest_spawner/landmark in GLOB.landmarks_list)
		if(landmark.quest_difficulty == difficulty_selection && (type_selection in landmark.quest_type))
			chosen_landmark = landmark
			break
	
	if(chosen_landmark)
		chosen_landmark.generate_quest(attached_quest, user.job == "Guild Handler" ? null : user)
		spawned_scroll.update_quest_text()
	else
		to_chat(user, span_warning("No suitable location found for this quest!"))
		qdel(attached_quest)
		qdel(spawned_scroll)
		return
	
	SStreasury.bank_accounts[user] -= deposit
	SStreasury.treasury_value += deposit
	SStreasury.log_entries += "+[deposit] to treasury (quest deposit)"

///Turn in completed scrolls and some items if it guild-exclusive. Click your scroll on some item or a landmark where it'll spawn to activate it and make it turnable in.
/obj/structure/roguemachine/questgiver/proc/turn_in_quest(mob/user)
	var/reward
	var/original_reward
	for(var/atom/movable/pawnable_loot in input_point)
		if(istype(pawnable_loot, /obj/item/paper/scroll/quest))
			var/obj/item/paper/scroll/quest/turned_in_scroll = pawnable_loot
			if(turned_in_scroll.assigned_quest.complete)
				reward += turned_in_scroll.assigned_quest.reward_amount
				original_reward = reward
				if(guild)
					if(user.job == "Guild Handler")
						reward *= 2
				switch(turned_in_scroll.assigned_quest.quest_difficulty) //Deposit returns
					if("Easy")
						reward += 5
						original_reward += 5
					if("Medium")
						reward += 10
						original_reward += 10
					if("Hard")
						reward += 20
						original_reward += 20
				qdel(turned_in_scroll)
				qdel(turned_in_scroll.assigned_quest)
				continue

		if(guild)
			if(is_type_in_list(pawnable_loot, sellable_items))
				var/obj/item/to_sell = pawnable_loot
				if(to_sell.get_real_price() > 0)
					reward += to_sell.sellprice
					qdel(to_sell)
					continue

	cash_in(round(reward), original_reward)

///Spawn the money in.
/obj/structure/roguemachine/questgiver/proc/cash_in(reward, original_reward)
	var/to_deposit = reward
	var/bonus = reward - original_reward
	
	// Calculate how many of each coin type to spawn
	var/gold_coins = FLOOR(to_deposit / 10, 1)
	to_deposit -= gold_coins * 10
	
	var/silver_coins = FLOOR(to_deposit / 5, 1)
	to_deposit -= silver_coins * 5
	
	var/copper_coins = to_deposit
	
	// Spawn the coins at the scroll point
	if(gold_coins > 0)
		for(var/i in 1 to gold_coins)
			new /obj/item/roguecoin/gold(scroll_point)
	
	if(silver_coins > 0)
		for(var/i in 1 to silver_coins)
			new /obj/item/roguecoin/silver(scroll_point)
	
	if(copper_coins > 0)
		for(var/i in 1 to copper_coins)
			new /obj/item/roguecoin/copper(scroll_point)
	
	if(gold_coins || silver_coins || copper_coins)
		if(reward != original_reward)
			say("Your guild handler assistance-increased reward of [reward] marks has been dispensed! The difference is [bonus] marks.")
		else
			say("Your reward of [reward] marks has been dispensed.")

///Place a scroll to the left of the machine and abandon it. Check if it's complete; if it is, actually turn it in as normal. Otherwise gives your deposit back.
/obj/structure/roguemachine/questgiver/proc/abandon_quest(mob/user)
	// Check if there's a quest scroll in the input point
	var/obj/item/paper/scroll/quest/abandoned_scroll
	for(var/obj/item/paper/scroll/quest/quest_scroll in input_point)
		abandoned_scroll = quest_scroll
		break
	
	if(!abandoned_scroll)
		to_chat(user, span_warning("No quest scroll found in the input area!"))
		return
	
	var/datum/quest/quest = abandoned_scroll.assigned_quest
	if(!quest)
		to_chat(user, span_warning("This scroll doesn't have an assigned quest!"))
		return
	
	// Calculate refund amount based on difficulty
	var/refund = 0
	switch(quest.quest_difficulty)
		if("Easy")
			refund = 5
		if("Medium")
			refund = 10
		if("Hard")
			refund = 20
	
	// Don't refund if quest is complete
	if(quest.complete)
		to_chat(user, span_notice("This quest is already complete! Turning it in instead..."))
		turn_in_quest(user)
		return
	
	// Clean up courier quest items more carefully
	if(quest.quest_type == "Courier" && quest.target_delivery_item)
		// First collect all potential items to delete
		var/list/items_to_delete = list()
		
		// Find parcels and items in the world
		for(var/obj/item/parcel/P in world)
			if(P.contained_item && istype(P.contained_item, quest.target_delivery_item))
				items_to_delete += P
				continue
			else if(istype(P, quest.target_delivery_item))
				items_to_delete += P
				continue
		
		// Also check for unwrapped items
		for(var/obj/item/I in world)
			if(istype(I, quest.target_delivery_item))
				var/datum/component/quest_object/Q = I.GetComponent(/datum/component/quest_object)
				if(Q && Q.quest_ref == WEAKREF(quest))
					items_to_delete += I
		
		// Delete collected items in a controlled manner
		for(var/obj/item/to_delete in items_to_delete)
			if(!QDELETED(to_delete)) // Only delete if not already being deleted
				qdel(to_delete)
	
	// Delete the quest and scroll
	qdel(quest)
	qdel(abandoned_scroll)
	
	// Refund the deposit
	if(refund > 0)
		if(user in SStreasury.bank_accounts)
			SStreasury.bank_accounts[user] += refund
			SStreasury.treasury_value -= refund
			SStreasury.log_entries += "-[refund] from treasury (quest refund)"
			to_chat(user, span_notice("You receive a [refund] mark refund for abandoning the quest."))
		else
			// If no bank account, spawn physical coins
			cash_in(refund)
			SStreasury.treasury_value -= refund
			SStreasury.log_entries += "-[refund] from treasury (quest refund)"
			to_chat(user, span_notice("Your refund of [refund] marks has been dispensed."))

///Prints a list of issued quests, to whom and which and their current general area.
/obj/structure/roguemachine/questgiver/proc/print_quests(mob/user)
	if(!guild)
		return
	
	var/list/active_quests = list()
	
	// Gather all active quests from existing scrolls
	for(var/obj/item/paper/scroll/quest/quest_scroll in world)
		if(quest_scroll.assigned_quest && !quest_scroll.assigned_quest.complete)
			active_quests += quest_scroll
	
	if(!length(active_quests))
		say("No active quests found.")
		return
	
	// Create the report scroll
	var/obj/item/paper/scroll/report = new(get_turf(scroll_point))
	report.name = "Guild Quest Report"
	report.desc = "A list of currently active quests issued by the Adventurers' Guild."
	
	// Generate report text
	var/report_text = "<center><b>ADVENTURER'S GUILD - ACTIVE QUESTS</b></center><br><br>"
	report_text += "<i>Generated on [station_time_timestamp()]</i><br><br>"
	
	for(var/obj/item/paper/scroll/quest/quest_scroll in active_quests)
		var/datum/quest/quest = quest_scroll.assigned_quest
		var/area/quest_area = get_area(quest_scroll)
		var/area_name = quest_area ? quest_area.name : "Unknown Location"
		
		report_text += "<b>Title:</b> [quest.title].<br>"
		if(quest.quest_receiver_name) // Only show recipient if claimed
			report_text += "<b>Recipient:</b> [quest.quest_receiver_name].<br>"
		else
			report_text += "<b>Recipient:</b> Unclaimed.<br>"
		report_text += "<b>Type:</b> [quest.quest_type].<br>"
		report_text += "<b>Difficulty:</b> [quest.quest_difficulty].<br>"
		report_text += "<b>Last Known Location:</b> [area_name].<br>"
		report_text += "<b>Reward:</b> [quest.reward_amount] marks.<br><br>"
	
	report.info = report_text
	say("Quest report printed.")

/obj/structure/roguemachine/questgiver/guild
	guild = TRUE
	icon_state = "questgiver_guild"
