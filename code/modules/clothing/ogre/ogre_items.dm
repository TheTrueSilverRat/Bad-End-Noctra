//................ Ogre Gear ............... //
#define OGRE_ONMOB_ICON 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
#define OGRE_ONMOB_SLEEVES 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'

/obj/item/clothing/head/helmet/graggar/ogre
	name = "graggar's champion helmet"
	desc = "The mark of Graggar's rampage, this is the helmet of his greatest warrior, his favorite child."
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "warlhelmet"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/armor/plate/ogre
	name = "giant cuirass"
	desc = "An absurdly large piece of armor, meant for an absurdly large warrior."
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_cuirass"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/armor/chainmail/hauberk/ogre
	name = "giant hauberk"
	desc = "A gigantic chainmail shirt, absurd to even think it would fit someone of normal size."
	sleeved = OGRE_ONMOB_SLEEVES
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_maille"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/pants/chainlegs/ogre
	name = "giant chain chausses"
	desc = "The amount of chainmail used for these could make a regular sized hauberk for a humble town guard."
	sleeved = OGRE_ONMOB_SLEEVES
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_chain"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/gloves/plate/ogre
	name = "oversized gauntlets"
	desc = "Huge, iron gauntlets - the size of a human head."
	icon = 'icons/roguetown/clothing/gloves.dmi'
	sleeved = OGRE_ONMOB_ICON
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogregrabbers"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/shoes/boots/armor/ogre
	name = "giant plate boots"
	desc = "When giants march to war, they need two things above all else. Something to eat, and boots to stomp around."
	icon = 'icons/roguetown/clothing/feet.dmi'
	sleeved = OGRE_ONMOB_ICON
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_plateboots"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/wrists/bracers/ogre
	name = "thick bracers"
	desc = "Normal humans can fit a leg through this hunk of steel."
	icon = 'icons/roguetown/clothing/wrists.dmi'
	sleeved = OGRE_ONMOB_ICON
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_bracers"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/clothing/neck/gorget/ogre
	name = "giant gorget"
	desc = "For the hardest working neck in the province, since you know people are going to target it first."
	icon = 'icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_gorget"
	allowed_race = list(SPEC_ID_OGRE)

/obj/item/storage/belt/leather/ogre
	name = "giant belt"
	desc = "When you have to tighten a belt of this size, best start keeping your tastiest allies close."
	icon = 'icons/roguetown/clothing/belts.dmi'
	sleeved = OGRE_ONMOB_ICON
	mob_overlay_icon = OGRE_ONMOB_ICON
	icon_state = "ogre_belt"

/obj/item/storage/belt/leather/ogre/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning, bypass_equip_delay_self)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(H.dna?.species?.id != SPEC_ID_OGRE)
		if(!disable_warning)
			to_chat(H, span_warning("This belt is far too large for me."))
		return FALSE

#undef OGRE_ONMOB_ICON
#undef OGRE_ONMOB_SLEEVES
