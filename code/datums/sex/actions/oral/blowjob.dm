
/datum/sex_action/blowjob
	name = "Suck them off"
	requires_hole_storage = TRUE
	hole_id = BODY_ZONE_PRECISE_MOUTH
	stored_item_type = /obj/item/organ/genitals/penis
	stored_item_name = "receiving member"
	require_grab = FALSE
	check_same_tile = FALSE
	requires_hole_storage = FALSE
	gags_user = TRUE
	target_priority = 100
	flipped = TRUE

/datum/sex_action/crotch_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/blowjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_PENIS))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE

	return TRUE

/datum/sex_action/blowjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] starts sucking [target]'s cock..."))

/datum/sex_action/blowjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.make_sucking_noise()
	do_thrust_animate(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] sucks [target] off."))

	sex_session.perform_sex_action(target, user, 2, 0, 2, src)
	sex_session.handle_passive_ejaculation(target)
	sex_session.perform_sex_action(user, target, 1, 0, 0.2, src)
	sex_session.handle_passive_ejaculation(user)

/datum/sex_action/blowjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops sucking [target]'s cock ..."))

/datum/sex_action/blowjob/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(target, ORGAN_SLOT_PENIS)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/blowjob/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target, must_flip)
	if(must_flip)
		target.visible_message(span_love("[user] cums into [target]'s mouth!"))
		return ORGASM_LOCATION_ORAL
	else
		target.visible_message(span_love("[user] creams themselves from sucking [target]'s cock!"))
		return ORGASM_LOCATION_SELF
