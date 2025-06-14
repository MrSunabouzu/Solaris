/mob/living/carbon/human/species/tieberian
	race = /datum/species/tieberian

/datum/species/tieberian
	name = "Tiefling"
	id = "tiefling"
	desc = "<b>Tiefling</b><br>\
To the outsider, the Tiefling is little more than a lesson in tragedy being written into a bloodline. The corruptive ebb and flow of the broken earth deep below, where the armies of the Underking once marched forward into the material plane, bled into mortal bodies to twist them into a darker reflection of what was once human but no longer is.\
To the privileged few, however, who understand the depths of what it means for a Tiefling to exist-- it is a lesson in redemption greater than any single lifetime. The intermingling of the 'corrupted' and the daemonic, those who had once been in the thrall of the Underking only to break free of his yoke, with the mortal races served to reinforce and stabilize the bloodlines into what is now recognized as a formal 'race'. <br>\

Tieflings have become more prominent, following the end of the Dusk Era, as survivors of the Breaches and remnant soldiers of the shattered hordes emerge into mortal society. Redeemed and redeemers both, they are still subject to skepticism and cruelty from the uninformed and the suspicious.\
Yet, it is a far cry from the struggles of the first to fall, who were often hunted, scorned, and outcasted from ‘civil’ society. As a result, many of the first Tieflings settled into remote, reclusive communities in the deep earth and in the wilds. <br>\
It is a popular rumor that the devilspawned are blessed by Nunos with the colors of the earth's greatest treasures, a small sign of the Voiceless One's gentle forgiveness or acceptance despite their accursed origins.\
While there is no official confirmation from the Church, this rumor has allowed some comfort and ease over the years in regards to those who would choose to move into the new urban societies following the Dusk War. <br>\
	(+1 Constitution, +1 Intelligence)"

	skin_tone_wording = "Progenitor"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_INTELLIGENCE = 1, STAT_CONSTITUTION = 1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/tiefling,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		//ORGAN_SLOT_TAIL = /obj/item/organ/tail/tiefling,
		//ORGAN_SLOT_HORNS = /obj/item/organ/horns/tiefling, We don't need these. No duplicate horns!
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/tail/tiefling,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
	)
	languages = list(
		/datum/language/common,
		/datum/language/hellspeak,
	)
	stress_examine = TRUE
	stress_desc = span_red("Helldweller... better stay away.")

/datum/species/tieberian/after_creation(mob/living/carbon/C)
	..()
	to_chat(C, "<span class='info'>I can speak Infernal with ,h before my speech.</span>")

/datum/species/tieberian/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/tieberian/get_skin_list()
	return list(
		"Jehoel" = SKIN_COLOR_JEHOEL,
		"Urvix" = SKIN_COLOR_URVIX,
		"Sarvyra" = SKIN_COLOR_SARVYRA,
		"Vheslyn" = SKIN_COLOR_VHESLYN,
		"Arlenneth" = SKIN_COLOR_ARLENNETH,
		"Nessyss" = SKIN_COLOR_NESSYSS,
		"Helixia" = SKIN_COLOR_HELIXIA,
		"Nymsea" = SKIN_COLOR_NYMSEA,
		"Vodyanev" = SKIN_COLOR_ABYSS,
		"Calvus" = SKIN_COLOR_CALVUS,
		"Voibion" = SKIN_COLOR_VOIBION,
		"Chyerno" = SKIN_COLOR_CHYERNO
	)

/datum/species/tieberian/get_hairc_list()
	return sortList(list(
	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b"
	))

/datum/species/tieberian/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/tiefm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/tieff.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/tiefm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/tieff.txt") )
	return randname

/datum/species/tieberian/random_surname()
	return " [pick(world.file2list("strings/rt/names/other/tieflast.txt"))]"


