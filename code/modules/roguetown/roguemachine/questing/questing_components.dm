/datum/component/quest_object
	/// The quest datum this object belongs to
	var/datum/weakref/quest_ref
	/// Whether this is a mob target (true) or item (false)
	var/is_mob = FALSE
	/// Filter ID for the gold outline
	var/outline_filter_id = "quest_item_outline"

/datum/component/quest_object/Initialize(datum/quest/target_quest)
	if(!isitem(parent) && !ismob(parent))
		return COMPONENT_INCOMPATIBLE
	
	quest_ref = WEAKREF(target_quest)
	is_mob = ismob(parent)
	
	if(is_mob)
		var/mob/M = parent
		M.add_filter(outline_filter_id, 2, list("type" = "outline", "color" = "#ff0000", "size" = 0.5))
		RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_target_death))
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_mob_examine))
		RegisterSignal(target_quest, COMSIG_PARENT_QDELETING, PROC_REF(on_quest_deleted))
	else
		var/obj/item/item_parent = parent
		item_parent.add_filter(outline_filter_id, 2, list("type" = "outline", "color" = "#008cff", "size" = 0.5))
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_item_dropped))
		RegisterSignal(target_quest, COMSIG_PARENT_QDELETING, PROC_REF(on_quest_deleted))

/datum/component/quest_object/Destroy()
	if(QDELETED(parent))
		return ..()
		
	var/datum/quest/Q = quest_ref?.resolve()
	if(Q && !Q.complete && isitem(parent))
		var/obj/item/I = parent
		I.remove_filter(outline_filter_id)
		
		// Only delete if it's a courier item and we're not already in a destruction
		if(Q.quest_type == "Courier" && (Q.target_delivery_item && istype(I, Q.target_delivery_item)) && !QDELETED(I))
			// Null the reference first
			Q.target_delivery_item = null
			// Queue for deletion but don't force it
			qdel(I)
	
	return ..()

/datum/component/quest_object/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	
	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete)
		return
	
	// Check if user has any active fetch quests that match this item
	var/list/user_scrolls = find_quest_scrolls(user)
	for(var/obj/item/paper/scroll/quest/scroll in user_scrolls)
		var/datum/quest/user_quest = scroll.assigned_quest
		if(user_quest && user_quest.quest_type == "Fetch" && istype(parent, user_quest.target_item_type))
			examine_list += span_notice("This looks like an item you need for your quest: [user_quest.title]!")
			break
		if(user_quest && user_quest.quest_type == "Courier" && istype(parent, user_quest.target_delivery_item))
			examine_list += span_notice("This looks like an item you need for your quest: [user_quest.title]!")
			break

/datum/component/quest_object/proc/on_mob_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	
	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete)
		return

	var/list/user_scrolls = find_quest_scrolls(user)
	for(var/obj/item/paper/scroll/quest/scroll in user_scrolls)
		var/datum/quest/user_quest = scroll.assigned_quest
		if(user_quest && user_quest.quest_type == "Kill" || user_quest.quest_type == "Clear Out"  || user_quest.quest_type == "Miniboss" && istype(parent, user_quest.target_mob_type))
			examine_list += span_notice("This looks like the target of your quest: [user_quest.title]!")
			break
		if(Q.target_spawn_area != get_area(get_turf(src)))
			examine_list += span_notice("It was last reported in the [Q.target_spawn_area] area, however.")

/datum/component/quest_object/proc/find_quest_scrolls(atom/container)
	var/list/scrolls = list()
	for(var/obj/item/paper/scroll/quest/Q in container)
		scrolls += Q
	
	// Recursively check contents of containers
	for(var/obj/item/storage/S in container)
		scrolls += find_quest_scrolls(S)

	return scrolls

/datum/component/quest_object/proc/on_target_death(mob/living/dead_mob, gibbed)
	SIGNAL_HANDLER
	var/datum/quest/Q = quest_ref.resolve()
	if(!Q || Q.complete)
		return

	if(!istype(dead_mob, Q.target_mob_type))
		return

	Q.target_amount--
	dead_mob.remove_filter("quest_item_outline")

	// Find and update the quest scroll
	var/obj/item/paper/scroll/quest/scroll
	if(Q.quest_scroll_ref)
		scroll = Q.quest_scroll_ref.resolve()
	else if(Q.quest_scroll)  // Fallback to direct reference
		scroll = Q.quest_scroll

	if(scroll)
		scroll.update_quest_text()
		if(Q.target_amount <= 0)
			Q.complete = TRUE
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
				do_sparks(3, TRUE, get_turf(dropped_item))
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
							parcel.remove_filter("quest_item_outline")
							parcel.contained_item.remove_filter("quest_item_outline")
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
						dropped_item.remove_filter("quest_item_outline")
						var/obj/item/paper/scroll/quest/scroll
						if(Q.quest_scroll_ref)
							scroll = Q.quest_scroll_ref.resolve()
						else if(Q.quest_scroll)
							scroll = Q.quest_scroll
						if(scroll)
							scroll.update_quest_text()
					return

/datum/component/quest_object/proc/on_quest_deleted(datum/source)
	SIGNAL_HANDLER
	var/datum/quest/Q = quest_ref?.resolve()
	if(ismob(parent))
		var/mob/M = parent
		M.remove_filter(outline_filter_id) //Still have to deal with them; not exactly free loot.
	else if(isitem(parent))
		var/obj/item/I = parent
		I.remove_filter(outline_filter_id) //No completely free loot however.
		if(!Q.complete) //It's okay to steal if you've delivered it. :)
			qdel(I)
	qdel(src)
