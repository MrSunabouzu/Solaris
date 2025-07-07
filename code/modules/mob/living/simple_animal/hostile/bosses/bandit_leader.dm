/mob/living/simple_animal/hostile/boss/bandit_leader
	name = "Bandit Leader"
	desc = "Something about the smile on his face makes you want to believe he is as harmless as he appears. You know better."
	mob_biotypes = MOB_HUMANOID
	boss_abilities = list()
	faction = list("miniboss")
	del_on_death = TRUE
	icon = 'icons/mob/solaris_badasses.dmi'
	icon_state = "bandit_leader"
	wander = 0
	vision_range = 8
	aggro_vision_range = 10
	retreat_distance = 1
	minimum_distance = 2
	environment_smash = 1
	obj_damage = 15
	base_intents = list(/datum/intent/spear/banditboss_spear)
	melee_damage_lower = 15
	melee_damage_upper = 25
	dodge_prob = 33
	health = 800
	maxHealth = 800
	point_regen_delay = 1
	STASTR = 13
	STAPER = 14
	STAINT = 10
	STACON = 14
	STAEND = 18
	STASPD = 16
	STALUC = 19
	loot = list(/obj/effect/spawner/lootdrop/roguetown/dungeon/money, /obj/effect/spawner/lootdrop/roguetown/gems, /obj/effect/temp_visual/minibossdeath)
	footstep_type = FOOTSTEP_MOB_SHOE
	stat_attack = UNCONSCIOUS

	//Melee Attacks

/datum/intent/spear/banditboss_spear
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	chargetime = 0
	swingdelay = 1
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 33
	item_d_type = "stab"
