GLOBAL_LIST_INIT(toyjester_aggro, world.file2list("strings/rt/toyjesteraggrolines.txt"))

/mob/living/carbon/human/species/construct/metal/toyjester
	aggressive=1
	mode = AI_IDLE
	faction = list("toybox")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	stand_attempts = 6
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak)
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.

/mob/living/carbon/human/species/construct/metal/toyjester/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/construct/metal/toyjester/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
	if(!is_silent && target != newtarg)
		say(pick(GLOB.toyjester_aggro))
		linepoint(target)

/mob/living/carbon/human/species/construct/metal/toyjester/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/construct/metal/toyjester/Initialize()
	. = ..()
	set_species(/datum/species/construct/metal)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/construct/metal/toyjester/after_creation()
	..()
	job = "Toy Jester"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/construct/metal/toyjester)
	gender = pick(MALE, FEMALE)
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/doublebun, 
						/datum/sprite_accessory/hair/head/halfbang, 
						/datum/sprite_accessory/hair/head/long, 
						/datum/sprite_accessory/hair/head/pixie))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/shorthaireighties, 
						/datum/sprite_accessory/hair/head/business4, 
						/datum/sprite_accessory/hair/head/emo, 
						/datum/sprite_accessory/hair/head/ponytail4))

	var/datum/bodypart_feature/hair/head/new_hair = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#a37126"
	new_hair.hair_color = "#a37126"
	hair_color = "#a37126"

	head.add_bodypart_feature(new_hair)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#C01414"
		organ_eyes.accessory_colors = "#C01414#C01414"
	
	if(organ_ears)
		organ_ears.accessory_colors = "#A18047"
	
	skin_tone = "A18047"

	real_name = pick(world.file2list("strings/rt/names/other/toyjester.txt"))

	update_hair()
	update_body()

/mob/living/carbon/human/species/construct/metal/toyjester/npc_idle()
	if(m_intent == MOVE_INTENT_SNEAK)
		return
	if(world.time < next_idle)
		return
	next_idle = world.time + rand(30, 70)
	if((mobility_flags & MOBILITY_MOVE) && isturf(loc) && wander)
		if(prob(20))
			var/turf/T = get_step(loc,pick(GLOB.cardinals))
			if(!istype(T, /turf/open/transparent/openspace))
				Move(T)
		else
			face_atom(get_step(src,pick(GLOB.cardinals)))
	if(!wander && prob(10))
		face_atom(get_step(src,pick(GLOB.cardinals)))

/mob/living/carbon/human/species/construct/metal/toyjester/handle_combat()
	if(mode == AI_HUNT)
		if(prob(5))
			emote("laugh")
		if(prob(5))
			emote("chuckle")
		if(prob(5))
			emote("giggle")
	. = ..()

/datum/outfit/job/roguetown/human/species/construct/metal/toyjester/pre_equip(mob/living/carbon/human/H)
	var/toyclass = rand(1,3)
	switch(toyclass)
		if(1) //Jester
			shirt = /obj/item/clothing/suit/roguetown/shirt/jester
			pants = /obj/item/clothing/under/roguetown/tights/jester
			mask = /obj/item/clothing/mask/rogue/facemask
			if(prob(50))
				mask = /obj/item/clothing/mask/rogue/ragmask/black
			head = /obj/item/clothing/head/roguetown/jester
			shoes = /obj/item/clothing/shoes/roguetown/jester
			H.STASTR = rand(12,16)
			H.STASPD = rand(10,16)
			H.STACON = rand(12,16)
			H.STAEND = rand(12,16)
			H.STAPER = rand(10,16)
			H.STAINT = rand(8,10)
			if(prob(50))
				r_hand = /obj/item/rogueweapon/knuckles/bronzeknuckles
				l_hand = /obj/item/rogueweapon/knuckles/bronzeknuckles
			else
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
		if(2) //Toy Arquebusier
			shirt = /obj/item/clothing/suit/roguetown/shirt/jester
			pants = /obj/item/clothing/under/roguetown/tights/jester
			cloak = /obj/item/clothing/cloak/cape
			mask = /obj/item/clothing/mask/rogue/facemask
			if(prob(50))
				mask = /obj/item/clothing/mask/rogue/ragmask/black
			head = /obj/item/clothing/head/roguetown/helmet/tricorn
			if(prob(1))
				head = /obj/item/clothing/head/roguetown/helmet/tricorn/lucky
			shoes = /obj/item/clothing/shoes/roguetown/jester
			H.STASTR = rand(12,16)
			H.STASPD = rand(10,16)
			H.STACON = rand(12,16)
			H.STAEND = rand(12,16)
			H.STAPER = rand(10,16)
			H.STAINT = rand(8,10)
			r_hand = /obj/item/rogueweapon/halberd/toyarquebus
		if(3) //Toy Knight
			shirt = /obj/item/clothing/suit/roguetown/shirt/jester
			pants = /obj/item/clothing/under/roguetown/tights/jester
			mask = /obj/item/clothing/mask/rogue/facemask
			if(prob(50))
				mask = /obj/item/clothing/mask/rogue/ragmask/black
			head = /obj/item/clothing/head/roguetown/jester
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/skullcap
			shoes = /obj/item/clothing/shoes/roguetown/jester
			H.STASTR = rand(12,16)
			H.STASPD = rand(10,16)
			H.STACON = rand(12,16)
			H.STAEND = rand(12,16)
			H.STAPER = rand(10,16)
			H.STAINT = rand(8,10)
			if(prob(50))
				r_hand = /obj/item/rogueweapon/sword/iron
				l_hand = /obj/item/rogueweapon/shield/heater
			else
				r_hand = /obj/item/rogueweapon/sword/iron/messer
				l_hand = /obj/item/rogueweapon/shield/heater
	
