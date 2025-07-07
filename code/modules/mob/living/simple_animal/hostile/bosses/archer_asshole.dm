/mob/living/simple_animal/hostile/boss/archer_asshole
	name = "Cocky Crossbowelf"
	desc = "The near permanent grin smeared on her face betrays the monster harbored inside. Cut her hubristic journey short."
	mob_biotypes = MOB_HUMANOID
	boss_abilities = list(/datum/action/boss/trickammo,/datum/action/boss/motormouth,/datum/action/boss/rapidfire)
	faction = list("miniboss")
	del_on_death = TRUE
	icon = 'icons/mob/solaris_badasses.dmi'
	icon_state = "archer_asshole"
	wander = 1
	vision_range = 10
	aggro_vision_range = 12
	ranged = 1
	rapid = 1
	rapid_fire_delay = 8
	ranged_message = "fires a bolt"
	projectiletype = /obj/projectile/bullet/reusable/bolt/weak
	projectilesound = 'sound/combat/Ranged/crossbow-small-shot-01.ogg'
	ranged_cooldown_time = 80
	retreat_distance = 8
	minimum_distance = 3
	environment_smash = 0
	obj_damage = 5
	base_intents = list(/datum/intent/simple/miniboss_sad_punch)
	melee_damage_lower = 1
	melee_damage_upper = 5
	dodge_prob = 75
	health = 600
	maxHealth = 600
	point_regen_delay = 3
	STASTR = 12
	STAPER = 16
	STAINT = 15
	STACON = 12
	STAEND = 20
	STASPD = 18
	STALUC = 15
	loot = list(/obj/effect/spawner/lootdrop/roguetown/dungeon/money, /obj/effect/spawner/lootdrop/roguetown/gems, /obj/effect/temp_visual/minibossdeath)
	footstep_type = FOOTSTEP_MOB_SHOE
	stat_attack = UNCONSCIOUS
	emote_taunt = list("smile","giggle","grin")

/mob/living/simple_animal/hostile/boss/archer_asshole/Initialize() //This is to avoid a second one on the same map starting at phase 2
	projectiletype = /obj/projectile/bullet/reusable/bolt/weak
	rapid = 1
	. = ..()

//Basic Attacks

/datum/intent/simple/miniboss_sad_punch //Useless on purpose, shes less dangerous in melee
	name = "punch"
	icon_state = "instrike"
	attack_verb = list("pathetically baps", "ineffectually punches", "hurts her hand attempting to jab")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	chargetime = 0
	penfactor = 0
	swingdelay = 2
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"

//Special Attacks

/datum/action/boss/trickammo //Projectile variety as fight continues
	check_flags = AB_CHECK_CONSCIOUS 
	boss_cost = 40 
	usage_probability = 16
	needs_target = FALSE 
	say_when_triggered = ""
	var/specialammo = list(/obj/projectile/bullet/reusable/bolt/weak, /obj/projectile/bullet/bolt/pyro/weak, /obj/projectile/magic/frostbolt)
	var/reloadsound = list('sound/combat/Ranged/crossbow-small-shot-01.ogg','sound/combat/Ranged/crossbow-small-shot-02.ogg','sound/combat/Ranged/crossbow-small-shot-03.ogg')
	var/reloadhums = list('sound/vo/female/gen/hum (1).ogg','sound/vo/female/gen/hum (2).ogg','sound/vo/female/gen/hum (3).ogg')
	var/reloadgrunts = list('sound/vo/female/gen/pain (1).ogg','sound/vo/female/gen/pain (2).ogg','sound/vo/female/gen/pain (3).ogg')

/datum/action/boss/trickammo/Trigger()
	. = ..()
	if(boss.health <= 400)
		boss.projectiletype = pick(specialammo)
	else
		return


/datum/action/boss/motormouth //She is already way too dangerous so this just gives her a chance to waste her own resources.
	check_flags = AB_CHECK_CONSCIOUS 
	boss_cost = 50 
	usage_probability = 9
	needs_target = TRUE
	say_when_triggered = ""
	var/quips = list("Hoo boy...", "Hee hee!", "C'mon, keep up!", "Sloooowpoke~", "Just you wait~", "I've seen TREES grow faster than you move!", "Betcha can't dodge this!", "I got things to do, hurry up and bleed out!", "First fight?", "Oooh your a natural at getting shot!", "Nothing like a good hunt!", "D'aww this is adorable. Look at you!", "That all you got?")
	var/quipsbloodied = list("Shit..! Alright, not bad for a sapling!", "Hey C'mon it was a joke I swear!", "Rrgh.. Stand! STILL!!", "Would you just DIE already?!", "I'll get through this... always do...", "Ugh! Quit movin already!", "Gah!", "YOU are costing me FAR too many bolts!", "Bolts aren't FREE you know, die already?", "Making me work for it eh?", "Ooooh I love an good dance partner!")
	var/quipsneardeath = list("Wait wait wait i'm sorry ok!?", "Damn..! Not like this!", "YOU won't be my end!", "DIE! DIE! DIE!", "I've been through worse...!", "Ngh..", "GAH-", "NO!", "DIE!", "Sunmarch isn't worth this..!", "Aeternus save me!", "I.. can still.... fight...!", "It's...going to be.... fine..!", "No! I'M supposed to be the one that WINS!", "I always win... just watch...")

/datum/action/boss/motormouth/Trigger() //Gets more desperate and less chatty as she's losing.
	. = ..()
	if(boss.health >= 400 && prob(88))
		boss.say(pick(quips))
	if(boss.health <= 400 && boss.health >= 200 && prob(77))
		boss.say(pick(quipsbloodied))
	if(boss.health <= 200 && prob(66))
		boss.say(pick(quipsneardeath))

/datum/action/boss/rapidfire //Desperation mechanic that makes her gimmick worse to deal with.
	check_flags = AB_CHECK_CONSCIOUS 
	boss_cost = 10
	usage_probability = 100
	needs_target = TRUE
	say_when_triggered = ""
	var/desperation = FALSE
	var/turf/dashturf
	var/dashdir

/datum/action/boss/rapidfire/Trigger()
	if(boss.health <= 200 && desperation == FALSE)
		boss.rapid = 3
		boss.say("Alright, That's it!! Now you asked for it!!!")
		boss.visible_message(span_boldannounce("[boss] cocks her crossbow and it transforms!"))
		playsound(boss,'sound/foley/gun_cock.ogg', 100)
		do_sparks(1,FALSE,boss) //make proper dodge effect proc later
		desperation = TRUE
		dashdir = get_dir(boss, boss.target) //Do exactly one martial dash to foil being penned in. Once.
		dashturf = get_step(boss.target, dashdir) 
		if(dashturf.density) 
			return
		boss.visible_message(span_boldannounce("[boss] backflips over [boss.target]!"))
		do_sparks(1, FALSE, boss)
		do_teleport(boss, dashturf, no_effects=TRUE)
		playsound(boss, 'sound/foley/martialdash.ogg', 100)
	else
		return

		