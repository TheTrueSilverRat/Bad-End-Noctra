/datum/sex_action/cunnilingus
	name = "Suck their cunt off"
	target_priority = 100
	gags_user = TRUE

/datum/sex_action/cunnilingus/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/cunnilingus/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_VAGINA))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts sucking [target]'s clit..."))

/datum/sex_action/cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] sucks [target]'s clit..."))
	user.make_sucking_noise()
	do_thrust_animate(user, target)

	sex_session.perform_sex_action(target, user, 2, 3, 2, src)
	sex_session.handle_passive_ejaculation(target)
	sex_session.perform_sex_action(user, target, 0.5, 0, 0, src)

/datum/sex_action/cunnilingus/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target, must_flip)
	if(must_flip)
		target.visible_message(span_love("[user] squirts girlcum into [target]'s mouth!"))
		return ORGASM_LOCATION_ORAL
	else //I mean it's never gonna happen but ok
		target.visible_message(span_love("[user] cums from sucking [target]'s pussy somehow!"))
		return ORGASM_LOCATION_SELF


/datum/sex_action/cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops sucking [target]'s clit ..."))

/datum/sex_action/cunnilingus/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_VAGINA)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)
