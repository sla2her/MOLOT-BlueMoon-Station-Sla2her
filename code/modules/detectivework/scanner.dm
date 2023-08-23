//CONTAINS: Detective's Scanner

// TODO: Split everything into easy to manage procs.

/obj/item/detective_scanner
	name = "forensic scanner"
	desc = "Used to remotely scan objects and biomass for DNA and fingerprints. Can print a report of the findings."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensicnew"
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	/// if the scanner is currently busy processing
	var/scanner_busy = FALSE
	var/list/log = list()
	var/range = 8
	var/view_check = TRUE
	var/forensicPrintCount = 0
	actions_types = list(/datum/action/item_action/display_detective_scan_results)

/datum/action/item_action/display_detective_scan_results
	name = "Display Forensic Scanner Results"

/datum/action/item_action/display_detective_scan_results/Trigger(trigger_flags)
	var/obj/item/detective_scanner/scanner = target
	if(istype(scanner))
		scanner.display_detective_scan_results(usr)

/obj/item/detective_scanner/attack_self(mob/user)
	if(!LAZYLEN(log))
		balloon_alert(user, "no logs!")
		return
	if(scanner_busy)
		balloon_alert(user, "scanner busy!")
		return
	scanner_busy = TRUE
	balloon_alert(user, "printing report...")
	addtimer(CALLBACK(src, PROC_REF(safe_print_report)), 10 SECONDS)

/**
 * safe_print_report - a wrapper proc for print_report
 *
 * Calls print_report(), and should a runtime occur within we can still reset the 'busy' state
 */
/obj/item/detective_scanner/proc/safe_print_report()
	print_report()
	scanner_busy = FALSE

/obj/item/detective_scanner/proc/print_report()
	// Create our paper
	var/obj/item/paper/report_paper = new(get_turf(src))

	//This could be a global count like sec and med record printouts. See GLOB.manifest.generalPrintCount AKA datacore.dm
	var/frNum = ++forensicPrintCount

	report_paper.name = "FR-[frNum] 'Forensic Record'"
	var/report_text = "<center><B>Forensic Record - (FR-[frNum])</B></center><HR><BR>"
	report_text += jointext(log, "<BR>")
	report_text += "<HR><B>Notes:</B><BR>"

	report_paper.add_raw_text(report_text)
	report_paper.update_appearance()

	if(ismob(loc))
		var/mob/printer = loc
		printer.put_in_hands(report_paper)
		balloon_alert(printer, "logs cleared")

	// Clear the logs
	log = list()

/obj/item/detective_scanner/afterattack(atom/A, mob/user, params)
	. = ..()
	safe_scan(user, atom_to_scan = A)
	return . | FALSE

/**
 * safe_scan - a wrapper proc for scan()
 *
 * calls scan(), and should a runtime occur within we can still reset the 'busy' state
 */
/obj/item/detective_scanner/proc/safe_scan(mob/user, atom/atom_to_scan)
	set waitfor = FALSE
	if(scanner_busy)
		return
	if(!scan(user, atom_to_scan)) // this should only return FALSE if a runtime occurs during the scan proc, so ideally never
		balloon_alert(user, "scanner error!") // but in case it does, we 'error' instead of just bricking the scanner
	scanner_busy = FALSE

/**
 * scan - scans an atom for forensic data and outputs it to the mob holding the scanner
 *
 * This should always return TRUE barring a runtime
 */
/obj/item/detective_scanner/proc/scan(atom/A, mob/user)
	set waitfor = 0
	if(!scanner_busy)
		// Can remotely scan objects and mobs.
		if((get_dist(A, user) > range) || (!(A in view(range, user)) && view_check) || (loc != user))
			return

		scanner_busy = TRUE

		user.visible_message("\The [user] points the [src.name] at \the [A] and performs a forensic scan.")
		to_chat(user, "<span class='notice'>You scan \the [A]. The scanner is now analysing the results...</span>")


		// GATHER INFORMATION

		//Make our lists
		var/list/fingerprints = list()
		var/list/blood = list()
		var/list/fibers = list()
		var/list/reagents = list()

		var/target_name = A.name

		// Start gathering

		if(A.blood_DNA && A.blood_DNA.len)
			blood = A.blood_DNA.Copy()

		if(A.suit_fibers && A.suit_fibers.len)
			fibers = A.suit_fibers.Copy()

		if(ishuman(A))

			var/mob/living/carbon/human/H = A
			if(!H.gloves)
				fingerprints += md5(H.dna.uni_identity)

		else if(!ismob(A))

			if(A.fingerprints && A.fingerprints.len)
				fingerprints = A.fingerprints.Copy()

			// Only get reagents from non-mobs.
			if(A.reagents && A.reagents.reagent_list.len)

				for(var/datum/reagent/R in A.reagents.reagent_list)
					reagents[R.name] = R.volume

					// Get blood data from the blood reagent.
					if(istype(R, /datum/reagent/blood))

						if(R.data["blood_DNA"] && R.data["blood_type"])
							var/blood_DNA = R.data["blood_DNA"]
							var/blood_type = R.data["blood_type"]
							LAZYINITLIST(blood)
							blood[blood_DNA] = blood_type

		// We gathered everything. Create a fork and slowly display the results to the holder of the scanner.

		var/found_something = FALSE
		add_log("<B>[STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)][get_timestamp()] - [target_name]</B>", 0)

		// Fingerprints
		if(length(fingerprints))
			sleep(3 SECONDS)
			add_log("<span class='info'><B>Prints:</B></span>")
			for(var/finger in fingerprints)
				add_log("[finger]")
			found_something = TRUE

		// Blood
		if (length(blood))
			sleep(3 SECONDS)
			add_log("<span class='info'><B>Blood:</B></span>")
			found_something = TRUE
			for(var/B in blood)
				if(B == "color")
					continue
				add_log("Type: <font color='red'>[blood[B]]</font> DNA: <font color='red'>[B]</font>")

		//Fibers
		if(length(fibers))
			sleep(3 SECONDS)
			add_log("<span class='info'><B>Fibers:</B></span>")
			for(var/fiber in fibers)
				add_log("[fiber]")
			found_something = TRUE

		//Reagents
		if(length(reagents))
			sleep(3 SECONDS)
			add_log("<span class='info'><B>Reagents:</B></span>")
			for(var/R in reagents)
				add_log("Reagent: <font color='red'>[R]</font> Volume: <font color='red'>[reagents[R]]</font>")
			found_something = TRUE

		// Get a new user
		var/mob/holder = null
		if(ismob(src.loc))
			holder = src.loc

		if(!found_something)
			add_log("<I># No forensic traces found #</I>", 0) // Don't display this to the holder user
			if(holder)
				to_chat(holder, "<span class='warning'>Unable to locate any fingerprints, materials, fibers, or blood on \the [target_name]!</span>")
		else
			if(holder)
				to_chat(holder, "<span class='notice'>You finish scanner_busy \the [target_name].</span>")

		add_log("---------------------------------------------------------", 0)
		scanner_busy = FALSE
		return

/obj/item/detective_scanner/proc/add_log(msg, broadcast = 1)
	if(scanner_busy)
		if(broadcast && ismob(loc))
			var/mob/logger = loc
			to_chat(logger, msg)
		log += "&nbsp;&nbsp;[msg]"
	else
		CRASH("[src] [REF(src)] is adding a log when it was never put in scanner_busy mode!")

/proc/get_timestamp()
	return time2text(world.time + 432000, ":ss")

/obj/item/detective_scanner/AltClick(mob/living/user)
	// Best way for checking if a player can use while not incapacitated, etc
	if(!user.canUseTopic(src, be_close=TRUE))
		return
	if(!LAZYLEN(log))
		balloon_alert(user, "no logs!")
		return
	if(scanner_busy)
		balloon_alert(user, "scanner busy!")
		return
	balloon_alert(user, "deleting logs...")
	if(do_after(user, 3 SECONDS, target = src))
		balloon_alert(user, "logs cleared")
		log = list()

/obj/item/detective_scanner/examine(mob/user)
	. = ..()
	if(LAZYLEN(log) && !scanner_busy)
		. += span_notice("Alt-click to clear scanner logs.")

/obj/item/detective_scanner/proc/display_detective_scan_results(mob/living/user)
	// No need for can-use checks since the action button should do proper checks
	if(!LAZYLEN(log))
		balloon_alert(user, "no logs!")
		return
	if(scanner_busy)
		balloon_alert(user, "scanner busy!")
		return
	to_chat(user, span_notice("<B>Scanner Report</B>"))
	for(var/iterLog in log)
		to_chat(user, iterLog)
