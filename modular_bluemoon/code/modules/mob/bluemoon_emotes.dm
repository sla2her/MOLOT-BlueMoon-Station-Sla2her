/datum/emote/living/growl
	key = "growl"
	key_third_person = "growls"
	message = "lets out a growl."
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	restraint_check = FALSE

/datum/emote/living/growl/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			return
		user.nextsoundemote = world.time + 3 SECONDS
		playsound(user, 'sound/voice/growl.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/wurble
	key = "wurble"
	key_third_person = "wurbles"
	message = "lets out a wurble."
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/wurble/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			return
		user.nextsoundemote = world.time + 3 SECONDS
		playsound(user, 'sound/voice/wurble.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/warble
	key = "warble"
	key_third_person = "warbles"
	message = "warbles!"
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/warble/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			return
		user.nextsoundemote = world.time + 3 SECONDS
		playsound(user, 'sound/voice/warbles.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/trills
	key = "trills"
	key_third_person = "trills!"
	message = "trills!"
	muzzle_ignore = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/trills/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			return
		user.nextsoundemote = world.time + 3 SECONDS
	playsound(user, 'sound/voice/trills.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/woof
	key = "woof"
	key_third_person = "woofs"
	message = "lets out a woof."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/woof/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			return
		user.nextsoundemote = world.time + 3 SECONDS
	playsound(user, 'sound/voice/woof.ogg', 50, 1, -1)
	. = ..()

