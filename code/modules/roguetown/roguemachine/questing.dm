/obj/item/roguemachine/quest_giver
	name = "quest giver"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'code/modules/roguetown/roguemachine/questing.dmi'
	icon_state = "questgiver"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
