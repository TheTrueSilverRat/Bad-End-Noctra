/datum/job/guilder
	title = "Thieves Guild Member"
	tutorial = "Blood stained Shadows, do you even see it when they line your palms with golden treasures?\
	\n\n\
	You are a member of the infamous Thieves' Guild, sprawled across the world as they stake their influence from the shadows.\
	Bound not by belief in Matthios but rather in the mutual interest of monopolizing the crime that lingers underneath cities. \
	\n\n\
	You care not on morals, only on a job done well. Another day, another mammon."
	department_flag = OUTSIDERS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_WRETCH
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_sexes = list(MALE,FEMALE)
	allowed_races = RACES_PLAYER_ALL

	outfit = null
	outfit_female = null
	advclass_cat_rolls = list(CTAG_CRIME = 20)

	is_foreigner = TRUE
	is_recognized = TRUE

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_CRIME, EXP_TYPE_COMBAT)

	jobstats = list(
		STATKEY_SPDS = 1, //All Thieves' Guild are kinda Sneaky
		STATKEY_PER = 1 //All Thieves' Guild are kinda perceptive
	)

	traits = list(
		TRAIT_THIEVESGUILD //For obvious reasons
	)

	mind_traits = list(
		TRAIT_KNOW_THIEF_DOORS
	)

	languages = list(/datum/language/thievescant)

/datum/job/guilder/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	to_chat(spawned, "<br><br><font color='#855b14'><span class='bold'>The Matron, the high overseer of the Guild Operations in the area may have work for you. See her in her room underneath the Tavern.</span></font><br><br>")

/datum/job/advclass/guilder
	abstract_type = /datum/job/advclass/guilder
	blacklisted_species = list(SPEC_ID_HALFLING)
	category_tags = list(CTAG_CRIME)
	exp_types_granted = list(EXP_TYPE_CRIME, EXP_TYPE_COMBAT)
