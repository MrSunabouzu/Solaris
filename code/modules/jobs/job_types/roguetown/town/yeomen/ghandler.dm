/datum/job/roguetown/ghandler
	title = "Guild Handler"
	flag = GHANDLER
	department_flag = YEOMEN
	selection_color = JCOLOR_YEOMAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_ALL_KINDS

	tutorial = "You are the proud handler for the local branch of the Rasurian Adventurer's Guild. You've taken upon yourself the task of wrangling the constant flow of adventurers and treasure-seekers into the March. It is a job of constant diplomacy and occasional action, keeping the local lords happy while arranging quests and affairs for the adventurers."
	advclass_cat_rolls = list(CTAG_GHANDLER = 20)
	display_order = JDO_GHANDLER
	give_bank_account = 43
	min_pq = 1
	max_pq = null
	round_contrib_points = 2


/datum/job/roguetown/ghandler/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")


/datum/advclass/ghandler/ace
	name = "Ace Adventurer"
	tutorial = "You were the best of the best. Being among the best of the Guild comes with promotion but what they don't tell you is that promotion comes with a desk, paperwork and endless responsibility. Your talent might be rusty but you can still pack a punch."
	outfit = /datum/outfit/job/roguetown/ghandler/ace

	category_tags = list(CTAG_GHANDLER)

/datum/outfit/job/roguetown/ghandler/ace/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/ghandler
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/clothing/neck/roguetown/horus
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/mace/silver
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/keyring/ghandler
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/paper = 2, /obj/item/natural/feather = 1)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("perception", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 1)
		H.change_stat("endurance", 1)
		H.change_stat("fortune", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/advclass/ghandler/receptionist
	name = "Guild Receptionist"
	tutorial = "You're not a fighter. As the Adventuring Guild grew from a twinkle in an enterprising eye to having holds all over Rasura the reality of the work set in. Someone needs to write paperwork, assign pay and communicate with local lords and ladies lest someones head gets lopped. That's where you come in. Booksmart and clever and respected by every toughbooted adventurer that walks in the door. "
	outfit = /datum/outfit/job/roguetown/ghandler/receptionist

	category_tags = list(CTAG_GHANDLER)

/datum/outfit/job/roguetown/ghandler/receptionist/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/ghandler
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	pants = /obj/item/clothing/under/roguetown/tights/black
	neck = /obj/item/clothing/neck/roguetown/horus
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/keyring/ghandler
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/
	backpack_contents = list(/obj/item/paper = 4, /obj/item/natural/feather = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.change_stat("perception", 2)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 1)
		H.change_stat("endurance", 1)
		H.change_stat("fortune", 2)
		H.change_stat("speed", 1)