/datum/quest
	var/title = ""
	var/datum/weakref/questee_reference
	var/questee_name = ""
	var/datum/weakref/quester_reference
	var/quester_name = ""
	var/quest_type = ""
	var/quest_difficulty = ""
	var/reward_amount = 0
	var/complete = FALSE
	/// Target item type for fetch quests
	var/obj/item/target_item_type
	/// Target item type for courier quests
	var/obj/item/target_delivery_item
	/// Target mob type for kill quests
	var/mob/target_mob_type
	/// Number of targets needed
	var/target_amount = 1
	/// Location for beacon quests
	var/area/beacon_activation_location
	/// Location for courier quests
	var/area/provincial/indoors/town/target_delivery_location
	/// Fallback reference to the spawned scroll
	var/obj/item/paper/scroll/quest/quest_scroll
	/// Weak reference to the quest scroll
	var/datum/weakref/quest_scroll_ref
	/// Target beacon for beacon quests
	var/obj/structure/roguemachine/teleport_beacon/target_beacon
	/// Whether the beacon has been activated for this quest
	var/beacon_activated = FALSE