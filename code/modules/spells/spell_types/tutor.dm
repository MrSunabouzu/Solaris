//A spell to teach other characters new skills
/obj/effect/proc_holder/spell/invoked/tutor
	name = "Arcane Tutoring"
	overlay_state = "book3"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	///just replace this var if doing a child for a new skill.
	var/datum/skill/item = /datum/skill/magic/arcane
	var/teachingtime = 30 SECONDS

/obj/effect/proc_holder/spell/invoked/tutor/cast(list/targets, mob/user = usr)
	. = ..()

	if(isliving(targets[1]))
		var/mob/living/L = targets[1]
		if(L == usr)
			to_chat(L, span_warning("In teaching myself, I become both the question and the answer."))
			return
		else
			if(L in range(1, usr))
				to_chat(usr, span_notice("My student needs some time to select a lesson."))
				if(!item)
					return  // student canceled
				if(alert(L, "Are you sure you want to study [item.name]?", "Learning", "Learn", "Cancel") == "Cancel")
					return
				if(HAS_TRAIT(L, TRAIT_STUDENT))
					to_chat(L, span_warning("There's no way I could handle all that knowledge!"))
					to_chat(usr, span_warning("My student cannot handle that much knowledge at once!"))
					return // cannot teach the same student twice
				if(L.mind?.get_skill_level(item) < SKILL_LEVEL_NOVICE)
					to_chat(L, span_warning("I cannot understand the lesson on [item.name], I need to get more skilled first!"))
					to_chat(usr, span_warning("I try teaching [L] [item.name] but my student couldnt grasp the lesson!"))
					return // some basic skill will not require you novice level
				if(L.mind?.get_skill_level(item) > SKILL_LEVEL_EXPERT)
					to_chat(L, span_warning("There's nothing I can learn from that person about [item.name]!"))
					to_chat(usr, span_warning("They know [item.name] better than I do, am I really supposed to be the teacher there?"))
					return // a student with master or legendary skill have nothing to learn from the scholar
				else
					to_chat(L, span_notice("[usr] starts teaching me about [item.name]!"))
					to_chat(usr, span_notice("[L] gets to listen carefully to my lesson about [item.name]."))
					if(L.mind?.get_skill_level(item) < SKILL_LEVEL_APPRENTICE) // +2 skill levels if novice
						if(do_after(usr, teachingtime, target = L))
							user.visible_message("<font color='yellow'>[user] teaches [L] a lesson.</font>")
							to_chat(usr, span_notice("My student grows a lot more proficient in [item.name]!"))
							L.mind?.adjust_skillrank(item, 2, FALSE)
							ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
						else
							to_chat(usr, span_warning("[L] got distracted and wandered off!"))
							to_chat(L, span_warning("I must be more focused on my studies!"))
							return
					else  // +1 skill level if apprentice or better
						if(do_after(usr, teachingtime, target = L))
							user.visible_message("<font color='yellow'>[user] teaches [L] a lesson.</font>")
							to_chat(usr, span_notice("My student grows more proficient in [item.name]!"))
							L.mind?.adjust_skillrank(item, 1, FALSE)
							ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
						else
							to_chat(usr, span_warning("[L] got distracted and wandered off!"))
							to_chat(L, span_warning("I must be more focused on my studies!"))
							return
			else
				to_chat(usr, span_warning("My student can barely hear me from there."))
				return
	else
		revert_cast()
		return FALSE