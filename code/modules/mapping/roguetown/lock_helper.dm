/obj/effect/mapping_helpers/lock_door
	layer = WALL_OBJ_LAYER
	icon_state = "locked_helper"

/obj/effect/mapping_helpers/lock_door/Initialize()
	. = ..()
	var/obj/structure/mineral_door/our_door = locate(/obj/structure/mineral_door) in loc
	if(!our_door)
		log_mapping("[src] at [AREACOORD(src)] tried to lock a door, but no door is present!")
		return
	if(our_door.locked) // Mapper fucked up
		log_mapping("[src] at [AREACOORD(src)] tried to lock a door, the door was already locked!")
		return
	our_door.locked = TRUE
