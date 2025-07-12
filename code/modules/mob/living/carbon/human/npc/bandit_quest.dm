GLOBAL_LIST_INIT(banditquest_aggro, world.file2list("strings/rt/searaideraggrolines.txt"))

/mob/living/carbon/human/species/human/bandit_quest
	aggressive=1
	mode = NPC_AI_IDLE
	faction = list("quest_ target")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list()
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.

/mob/living/carbon/human/species/human/bandit_quest/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/bandit_quest/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.banditquest_aggro))
			linepoint(target)

/mob/living/carbon/human/species/human/bandit_quest/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/bandit_quest/Initialize(mob/living/L)
	. = ..()
	var/list/allowed_species = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/elf/wood,/datum/species/moth,/datum/species/kobold,/datum/species/goblinp,/datum/species/tabaxi)
	var/datum/species/chosen_species
	chosen_species = pick(allowed_species)
	set_species(/datum/species/tabaxi)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE

/mob/living/carbon/human/species/human/bandit_quest/after_creation(mob/living/L)
	..()
	job = "Pillager"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	real_name = pick("Thug","Outlaw","Brigand","Blackguard","Knave","Wretch")
	gender = pick(MALE, FEMALE)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/himecut, 
						/datum/sprite_accessory/hair/head/countryponytailalt, 
						/datum/sprite_accessory/hair/head/stacy, 
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher, 
						/datum/sprite_accessory/hair/head/dave, 
						/datum/sprite_accessory/hair/head/emo, 
						/datum/sprite_accessory/hair/head/sabitsuki))
	var/hairc =  pick(list("#e02222","#a39c3d","#7a440f","#3f2516"))
	var/eyec = pick(list("#29b136","#3d51be","#8b6215","#72863c"))
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/organ/ears/ears = get_bodypart(BODY_ZONE_PRECISE_EARS)
	var/obj/item/organ/tail/tail = getorganslot(ORGAN_SLOT_TAIL)
	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, hairc, src)
	else
		new_hair.set_accessory_type(hairm, hairc, src)

	head.add_bodypart_feature(new_hair)

	if(is_species(/datum/species/lupian))
		ears.set_accessory_type(/datum/sprite_accessory/ears/wolf, (hairc))
		tail.set_accessory_type(/datum/sprite_accessory/tail/wolf, (hairc))
	if(is_species(/datum/species/goblinp))
		ears.set_accessory_type(/datum/sprite_accessory/ears/goblin, (hairc))
	if(is_species(/datum/species/elf/wood))
		ears.set_accessory_type(/datum/sprite_accessory/ears/elfw, (hairc))
	if(is_species(/datum/species/moth))
	if(is_species(/datum/species/kobold))
	if(is_species(/datum/species/tabaxi))
		ears.set_accessory_type(/obj/item/organ/ears/tajaran)
		ears.dye_color = (hairc)

		
	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	update_hair()
	update_body()
	update_body_parts(TRUE)	
	src.say(pick("On it boss!","You got it boss!","Roger dat boss!","Lets get em!"))

/mob/living/carbon/human/species/human/bandit_quest/npc_idle()
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

/mob/living/carbon/human/species/human/bandit_leader_henchman/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(5))
			emote("warcry")
	. = ..()


	
	

