GLOBAL_LIST_INIT(command_positions, list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician"))


GLOBAL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",
	"Virologist",
	"Chemist"))


GLOBAL_LIST_INIT(science_positions, list(
	"Research Director",
	"Scientist",
	"Roboticist"))


GLOBAL_LIST_INIT(supply_positions, list(
	"Head of Personnel",
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner"))


GLOBAL_LIST_INIT(civilian_positions, list(
	"Bartender",
	"Kek",
	"Cook",
	"Janitor",
	"Curator",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Mime",
	"Assistant"))


GLOBAL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer"))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	"AI",
	"Cyborg",
	ROLE_PAI))

GLOBAL_LIST_INIT(noble_positions, list(
	/datum/job/roguetown/lord::title,
	/datum/job/roguetown/nobleman::title,
	/datum/job/roguetown/hand::title,
	/datum/job/roguetown/captain::title,
	/datum/job/roguetown/marshal::title,
	/datum/job/roguetown/steward::title,
	/datum/job/roguetown/clerk::title,
	/datum/job/roguetown/knight::title
))

GLOBAL_LIST_INIT(courtier_positions, list(
	/datum/job/roguetown/magician::title,
	/datum/job/roguetown/deacon::title,
	/datum/job/roguetown/councillor::title,
	/datum/job/roguetown/jester::title,
	/datum/job/roguetown/seneschal::title,
	/datum/job/roguetown/servant::title
))

GLOBAL_LIST_INIT(garrison_positions, list(
	/datum/job/roguetown/guardsman::title,
	/datum/job/roguetown/bogguardsman::title,
	/datum/job/roguetown/sergeant::title,
	/datum/job/roguetown/manorguard::title,
	/datum/job/roguetown/veteran::title,
	/datum/job/roguetown/hostage::title,
	/datum/job/roguetown/prisonerr::title,
	/datum/job/roguetown/squire::title
))

GLOBAL_LIST_INIT(church_positions, list(
	/datum/job/roguetown/priest::title,
	/datum/job/roguetown/acolyte::title,
	/datum/job/roguetown/templar::title,
	/datum/job/roguetown/churchling::title
))

GLOBAL_LIST_INIT(yeoman_positions, list(
	/datum/job/roguetown/merchant::title,
	/datum/job/roguetown/shophand::title,
	/datum/job/roguetown/barkeep::title,
	/datum/job/roguetown/blacksmith::title,
	/datum/job/roguetown/bapprentice::title,
	/datum/job/roguetown/janitor::title,
	/datum/job/roguetown/tailor::title,
	/datum/job/roguetown/ghandler::title,
))

GLOBAL_LIST_INIT(peasant_positions, list(
	/datum/job/roguetown/adventurer::title,
	/datum/job/roguetown/bandit::title,
	/datum/job/roguetown/pilgrim::title,
	/datum/job/roguetown/towner::title,
	/datum/job/roguetown/lunatic::title,
	/datum/job/roguetown/knavewench::title,
	/datum/job/roguetown/woodsman::title,
	/datum/job/roguetown/adventurer/courtagent::title,
	/datum/job/roguetown/soilson::title,
	/datum/job/roguetown/wretch::title,
))

GLOBAL_LIST_INIT(mages_university_positions, list(
	/datum/job/roguetown/head_mage::title,
	/datum/job/roguetown/alchemist::title,
	/datum/job/roguetown/archivist::title,
	/datum/job/roguetown/artificer::title,
	/datum/job/roguetown/apothicant_apprentice::title,
	/datum/job/roguetown/wapprentice::title
))

GLOBAL_LIST_INIT(allmig_positions, list(
	"Adventurer",
	"Pilgrim",
))

GLOBAL_LIST_INIT(roguewar_positions, list(
	"Adventurer",
))

GLOBAL_LIST_INIT(test_positions, list(
	"Tester",
))

GLOBAL_LIST_INIT(job_assignment_order, get_job_assignment_order())

/proc/get_job_assignment_order()
	var/list/sorting_order = list()
	sorting_order += GLOB.noble_positions
	sorting_order += GLOB.courtier_positions
	sorting_order += GLOB.garrison_positions
	sorting_order += GLOB.church_positions
	sorting_order += GLOB.yeoman_positions
	sorting_order += GLOB.peasant_positions
	sorting_order += GLOB.mages_university_positions
	return sorting_order

GLOBAL_LIST_INIT(exp_jobsmap, list(
	EXP_TYPE_CREW = list("titles" = peasant_positions | command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | civilian_positions | list("AI","Cyborg")), // crew positions
	EXP_TYPE_COMMAND = list("titles" = command_positions),
	EXP_TYPE_ENGINEERING = list("titles" = engineering_positions),
	EXP_TYPE_MEDICAL = list("titles" = medical_positions),
	EXP_TYPE_SCIENCE = list("titles" = science_positions),
	EXP_TYPE_SUPPLY = list("titles" = supply_positions),
	EXP_TYPE_SECURITY = list("titles" = security_positions),
	EXP_TYPE_SILICON = list("titles" = list("AI","Cyborg")),
	EXP_TYPE_SERVICE = list("titles" = civilian_positions),
))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

/proc/guest_jobbans(job)
	return ((job in GLOB.command_positions) || (job in GLOB.nonhuman_positions) || (job in GLOB.security_positions))



//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job


