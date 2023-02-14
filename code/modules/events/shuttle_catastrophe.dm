/datum/round_event_control/shuttle_catastrophe
	name = "Shuttle Catastrophe"
	typepath = /datum/round_event/shuttle_catastrophe
	weight = 50
	max_occurrences = 3

/datum/round_event_control/shuttle_catastrophe/canSpawnEvent(players, gamemode)
	if(SSshuttle.emergency.name == "Build your own shuttle kit")
		return FALSE //don't undo manual player engineering, it also would unload people and ghost them, there's just a lot of problems
	if(SSshuttle.emergency.in_flight())
		return FALSE //ditto, problems
	return ..()


/datum/round_event/shuttle_catastrophe
	var/datum/map_template/shuttle/new_shuttle

/datum/round_event/shuttle_catastrophe/announce(fake)
	var/cause = pick("был атакован оперативниками [syndicate_name()]", "таинственным образом телепортировался", "был заблокирован, так как взбунтовалась его дозаправочная бригада",
		"был найден с украденными двигателями", "\[ЗАСЕКРЕЧЕНО\]", "улетел в закат и растаял", "чему-то научился у очень мудрой коровы и ушел сам по себе",
		"был с клонирующими устройствами на нём", "увидел инспектор шаттлов и припарковал шаттл задним ходом, в результате чего шаттл врезался в ангар")

	priority_announce("Ваш эвакуационный шаттл [cause]. В качестве замены вам будет предоставлен [new_shuttle.name] до дальнейшего уведомления.", "Кораблестроение Центрального Командования")

/datum/round_event/shuttle_catastrophe/setup()
	var/list/valid_shuttle_templates = list()
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(template.can_be_bought && template.credit_cost < INFINITY) //if we could get it from the communications console, it's cool for us to get it here
			valid_shuttle_templates += template
	new_shuttle = pick(valid_shuttle_templates)

/datum/round_event/shuttle_catastrophe/start()
	SSshuttle.shuttle_purchased = SHUTTLEPURCHASE_FORCED
	SSshuttle.unload_preview()
	SSshuttle.load_template(new_shuttle)
	SSshuttle.existing_shuttle = SSshuttle.emergency
	SSshuttle.action_load(new_shuttle)
	log_shuttle("Shuttle Catastrophe set a new shuttle, [new_shuttle.name].")
