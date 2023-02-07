//Tarkoff.
/datum/map_template/ruin/space/tarkoff
	prefix = "_maps/RandomRuins/SpaceRuins/BlueMoon/"
	cost = 15
	allow_duplicates = FALSE
	always_place = TRUE

/datum/map_template/ruin/space/tarkoff/New()
	if(prob(50))
		suffix = "defcon5.dmm"
	else
		suffix = "defcon4.dmm"
	. = ..()

