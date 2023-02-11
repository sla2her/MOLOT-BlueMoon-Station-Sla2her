//Tarkov.
/datum/map_template/ruin/space/tarkoff
	name = "Port Tarkov"
	prefix = "_maps/RandomRuins/SpaceRuins/BlueMoon/"
	allow_duplicates = FALSE
	always_place = TRUE
	id = "tarkoff-base"
/datum/map_template/ruin/space/tarkoff/New()
	if(prob(35))
		suffix = "defcon5.dmm"
	else if(prob(35))
		suffix = "defcon4.dmm"
	else
		suffix = "defcon3.dmm"
	. = ..()
