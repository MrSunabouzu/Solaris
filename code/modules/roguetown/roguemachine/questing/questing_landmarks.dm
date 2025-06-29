/obj/effect/landmark/quest_spawner
	name = "quest landmark"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "quest_marker"
	var/quest_difficulty = list("Easy", "Medium", "Hard")
	var/quest_type = list("Fetch", "Courier", "Clear Out", "Kill", "Beacon", "Miniboss")

/obj/effect/landmark/quest_spawner/easy
	name = "easy quest landmark"
	icon_state = "quest_marker_low"
	quest_difficulty = "Easy"
	quest_type = list("Fetch", "Courier", "Kill")

/obj/effect/landmark/quest_spawner/medium
	name = "medium quest landmark"
	icon_state = "quest_marker_mid"
	quest_difficulty = "Medium"
	quest_type = list("Kill", "Clear Out", "Beacon")

/obj/effect/landmark/quest_spawner/hard
	name = "hard quest landmark"
	icon_state = "quest_marker_high"
	quest_difficulty = "Hard"
	quest_type = list("Clear Out", "Beacon", "Miniboss")
