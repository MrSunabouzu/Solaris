//human master chef

/datum/advclass/masterchef
	name = "Master Chef"
	tutorial = "A master chef, one of the best cooks to ever live. \
	With noble origins, you were taught by cooking masters in the secretive League of Fine Dining in exotic meals from all around the world \
	Now you wander, free to experiment, cook exotic dishes and gourmet meals, worthy for a king."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/masterchef

	maximum_possible_slots = 1
	pickprob = 5
	category_tags = list(CTAG_TOWNER)

/datum/outfit/job/roguetown/adventurer/masterchef/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 6, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/butchering, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/tights/random
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	cloak = /obj/item/clothing/cloak/apron
	head = /obj/item/clothing/head/roguetown/chef
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/cooking/pan
	mouth = /obj/item/rogueweapon/huntingknife/cleaver
	beltl = /obj/item/flint
	r_hand = /obj/item/flashlight/flare/torch
	H.change_stat("intelligence", 3)
	H.change_stat("constitution", 2)
	H.change_stat("endurance", 1)
	if(H.age == AGE_OLD)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	var/packcontents = pickweight(list("Honey" = 1, "Truffles" = 1, "Bacon" = 1)) // What is our special ingredient? Honey, truffles, or BACON?
	switch(packcontents)
		if("Honey")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/honey = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				)
		if("Truffles")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/truffles = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				)
		if("Bacon")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/meat/bacon = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				)
