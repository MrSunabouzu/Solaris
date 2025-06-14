// Get what tier of spells is the user allowed to access
/proc/get_user_spell_tier(mob/target)
	if(HAS_TRAIT(target, TRAIT_ARCANE_T4))
		return 4
	if(HAS_TRAIT(target, TRAIT_ARCANE_T3) || (HAS_TRAIT(target, TRAIT_ARCANE_T2) && target.mind.get_skill_level(/datum/skill/magic/arcane) == SKILL_LEVEL_LEGENDARY))
		return 3
	if(HAS_TRAIT(target, TRAIT_ARCANE_T2) || (HAS_TRAIT(target, TRAIT_ARCANE_T1) && target.mind.get_skill_level(/datum/skill/magic/arcane) == SKILL_LEVEL_LEGENDARY))
		return 2
	if(HAS_TRAIT(target, TRAIT_ARCANE_T1) || HAS_TRAIT(target,TRAIT_MAGIC_TALENT))
		return 1
	return 0
