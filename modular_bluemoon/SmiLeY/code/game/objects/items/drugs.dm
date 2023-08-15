/datum/reagent/drug/zvezdochka
	name = "Звёздочка"
	description = "Реверс-инжениринг версия старого советского психотропного вещества. По крайней мере попытка."
	color = "#f00aef"

/datum/reagent/drug/zvezdochka/on_mob_metabolize(mob/living/M)
	. = ..()

	M.add_client_colour(/datum/client_colour/zvezdochka)
	var/sound/sound = sound(pick('modular_bluemoon/SmiLeY/sounds/LYENEN.ogg', 'modular_bluemoon/SmiLeY/sounds/LYENEN2.ogg'), TRUE)
	sound.environment = 23
	sound.volume = 20
	SEND_SOUND(M.client, sound)

	return

/datum/reagent/drug/zvezdochka/on_mob_life(mob/living/M)

	var/high_message = pick("ЗВЁЗДОЧКИ", "КАЙФ")

	if(prob(15))
		to_chat(M, span_notice("<i> ... [high_message] ... </i>"))
		M.adjustToxLoss(-4 * REM, 0)
		M.adjustBruteLoss(-4 * REM, 0)
		M.adjustFireLoss(-4 * REM, 0)
		M.adjustOxyLoss(-12 * REM, 0)

		M.Jitter(rand(0,2))
		M.Dizzy(rand(0,2))

	new /datum/hallucination/delusion(M, TRUE, "custom", rand(10, 50), custom_icon_file = 'modular_bluemoon/SmiLeY/icons/stars.dmi', custom_icon = pick("star1","star2"), custom_name = "ЗВЁЗДОЧКА")

	if(prob(65))
		var/image/trip_img = image('modular_bluemoon/SmiLeY/icons/stars.dmi', get_turf(pick(view(7, M))), pick("star1","star2"), CURSE_LAYER)
		if(M.client)
			M.client.images += trip_img
		spawn(rand(30,50))
			if(M.client)
				M.client.images -= trip_img
			QDEL_NULL(trip_img)
	..()

/datum/reagent/drug/zvezdochka/on_mob_end_metabolize(mob/living/M)
	M.remove_client_colour(/datum/client_colour/zvezdochka)
	DIRECT_OUTPUT(M.client, sound(null))
	..()

/datum/client_colour/zvezdochka
	colour = list(rgb(255,15,15), rgb(15,225,15), rgb(15,15,255), rgb(0,0,0))
	priority = 6

/obj/item/reagent_containers/pill/zvezdochka
	name = "Звёздочка"
	desc = "Не похоже на мазь."
	icon_state = "pill7"
	list_reagents = list(/datum/reagent/drug/zvezdochka = 10)

/obj/item/storage/pill_bottle/zvezdochka
	name = "Мазь Звёздочка"
	desc = "Может вызвать ожог глаз. По крайней мере в старой инструкции так было написано."

/obj/item/storage/pill_bottle/zvezdochka/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/zvezdochka(src)
