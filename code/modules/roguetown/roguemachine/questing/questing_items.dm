/obj/item/paper/scroll/quest
	name = "enchanted quest scroll"
	desc = "A weathered scroll enchanted to list the active quests from the Adventurers' Guild."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest"
	var/base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest

/obj/item/paper/scroll/quest/Initialize()
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src 
	update_quest_text()

/obj/item/paper/scroll/quest/update_icon_state()
	if(open)
		if(info)
			icon_state = "[base_icon_state]_info"
		else
			icon_state = "[base_icon_state]"
	else
		icon_state = "[base_icon_state]_closed"

/obj/item/paper/scroll/quest/examine(mob/user)
	. = ..()
	if(assigned_quest)
		if(!assigned_quest.quest_receiver_reference)
			. += span_notice("This quest hasn't been claimed yet. Open it to claim it for yourself!")
			return
	if(assigned_quest?.complete)
		. += span_notice("\nThis quest is complete! Return it to the Quest Book to claim your reward.")
		. += span_info("\nPlace it on the marked area next to the book.")
	else if(assigned_quest)
		. += span_notice("\nThis quest is still in progress.")

/obj/item/paper/scroll/quest/attack_self(mob/user)
	. = ..()
	if(.)
		return

	if(!assigned_quest)
		return

	// Handle claiming of guild-issued quests
	if(!assigned_quest.quest_receiver_reference)
		assigned_quest.quest_receiver_reference = WEAKREF(user)
		assigned_quest.quest_receiver_name = user.real_name

		// Special handling for beacon quests
		if(assigned_quest.quest_type == "Beacon" && assigned_quest.beacon_connection && length(assigned_quest.possible_beacons))
			// Filter beacons this player hasn't connected to yet
			var/list/valid_beacons = list()
			for(var/obj/structure/roguemachine/teleport_beacon/beacon in assigned_quest.possible_beacons)
				if(!(user.real_name in beacon.granted_list) && beacon != src)
					valid_beacons += beacon

			if(length(valid_beacons))
				// Filter by difficulty if possible
				var/list/difficulty_beacons = list()
				for(var/obj/structure/roguemachine/teleport_beacon/beacon in valid_beacons)
					if(beacon.quest_difficulty == assigned_quest.quest_difficulty)
						difficulty_beacons += beacon

				// Use either difficulty-filtered beacons or all valid beacons
				assigned_quest.possible_beacons = length(difficulty_beacons) ? difficulty_beacons : valid_beacons
				assigned_quest.target_beacon = pick(assigned_quest.possible_beacons)
			else
				to_chat(user, span_warning("There are no unconnected beacons available for this quest!"))
				return

		to_chat(user, span_notice("You claim this quest for yourself!"))
		update_quest_text()
		return TRUE

/obj/item/paper/scroll/quest/proc/update_quest_text()
	if(!assigned_quest)
		return

	var/scroll_text = "<center>HELP NEEDED</center><br>"
	scroll_text += "<center><b>[assigned_quest.title]</b></center><br><br>"
	scroll_text += "<b>Issued by:</b> [assigned_quest.quest_giver_name ? "Guild Handler [assigned_quest.quest_giver_name]" : "The Adventurer's Guild"].<br>"
	scroll_text += "<b>Issued to:</b> [assigned_quest.quest_receiver_name ? assigned_quest.quest_receiver_name : "whoever it may concern"].<br>"
	scroll_text += "<b>Type:</b> [assigned_quest.quest_type] quest.<br>"
	scroll_text += "<b>Difficulty:</b> [assigned_quest.quest_difficulty].<br><br>"

	// Quest-specific details
	switch(assigned_quest.quest_type)
		if("Fetch")
			var/obj/item/example_item = assigned_quest.target_item_type
			scroll_text += "<b>Objective:</b> Retrieve [assigned_quest.target_amount] [initial(example_item.name)].<br>"
			scroll_text += "<b>Last Seen Location:</b> Reported sighting in [assigned_quest.target_spawn_area] region.<br>"
		
		if("Kill", "Miniboss")
			var/mob/example_mob = assigned_quest.target_mob_type
			scroll_text += "<b>Objective:</b> Slay [assigned_quest.target_amount] [initial(example_mob.name)].<br>"
			if(assigned_quest.target_spawn_area)
				scroll_text += "<b>Last Seen Location:</b> Reported sighting in [assigned_quest.target_spawn_area] region.<br>"
			else
				scroll_text += "<b>Likely Locations:</b> Reported sighting in Sunmarch region.<br>"
		
		if("Clear Out")
			var/mob/example_mob = assigned_quest.target_mob_type
			scroll_text += "<b>Objective:</b> Eliminate [assigned_quest.target_amount] [initial(example_mob.name)].<br>"
			if(assigned_quest.target_spawn_area)
				scroll_text += "<b>Infestation Location:</b> Reported sighting in [assigned_quest.target_spawn_area] region.<br>"
			else
				scroll_text += "<b>Likely Locations:</b> Reported infestations in Sunmarch region.<br>"

		if("Courier")
			var/obj/item/example_item = assigned_quest.target_delivery_item
			var/area_name = initial(assigned_quest.target_delivery_location.name)
			scroll_text += "<b>Objective:</b> Deliver [initial(example_item.name)] to [area_name].<br>"
			scroll_text += "<b>Delivery Instructions:</b> Package must remain intact and be delivered directly to the recipient.<br>"
			scroll_text += "<b>Destination Description:</b> [initial(assigned_quest.target_delivery_location.brief_descriptor)].<br>"

		if("Beacon")
			if(assigned_quest.target_beacon)
				var/area/beacon_area = get_area(assigned_quest.target_beacon)
				scroll_text += "<b>Objective:</b> Activate the Kasmidian beacon in [beacon_area.name]<br>"
				scroll_text += "<b>Beacon Name:</b> [assigned_quest.target_beacon.name]<br>"
				scroll_text += "<b>Location Description:</b> [beacon_area.desc]<br>"
				scroll_text += "<b>Activation Method:</b> Simply interact with the beacon once found<br>"
	
	scroll_text += "<br><b>Reward:</b> [assigned_quest.reward_amount] marks upon completion<br>"
	
	if(assigned_quest.complete)
		scroll_text += "<br><center><b>QUEST COMPLETE</b></center>"
		scroll_text += "<br><b>Return this scroll to the Quest Book to claim your reward!</b>"
		scroll_text += "<br><i>Place it on the marked area next to the book.</i>"
	else
		scroll_text += "<br><i>The magic in this scroll will update as you progress.</i>"
	
	info = scroll_text

/obj/item/parcel
	name = "parcel wrapping paper"
	desc = "A sturdy piece of paper used to wrap items for secure delivery. The final size of the parcel depends on the size of the original item."
	icon = 'modular/Neu_food/icons/ration.dmi'
	icon_state = "ration_wrapper"
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6
	/// Item wrapped in said parcel
	var/obj/item/contained_item = null
	/// List of jobs allowed to open this parcel, persists after quest deletion
	var/list/allowed_jobs = list()
	/// The delivery area this parcel is meant for
	var/delivery_area_type

/obj/item/parcel/Initialize(mapload)
	. = ..()
	// Define the complete area to jobs mapping
	var/static/list/area_allowed_jobs = list(
		/area/provincial/indoors/town/tavern = list("Guild Handler", "Innkeeper", "Tapster"),
		/area/provincial/indoors/town/church = list("Guild Handler", "Priest", "Acolyte", "Templar", "Churchling"),
		/area/provincial/indoors/town/farm = list("Guild Handler", "Soilson"),
		/area/provincial/indoors/town/blacksmith = list("Guild Handler", "Blacksmith"),
		/area/provincial/indoors/town/shop = list("Guild Handler", "Merchant", "Shophand"),
		/area/provincial/indoors/town/province_keep = list("Guild Handler", "Nobleman", "Hand", "Knight Captain", "Marshal", "Steward", "Clerk", "Head Mage", "Marquis"),
		/area/provincial/indoors/town/mages_university = list("Guild Handler", "Head Mage", "Archivist", "Artificer", "Apothicant Apprentice", "Apprentice Magician"),
		/area/provincial/indoors/town/mages_university/alchemy_lab = list("Guild Handler", "Head Mage", "Archivist", "Artificer", "Apothicant Apprentice", "Apprentice Magician"),
		/area/provincial/indoors/town/steward = list("Guild Handler", "Steward"),
		/area/provincial/indoors/town = list("Guild Handler"),
	)

	// If this is a quest parcel, set up the allowed jobs
	var/datum/component/quest_object/courier_quest = GetComponent(/datum/component/quest_object)
	if(courier_quest)
		var/datum/quest/quest = courier_quest.quest_ref?.resolve()
		if(quest && quest.quest_type == "Courier" && quest.target_delivery_location)
			delivery_area_type = quest.target_delivery_location
			allowed_jobs = area_allowed_jobs[delivery_area_type] || list("Guild Handler")
			RegisterSignal(courier_quest, COMSIG_PARENT_QDELETING, PROC_REF(on_quest_component_deleted))

/obj/item/parcel/proc/on_quest_component_deleted(datum/source)
	SIGNAL_HANDLER
	// Keep the allowed_jobs list even after quest deletion
	return

/obj/item/parcel/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/parcel)) // Prevent wrapping parcels in parcels
		to_chat(user, span_warning("You can't wrap a parcel in another parcel."))
		return

	if(I.w_class > WEIGHT_CLASS_BULKY) // Limit what can be wrapped
		to_chat(user, span_warning("[I] is too large to be wrapped in [src]."))
		return

	if(contained_item)
		to_chat(user, span_warning("There is already something wrapped in [src]."))
		return

	if(do_after(user, 2 SECONDS, target = src))
		user.transferItemToLoc(I, src)
		contained_item = I
		to_chat(user, span_notice("You wrap [I] in the parcel wrapper."))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		
		// Set name and description based on wrapped item
		name = "parcel ([contained_item.name])"
		desc = "A securely wrapped parcel containing [contained_item.name]."
		
		// Set appropriate size and icon
		if(I.w_class >= WEIGHT_CLASS_NORMAL)
			icon_state = "ration_large"
			dropshrink = 1
		else
			icon_state = "ration_small"
			dropshrink = 1
		update_icon()

/obj/item/parcel/attack_self(mob/user)
	. = ..()
	if(.)
		return

	if(!contained_item)
		return

	if(delivery_area_type)
		var/area/quest_area = delivery_area_type
		if(!ispath(quest_area, /area))
			return
	
		if(!(user.job in allowed_jobs))
			var/area_name = initial(quest_area.name)
			to_chat(user, span_warning("This parcel is sealed for delivery to [area_name] and can only be opened by: [english_list(allowed_jobs)]!"))
			return FALSE

	if(do_after(user, 2 SECONDS, target = src))
		to_chat(user, span_notice("You unwrap [contained_item] from the parcel."))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		user.put_in_hands(contained_item)
		contained_item.update_icon()
		contained_item = null
		qdel(src) //No reusing wrapper

/obj/item/parcel/examine(mob/user)
	. = ..()
	if(!delivery_area_type)
		return

	var/area/delivery_area = delivery_area_type
	if(!ispath(delivery_area, /area))
		return

	var/area_name = initial(delivery_area.name)
	. += span_info("This parcel is addressed to [area_name].")
	if(!(user.job in allowed_jobs))
		. += span_warning("It's sealed with an official guild mark - only authorized personnel should open this!")
	else
		. += span_notice("As [user.job], you're authorized to open this.")
