/obj/item/branding_iron
	name = "branding iron"
	desc = "A heavy iron meant to sear a mark into flesh when heated."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "brandingiron"
	item_state = "brandingiron"
	force = 8
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_BLUNT
	var/hott = 0

/obj/item/branding_iron/examine(mob/user)
	. = ..()
	if(hott)
		. += span_warning("It's red hot.")

/obj/item/branding_iron/get_temperature()
	if(hott)
		return T0C + 500
	return ..()

/obj/item/branding_iron/fire_act(added, maxstacks)
	. = ..()
	hott = world.time
	addtimer(CALLBACK(src, PROC_REF(make_unhot), hott), 30 SECONDS)

/obj/item/branding_iron/proc/make_unhot(input)
	if(hott == input)
		hott = 0

/obj/item/branding_iron/proc/is_hot()
	return hott || get_temperature() >= T0C + 400

/obj/item/branding_iron/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return ..()

	if(!is_hot())
		to_chat(user, span_warning("[src] needs to be heated red-hot before branding."))
		return TRUE

	// basic check for magically attuned user (job flag or trait)
	var/has_magic = FALSE
	if(user?.mind?.assigned_role?.magic_user)
		has_magic = TRUE
	else if(HAS_TRAIT(user, TRAIT_MAGICALLY_PHASED))
		has_magic = TRUE
	if(!has_magic)
		to_chat(user, span_warning("You feel no branding power flow through [src]; only a mage can force this mark."))
		return TRUE

	if(!get_location_accessible(target, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("You need clear access to their groin to brand them."))
		return TRUE

	var/obj/item/bodypart/groin_part = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
	if(groin_part?.wounds)
		for(var/datum/wound/slash/incision/incision as anything in groin_part.wounds)
			if(!incision.is_sewn())
				to_chat(user, span_warning("The incision on their groin prevents the brand from taking."))
				return TRUE

	var/branded = FALSE
	if(!HAS_TRAIT(target, TRAIT_INDENTURED))
		ADD_TRAIT(target, TRAIT_INDENTURED, "branding_iron")
		branded = TRUE

	target.apply_damage(5, BURN, BODY_ZONE_PRECISE_GROIN)
	target.visible_message(span_danger("[user] presses [src] against [target]'s groin, searing flesh!"))
	target.emote("painscream", forced = TRUE)
	if(branded)
		to_chat(target, span_danger("Agony floods you as the Baothan brand sears into your flesh."))
		if(SSindentured_trait)
			SSindentured_trait.apply_indentured(target)
	return TRUE
