/obj/item/clothing/mask/kitsunewhi/magic
	name = "Magic Kitsune Mask"
	desc = "A magic Kistune Mask. Wow!"
	icon_state = "whitekitsunemask_alt"
	item_state = "whitekitsunemask_alt"
	color = "#999999"
	dynamic_hair_suffix = ""

	dog_fashion = /datum/dog_fashion/head/kitty
	beepsky_fashion = /datum/beepsky_fashion/cat

/obj/item/clothing/mask/kitsunewhi/magic/equipped(mob/living/carbon/human/user, slot)
	if(ishuman(user) && slot == ITEM_SLOT_MASK)
		update_icon(user)
		user.update_inv_head() //Color might have been changed by update_icon.
	..()

/obj/item/clothing/mask/kitsunewhi/magic/update_icon(mob/living/carbon/human/user)
	if(ishuman(user))
		add_atom_colour("#[user.hair_color]", FIXED_COLOUR_PRIORITY)
