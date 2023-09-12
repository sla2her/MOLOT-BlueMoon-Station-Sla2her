// NOT THE SAME AS TG! THIS IS BAREMETAL JUST TO MAKE COMSIGS WORK!
SUBSYSTEM_DEF(security_level)
	name = "Security Level"
	can_fire = FALSE // We will control when we fire in this subsystem
	init_order = INIT_ORDER_SECURITY_LEVEL
	/// Currently set security level
	var/datum/security_level/current_security_level

/**
 * Sets a new security level as our current level
 *
 * This is how everything should change the security level.
 *
 * Arguments:
 * * new_level - The new security level that will become our current level
 */
/datum/controller/subsystem/security_level/proc/set_level(new_level)
	if(!isnum(new_level))
		new_level = SECLEVEL2NUM(new_level)

	//Will not be announced if you try to set to the same level as it already is
	if(new_level >= SEC_LEVEL_GREEN && new_level <= SEC_LEVEL_DELTA && new_level != GLOB.security_level)
		switch(new_level)
			if(SEC_LEVEL_GREEN)
				minor_announce(CONFIG_GET(string/alert_green), "Внимание! Уровень тревоги был снижен до ЗЕЛЁНЫЙ:")
				unset_stationwide_emergency_lighting()
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level >= SEC_LEVEL_RED)
						SSshuttle.emergency.modTimer(4)
					else if(GLOB.security_level == SEC_LEVEL_AMBER)
						SSshuttle.emergency.modTimer(2.5)
					else
						SSshuttle.emergency.modTimer(1.66)
				GLOB.security_level = SEC_LEVEL_GREEN
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "greenalert")
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()

			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					minor_announce(CONFIG_GET(string/alert_blue_upto), "Внимание! Уровень тревоги был поднят до СИНЕГО:",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(0.6)
				else
					minor_announce(CONFIG_GET(string/alert_blue_downto), "Внимание! Уровень тревоги был снижен до СИНЕГО:")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level >= SEC_LEVEL_RED)
							SSshuttle.emergency.modTimer(2.4)
						else
							SSshuttle.emergency.modTimer(1.5)
				GLOB.security_level = SEC_LEVEL_BLUE
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "bluealert")
				unset_stationwide_emergency_lighting()
				sound_to_playing_players('sound/misc/alerts/voybluealert.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()

			if(SEC_LEVEL_ORANGE)
				if(GLOB.security_level < SEC_LEVEL_ORANGE)
					minor_announce(CONFIG_GET(string/alert_orange_upto), "Внимание! Уровень тревоги был поднят до ОРАНЖЕВОГО:",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(0.6)
				else
					minor_announce(CONFIG_GET(string/alert_orange_downto), "Внимание! Уровень тревоги был снижен до ОРАНЖЕВОГО:")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level >= SEC_LEVEL_RED)
							SSshuttle.emergency.modTimer(2.4)
						else
							SSshuttle.emergency.modTimer(1.5)
				GLOB.security_level = SEC_LEVEL_ORANGE
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "orangealert")
				unset_stationwide_emergency_lighting()
				sound_to_playing_players('sound/misc/alerts/orange.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()

			if(SEC_LEVEL_VIOLET)
				if(GLOB.security_level < SEC_LEVEL_VIOLET)
					minor_announce(CONFIG_GET(string/alert_violet_upto), "Внимание! Уровень тревоги был поднят до ФИОЛЕТОВОГО:",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(0.6)
				else
					minor_announce(CONFIG_GET(string/alert_violet_downto), "Внимание! Уровень тревоги был снижен до ФИОЛЕТОВОГО:")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level >= SEC_LEVEL_RED)
							SSshuttle.emergency.modTimer(2.4)
						else
							SSshuttle.emergency.modTimer(1.5)
				GLOB.security_level = SEC_LEVEL_VIOLET
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "violetalert")
				unset_stationwide_emergency_lighting()
				sound_to_playing_players('sound/misc/alerts/violet.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()

			if(SEC_LEVEL_AMBER)
				if(GLOB.security_level < SEC_LEVEL_AMBER)
					minor_announce(CONFIG_GET(string/alert_amber_upto), "Внимание! Уровень тревоги был поднят до ЯНТАРНОГО:",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level == SEC_LEVEL_GREEN)
							SSshuttle.emergency.modTimer(0.4)
						else
							SSshuttle.emergency.modTimer(0.66)
				else
					minor_announce(CONFIG_GET(string/alert_amber_downto), "Внимание! Уровень тревоги был снижен до ЯНТАРНОГО:")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(1.6)
				GLOB.security_level = SEC_LEVEL_AMBER
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "amberalert")
				unset_stationwide_emergency_lighting()
				sound_to_playing_players('sound/misc/alerts/amber.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()

			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					minor_announce(CONFIG_GET(string/alert_red_upto), "Внимание! Код - КРАСНЫЙ!",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level == SEC_LEVEL_GREEN)
							SSshuttle.emergency.modTimer(0.25)
						else if(GLOB.security_level == SEC_LEVEL_BLUE)
							SSshuttle.emergency.modTimer(0.416)
						else
							SSshuttle.emergency.modTimer(0.625)
				else
					minor_announce(CONFIG_GET(string/alert_red_downto), "Внимание! Код - КРАСНЫЙ!")
				GLOB.security_level = SEC_LEVEL_RED
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "redalert")
				set_stationwide_emergency_lighting()
				sound_to_playing_players('sound/misc/alerts/red.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()

			if(SEC_LEVEL_LAMBDA)
				minor_announce(CONFIG_GET(string/alert_lambda), "Внимание! КОД - ЛЯМБДА!",1)
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level < SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.25)
					else if(GLOB.security_level == SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.416)
					else
						SSshuttle.emergency.modTimer(0.625)
				GLOB.security_level = SEC_LEVEL_LAMBDA
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "lambdaalert")
				set_stationwide_emergency_lighting()
				sound_to_playing_players('modular_bluemoon/kovac_shitcode/sound/lambda_code.ogg') // Citadel change - Makes alerts play a sound
				INVOKE_ASYNC(src, .proc/move_shuttle)

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.admin_controlled = FALSE

			if(SEC_LEVEL_EPSILON)
				for(var/mob/M in GLOB.player_list)
					var/turf/T = get_turf(M)
					if(!M.client || !is_station_level(T.z))
						continue
					SEND_SOUND(M, sound('sound/effects/powerloss.ogg'))
				set_stationwide_emergency_lighting()
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(epsilon_process)), 15 SECONDS)
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				INVOKE_ASYNC(src, .proc/move_shuttle)
				SSblackbox.record_feedback("tally", "security_level_changes", 1, NUM2SECLEVEL(GLOB.security_level))
				return

			if(SEC_LEVEL_DELTA)
				minor_announce(CONFIG_GET(string/alert_delta), "Тревога! КОД - ДЕЛЬТА!",1)
				GLOB.security_level = SEC_LEVEL_DELTA
				var/obj/machinery/computer/communications/C = locate() in GLOB.machines
				if(C)
					C.post_status("alert", "deltaalert")

				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level < SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.25)
					else if(GLOB.security_level == SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.416)
					else
						SSshuttle.emergency.modTimer(0.625)

				set_stationwide_emergency_lighting()
				sound_to_playing_players('sound/misc/alerts/delta.ogg')
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.admin_controlled = FALSE
		if(new_level >= SEC_LEVEL_RED)
			for(var/obj/machinery/door/D in GLOB.machines)
				if(D.red_alert_access)
					D.visible_message("<span class='notice'>[D] whirrs as it automatically lifts access requirements!</span>")
					playsound(D, 'sound/machines/boltsup.ogg', 50, TRUE)
		SEND_SIGNAL(src, COMSIG_SECURITY_LEVEL_CHANGED, new_level)
		SSblackbox.record_feedback("tally", "security_level_changes", 1, NUM2SECLEVEL(GLOB.security_level))
		SSnightshift.check_nightshift()
	else
		return

/datum/controller/subsystem/security_level/proc/move_shuttle()
	if(!SSshuttle.toggleShuttle("lambda","lambda_away","lambda_station"))
		message_admins("Lambda Armory shuttle was sent to the station")
		log_admin("Lambda Armory shuttle was sent to the station")

/**
 * Called to check/change security level.
 * Checks if the station security level is at least minimum_level, and if not, sets it to that level.
 * Arguments determine if engineering override or maint access is granted.
 * Arguments: min_level: number, eng_access: boolean, maint_access: boolean
*/
/datum/controller/subsystem/security_level/proc/minimum_security_level(min_level = SEC_LEVEL_ORANGE, eng_access = TRUE, maint_access = FALSE)
	if(NUM2SECLEVEL(GLOB.security_level) < min_level)
		SSsecurity_level.set_level(min_level)

	if(eng_access)
		GLOB.force_eng_override = TRUE
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_FORCE_AIRLOCK_OVERRIDE, TRUE)

	if(maint_access)
		make_maint_all_access()

/proc/set_stationwide_emergency_lighting()
	for(var/obj/machinery/power/apc/A in GLOB.apcs_list)
		var/area/AR = get_area(A)
		if(!is_station_level(A.z))
			continue
		A.emergency_lights = TRUE
		AR.area_emergency_mode = TRUE
		for(var/obj/machinery/light/L in A.area)
			if(L.status)
				continue
			if(GLOB.security_level == SEC_LEVEL_DELTA)
				L.fire_mode = TRUE
			L.on = FALSE
			L.emergency_mode = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)

/proc/unset_stationwide_emergency_lighting()
	for(var/area/A as anything in GLOB.sortedAreas)
		if(!is_station_level(A.z))
			continue
		if(!A.area_emergency_mode)
			continue
		A.area_emergency_mode = FALSE
		for(var/obj/machinery/light/L in A)
			if(A.fire)
				continue
			if(L.status)
				continue
			L.fire_mode = FALSE
			L.emergency_mode = FALSE
			L.on = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)
	for(var/obj/machinery/power/apc/A in GLOB.apcs_list)
		if(!is_station_level(A.z))
			continue
		A.emergency_lights = FALSE
		A.update()

/proc/epsilon_process()
	minor_announce(CONFIG_GET(string/alert_epsilon), "Внимание! КОД - ЭПСИЛОН!",1)
	GLOB.security_level = SEC_LEVEL_EPSILON
	var/obj/machinery/computer/communications/C = locate() in GLOB.machines
	if(C)
		C.post_status("alert", "epsilonalert")
	sound_to_playing_players('sound/misc/alerts/epsilon.ogg')
	for(var/area/A as anything in GLOB.sortedAreas)
		if(!is_station_level(A.z))
			continue
		for(var/obj/machinery/light/L in A)
			if(L.status)
				continue
			L.fire_mode = TRUE
			L.update()
