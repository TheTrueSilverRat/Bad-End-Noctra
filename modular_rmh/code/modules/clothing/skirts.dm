//By Vide Noir https://github.com/EaglePhntm.

/obj/item/clothing/pants/trou/leather/skirt
	name = "leather skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	desc = "Short skirt made of fine leather."
	icon_state = "leatherskirt"
	genital_access = TRUE

/obj/item/clothing/pants/trou/leather/advanced/skirt
	name = "hardened leather skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	icon_state = "hlskirt"
	item_state = "hlskirt"
	genital_access = TRUE

/obj/item/clothing/pants/chainlegs/iron/studdedskirt
	name = "studded leather skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	armor = ARMOR_LEATHER_GOOD
	desc = "Short studded skirt made of fine leather and iron."
	icon_state = "studdedskirt"
	genital_access = TRUE

/obj/item/clothing/pants/chainlegs/iron/skirt
	name = "iron chain skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	color = "#9EA48E"
	genital_access = TRUE

/obj/item/clothing/pants/chainlegs/skirt
	name = "chain skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	genital_access = TRUE

/obj/item/clothing/pants/platelegs/skirt
	name = "plated skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	icon_state = "plate_skirt"
	item_state = "plate_skirt"
	genital_access = TRUE

// Additional pants variants
/obj/item/clothing/pants/trou/leather/advanced/leggings
	name = "hardened leather leggings"
	desc = "Sturdy, durable, flexible. Shortened for better mobility."
	icon_state = "hlegs"
	item_state = "hlegs"

/obj/item/clothing/pants/chainlegs/bootyshorts
	name = "chain bootyshorts"
	desc = "Short chain mail shorts favored by those who want more mobility."
	icon_state = "chain_bootyshorts"
	item_state = "chain_bootyshorts"

///RECIPES

/datum/repeatable_crafting_recipe/sewing/leatherskirt
	name = "leather skirt"
	output = list(/obj/item/clothing/pants/trou/leather/skirt)
	requirements = list(/obj/item/natural/hide/cured = 1)
	sellprice = 10

/datum/repeatable_crafting_recipe/leather/standalone/hlskirt
	name = "hardened leather skirt"
	output = /obj/item/clothing/pants/trou/leather/advanced/skirt
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/chausses/leggings
	name = "hardened leather leggings"
	output = /obj/item/clothing/pants/trou/leather/advanced/leggings

/datum/anvil_recipe/armor/studdedskirt
	name = "Studded Skirt (+1 Leather Skirt)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/clothing/pants/trou/leather/skirt)
	created_item = /obj/item/clothing/pants/chainlegs/iron/studdedskirt
	category = "Armor"

/datum/anvil_recipe/armor/chainskirt
	name = "Chain Skirt"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/pants/chainlegs/skirt
	craftdiff = 2
	category = "Armor"

/datum/anvil_recipe/armor/ichainskirt
	name = "Iron Chain Skirt"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/pants/chainlegs/iron/skirt
	craftdiff = 1
	category = "Armor"

/datum/anvil_recipe/armor/plateskirt
	name = "Plate Tassets"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/pants/platelegs/skirt
	craftdiff = 4	//It's plate, no easy craft.
	category = "Armor"

/datum/anvil_recipe/armor/chainbootyshorts
	name = "Chain Bootyshorts"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/pants/chainlegs/bootyshorts
	craftdiff = 2
	category = "Armor"

/obj/item/clothing/pants/trou/leather/masterwork/skirt
	name = "masterwork leather skirt"
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	icon_state = "hlskirt"
	item_state = "hlskirt"
	genital_access = TRUE

///CONVERSIONS

/datum/repeatable_crafting_recipe/conversion
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to cut", "start to cut")
	)
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 0
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/conversion/leatherskirtconv
	name = "leather skirt"
	output = list(/obj/item/clothing/pants/trou/leather/skirt)
	requirements = list(/obj/item/clothing/pants/trou/leather = 1)
	attacked_atom = /obj/item/clothing/pants/trou/leather

/datum/repeatable_crafting_recipe/conversion/leatherskirtconvtwo
	name = "hardened leather skirt"
	output = list(/obj/item/clothing/pants/trou/leather/advanced/skirt)
	requirements = list(/obj/item/clothing/pants/trou/leather/advanced = 1)
	attacked_atom = /obj/item/clothing/pants/trou/leather/advanced

/datum/repeatable_crafting_recipe/conversion/leatherskirtconvthree
	name = "masterwork leather skirt"
	output = list(/obj/item/clothing/pants/trou/leather/masterwork/skirt)
	requirements = list(/obj/item/clothing/pants/trou/leather/masterwork/skirt = 1)
	attacked_atom = /obj/item/clothing/pants/trou/leather/masterwork

/datum/repeatable_crafting_recipe/conversion/hlegs
	name = "hardened leather leggings"
	output = /obj/item/clothing/pants/trou/leather/advanced/leggings
	requirements = list(/obj/item/clothing/pants/trou/leather/advanced = 1)
	attacked_atom = /obj/item/clothing/pants/trou/leather/advanced
	subtypes_allowed = FALSE

/datum/repeatable_crafting_recipe/conversion/chainbootyshorts
	name = "chain bootyshorts"
	output = /obj/item/clothing/pants/chainlegs/bootyshorts
	requirements = list(/obj/item/clothing/pants/chainlegs = 1)
	attacked_atom = /obj/item/clothing/pants/chainlegs
	subtypes_allowed = FALSE
