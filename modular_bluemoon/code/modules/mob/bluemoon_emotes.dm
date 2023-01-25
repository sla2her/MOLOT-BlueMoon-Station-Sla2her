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
			to_chat(user, span_warning("Рано!"))
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
			to_chat(user, span_warning("Рано!"))
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
			to_chat(user, span_warning("Рано!"))
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
			to_chat(user, span_warning("Рано!"))
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
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 3 SECONDS
	playsound(user, 'sound/voice/woof.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/cloaker1
	key = "cloaker"
	key_third_person = "cloakers"
	message = "aggressively approaching."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cloaker1/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 30 SECONDS
	playsound(user, 'sound/voice/cloaker1.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/cloaker2
	key = "cloaker2"
	key_third_person = "cloakers2"
	message = "clearly demands to stop beating yourself."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cloaker2/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/cloaker2.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/cloaker3
	key = "cloaker3"
	key_third_person = "cloakers3"
	message = "explains the reason for the detention."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cloaker3/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/cloaker3.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/cloaker4
	key = "cloaker4"
	key_third_person = "cloakers4"
	message = "approves the Safe Word."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cloaker4/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/cloaker4.ogg', 50, 1, -1)
	. = ..()

/datum/emote/living/cluwne
	key = "cluwne"
	key_third_person = "cluwnes"
	message = "clown around; laughs terribly..."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cluwne/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, pick('sound/voice/cluwnelaugh1.ogg', 'sound/voice/cluwnelaugh2.ogg', 'sound/voice/cluwnelaugh3.ogg'), 50, 1, -1)
	. = ..()

/datum/emote/sound/suka1
	key = "suka"
	key_third_person = "sukas"
	message = "seems to be very angry."
	message_param = "angry at %t."
	sound = 'sound/voice/human/bear_fight.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon, /mob/living/carbon/human, /mob/camera/aiEye)

/datum/emote/living/suka2
	key = "suka2"
	key_third_person = "sukas2"
	message = "seems to be very angry."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/suka2/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/bear_fight2.ogg', 50, 1, -1)
	. = ..()


/datum/emote/living/jacket1
	key = "jacket"
	key_third_person = "jackets"
	message = "asks: <b>'Do You Know What Time It Is?'</b>"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/jacket1/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/jacket1.ogg', 75, 1, -1)
	. = ..()

/datum/emote/living/jacket2
	key = "jacket2"
	key_third_person = "jacket2"
	message = "speaking: <b>'Help Is On The Way!'</b>"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/jacket2/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/jacket2.ogg', 75, 1, -1)
	. = ..()

/datum/emote/living/bulldozer1
	key = "bulldozer"
	key_third_person = "bulldozers"
	message = "yelling: <b>'You're up against the wall and I am the fucking wall!'</b>"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/bulldozer1/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/bulldozer1.ogg', 75, 1, -1)
	. = ..()

/datum/emote/living/bulldozer2
	key = "bulldozer2"
	key_third_person = "bulldozers2"
	message = "yelling: <b>'Please, stay alive a little bit longer, so I can kill you myself!!'</b>"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/bulldozer2/run_emote(mob/user, params, type_override, intentional)
	if(ishuman(user))
		if(user.nextsoundemote >= world.time)
			to_chat(user, span_warning("Рано!"))
			return
		user.nextsoundemote = world.time + 10 SECONDS
	playsound(user, 'sound/voice/bulldozer2.ogg', 75, 1, -1)
	. = ..()
