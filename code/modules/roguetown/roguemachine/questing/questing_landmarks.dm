/obj/effect/landmark/quest_spawner
	name = "quest landmark"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "quest_marker"
	var/quest_difficulty = list("Easy", "Medium", "Hard")
	var/quest_type = list("Fetch", "Courier", "Clear Out", "Kill", "Beacon", "Miniboss")
	/// List of possible fetch items for this landmark
	var/list/fetch_items = list(
		/obj/item/rogueweapon/huntingknife/throwingknife/steel,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine,

	)
	/// List of possible mobs for kill/clear quests
	var/list/kill_mobs = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/sea,
		/mob/living/carbon/human/species/skeleton/npc/ambush,
		/mob/living/carbon/human/species/human/northern/searaider/ambush,
	)
	/// Mob type for miniboss quests
	var/miniboss_mob = /mob/living/carbon/human/species/elf/dark/drowraider/ambush

/obj/effect/landmark/quest_spawner/Initialize()
	. = ..()

/obj/effect/landmark/quest_spawner/proc/generate_quest(datum/quest/new_quest, mob/user)
	new_quest.quest_difficulty = quest_difficulty
	new_quest.quest_receiver_reference = user ? WEAKREF(user) : null
	new_quest.quest_receiver_name = user ? user.real_name : null
	new_quest.target_spawn_area = get_area_name(get_turf(src))

	// Set reward based on difficulty
	switch(quest_difficulty)
		if("Easy")
			new_quest.reward_amount = rand(15, 25)
		if("Medium")
			new_quest.reward_amount = rand(30, 50)
		if("Hard")
			new_quest.reward_amount = rand(60, 100)

	// Generate quest-specific content based on the selected type
	switch(new_quest.quest_type)
		if("Fetch")
			new_quest.title = "Retrieve [pick("an ancient", "a rare", "a stolen", "a magical")] [pick("artifact", "relic", "doohickey", "treasure")]"
			new_quest.target_item_type = pick(fetch_items)
			new_quest.target_amount = rand(1, 3)
			spawn_fetch_items(new_quest.target_item_type, new_quest.target_amount, new_quest)

		if("Kill")
			new_quest.title = "Slay [pick("a dangerous", "a fearsome", "a troublesome", "an elusive")] [pick("beast", "monster", "brigand", "creature")]"
			new_quest.target_mob_type = pick(kill_mobs)
			new_quest.target_amount = 1
			spawn_kill_mob(new_quest.target_mob_type, new_quest)

		if("Clear Out")
			new_quest.title = "Clear out [pick("a nest of", "a den of", "a group of", "a pack of")] [pick("monsters", "bandits", "creatures", "vermin")]"
			new_quest.target_mob_type = pick(kill_mobs)
			new_quest.target_amount = rand(3, 6)
			spawn_clear_out_mobs(new_quest.target_mob_type, new_quest.target_amount, new_quest)

		if("Courier")
			new_quest.title = "Deliver [pick("an important", "a sealed", "a confidential", "a valuable")] [pick("package", "parcel", "letter", "delivery")]"
			var/area/delivery_area = pick(
				/area/provincial/indoors/town/tavern,
				/area/provincial/indoors/town/church,
				/area/provincial/indoors/town/farm,
				/area/provincial/indoors/town/blacksmith,
				/area/provincial/indoors/town/shop,
				/area/provincial/indoors/town/province_keep,
				/area/provincial/indoors/town/mages_university,
				/area/provincial/indoors/town/mages_university/alchemy_lab,
				/area/provincial/indoors/town/steward,
			)
			new_quest.target_delivery_location = delivery_area
			spawn_courier_item(new_quest, new_quest.target_delivery_location)

		if("Beacon")
			new_quest.title = "Activate [pick("an ancient", "a dormant", "a forgotten", "a mysterious")] Kasmidian beacon"
			new_quest.beacon_connection = TRUE
			
			// For guild-issued quests, we'll wait until the quest is claimed to determine possible beacons
			if(user)
				// Get all beacons the player hasn't connected to yet
				var/list/unconnected_beacons = list()
				for(var/obj/structure/roguemachine/teleport_beacon/beacon in SSroguemachine.teleport_beacons)
					if(!(user.real_name in beacon.granted_list) && beacon != src)
						unconnected_beacons += beacon
			
				if(length(unconnected_beacons))
					// Filter beacons by difficulty
					var/list/difficulty_beacons = list()
					for(var/obj/structure/roguemachine/teleport_beacon/beacon in unconnected_beacons)
						if(beacon.quest_difficulty == new_quest.quest_difficulty)
							difficulty_beacons += beacon
				
					// If no beacons of exact difficulty, expand search
					if(!length(difficulty_beacons))
						difficulty_beacons = unconnected_beacons
				
					new_quest.target_beacon = pick(difficulty_beacons)
					new_quest.target_amount = 1
					new_quest.possible_beacons = unconnected_beacons
			else
				// For guild-issued quests, store all beacons and let the claiming player determine which are valid
				new_quest.possible_beacons = SSroguemachine.teleport_beacons.Copy()
				new_quest.target_amount = 1

		if("Miniboss")
			new_quest.title = "Defeat [pick("the terrible", "the dreadful", "the monstrous", "the infamous")] [pick("warlord", "beast", "sorcerer", "abomination")]"
			new_quest.target_mob_type = miniboss_mob
			new_quest.target_amount = 1
			spawn_miniboss(new_quest)

	return new_quest

/obj/effect/landmark/quest_spawner/proc/spawn_fetch_items(item_type, amount, datum/quest/quest)
	var/turf/spawn_turf = get_safe_spawn_turf()
	if(!spawn_turf)
		return

	for(var/i in 1 to amount)
		var/obj/item/new_item = new item_type(spawn_turf)
		new_item.AddComponent(/datum/component/quest_object, quest)

/obj/effect/landmark/quest_spawner/proc/spawn_kill_mob(mob_type, datum/quest/quest)
	var/turf/spawn_turf = get_safe_spawn_turf()
	if(!spawn_turf)
		return
	
	var/mob/living/new_mob = new mob_type(spawn_turf)
	new_mob.faction |= "quest"
	new_mob.AddComponent(/datum/component/quest_object, quest)
	add_quest_faction_to_nearby_mobs(spawn_turf)

/obj/effect/landmark/quest_spawner/proc/add_quest_faction_to_nearby_mobs(turf/center)
	for(var/mob/living/M in view(7, center))
		// Skip players and mobs that already have the quest faction
		if(M.ckey || ("quest" in M.faction))
			continue
		M.faction |= "quest"

/obj/effect/landmark/quest_spawner/proc/get_safe_spawn_turf()
	var/list/possible_landmarks = list()
	var/obj/effect/landmark/quest_spawner/selected_landmark
	var/list/possible_turfs = list()

	// Gather all quest landmarks with matching difficulty
	for(var/obj/effect/landmark/quest_spawner/gathered_landmarks in GLOB.landmarks_list)
		// Check if this landmark's difficulty list includes our difficulty
		if((quest_difficulty in gathered_landmarks.quest_difficulty) || (gathered_landmarks.quest_difficulty in quest_difficulty))
			possible_landmarks += gathered_landmarks

	// If no matching landmarks found, use ourselves
	if(!length(possible_landmarks))
		possible_landmarks += src
	
	selected_landmark = pick(possible_landmarks)

	// Check turfs around all matching landmarks
	for(var/obj/effect/landmark/quest_spawner/landmark in selected_landmark)
		for(var/turf/open/T in view(7, landmark)) // Only consider open turfs (non-wall, non-dense)
			// Additional safety check for non-dense turfs
			if(T.density)
				continue

			// Check if any player mobs are nearby
			for(var/mob/M in view(9, T))
				if(M.ckey)
					break
				possible_turfs += T

	// If we found possible turfs, pick one at random
	if(length(possible_turfs))
		return pick(possible_turfs)

	// Final fallback: return the landmark's turf if all else fails
	return get_turf(src)

/obj/effect/landmark/quest_spawner/proc/spawn_courier_item(datum/quest/quest, area/delivery_area)
	if(!quest || !delivery_area)
		stack_trace("Invalid quest or delivery area in spawn_courier_item")
		return null

	// Verify we have a quest scroll
	if(!quest.quest_scroll)
		stack_trace("Quest [quest.title] has no associated scroll")
		return null

	// Create the parcel at the scroll's location
	var/obj/item/parcel/delivery_parcel = new(get_turf(quest.quest_scroll))
	
	// Define delivery items by area type with clear fallbacks
	var/static/list/area_delivery_items = list(
		/area/provincial/indoors/town/tavern = list(
			/obj/item/cooking/pan,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar,
		),
		/area/provincial/indoors/town/church = list(
			/obj/item/natural/cloth,
			/obj/item/reagent_containers/powder/ozium,
			/obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
		),
		/area/provincial/indoors/town/farm = list(
			/obj/item/seeds/wheat,
			/obj/item/reagent_containers/food/snacks/egg,
			/obj/item/reagent_containers/food/snacks/egg/mothcat,
			
		),
		/area/provincial/indoors/town/blacksmith = list(
			/obj/item/ingot/iron,
			/obj/item/ingot/bronze,
			/obj/item/rogueore/coal,
		),
		/area/provincial/indoors/town/shop = list(
			/obj/item/roguecoin/gold,
			/obj/item/clothing/ring/silver,
			/obj/item/scomstone/bad,
		),
		/area/provincial/indoors/town/province_keep = list(
			/obj/item/clothing/cloak/raincloak/furcloak,
			/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged,
		),
		/area/provincial/indoors/town/mages_university = list(
			/obj/item/book/spellbook,
			/obj/item/roguegem/yellow,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot,
		),
		/area/provincial/indoors/town/mages_university/alchemy_lab = list(
			/obj/item/alch/waterdust,
			/obj/item/alch/viscera,
			/obj/item/alch/seeddust,
		),
		/area/provincial/indoors/town/steward = list(
			/obj/item/clothing/ring/silver,
			/obj/item/reagent_containers/glass/cup/silver,
			/obj/item/reagent_containers/glass/cup/golden,
		),
		/area/provincial/indoors/town = list(
			/obj/item/ration,
		)
	)

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

	// Set the delivery area type and allowed jobs on the parcel
	delivery_parcel.delivery_area_type = delivery_area
	delivery_parcel.allowed_jobs = area_allowed_jobs[delivery_area] || list("Guild Handler") // Fallback to just Guild Handler if area not found

	// Get appropriate items for this delivery location
	var/list/possible_items = area_delivery_items[delivery_area] || list(
		/obj/item/natural/cloth,
		/obj/item/ration,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
	)

	// Create the item directly inside the parcel
	var/contained_item_type = pick(possible_items)
	var/obj/item/contained_item = new contained_item_type(delivery_parcel)
	delivery_parcel.contained_item = contained_item

	// Set up parcel appearance and properties
	var/area_name = initial(delivery_area.name) || "Unknown Location"
	delivery_parcel.name = "Delivery for [area_name]"
	delivery_parcel.desc = "A securely wrapped parcel addressed to [area_name]. [pick("Handle with care.", "Do not bend.", "Confidential contents.", "Urgent delivery.")]"
	
	// Set icon based on item size
	delivery_parcel.icon_state = contained_item.w_class >= WEIGHT_CLASS_NORMAL ? "ration_large" : "ration_small"
	delivery_parcel.dropshrink = 1
	delivery_parcel.update_icon()

	// Set up quest tracking
	quest.target_delivery_item = contained_item_type
	delivery_parcel.AddComponent(/datum/component/quest_object, quest)
	contained_item.AddComponent(/datum/component/quest_object, quest)

	return delivery_parcel

/obj/effect/landmark/quest_spawner/proc/spawn_clear_out_mobs(mob_type, amount, datum/quest/quest)
	for(var/i in 1 to amount)
		var/turf/spawn_turf = get_safe_spawn_turf()
		if(!spawn_turf)
			return
		
		var/mob/living/new_mob = new mob_type(spawn_turf)
		new_mob.faction |= "quest"
		new_mob.AddComponent(/datum/component/quest_object, quest)
		add_quest_faction_to_nearby_mobs(spawn_turf)
		sleep(1)

/obj/effect/landmark/quest_spawner/proc/spawn_miniboss(datum/quest/quest)
	var/turf/spawn_turf = get_safe_spawn_turf()
	if(!spawn_turf)
		return
	
	var/mob/living/new_mob = new miniboss_mob(spawn_turf)
	new_mob.faction |= "quest"
	new_mob.AddComponent(/datum/component/quest_object, quest)
	new_mob.maxHealth *= 2
	new_mob.health = new_mob.maxHealth
	add_quest_faction_to_nearby_mobs(spawn_turf)

/obj/effect/landmark/quest_spawner/easy
	name = "easy quest landmark"
	icon_state = "quest_marker_low"
	quest_difficulty = "Easy"
	quest_type = list("Fetch", "Courier", "Kill", "Beacon")

/obj/effect/landmark/quest_spawner/medium
	name = "medium quest landmark"
	icon_state = "quest_marker_mid"
	quest_difficulty = "Medium"
	quest_type = list("Kill", "Clear Out", "Beacon")

/obj/effect/landmark/quest_spawner/hard
	name = "hard quest landmark"
	icon_state = "quest_marker_high"
	quest_difficulty = "Hard"
	quest_type = list("Clear Out", "Beacon", "Miniboss")
