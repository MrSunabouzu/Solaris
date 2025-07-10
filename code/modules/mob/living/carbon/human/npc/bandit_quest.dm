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
	var/list/allowed_species = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/elf/wood,/datum/species/moth,/datum/species/kobold,/datum/species/goblinp)
	var/datum/species/chosen_species
	chosen_species = pick(allowed_species)
	set_species(chosen_species)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE

/mob/living/carbon/human/species/human/bandit_quest/after_creation()
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
	var/hairc =  pick(list("#191515","#a39c3d"),"#7a440f","#3f2516")
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/eyec = pick(list("#29b136","#3d51be","#8b6215","#72863c"))

	if(organ_eyes)
		(organ_eyes.eye_color) = (eyec)
	hair_color = (hairc)
	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	head.add_bodypart_feature(new_hair)
	if(is_species(src,/obj/item/organ/ears/lupian))
		new_hair.add_bodypart_feature(/datum/sprite_accessory/ears/wolf)
		
	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	update_hair()
	update_body()
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


	
	

