/mob/living/simple_animal/hostile/boss/lost_swordsman
	name = "Forgotten Swordsman"
	desc = "What was once an honorable knight glittering in the dawns light has become... this. End their nightmare."
	mob_biotypes = MOB_HUMANOID|MOB_UNDEAD
	boss_abilities = list(/datum/action/boss/martialdash)
	faction = list("artorias")
	del_on_death = TRUE
	icon = 'icons/mob/solaris_badasses.dmi'
	icon_state = "lost_swordsman"
	wander = 1
	vision_range = 4
	aggro_vision_range = 18
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 100
	base_intents = list(/datum/intent/simple/miniboss_bigsword_cleave, /datum/intent/simple/miniboss_bigsword_impale, /datum/intent/simple/miniboss_bigsword_suckerpunch)
	melee_damage_lower = 10
	melee_damage_upper = 30
	health = 900
	maxHealth = 900
	STASTR = 18
	STAPER = 12
	STAINT = 8
	STACON = 20
	STAEND = 20
	STASPD = 15
	STALUC = 15
	loot = list(/obj/effect/spawner/lootdrop/roguetown/dungeon/money/rich, /obj/effect/spawner/lootdrop/roguetown/dungeon/gadgets, /obj/effect/spawner/lootdrop/roguetown/gems)
	footstep_type = FOOTSTEP_MOB_SHOE
	stat_attack = UNCONSCIOUS

//Basic Attacks

/datum/intent/simple/miniboss_bigsword_cleave //Weak Attack
	name = "cleave"
	icon_state = "instrike"
	attack_verb = list("cleaves", "rends", "tears")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list("genchop", "genslash")
	chargetime = 0
	penfactor = 30
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"

/datum/intent/simple/miniboss_bigsword_impale //Strong attack
	name = "impale"
	icon_state = "instrike"
	attack_verb = list("impales", "skewers", "runs through")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list("genstab", "genslash")
	chargetime = 0
	penfactor = 60
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"

/datum/intent/simple/miniboss_bigsword_suckerpunch //Equipment mauler
	name = "jab"
	icon_state = "instrike"
	attack_verb = list("uppercuts", "punches")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"

//Special Attacks

/datum/action/boss/martialdash
	check_flags = AB_CHECK_CONSCIOUS //Incase the boss is given a player
	boss_cost = 30 //Cost of usage for the boss' AI 1-100
	usage_probability = 100
	needs_target = TRUE //Does the boss need to have a target? (Only matters for the AI)
	say_when_triggered = "Nothing Personel Kid" //What does the boss Say() when the ability triggers?

/datum/action/boss/martialdash/Trigger()
	. = ..()
	var/turf/dashturf = get_turf(boss.target)
	/*switch(target_dir)
		if(1) //North
			dashturf = (dashturf.y-1)
		if(2) //South
			dashturf = (dashturf.y+1)
		if(4) //East
			dashturf = (dashturf.x-1)
		if(8) //West 
			dashturf = (dashturf.x+1)*/
	do_teleport(boss, dashturf)
