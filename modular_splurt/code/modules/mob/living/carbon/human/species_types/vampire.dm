/datum/species/vampire/roundstart/New()
	. = ..()

	// Add species incompatible quirks
	LAZYADD(blacklisted_quirks, list(/datum/quirk/bloodfledge))
