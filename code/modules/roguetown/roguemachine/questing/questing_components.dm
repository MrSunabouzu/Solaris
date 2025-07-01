/datum/component/quest_object
	/// The quest datum this object belongs to
	var/datum/weakref/quest_ref
	/// Whether this is a mob target (true) or item (false)
	var/is_mob = FALSE

/datum/component/quest_object/Initialize(datum/quest/target_quest)
	if(!isitem(parent) && !ismob(parent))
		return COMPONENT_INCOMPATIBLE
	
	quest_ref = WEAKREF(target_quest)
	is_mob = ismob(parent)
	
	if(is_mob)
		RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_target_death))
	else
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))

/datum/component/quest_object/proc/on_target_death(mob/living/dead_mob, gibbed)
	SIGNAL_HANDLER
	var/datum/quest/Q = quest_ref.resolve()
	if(Q && !Q.complete && istype(dead_mob, Q.target_mob_type))
		Q.target_amount--
		if(Q.target_amount <= 0)
			Q.complete = TRUE
			var/obj/item/paper/scroll/quest/scroll
			if(Q.quest_scroll_ref)
				scroll = Q.quest_scroll_ref.resolve()
			else if(Q.quest_scroll)  // Fallback to direct reference
				scroll = Q.quest_scroll
			if(scroll)
				scroll.update_quest_text()

/datum/component/quest_object/proc/on_item_dropped(obj/item/dropped_item, mob/user)
	SIGNAL_HANDLER
	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete)
		return

	var/turf/drop_turf = get_turf(dropped_item)
	for(var/obj/structure/roguemachine/questgiver/quest_machine in SSroguemachine.questgivers)
		if(get_turf(quest_machine.input_point) == drop_turf)
			// Handle fetch quest items
			if(Q.target_item_type && istype(dropped_item, Q.target_item_type))
				Q.target_amount--
				if(Q.target_amount <= 0)
					Q.complete = TRUE
					var/obj/item/paper/scroll/quest/scroll
					if(Q.quest_scroll_ref)
						scroll = Q.quest_scroll_ref.resolve()
					else if(Q.quest_scroll)
						scroll = Q.quest_scroll
					if(scroll)
						scroll.update_quest_text()
				qdel(dropped_item)
				return
			
		// Handle delivery quest items
		if(Q.target_delivery_item && (istype(dropped_item, /obj/item/parcel) || istype(dropped_item, Q.target_delivery_item)))
			var/area/current_area = get_area(user)
			if(istype(current_area, Q.target_delivery_location))
				// If it's a parcel wrapper
				if(istype(dropped_item, /obj/item/parcel))
					var/obj/item/parcel/parcel = dropped_item
					if(parcel.contained_item && istype(parcel.contained_item, Q.target_delivery_item))
						Q.target_amount--
						if(Q.target_amount <= 0)
							Q.complete = TRUE
							var/obj/item/paper/scroll/quest/scroll
							if(Q.quest_scroll_ref)
								scroll = Q.quest_scroll_ref.resolve()
							else if(Q.quest_scroll)
								scroll = Q.quest_scroll
							if(scroll)
								scroll.update_quest_text()
						return
				// Handle direct delivery of non-wrapped items
				else if(istype(dropped_item, Q.target_delivery_item))
					Q.target_amount--
					if(Q.target_amount <= 0)
						Q.complete = TRUE
						var/obj/item/paper/scroll/quest/scroll
						if(Q.quest_scroll_ref)
							scroll = Q.quest_scroll_ref.resolve()
						else if(Q.quest_scroll)
							scroll = Q.quest_scroll
						if(scroll)
							scroll.update_quest_text()
					return
