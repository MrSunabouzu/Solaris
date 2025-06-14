//shield
/datum/advclass/cleric
	name = "Cleric"
	tutorial = "Disciples of the divine - clerics are blessed with the power of miracles from the gods themselves."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_OUTLANDER)
	vampcompat = FALSE
	outfit = /datum/outfit/job/roguetown/adventurer/cleric
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	classes = list("Monk" = "You are a wandering acolyte, versed in both miracles and martial arts. You forego the heavy armor paladins wear in favor of a more nimble approach to combat, utilizing your fists.",
					"Paladin" = "A holy warrior. Where others of the clergy may have spent their free time studying scriptures, you have instead honed your skills with a blade.",
					"Missionary" = "You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith.",
					"Cantor" = "You were a bard once - but you've found a new calling. Your eyes have been opened to the divine, now you wander from city to city singing songs and telling tales of your patron's greatness.",
					"Druid" = "You are a specialized acolyte of Tamari, poised to wander and protect the land of Sunmarch in her name - having traded the comforts of the walled cities and towers for her wisdom.")

/datum/outfit/job/roguetown/adventurer/cleric
	allowed_patrons = ALL_PATRONS

/datum/outfit/job/roguetown/adventurer/cleric/pre_equip(mob/living/carbon/human/H)
	..()

	// Add druidic skill for Tamari followers
	var/classes = list("Monk","Paladin","Missionary","Cantor")
	if(istype(H.patron, /datum/patron/three_sisters/tamari))
		H.mind.adjust_skillrank(/datum/skill/magic/druidic, 3, TRUE)
		to_chat(H, span_notice("As a follower of Tamari, you have innate knowledge of druidic magic."))
		classes |= list("Druid") // We follow Tamari! Unlock Druid as an option.
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)

	switch(classchoice)

		if("Monk")
			H.set_blindness(0)
			to_chat(H, span_warning("You are a wandering acolyte, versed in both miracles and martial arts. You forego the heavy armor paladins wear in favor of a more nimble approach to combat, utilizing your fists."))
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			gloves = /obj/item/clothing/gloves/roguetown/chain
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			shoes = /obj/item/clothing/shoes/roguetown/boots
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/flashlight/flare/torch/lantern
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/roguekey/adventurers_guild = 1)
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_spells_templar(H)
			H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
			if(H.patron?.type == /datum/patron/three_sisters/nunos)
				H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
			if(H.patron?.type == /datum/patron/lording_three/tsoridys)
				ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/varielle)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/cinella)
				H.mind.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
				ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			var/weapons = list("Katar","Knuckle Dusters","MY BARE HANDS!!!")
			var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Katar")
					backpack_contents += list(/obj/item/rogueweapon/katar = 1)
				if("Knuckle Dusters")
					backpack_contents += list(/obj/item/rogueweapon/knuckles = 1)
				if("MY BARE HANDS!!!")
					ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			switch(H.patron?.type)
				if(/datum/patron/lording_three/aeternus)
					head = /obj/item/clothing/head/roguetown/roguehood/aeternus
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/aeternus
				if(/datum/patron/lording_three/zira)
					head =  /obj/item/clothing/head/roguetown/zirahood
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/zira
				if(/datum/patron/peoples_pantheon/cinella)
					head = /obj/item/clothing/head/roguetown/roguehood/cinella
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/cinella
				if(/datum/patron/three_sisters/tamari)
					head = /obj/item/clothing/head/roguetown/tamarimask
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/tamari
				if(/datum/patron/lording_three/tsoridys)
					head = /obj/item/clothing/head/roguetown/tsoridyshood
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/tsoridys
				if (/datum/patron/three_sisters/nunos)
					head = /obj/item/clothing/head/roguetown/roguehood //placeholder
					cloak = /obj/item/clothing/cloak/templar/nunite
				if (/datum/patron/peoples_pantheon/varielle)
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/varielle
					head = /obj/item/clothing/head/roguetown/variellemask
				else
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
					head = /obj/item/clothing/head/roguetown/roguehood
			H.cmode_music = 'sound/music/combat_holy.ogg'
			H.change_stat("strength", 2)
			H.change_stat("endurance", 1)
			H.change_stat("speed", 2)
			H.change_stat("perception", -1)
			H.change_stat("intelligence", -1)

		if("Paladin")
			to_chat(H, span_warning("A holy warrior. Where others of the clergy may have spent their free time studying scriptures, you have instead honed your skills with a blade."))
			belt = /obj/item/storage/belt/rogue/leather
			backl = /obj/item/storage/backpack/rogue/satchel
			backr = /obj/item/rogueweapon/shield/tower
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			pants = /obj/item/clothing/under/roguetown/chainlegs
			shoes = /obj/item/clothing/shoes/roguetown/boots
			gloves = /obj/item/clothing/gloves/roguetown/chain
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/roguekey/adventurers_guild = 1)
			H.mind.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
			if(H.patron?.type == /datum/patron/three_sisters/nunos)
				H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
			if(H.patron?.type == /datum/patron/lording_three/tsoridys)
				ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/varielle)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/cinella)
				H.mind.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
				ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			H.cmode_music = 'sound/music/combat_holy.ogg'
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			switch(H.patron?.type)
				if(/datum/patron/lording_three/aeternus)
					cloak = /obj/item/clothing/cloak/templar/aeternus
					head = /obj/item/clothing/head/roguetown/helmet/heavy/aeternian
				if(/datum/patron/lording_three/zira)
					cloak = /obj/item/clothing/cloak/templar/zira
					head = /obj/item/clothing/head/roguetown/helmet/heavy/zirahelm
				if(/datum/patron/peoples_pantheon/cinella)
					cloak = /obj/item/clothing/cloak/templar/cinella
					head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
				if(/datum/patron/three_sisters/tamari)
					cloak = /obj/item/clothing/cloak/templar/tamari
					head = /obj/item/clothing/head/roguetown/helmet/heavy/tamarihelm
				if(/datum/patron/lording_three/tsoridys)
					cloak = /obj/item/clothing/cloak/templar/tsoridys
					head = /obj/item/clothing/head/roguetown/helmet/heavy/tsoridyshelm
				if (/datum/patron/three_sisters/nunos)
					cloak = /obj/item/clothing/cloak/templar/nunos
					head = /obj/item/clothing/head/roguetown/helmet/heavy/nunos
				if (/datum/patron/peoples_pantheon/varielle)
					cloak = /obj/item/clothing/cloak/templar/varielle
					head = /obj/item/clothing/head/roguetown/helmet/heavy/variellian
				if (/datum/patron/peoples_pantheon/carthus)
					cloak = /obj/item/clothing/cloak/templar/carthus
					head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold
				if (/datum/patron/three_sisters/kasmidian)
					cloak = /obj/item/clothing/cloak/templar/kasmidian
					head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
				else
					cloak = /obj/item/clothing/cloak/cape/crusader
					head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_spells_templar(H)
			var/weapons = list("Bastard Sword","Mace","Flail")
			var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Bastard Sword")
					H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
					beltr = /obj/item/rogueweapon/sword/long
				if("Mace")
					H.mind.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
					beltr = /obj/item/rogueweapon/mace
				if("Flail")
					H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
					beltr = /obj/item/rogueweapon/flail
			H.set_blindness(0)
			H.change_stat("strength", 2)
			H.change_stat("constitution", 2)
			H.change_stat("endurance", 1)

		if("Cantor")
			H.set_blindness(0)
			to_chat(H, span_warning("You were a bard once - but you've found a new calling. Your eyes have been opened to the divine, now you wander from city to city singing songs and telling tales of your patron's greatness."))
			head = /obj/item/clothing/head/roguetown/bardhat
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
			backl = /obj/item/storage/backpack/rogue/satchel
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
			gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_spells_templar(H)
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/roguekey/adventurers_guild = 1)
			H.mind.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
			if(H.patron?.type == /datum/patron/three_sisters/nunos)
				H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
			if(H.patron?.type == /datum/patron/lording_three/tsoridys)
				ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/varielle)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/cinella)
				H.mind.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
				ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			H.cmode_music = 'sound/music/combat_bard.ogg'
			H.change_stat("strength", 1)
			H.change_stat("endurance", 1)
			H.change_stat("speed", 2)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
			switch(H.patron?.type)
				if(/datum/patron/lording_three/aeternus)
					cloak = /obj/item/clothing/cloak/templar/aeternus
				if(/datum/patron/lording_three/zira)
					cloak = /obj/item/clothing/cloak/templar/zira
				if(/datum/patron/peoples_pantheon/cinella)
					cloak = /obj/item/clothing/cloak/templar/cinella
				if(/datum/patron/three_sisters/tamari)
					cloak = /obj/item/clothing/cloak/templar/tamari
				if(/datum/patron/lording_three/tsoridys)
					cloak = /obj/item/clothing/cloak/templar/tsoridys
				if (/datum/patron/three_sisters/nunos)
					cloak = /obj/item/clothing/cloak/templar/nunos
				if (/datum/patron/peoples_pantheon/varielle)
					cloak = /obj/item/clothing/cloak/templar/varielle
				if (/datum/patron/peoples_pantheon/carthus)
					cloak = /obj/item/clothing/cloak/templar/carthus
				if (/datum/patron/three_sisters/kasmidian)
					cloak = /obj/item/clothing/cloak/templar/kasmidian
				else
					cloak = /obj/item/clothing/cloak/cape/crusader
			var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman")
			var/weapon_choice = input("Choose your instrument.", "TAKE UP ARMS") as anything in weapons
			H.set_blindness(0)
			switch(weapon_choice)
				if("Harp")
					backr = /obj/item/rogue/instrument/harp
				if("Lute")
					backr = /obj/item/rogue/instrument/lute
				if("Accordion")
					backr = /obj/item/rogue/instrument/accord
				if("Guitar")
					backr = /obj/item/rogue/instrument/guitar
				if("Hurdy-Gurdy")
					backr = /obj/item/rogue/instrument/hurdygurdy
				if("Viola")
					backr = /obj/item/rogue/instrument/viola
				if("Vocal Talisman")
					backr = /obj/item/rogue/instrument/vocals

		if("Missionary")
			H.set_blindness(0)
			to_chat(H, span_warning("You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."))
			backl = /obj/item/storage/backpack/rogue/satchel
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots
			backr = /obj/item/rogueweapon/woodstaff
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/flashlight/flare/torch/lantern
			backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch = 1, /obj/item/roguekey/adventurers_guild = 1)
			H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/magic/holy, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
			if(H.patron?.type == /datum/patron/three_sisters/nunos)
				H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
			if(H.patron?.type == /datum/patron/lording_three/tsoridys)
				ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/varielle)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
			if(H.patron?.type == /datum/patron/peoples_pantheon/cinella)
				H.mind.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
				ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			H.cmode_music = 'sound/music/combat_holy.ogg'
			H.change_stat("intelligence", 2)
			H.change_stat("endurance", 1)
			H.change_stat("perception", 2)
			H.change_stat("speed", 1)
			switch(H.patron?.type)
				if(/datum/patron/lording_three/aeternus)
					head = /obj/item/clothing/head/roguetown/roguehood/aeternus
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/aeternus
				if(/datum/patron/lording_three/zira)
					head =  /obj/item/clothing/head/roguetown/zirahood
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/zira
				if(/datum/patron/peoples_pantheon/cinella)
					head = /obj/item/clothing/head/roguetown/roguehood/cinella
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/cinella
				if(/datum/patron/three_sisters/tamari)
					head = /obj/item/clothing/head/roguetown/tamarimask
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/tamari
					H.cmode_music = 'sound/music/combat_druid.ogg'
				if(/datum/patron/lording_three/tsoridys)
					head = /obj/item/clothing/head/roguetown/tsoridyshood
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/tsoridys
				if (/datum/patron/three_sisters/nunos)
					head = /obj/item/clothing/head/roguetown/roguehood //placeholder
					cloak = /obj/item/clothing/cloak/templar/nunite
				if (/datum/patron/peoples_pantheon/varielle)
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/varielle
					head = /obj/item/clothing/head/roguetown/variellemask
				else
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
					head = /obj/item/clothing/head/roguetown/roguehood
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_spells_monk(H)
			START_PROCESSING(SSobj, C)
		if("Druid")
			if(!istype(H.patron, /datum/patron/three_sisters/tamari)) // I see your bitchass
				message_admins("ADMIN LOG: [H] attempted to bypass class protection to play druid as a non-tamari worshipper.")
				return // eat shit and live, bill
			H.set_blindness(0)
			to_chat(H, span_warning("You are a specialized acolyte of Tamari, poised to wander and protect the land of Sunmarch in her name - having traded the comforts of the walled cities and towers for her wisdom."))
			allowed_patrons = list(/datum/patron/three_sisters/tamari)
			default_patron = /datum/patron/three_sisters/tamari
			belt = /obj/item/storage/belt/rogue/leather/rope
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/rogueweapon/whip //The whip itself is not often associated to many jobs. Druids feel like a thematic choice to have a self-defense whip
			backl = /obj/item/storage/backpack/rogue/satchel
			backr = /obj/item/rogueweapon/woodstaff
			head = /obj/item/clothing/head/roguetown/tamarimask
			shirt = /obj/item/clothing/suit/roguetown/shirt/robe/tamari
			backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife/stoneknife = 1, /obj/item/roguekey/adventurers_guild = 1)
			if(H.mind) // Mostly based off the old druid job with some minor tweaks and cuts. THESE druids are still ambushable
				H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
				H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
				H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
				H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/magic/holy, 4, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
				H.mind.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
				H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
				H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
				H.mind.adjust_skillrank(/datum/skill/magic/druidic, 3, TRUE) //Shapeshifting.
				H.mind.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE) //Druids know the forest and when it has been disturbed
				H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
				H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
				H.mind.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE) //To help them defend themselves with parrying
				H.change_stat("intelligence", 1)
				H.change_stat("endurance", 1)
				H.change_stat("speed", 1)
				if(H.age == AGE_OLD)
					H.mind.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
					H.mind.adjust_skillrank(/datum/skill/magic/druidic, 1, TRUE)
				H.change_stat("intelligence", 1)
				H.change_stat("endurance", 1)
				H.change_stat("perception", -1)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_spells_monk(H) // Equivalent skills to an acolyte rather than the priest

	switch(H.patron?.type)
		if(/datum/patron/lording_three/aeternus)
			neck = /obj/item/clothing/neck/roguetown/psicross/aeternus
		if(/datum/patron/lording_three/zira)
			neck = /obj/item/clothing/neck/roguetown/psicross/zira
		if(/datum/patron/peoples_pantheon/cinella)
			neck = /obj/item/clothing/neck/roguetown/psicross/cinella
		if(/datum/patron/three_sisters/tamari)
			neck = /obj/item/clothing/neck/roguetown/psicross/tamari
		if(/datum/patron/lording_three/tsoridys)
			neck = /obj/item/clothing/neck/roguetown/psicross/tsoridys
		if(/datum/patron/peoples_pantheon/carthus)
			neck = /obj/item/clothing/neck/roguetown/psicross/carthus
		if(/datum/patron/three_sisters/nunos)
			neck = /obj/item/clothing/neck/roguetown/psicross/nunos
		if(/datum/patron/peoples_pantheon/varielle)
			neck = /obj/item/clothing/neck/roguetown/psicross/varielle
		if(/datum/patron/three_sisters/kasmidian) // SOLARIS NOTE: kasmidian would ideally have their own psicross but idc to change this off xylix behavior rn
			var/list/psicross_options = list(
			/obj/item/clothing/neck/roguetown/psicross,
			/obj/item/clothing/neck/roguetown/psicross/aeternus,
			/obj/item/clothing/neck/roguetown/psicross/zira,
			/obj/item/clothing/neck/roguetown/psicross/cinella,
			/obj/item/clothing/neck/roguetown/psicross/tamari,
			/obj/item/clothing/neck/roguetown/psicross/tsoridys,
			/obj/item/clothing/neck/roguetown/psicross/carthus,
			/obj/item/clothing/neck/roguetown/psicross/nunos,
			/obj/item/clothing/neck/roguetown/psicross/varielle
			)
			neck = pick(psicross_options)

	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
