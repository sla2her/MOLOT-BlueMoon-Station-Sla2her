/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = TRUE
	opacity = 0
	density = FALSE
	plane = ABOVE_WALL_PLANE
	layer = SIGN_LAYER
	max_integrity = 100
	armor = list(MELEE = 50, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	var/buildable_sign = 1 //unwrenchable and modifiable
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE
	///sign_change_name is used to make nice looking, alphebetized and categorized names when you use a pen on any sign item or structure which is_editable.
	var/sign_change_name
	///This determines if you can select this sign type when using a pen on a sign backing. False by default, set to true per sign type to override.
	var/is_editable = FALSE

/obj/structure/sign/basic
	name = "blank sign"
	desc = "How can signs be real if our eyes aren't real?"
	icon_state = "backing"
	is_editable = TRUE
	sign_change_name = "Blank Sign"

/obj/structure/sign/wrench_act(mob/living/user, obj/item/wrench/I)
	. = ..()
	if(!buildable_sign)
		return TRUE
	user.visible_message(span_notice("[user] starts removing [src]..."), \
		span_notice("You start unfastening [src]."))
	I.play_tool_sound(src)
	if(!I.use_tool(src, user, 4 SECONDS))
		return TRUE
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	user.visible_message(span_notice("[user] unfastens [src]."), \
		span_notice("You unfasten [src]."))
	var/obj/item/sign/unwrenched_sign = new (get_turf(user))
	if(type != /obj/structure/sign/basic) //If it's still just a basic sign backing, we can (and should) skip some of the below variable transfers.
		unwrenched_sign.name = name //Copy over the sign structure variables to the sign item we're creating when we unwrench a sign.
		unwrenched_sign.desc = "[desc] It can be placed on a wall."
		unwrenched_sign.icon = icon
		unwrenched_sign.icon_state = icon_state
		unwrenched_sign.sign_path = type
		unwrenched_sign.set_custom_materials(custom_materials) //This is here so picture frames and wooden things don't get messed up.
		unwrenched_sign.is_editable = is_editable
	unwrenched_sign.update_integrity(get_integrity_structures()) //Transfer how damaged it is.
	unwrenched_sign.setDir(dir)
	qdel(src) //The sign structure on the wall goes poof and only the sign item from unwrenching remains.
	return TRUE

/**
 * This proc populates GLOBAL_LIST_EMPTY(editable_sign_types)
 *
 * The first time a pen is used on any sign, this populates GLOBAL_LIST_EMPTY(editable_sign_types), creating a global list of all the signs that you can set a sign backing to with a pen.
 */
/proc/populate_editable_sign_types()
	var/list/output = list()
	for(var/s in subtypesof(/obj/structure/sign))
		var/obj/structure/sign/potential_sign = s
		if(!initial(potential_sign.is_editable))
			continue
		output[initial(potential_sign.sign_change_name)] = potential_sign
	output = sort_list(output) //Alphabetizes the results.
	return output

/obj/item/sign
	name = "sign backing"
	desc = "A plastic sign backing, use a pen to change the decal. It can be placed on a wall."
	icon = 'icons/obj/decals.dmi'
	icon_state = "backing"
	flags_1 = INITIALIZED_1
	inhand_icon_state = "backing"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/plastic = 2000)
	armor = /datum/armor/item_sign
	resistance_flags = FLAMMABLE
	max_integrity = 100
	///The type of sign structure that will be created when placed on a turf, the default looks just like a sign backing item.
	var/sign_path = /obj/structure/sign/basic
	///This determines if you can select this sign type when using a pen on a sign backing. False by default, set to true per sign type to override.
	var/is_editable = TRUE

/datum/armor/item_sign
	melee = 50
	fire = 50
	acid = 50

/obj/item/sign/Initialize(mapload) //Signs not attached to walls are always rotated so they look like they're laying horizontal.
	. = ..()
	var/matrix/M = matrix()
	M.Turn(90)
	transform = M

/obj/item/sign/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(user.combat_mode)
		return FALSE
	if(atom_integrity == max_integrity)
		to_chat(user, span_warning("This sign is already in perfect condition."))
		return TRUE
	if(!I.tool_start_check(user, amount=0))
		return TRUE
	user.visible_message(span_notice("[user] starts repairing [src]..."), \
		span_notice("You start repairing [src]."))
	if(!I.use_tool(src, user, 4 SECONDS, volume =50 ))
		return TRUE
	user.visible_message(span_notice("[user] finishes repairing [src]."), \
		span_notice("You finish repairing [src]."))
	atom_integrity = max_integrity
	return TRUE

/obj/item/sign/attackby(obj/item/I, mob/user, params)
	if(is_editable && istype(I, /obj/item/pen))
		if(!length(GLOB.editable_sign_types))
			CRASH("GLOB.editable_sign_types failed to populate")
		var/choice = tgui_input_list(user, "Select a sign type", "Sign Customization", GLOB.editable_sign_types)
		if(isnull(choice))
			return
		if(!Adjacent(user)) //Make sure user is adjacent still.
			to_chat(user, span_warning("You need to stand next to the sign to change it!"))
			return
		user.visible_message(span_notice("You begin changing [src]."))
		if(!do_after(user, 4 SECONDS, target = src))
			return
		set_sign_type(GLOB.editable_sign_types[choice])
		user.visible_message(span_notice("You finish changing the sign."))
		return
	return ..()

/obj/item/sign/proc/set_sign_type(obj/structure/sign/fake_type)
	name = initial(fake_type.name)
	if(fake_type != /obj/structure/sign/basic)
		desc = "[initial(fake_type.desc)] It can be placed on a wall."
	else
		desc = initial(desc)
	icon_state = initial(fake_type.icon_state)
	sign_path = fake_type

/obj/item/sign/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!iswallturf(target) || !proximity)
		return
	var/turf/target_turf = target
	var/turf/user_turf = get_turf(user)
	var/obj/structure/sign/placed_sign = new sign_path(user_turf) //We place the sign on the turf the user is standing, and pixel shift it to the target wall, as below.
	//This is to mimic how signs and other wall objects are usually placed by mappers, and so they're only visible from one side of a wall.
	var/dir = get_dir(user_turf, target_turf)
	if(dir & NORTH)
		placed_sign.pixel_y = 32
	else if(dir & SOUTH)
		placed_sign.pixel_y = -32
	if(dir & EAST)
		placed_sign.pixel_x = 32
	else if(dir & WEST)
		placed_sign.pixel_x = -32
	user.visible_message(span_notice("[user] fastens [src] to [target_turf]."), \
		span_notice("You attach the sign to [target_turf]."))
	playsound(target_turf, 'sound/items/deconstruct.ogg', 50, TRUE)
	placed_sign.update_integrity(get_integrity_structures())
	placed_sign.setDir(dir)
	qdel(src)

/obj/item/sign/random/Initialize(mapload)
	. = ..()
	set_sign_type(GLOB.editable_sign_types[pick(GLOB.editable_sign_types)])

/obj/structure/sign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 80, 1)

/obj/structure/sign/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH && buildable_sign)
		user.visible_message("<span class='notice'>[user] starts removing [src]...</span>", \
							 "<span class='notice'>You start unfastening [src].</span>")
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 40))
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] unfastens [src].</span>", \
								 "<span class='notice'>You unfasten [src].</span>")
			var/obj/item/sign_backing/SB = new (get_turf(user))
			SB.icon_state = icon_state
			SB.set_custom_materials(custom_materials) //This is here so picture frames and wooden things don't get messed up.
			SB.sign_path = type
			SB.setDir(dir)
			qdel(src)
		return
	else if(istype(I, /obj/item/pen) && buildable_sign)
		var/list/sign_types = list("Secure Area", "Biohazard", "High Voltage", "Radiation", "Hard Vacuum Ahead", "Disposal: Leads To Space", "Danger: Fire", "No Smoking", "Medbay", "Science", "Chemistry", \
		"Hydroponics", "Xenobiology")
		var/obj/structure/sign/sign_type
		switch(input(user, "Select a sign type.", "Sign Customization") as null|anything in sign_types)
			if("Blank")
				sign_type = /obj/structure/sign/basic
			if("Secure Area")
				sign_type = /obj/structure/sign/warning/securearea
			if("Biohazard")
				sign_type = /obj/structure/sign/warning/biohazard
			if("High Voltage")
				sign_type = /obj/structure/sign/warning/electricshock
			if("Radiation")
				sign_type = /obj/structure/sign/warning/radiation
			if("Hard Vacuum Ahead")
				sign_type = /obj/structure/sign/warning/vacuum
			if("Disposal: Leads To Space")
				sign_type = /obj/structure/sign/warning/deathsposal
			if("Danger: Fire")
				sign_type = /obj/structure/sign/warning/fire
			if("No Smoking")
				sign_type = /obj/structure/sign/warning/nosmoking/circle
			if("Medbay")
				sign_type = /obj/structure/sign/departments/medbay/alt
			if("Science")
				sign_type = /obj/structure/sign/departments/science
			if("Chemistry")
				sign_type = /obj/structure/sign/departments/chemistry
			if("Hydroponics")
				sign_type = /obj/structure/sign/departments/botany
			if("Xenobiology")
				sign_type = /obj/structure/sign/departments/xenobio

		//Make sure user is adjacent still
		if(!Adjacent(user))
			return

		if(!sign_type)
			return

		//It's import to clone the pixel layout information
		//Otherwise signs revert to being on the turf and
		//move jarringly
		var/obj/structure/sign/newsign = new sign_type(get_turf(src))
		newsign.pixel_x = pixel_x
		newsign.pixel_y = pixel_y
		qdel(src)
	else
		return ..()

/obj/item/sign_backing
	name = "sign backing"
	desc = "A sign with adhesive backing."
	icon = 'icons/obj/decals.dmi'
	icon_state = "backing"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	var/sign_path = /obj/structure/sign/basic //the type of sign that will be created when placed on a turf

/obj/item/sign_backing/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(isturf(target) && proximity)
		var/turf/T = target
		user.visible_message("<span class='notice'>[user] fastens [src] to [T].</span>", \
							 "<span class='notice'>You attach the sign to [T].</span>")
		playsound(T, 'sound/items/deconstruct.ogg', 50, 1)
		var/obj/structure/sign/S = new sign_path(T)
		S.setDir(dir)
		qdel(src)

/obj/item/sign_backing/Move(atom/new_loc, direct = 0)
	// pulling, throwing, or conveying a sign backing does not rotate it
	var/old_dir = dir
	. = ..()
	setDir(old_dir)

/obj/item/sign_backing/attack_self(mob/user)
	. = ..()
	setDir(turn(dir, 90))

/obj/structure/sign/nanotrasen
	name = "\improper Nanotrasen Logo"
	desc = "A sign with the Nanotrasen Logo on it. Glory to Nanotrasen!"
	icon_state = "nanotrasen"

/obj/structure/sign/logo
	name = "nanotrasen logo"
	desc = "The Nanotrasen corporate logo."
	icon_state = "nanotrasen_sign1"
