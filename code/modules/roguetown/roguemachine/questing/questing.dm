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
	///Items that can be sold off directly.
	var/sellable_items

	/// Timer for the quest giving cooldown.
	COOLDOWN_DECLARE(heal_timer)

/obj/structure/roguemachine/questgiver/Initialize()
	. = ..()
	SSroguemachine.questgivers += src
	input_point = locate(x - 1, y, z)
	scroll_point = locate(x, y, z)

/obj/structure/roguemachine/questgiver/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(guild)
		if(user.job != "Guild Handler")
			return

	// Main Menu
	var/list/choices = list("Consult Quests", "Turn In Quest", "Abandon Quest")

	if(guild)
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

///Quest generator. Guild one's better (permits high difficulty quests, has better rewards and takes deposit fees from the guild's fund). Requires a small deposit to spawn otherwise.
/obj/structure/roguemachine/questgiver/proc/consult_quests(mob/user)
	var/deposit
	var/obj/item/paper/scroll/quest/spawned_scroll
	var/datum/bank_account

	if(!guild) //Guildless take deposit from your bank account. Guildful take from the Guild's funds.
		// Has user a bank account?
		if(!(user in SStreasury.bank_accounts))
			say("You have no bank account.")
			return

		// Has user enough money?
		if(SStreasury.bank_accounts[user] < deposit)
			say("Insufficient balance funds.")
			return

///Turn in completed scrolls and some items. Click your scroll on some item or a landmark where it'll spawn to activate it and make it turnable in.
/obj/structure/roguemachine/questgiver/proc/turn_in_quest(mob/user)
	var/reward
	for(var/atom/movable/pawnable_loot in input_point)

		if(istype(pawnable_loot, /obj/item/paper/scroll/quest))
			var/obj/item/paper/scroll/quest/turned_in_scroll = pawnable_loot
			if(turned_in_scroll.assigned_quest.complete)
				reward += turned_in_scroll.assigned_quest.reward_amount
				switch(scroll.assigned_quest.difficulty) //deposit returns
					if(1)
						reward += 10
					if(2)
						reward += 20
					if(3)
						reward += 40
				continue

		if(is_type_in_list(pawnable_loot, sellable_items))
			var/obj/item/to_sell = pawnable_loot
			if(to_sell.get_real_price() > 0)
				reward += to_sell.sellprice
				continue

	if(guild)
		reward *= 1.5 //So guild handlers get some profit you know.
	cash_in(reward)

///Spawn the money in.
/obj/structure/roguemachine/questgiver/proc/cash_in(reward)

///Place a scroll to the left of the machine and abandon it. Check if it's complete; if it is, actually turn in it as normal. Otherwise gives your deposit back.
/obj/structure/roguemachine/questgiver/proc/abandon_quest(mob/user)

///Prints a list of issued quests, to whom and which and their current general area.
/obj/structure/roguemachine/questgiver/proc/print_quests(mob/user)
