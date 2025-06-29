/obj/item/paper/scroll/quest
	name = "enchanted quest scroll"
	desc = "A weathered scroll enchanted to list the active quests from the Adventurers' Guild."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest"
	var/datum/quest/assigned_quest

/obj/item/paper/scroll/quest/examine(mob/user)
	. = ..()
	if(open)
		update_quest_text()

/obj/item/paper/scroll/quest/proc/update_quest_text()
	var/scroll_text = "<center>HELP NEEDED</center><br><br>"
	scroll_text += assigned_quest.title
	scroll_text += "issued by [assigned_quest.questee_name]<br>"
	scroll_text += "issued to [assigned_quest.quester_name]<br>"
	scroll_text += "a [assigned_quest.quest_type] quest<br>"
	scroll_text += "of [assigned_quest.quest_difficulty] difficulty<br>"
	scroll_text += "[assigned_quest.reward_amount] to be paid upon completion"

	info = scroll_text
