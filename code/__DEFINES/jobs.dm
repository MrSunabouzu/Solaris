
#define ENGSEC			(1<<0)

#define CAPTAIN			(1<<0)
#define HOS				(1<<1)
#define WARDEN			(1<<2)
#define DETECTIVE		(1<<3)
#define OFFICER			(1<<4)
#define CHIEF			(1<<5)
#define ENGINEER		(1<<6)
#define ATMOSTECH		(1<<7)
#define ROBOTICIST		(1<<8)
#define AI_JF			(1<<9)
#define CYBORG			(1<<10)


#define MEDSCI			(1<<1)

#define RD_JF			(1<<0)
#define SCIENTIST		(1<<1)
#define CHEMIST			(1<<2)
#define CMO_JF			(1<<3)
#define DOCTOR			(1<<4)
#define GENETICIST		(1<<5)
#define VIROLOGIST		(1<<6)


#define CIVILIAN		(1<<2)

#define HOP				(1<<0)
#define BARTENDER		(1<<1)
#define BOTANIST		(1<<2)
//#define COOK			(1<<3) //This is redefined below, and is a ss13 leftover.
//#define JANITOR		(1<<4) //This is redefined below, and is a ss13 leftover.
#define CURATOR			(1<<5)
#define QUARTERMASTER	(1<<6)
#define CARGOTECH		(1<<7)
//#define MINER			(1<<8) //This is redefined below, and is a ss13 leftover.
#define LAWYER			(1<<9)
#define CHAPLAIN		(1<<10)
#define CLOWN			(1<<11)
#define MIME			(1<<12)
#define ASSISTANT		(1<<13)

#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_PATRON 5
#define JOB_UNAVAILABLE_RACE 6
#define JOB_UNAVAILABLE_SEX 7
#define JOB_UNAVAILABLE_AGE 8
#define JOB_UNAVAILABLE_WTEAM 9
#define JOB_UNAVAILABLE_LASTCLASS 10
#define JOB_UNAVAILABLE_JOB_COOLDOWN 11
#define JOB_UNAVAILABLE_SLOTFULL 12
#define JOB_UNAVAILABLE_VIRTUESVICE 13

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"

#define JOB_DISPLAY_ORDER_DEFAULT 0

#define JOB_DISPLAY_ORDER_ASSISTANT 1
#define JOB_DISPLAY_ORDER_CAPTAIN 2
#define JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL 3
#define JOB_DISPLAY_ORDER_QUARTERMASTER 4
#define JOB_DISPLAY_ORDER_CARGO_TECHNICIAN 5
#define JOB_DISPLAY_ORDER_SHAFT_MINER 6
#define JOB_DISPLAY_ORDER_BARTENDER 7
#define JOB_DISPLAY_ORDER_COOK 8
#define JOB_DISPLAY_ORDER_BOTANIST 9
#define JOB_DISPLAY_ORDER_JANITOR 10
#define JOB_DISPLAY_ORDER_CLOWN 11
#define JOB_DISPLAY_ORDER_MIME 12
#define JOB_DISPLAY_ORDER_CURATOR 13
#define JOB_DISPLAY_ORDER_LAWYER 14
#define JOB_DISPLAY_ORDER_CHAPLAIN 15
#define JOB_DISPLAY_ORDER_CHIEF_ENGINEER 16
#define JOB_DISPLAY_ORDER_STATION_ENGINEER 17
#define JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN 18
#define JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER 19
#define JOB_DISPLAY_ORDER_MEDICAL_DOCTOR 20
#define JOB_DISPLAY_ORDER_CHEMIST 21
#define JOB_DISPLAY_ORDER_GENETICIST 22
#define JOB_DISPLAY_ORDER_VIROLOGIST 23
#define JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR 24
#define JOB_DISPLAY_ORDER_SCIENTIST 25
#define JOB_DISPLAY_ORDER_ROBOTICIST 26
#define JOB_DISPLAY_ORDER_HEAD_OF_SECURITY 27
#define JOB_DISPLAY_ORDER_WARDEN 28
#define JOB_DISPLAY_ORDER_DETECTIVE 29
#define JOB_DISPLAY_ORDER_SECURITY_OFFICER 30
#define JOB_DISPLAY_ORDER_AI 31
#define JOB_DISPLAY_ORDER_CYBORG 32

#define NOBLEMEN					(1<<0)

#define LORD					(1<<0)
#define NOBLEMAN				(1<<1)
#define HAND					(1<<2)
#define STEWARD					(1<<3)
#define CLERK 					(1<<4)
#define KNIGHT					(1<<5)
#define GUARD_CAPTAIN			(1<<6)
#define MARSHAL					(1<<7)

#define GARRISON					(1<<1)

#define GUARDSMAN				(1<<0)
#define MANATARMS				(1<<1)
#define BOGGUARD				(1<<2)
#define SERGEANT				(1<<3)
#define SQUIRE					(1<<4)
#define SHERIFF					(1<<5)
#define VETERAN					(1<<6)
#define HOSTAGE					(1<<7)
#define PRISONERR				(1<<8)

#define CHURCHMEN					(1<<2)

#define PRIEST					(1<<0)
#define MONK					(1<<1)
#define TEMPLAR					(1<<2)
#define CHURCHLING				(1<<3)

#define COURTIERS					(1<<3)

#define JESTER					(1<<0)
#define WIZARD					(1<<1)
#define DEACON		 			(1<<2)
#define COUNCILLOR				(1<<3)
#define BUTLER					(1<<4)
#define SERVANT					(1<<5)

#define YEOMEN						(1<<4)

#define BARKEEP					(1<<0)
#define BLACKSMITH				(1<<1)
#define APPRENTICE				(1<<2)
#define MERCHANT				(1<<3)
#define SHOPHAND				(1<<4)
#define JANITOR					(1<<5)
#define TAILOR					(1<<6)
#define GHANDLER				(1<<7)

#define PEASANTS					(1<<5)

#define KNAVEWENCH 				(1<<0)
#define ADVENTURER				(1<<1)
#define PILGRIM					(1<<2)
#define VILLAGER				(1<<3)
#define SOILSON					(1<<4)
#define LUNATIC					(1<<5)
#define MIGRANT					(1<<6)
#define BANDIT					(1<<7)
#define COURTAGENT				(1<<8)
#define ELDER					(1<<9)
#define WRETCH					(1<<10)

#define MAGES_UNIVERSITY			(1<<7)

#define HEAD_MAGE				(1<<0)
#define ALCHEMIST				(1<<1)
#define ARCHIVIST				(1<<2)
#define ARTIFICER				(1<<3)
#define APOTHICANT_APPRENTICE	(1<<4)
#define MAGEAPPRENTICE			(1<<5)

#define SLOP						(1<<8)

#define TESTER					(1<<0)
#define DEATHKNIGHT				(1<<1)
#define SKELETON				(1<<2)

/// siri explain this to me in ss13 terms
#define JCOLOR_NOBLE "#0b638b" // Command
#define JCOLOR_COURTIER "#215bb3" // Extension Of Command
#define JCOLOR_CHURCH "#81d1d1" // Medical
#define JCOLOR_MAGES "#965b9e" // Science
#define JCOLOR_SOLDIER "#b18484" // Security
#define JCOLOR_YEOMAN "#819e82" // Service
#define JCOLOR_PEASANT "#cfbb9a" // Service but also Greytiders
#define JCOLOR_SLOP "#71c980" // Deathsquad
#define JCOLOR_ANTAG "#9c0000" // Syndies

// job display orders //

/// Nobles
#define JDO_LORD 1
#define JDO_NOBLEMAN 2
#define JDO_HAND 3
#define JDO_STEWARD 4
#define JDO_CLERK 5
#define JDO_MARSHAL 6
#define JDO_COUNCILLOR 7
#define JDO_KNIGHT 8
#define JDO_GUARD_CAPTAIN 9

/// Courtiers
#define JDO_MAGICIAN 10
#define JDO_DEACON 11
#define JDO_BUTLER 12
#define JDO_JESTER 13
#define JDO_SERVANT 14

/// Garrison
#define JDO_SERGEANT 15
#define JDO_SQUIRE 16
#define JDO_CASTLEGUARD 17
#define JDO_TOWNGUARD 18
#define JDO_VET 19
#define JDO_BOGGUARD 20
#define JDO_PRISONERR 21
#define JDO_HOSTAGE 22

/// Mage's University
#define JDO_HEAD_MAGE 23
#define JDO_ARTIFICER 24
#define JDO_ALCHEMIST 25
#define JDO_ARCHIVIST 26
#define JDO_MAGEAPPRENTICE 27
#define JDO_APOTHICANT_APPRENTICE 28

/// Church
#define JDO_PRIEST 29
#define JDO_MONK 30
#define JDO_TEMPLAR 31
#define JDO_CHURCHLING 32

/// Town
#define JDO_MERCHANT 33
#define JDO_SHOPHAND 34

#define JDO_CHIEF 35
#define JDO_BLACKSMITH 36
#define JDO_APPRENTICE 37

#define JDO_BARKEEP 38
#define JDO_KNAVEWENCH 39
#define JDO_SOILSON 40
#define JDO_JANITOR 41
#define JDO_TAILOR 42
#define JDO_GHANDLER 43

#define JDO_VILLAGER 44

/// External
#define JDO_ADVENTURER 45
#define JDO_PILGRIM 46
#define JDO_MIGRANT 47
#define JDO_BANDIT 48
#define JDO_COURTAGENT 49
#define JDO_WRETCH 50

#define JDO_LUNATIC 51 // ALWAYS keep lunatic last. It's a reward role for being a true sport.

#define MANOR_ROLES \
	/datum/job/roguetown/jester,\
	/datum/job/roguetown/veteran,\
	/datum/job/roguetown/clerk,\
	/datum/job/roguetown/servant,\
	/datum/job/roguetown/squire,\
	/datum/job/roguetown/seneschal,\
	/datum/job/roguetown/magician

#define NOBLE_ROLES \
	/datum/job/roguetown/nobleman,\
	/datum/job/roguetown/councillor,\
	/datum/job/roguetown/deacon,\
	/datum/job/roguetown/marshal,\
	/datum/job/roguetown/captain,\
	/datum/job/roguetown/hand,\
	/datum/job/roguetown/knight,\
	/datum/job/roguetown/lady,\
	/datum/job/roguetown/lord,\
	/datum/job/roguetown/steward

#define KING_QUEEN_ROLES \
	/datum/job/roguetown/lady,\
	/datum/job/roguetown/lord

#define CHURCH_ROLES \
	/datum/job/roguetown/churchling,\
	/datum/job/roguetown/acolyte,\
	/datum/job/roguetown/priest,\
	/datum/job/roguetown/templar

#define PEASANT_ROLES \
	/datum/job/roguetown/towner,\
	/datum/job/roguetown/soilson,\
	/datum/job/roguetown/cook,\
	/datum/job/roguetown/knavewench,\
	/datum/job/roguetown/lunatic,\
	/datum/job/roguetown/shophand,\
	/datum/job/roguetown/bapprentice,\
	/datum/job/roguetown/hostage,\
	/datum/job/roguetown/prisonerr

#define YEOMEN_ROLES \
	/datum/job/roguetown/woodsman,\
	/datum/job/roguetown/barkeep,\
	/datum/job/roguetown/blacksmith,\
	/datum/job/roguetown/merchant,\
	/datum/job/roguetown/tailor,\
	/datum/job/roguetown/janitor,\
	/datum/job/roguetown/ghandler


#define WANDERER_ROLES \
	/datum/job/roguetown/pilgrim,\
	/datum/job/roguetown/adventurer,\
	/datum/job/roguetown/bandit

#define GARRISON_ROLES \
	/datum/job/roguetown/bogguardsman,\
	/datum/job/roguetown/sergeant,\
	/datum/job/roguetown/dungeoneer,\
	/datum/job/roguetown/gatemaster,\
	/datum/job/roguetown/manorguard,\
	/datum/job/roguetown/sheriff,\
	/datum/job/roguetown/guardsman

#define MAGES_UNIVERSITY_ROLES \
	/datum/job/roguetown/head_mage, \
	/datum/job/roguetown/archivist,\
	/datum/job/roguetown/artificer,\
	/datum/job/roguetown/wapprentice,\
	/datum/job/roguetown/apothicant_apprentice,\
	/datum/job/roguetown/alchemist
