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

/obj/item/paper/scroll/quest/proc/update_quest_text()
	if(!assigned_quest)
		return
	
	var/scroll_text = "<center>HELP NEEDED</center><br>"
	scroll_text += " <center>[assigned_quest.title]<br><br>"
	scroll_text += " issued by [assigned_quest.questee_name ? assigned_quest.questee_name : "The Adventurer's Guild."]<br>"
	scroll_text += " issued to [assigned_quest.quester_name].<br>"
	scroll_text += " a [assigned_quest.quest_type] quest.<br>"
	scroll_text += " of [assigned_quest.quest_difficulty] difficulty.<br>"
	
	if(assigned_quest.quest_type == "Beacon")
		if(assigned_quest.target_beacon)
			scroll_text += " Locate and activate the Kasmidian beacon of [get_area(assigned_quest.target_beacon)].<br>"
			scroll_text += " The beacon is also known as [assigned_quest.target_beacon.name]<br>"

	if(assigned_quest.quest_type == "Courier" && assigned_quest.target_delivery_location)
		var/area_name = initial(assigned_quest.target_delivery_location.name)
		scroll_text += " Deliver the package to [area_name].<br>"

	scroll_text += "A minimum of [assigned_quest.reward_amount] marks plus deposit to be paid upon completion."

	if(assigned_quest.complete)
		scroll_text += "<center><b>QUEST COMPLETE</b></center>"
	info = scroll_text

/obj/item/parcel
	name = "parcel wrapping paper"
	desc = "A sturdy piece of paper used to wrap items for secure delivery. The final size of the parcel depends on the size of the original item."
	icon = 'modular/Neu_food/icons/ration.dmi' // Using same icon file for consistency
	icon_state = "ration_wrapper"
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6
	var/obj/item/contained_item = null // The item wrapped in the parcel

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
	if(contained_item)
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("You unwrap [contained_item] from the parcel."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			user.put_in_hands(contained_item)
			contained_item.update_icon()
			contained_item = null
			qdel(src) // No reusing wrapper

/obj/item/parcel/examine(mob/user)
	. = ..()
	if(contained_item)
		. += span_notice("It contains [contained_item.name].")
