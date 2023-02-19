//predominantly negative traits

/datum/quirk/blooddeficiency
	name = "Acute Blood Deficiency"
	desc = "Your body can't produce enough blood to sustain itself."
	value = -2
	gain_text = "<span class='danger'>You feel your vigor slowly fading away.</span>"
	lose_text = "<span class='notice'>You feel vigorous again.</span>"
	antag_removal_text = "Your antagonistic nature has removed your blood deficiency."
	medical_record_text = "Patient requires regular treatment for blood loss due to low production of blood."

/datum/quirk/blooddeficiency/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if your species doesn't have any
		return
	else
		quirk_holder.blood_volume -= 0.2

/datum/quirk/depression
	name = "Депрессия"
	desc = "Время от времени вы просто ненавидите жизнь."
	mob_trait = TRAIT_DEPRESSION
	value = -1
	gain_text = "<span class='danger'>У вас начинается депрессия.</span>"
	lose_text = "<span class='notice'>У вас больше нет депрессии.</span>" //if only it were that easy!
	medical_record_text = "У пациента наблюдаются серьёзные перепады настроения, вызывающие острые периоды депрессии."
	mood_quirk = TRUE
	processing_quirk = TRUE

/datum/quirk/depression/on_process()
	if(prob(0.05))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "depression", /datum/mood_event/depression)

/datum/quirk/family_heirloom
	name = "Семейная реликвия"
	desc = "Вы текущий владелец реликвии, передающейся из поколения в поколение. Её нужно беречь!"
	value = -1
	mood_quirk = TRUE
	medical_record_text = "Пациент демонстрирует неестественную привязанность к семейной реликвии."
	var/obj/item/heirloom
	var/where
	processing_quirk = TRUE

GLOBAL_LIST_EMPTY(family_heirlooms)

/datum/quirk/family_heirloom/on_spawn()
	// Define holder and type
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/heirloom_type

	// The quirk holder's species - we have a 50% chance, if we have a species with a set heirloom, to choose a species heirloom.
	var/datum/species/holder_species = human_holder.dna?.species
	if(holder_species && LAZYLEN(holder_species.family_heirlooms) && prob(50))
		heirloom_type = pick(holder_species.family_heirlooms)
	else
		// Our quirk holder's job
		var/datum/job/holder_job = SSjob.GetJob(human_holder.last_mind?.assigned_role)
		if(holder_job && LAZYLEN(holder_job.family_heirlooms))
			heirloom_type = pick(holder_job.family_heirlooms)

	// If we didn't find an heirloom somehow, throw them a generic one
	if(!heirloom_type)
		heirloom_type = pick(/obj/item/toy/cards/deck, /obj/item/lighter, /obj/item/dice/d20)

	// Create the heirloom item
	heirloom = new heirloom_type(get_turf(quirk_holder))

	// Add to global list
	GLOB.family_heirlooms += heirloom

	// Determine and assign item location
	var/list/slots = list(
		"В левом кармане" = ITEM_SLOT_LPOCKET,
		"В правом кармане" = ITEM_SLOT_RPOCKET,
		"В рюкзаке" = ITEM_SLOT_BACKPACK
	)
	where = human_holder.equip_in_one_of_slots(heirloom, slots, FALSE) || "at your feet"

/datum/quirk/family_heirloom/post_add()
	if(where == "in your backpack")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

	to_chat(quirk_holder, "<span class='boldnotice'>[where] находится [heirloom.name], передающаяся из поколения в поколение. Береги её!</span>")
	var/list/family_name = splittext(quirk_holder.real_name, " ")
	heirloom.name = "\improper [family_name[family_name.len]] family [heirloom.name]"

/datum/quirk/family_heirloom/on_process()
	// Ignore for dead holder
	if(quirk_holder.stat == DEAD)
		return

	// When held: Positive mood
	if(heirloom && (heirloom in quirk_holder.GetAllContents()))
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom_missing")
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "family_heirloom", /datum/mood_event/family_heirloom)

	// When not held: Negative mood
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom")
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "family_heirloom_missing", /datum/mood_event/family_heirloom_missing)

/datum/quirk/item_quirk/family_heirloom/remove()
	// Clear mood events when removing this quirk
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom")
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom_missing")

/datum/quirk/family_heirloom/clone_data()
	return heirloom

/datum/quirk/family_heirloom/on_clone(data)
	heirloom = data

/datum/quirk/heavy_sleeper
	name = "Крепко спящий"
	desc = "Вы спите, как камень! Каждый раз засыпая, вы спите чуть дольше."
	value = -1
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = "<span class='danger'>Вы чувствуете сонливость.</span>"
	lose_text = "<span class='notice'>Вы снова чувствуете себя бодрым!.</span>"
	medical_record_text = "Пациент показал аномальные способности ко сну — его тяжелее разбудить."

/datum/quirk/brainproblems
	name = "Опухоль мозга"
	desc = "В вашей голове есть маленький друг, который медленно разрушает мозг. Стоит прихвотить с собой маннит!"
	value = -3
	gain_text = "<span class='danger'>You feel smooth.</span>" /// Хз как это перевести 
	lose_text = "<span class='notice'>You feel wrinkled again.</span>"
	medical_record_text = "У пациента опухоль, которая постепенно разрушает его мозг."
	processing_quirk = TRUE

/datum/quirk/brainproblems/on_process()
	quirk_holder.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2)

/datum/quirk/nearsighted //t. errorage
	name = "Близорукость"
	desc = "Вы близорукий без очков по рецепту, но прибываете на станцию с ними."
	value = -1
	gain_text = "<span class='danger'>Вещи вдали вас расплываются.</span>"
	lose_text = "<span class='notice'>Ваше зрение снова стало нормальным.</span>"
	medical_record_text = "Для того, чтобы бороться с близорукость, пациенту требуются очки по рецепту."

/datum/quirk/nearsighted/add()
	quirk_holder.become_nearsighted(ROUNDSTART_TRAIT)

/datum/quirk/nearsighted/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/regular/glasses = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(glasses, ITEM_SLOT_EYES))
		H.put_in_hands(glasses)

/datum/quirk/nyctophobia
	name = "Никтофобия"
	desc = "Сколько себя помните вы всегда боялись темноты. Находясь в полной темноте, вы инстинктивно осторожничаете и боитесь."
	value = -1
	medical_record_text = "Пациент боится темноты. (В самом деле?)"

/datum/quirk/nyctophobia/add()
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)

/datum/quirk/nyctophobia/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED)
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "nyctophobia")

/// Called when the quirk holder moves. Updates the quirk holder's mood.
/datum/quirk/nyctophobia/proc/on_holder_moved(mob/living/source, atom/old_loc, dir, forced)
	if(quirk_holder.stat != CONSCIOUS || quirk_holder.IsSleeping() || quirk_holder.IsUnconscious())
		return

	var/mob/living/carbon/human/human_holder = quirk_holder

	if(human_holder.dna?.species.id in list(SPECIES_SHADOW, SPECIES_NIGHTMARE))
		return

	if((human_holder.sight & SEE_TURFS) == SEE_TURFS)
		return

	var/turf/holder_turf = get_turf(quirk_holder)

	var/lums = holder_turf.get_lumcount()

	if(lums > 0.2)
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "nyctophobia")
		return

	if(quirk_holder.m_intent == MOVE_INTENT_RUN)
		to_chat(quirk_holder, span_warning("Тише! Не торопитесь... вы в кромешной тьме..."))
		quirk_holder.toggle_move_intent()
	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "nyctophobia", /datum/mood_event/nyctophobia)

/datum/quirk/lightless
	name = "Светобоязнь"
	desc = "Яркий свет раздражает вас. Глаза начинают слезиться и кожа чешется под излучением фотонов, а волосы становятся сухими и вьющимися. Возможно, это заболевание. Если бы только Nanotrasen учитывал ваши потребности..."
	value = -1
	gain_text = "<span class='danger'>Яркий свет раздражает вас.</span>"
	lose_text = "<span class='notice'>Вы достигли просветления.</span>"
	medical_record_text = "Несмотря на мои предупреждения, пацинает отказываться включать свет, что приводит к падению с лестницы прямо в подвал."

/datum/quirk/lightless/add()
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)

/datum/quirk/lightless/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED)
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "brightlight")

/datum/quirk/lightless/proc/on_holder_moved(mob/living/source, atom/old_loc, dir, forced)
	if(quirk_holder.stat != CONSCIOUS || quirk_holder.IsSleeping() || quirk_holder.IsUnconscious())
		return

	var/mob/living/carbon/human/human_holder = quirk_holder

	if(human_holder.dna?.species.id in list(SPECIES_SHADOW, SPECIES_NIGHTMARE))
		return

	if((human_holder.sight & SEE_TURFS) == SEE_TURFS)
		return

	var/turf/holder_turf = get_turf(quirk_holder)

	var/lums = holder_turf.get_lumcount()

	if(lums < 0.8)
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "brightlight")
		return

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "brightlight", /datum/mood_event/brightlight)


/datum/quirk/lightless/on_process()
	var/turf/T = get_turf(quirk_holder)
	var/lums = T.get_lumcount()
	if(lums >= 0.8)
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "brightlight", /datum/mood_event/brightlight)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "brightlight")

/datum/quirk/nonviolent
	name = "Пацифист"
	desc = "Насилие противно вам. До такой степени, что в следствие, вы не можете никому навредить."
	value = -2
	mob_trait = TRAIT_PACIFISM
	gain_text = "<span class='danger'>Вы отвергаете саму мысль о возможном насилии!</span>"
	lose_text = "<span class='notice'>Вам кажется, что вы снова можете постоять за себя.</span>"
	medical_record_text = "Пациент крайне миролюбивый и не может заставить себя сделать кому-то больно."
	antag_removal_text = "Ваша антагонистическая натура привела к отказу от пацифизма."

/datum/quirk/paraplegic
	name = "Парализованный"
	desc = "Ваши ноги не работаются. Ничто и никогда не исправит это. Подумайте о хорошем — о бесплатной инвалидной коляске!"
	value = -4
	mob_trait = TRAIT_PARA
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "У пациента неизлечимое нарушение опорно-двигательных функций нижних конечностей."
	on_spawn_immediate = FALSE

/datum/quirk/paraplegic/add()
	var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/on_spawn()
	if(quirk_holder.client)
		var/modified_limbs = quirk_holder.client.prefs.modified_limbs
		if(!(modified_limbs[BODY_ZONE_L_LEG] == LOADOUT_LIMB_AMPUTATED && modified_limbs[BODY_ZONE_R_LEG] == LOADOUT_LIMB_AMPUTATED && !isjellyperson(quirk_holder)))
			if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
				quirk_holder.buckled.unbuckle_mob(quirk_holder)

			var/turf/T = get_turf(quirk_holder)
			var/obj/structure/chair/spawn_chair = locate() in T

			var/obj/vehicle/ridden/wheelchair/wheels = new(T)
			if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
				wheels.setDir(spawn_chair.dir)

			wheels.buckle_mob(quirk_holder)

			// During the spawning process, they may have dropped what they were holding, due to the paralysis
			// So put the things back in their hands.

			for(var/obj/item/I in T)
				if(I.fingerprintslast == quirk_holder.ckey)
					quirk_holder.put_in_hands(I)

/datum/quirk/poor_aim
	name = "Ужасный стрелок"
	desc = "Ваши навыки обращения с оружием не позволяют точно прицелится даже для того, чтобы спасти свою жизнь. Стрельб даже не обсуждается."
	value = -1
	mob_trait = TRAIT_POOR_AIM
	medical_record_text = "Обе руки пациента подвержены сильной дрожи."

/datum/quirk/prosopagnosia
	name = "Прозопагнозия"
	desc = "Расстройство не позволяет вам узнавать лица, совсем."
	value = -1
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Пациент страдает от прозопагнозии и не способен узнавать лица."

/datum/quirk/insanity
	name = "Диссоциативное расстройство"
	desc = "Вы страдаете от серьёзного расстройства и видите пёстрые галлюцинации. Mindbreaker может подавить эти эффекты, также у вас невосприимчивость к mindbreaker's галлюциногенному эффекту. <b>Это не разрешает грифинг.</b>"
	value = -2
	//no mob trait because it's handled uniquely
	gain_text = "<span class='userdanger'>...</span>"
	lose_text = "<span class='notice'>Вам снова кажется, что вы понимаете мир вокруг.</span>"
	medical_record_text = "Пациент страдает от острого диссоциативного расстройства и испытывает яркие галлюцинации."
	processing_quirk = TRUE

/datum/quirk/insanity/on_process()
	if(quirk_holder.reagents.has_reagent(/datum/reagent/toxin/mindbreaker))
		quirk_holder.hallucination = 0
		return
	if(prob(2)) //we'll all be mad soon enough
		madness()

/datum/quirk/insanity/proc/madness()
	quirk_holder.hallucination += rand(10, 25)

/datum/quirk/insanity/post_add() //I don't /think/ we'll need this but for newbies who think "roleplay as insane" = "license to kill" it's probably a good thing to have
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Please note that your dissociation syndrome does NOT give you the right to attack people or otherwise cause any interference to \
	the round. You are not an antagonist, and the rules will treat you the same as other crewmembers.</span>")

/datum/quirk/social_anxiety
	name = "Social Anxiety"
	desc = "Talking to people is very difficult for you, and you often stutter or even lock up."
	value = -1
	gain_text = "<span class='danger'>You start worrying about what you're saying.</span>"
	lose_text = "<span class='notice'>You feel easier about talking again.</span>" //if only it were that easy!
	medical_record_text = "Patient is usually anxious in social encounters and prefers to avoid them."
	var/dumb_thing = TRUE
	processing_quirk = TRUE

/datum/quirk/social_anxiety/add()
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, .proc/eye_contact)
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, .proc/looks_at_floor)

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE))

/datum/quirk/social_anxiety/on_process()
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/mob/living/carbon/human/H = quirk_holder
	if(prob(2 + nearby_people))
		H.stuttering = max(3, H.stuttering)
	else if(prob(min(3, nearby_people)) && !H.silent)
		to_chat(H, "<span class='danger'>You retreat into yourself. You <i>really</i> don't feel up to talking.</span>")
		H.silent = max(10, H.silent)
	else if(prob(0.5) && dumb_thing)
		to_chat(H, "<span class='userdanger'>You think of a dumb thing you said a long time ago and scream internally.</span>")
		dumb_thing = FALSE //only once per life
		if(prob(1))
			new/obj/item/reagent_containers/food/snacks/pastatomato(get_turf(H)) //now that's what I call spaghetti code

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, quirk_holder, "<span class='smallnotice'>You make eye contact with [A].</span>"), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "You make eye contact with [other_mob], "
	else
		msg = "[other_mob] makes eye contact with you, "

	switch(rand(1,3))
		if(1)
			quirk_holder.Jitter(10)
			msg += "causing you to start fidgeting!"
		if(2)
			quirk_holder.stuttering = max(3, quirk_holder.stuttering)
			msg += "causing you to start stuttering!"
		if(3)
			quirk_holder.Stun(2 SECONDS)
			msg += "causing you to freeze up!"

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "anxiety_eyecontact", /datum/mood_event/anxiety_eyecontact)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, quirk_holder, "<span class='userdanger'>[msg]</span>"), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT

/datum/mood_event/anxiety_eyecontact
	description = "<span class='warning'>Sometimes eye contact makes me so nervous...</span>\n"
	mood_change = -5
	timeout = 3 MINUTES

/datum/quirk/phobia
	name = "Phobia"
	desc = "You've had a traumatic past, one that has scarred you for life, and cripples you when dealing with your greatest fears."
	value = -2 // It can hardstun you. You can be a job that your phobia targets...
	gain_text = "<span class='danger'>You begin to tremble as an immeasurable fear grips your mind.</span>"
	lose_text = "<span class='notice'>Your confidence wipes away the fear that had been plaguing you.</span>"
	medical_record_text = "Patient has an extreme or irrational fear and aversion to an undefined stimuli."
	var/datum/brain_trauma/mild/phobia/phobia

/datum/quirk/phobia/post_add()
	var/mob/living/carbon/human/H = quirk_holder
	phobia = new
	H.gain_trauma(phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H?.cure_trauma_type(phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/mute
	name = "Mute"
	desc = "Due to some accident, medical condition, or simply by choice, you are completely unable to speak."
	value = -2 //HALP MAINTS
	gain_text = "<span class='danger'>You find yourself unable to speak!</span>"
	lose_text = "<span class='notice'>You feel a growing strength in your vocal chords.</span>"
	medical_record_text = "Functionally mute, patient is unable to use their voice in any capacity."
	antag_removal_text = "Your antagonistic nature has caused your voice to be heard."
	var/datum/brain_trauma/severe/mute/mute

/datum/quirk/mute/add()
	var/mob/living/carbon/human/H = quirk_holder
	mute = new
	H.gain_trauma(mute, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/mute/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H?.cure_trauma_type(mute, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/unstable
	name = "Unstable"
	desc = "Due to past troubles, you are unable to recover your sanity if you lose it. Be very careful managing your mood!"
	value = -2
	mob_trait = TRAIT_UNSTABLE
	gain_text = "<span class='danger'>There's a lot on your mind right now.</span>"
	lose_text = "<span class='notice'>Your mind finally feels calm.</span>"
	medical_record_text = "Patient's mind is in a vulnerable state, and cannot recover from traumatic events."

/datum/quirk/blindness
	name = "Blind"
	desc = "You are completely blind, nothing can counteract this."
	value = -4
	gain_text = "<span class='danger'>You can't see anything.</span>"
	lose_text = "<span class='notice'>You miraculously gain back your vision.</span>"
	medical_record_text = "Patient has permanent blindness."

/datum/quirk/blindness/add()
	quirk_holder.become_blind(ROUNDSTART_TRAIT)

/datum/quirk/blindness/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/sunglasses/blindfold/white/glasses = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(glasses, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE)) //if you can't put it on the user's eyes, put it in their hands, otherwise put it on their eyes eyes
		H.put_in_hands(glasses)
	H.regenerate_icons()

/datum/quirk/blindness/remove()
	quirk_holder?.cure_blind(ROUNDSTART_TRAIT)

/datum/quirk/coldblooded
	name = "Cold-blooded"
	desc = "Your body doesn't create its own internal heat, requiring external heat regulation."
	value = -2
	medical_record_text = "Patient is ectothermic."
	mob_trait = TRAIT_COLDBLOODED
	gain_text = "<span class='notice'>You feel cold-blooded.</span>"
	lose_text = "<span class='notice'>You feel more warm-blooded.</span>"

/datum/quirk/monophobia
	name = "Monophobia"
	desc = "You will become increasingly stressed when not in company of others, triggering panic reactions ranging from sickness to heart attacks."
	value = -3 // Might change it to 4.
	gain_text = "<span class='danger'>You feel really lonely...</span>"
	lose_text = "<span class='notice'>You feel like you could be safe on your own.</span>"
	medical_record_text = "Patient feels sick and distressed when not around other people, leading to potentially lethal levels of stress."

/datum/quirk/monophobia/post_add()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(/datum/brain_trauma/severe/monophobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/monophobia/remove()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	H?.cure_trauma_type(/datum/brain_trauma/severe/monophobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/no_smell
	name = "Anosmia"
	desc = "You can't smell anything! You won't be able to detect certain colorless gases."
	value = -1
	mob_trait = TRAIT_ANOSMIA
	gain_text = "<span class='notice'>You can't smell anything!</span>"
	lose_text = "<span class='notice'>You can smell again!</span>"
	medical_record_text = "Patient suffers from anosmia and is incapable of smelling gases or particulates."

/datum/quirk/paper_skin
	name = "Paper Skin"
	desc = "Your flesh is weaker, resulting in receiving cuts more easily."
	value = -1
	mob_trait = TRAIT_PAPER_SKIN
	gain_text = "<span class='notice'>Your flesh feels weak!</span>"
	lose_text = "<span class='notice'>Your flesh feels more durable!</span>"
	medical_record_text = "Patient suffers from weak flesh, resulting in them receiving cuts far more easily."

/datum/quirk/glass_bones
	name = "Glass Bones"
	desc = "Your bones are far more brittle, and more vulnerable to breakage."
	value = -1
	mob_trait = TRAIT_GLASS_BONES
	gain_text = "<span class='notice'>Your bones feels weak!</span>"
	lose_text = "<span class='notice'>Your bones feels more durable!</span>"
	medical_record_text = "Patient suffers from brittle bones, resulting in them receiving breakages far more easily."

/datum/quirk/cursed
	name = "Cursed"
	desc = "You are cursed with bad luck. You are much more likely to suffer from accidents and mishaps. When it rains, it pours."
	value = -3
	mob_trait = TRAIT_CURSED
	gain_text = span_danger("You feel like you're going to have a bad day.")
	lose_text = span_notice("You feel like you're going to have a good day.")
	medical_record_text = "Patient is cursed with bad luck."

/datum/quirk/cursed/add(client/client_source)
	quirk_holder.AddComponent(/datum/component/omen/quirk)
