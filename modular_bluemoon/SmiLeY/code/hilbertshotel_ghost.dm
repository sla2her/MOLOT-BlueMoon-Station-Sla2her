/obj/item/hilbertshotel/ghostdojo
	name = "infinite dormitories"
	anchored = TRUE

/obj/item/hilbertshotel/ghostdojo/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind?.antag_datums)
		if(user.mind?.has_antag_datum(/datum/antagonist/ghost_role))
			return promptAndCheckIn(user, user)
		if(user.mind?.has_antag_datum(/datum/antagonist/ashwalker))
			return promptAndCheckIn(user, user)
		else
			to_chat(user, "<span class='warning'>Your special role doesn't allow you to enter infinity dormitory.</span>")
			return //you can't enter infinity dormitories if you are a role
	return promptAndCheckIn(user, user)

/datum/map_template/ghost_cafe_rooms
	name = "Apartment"
	mappath = '_maps/templates/apartment.dmm'

/datum/map_template/ghost_cafe_rooms/one
	name = "Apartment-1"
	mappath = '_maps/templates/apartment-1.dmm'

/datum/map_template/ghost_cafe_rooms/two
	name = "Apartment-2"
	mappath = '_maps/templates/apartment-2.dmm'
