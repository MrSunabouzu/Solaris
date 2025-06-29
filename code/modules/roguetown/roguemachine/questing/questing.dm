/obj/structure/roguemachine/questgiver
	name = "grand quest book"
	desc = "A large wooden notice board, carrying postings from all across Sunmarch. A crow's perch sits atop it."
	icon = 'code/modules/roguetown/roguemachine/questing.dmi'
	icon_state = "questgiver"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	///Whether it's the main one, -guild-belonging-, or not. Determines accessibility, reward thresholds and cooldowns.
	var/guild = FALSE
	///Place to deposit completed scrolls or items to pawn off.
	var/input_point
	///Place to spawn scrolls or rewards at.
	var/scroll_point

/obj/structure/roguemachine/questgiver/Initialize()
	. = ..()
	SSroguemachine.questgivers += src
	input_point = locate(x - 1, y, z)
	scroll_point = locate(x, y, z)

/obj/structure/roguemachine/questgiver/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	// Main Menu
	var/list/choices = list("Consult Quests", "Turn In Quest", "Abandon Quest")

	if(guild)
		choices += list("Print Issued Quests")

	var/selection = input(user, "The Excidium listens", src) as null|anything in choices

	switch(selection)

		if("Consult Quests")
			consult_quests(user)

		if("Turn In Quest")
			turn_in_quest(user)

		if("Abandon Quest")
			abandon_quest(user)

		if("Print Issued Quests")
			print_quests(user)


//Quest generator. Guild one's better (permits high difficulty quests, has better rewards and requires no deposit fees). Requires a small deposit to spawn it in.
/obj/structure/roguemachine/questgiver/proc/consult_quests(mob/user)

	// Has user a bank account?
	if(!(user in SStreasury.bank_accounts))
		say("You have no bank account.")
		return

	// Has user enough money?
	if(SStreasury.bank_accounts[user] < amount)
		say("Insufficient balance funds.")
		return

//Turn in completed scrolls. Click your scroll on some item or a landmark where it'll spawn to activate it and make it turnable in.
/obj/structure/roguemachine/questgiver/proc/turn_in_quest(mob/user)
	var/reward
	if(guild)
		reward *= 2 //So guild handlers get some profit you know.
	switch(scroll.difficulty) //deposit returns
		if(1)
			reward += 10
		if(2)
			reward += 20
		if(3)
			reward += 40

//Place a scroll to the left of the machine and abandon it. Gives your deposit back.
/obj/structure/roguemachine/questgiver/proc/abandon_quest(mob/user)

//Prints a list of issued quests, to whom and which and their general area.
/obj/structure/roguemachine/questgiver/proc/print_quests(mob/user)
