/turf/open/space/transit
	name = "\proper hyperspace"
	icon_state = "black"
	dir = SOUTH
	baseturfs = /turf/open/space/transit
	flags_1 = NOJAUNT_1 //This line goes out to every wizard that ever managed to escape the den. I'm sorry.
	explosion_block = INFINITY

/turf/open/space/transit/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	. = ..()
	underlay_appearance.icon_state = "speedspace_ns_[get_transit_state(asking_turf)]"
	underlay_appearance.transform = turn(matrix(), get_transit_angle(asking_turf))

/turf/open/space/transit/south
	dir = SOUTH

/turf/open/space/transit/north
	dir = NORTH

/turf/open/space/transit/horizontal
	dir = WEST

/turf/open/space/transit/west
	dir = WEST

/turf/open/space/transit/east
	dir = EAST

/turf/open/space/transit/border
	opacity = TRUE

/turf/open/space/transit/border/south
	dir = SOUTH

/turf/open/space/transit/border/north
	dir = NORTH

/turf/open/space/transit/border/west
	dir = WEST

/turf/open/space/transit/border/east
	dir = EAST

/turf/open/space/transit/centcom
	dir = SOUTH

/turf/open/space/transit/centcom/Entered(atom/movable/AM, atom/OldLoc)
	..()
	if(!locate(/obj/structure/lattice) in src)
		throw_atom(AM)

/turf/open/space/transit/border/Entered(atom/movable/AM, atom/OldLoc)
	..()
	if(!locate(/obj/structure/lattice) in src)
		throw_atom(AM)

/turf/open/space/transit/proc/throw_atom(atom/movable/AM)
	set waitfor = FALSE
	if(!AM || istype(AM, /obj/docking_port))
		return
	if(AM.loc != src) // Multi-tile objects are "in" multiple locs but its loc is it's true placement.
		return // Don't move multi tile objects if their origin isn't in transit
	var/max = world.maxx-TRANSITIONEDGE
	var/min = 1+TRANSITIONEDGE

	var/list/possible_transtitons = list()
	for(var/A in SSmapping.z_list)
		var/datum/space_level/D = A
		if (D.linkage == CROSSLINKED)
			possible_transtitons += D.z_value
	if(!length(possible_transtitons)) //No space to throw them to - try throwing them onto mining
		possible_transtitons = SSmapping.levels_by_trait(ZTRAIT_MINING)
		if(!length(possible_transtitons)) //Just throw them back on station, if not just runtime.
			possible_transtitons = SSmapping.levels_by_trait(ZTRAIT_STATION)
	var/_z = pick(possible_transtitons)

	//now select coordinates for a border turf
	var/_x
	var/_y
	switch(dir)
		if(SOUTH)
			_x = rand(min,max)
			_y = max
		if(WEST)
			_x = max
			_y = rand(min,max)
		if(EAST)
			_x = min
			_y = rand(min,max)
		else
			_x = rand(min,max)
			_y = min

	var/turf/T = locate(_x, _y, _z)

	if(!QDELETED(AM))
		AM.forceMove(T)
		var/turf/throwturf = get_ranged_target_turf(T, dir, 1)
		AM.safe_throw_at(throwturf, 1, 4, null, FALSE)


/turf/open/space/transit/CanBuildHere()
	return SSshuttle.is_in_shuttle_bounds(src)


/turf/open/space/transit/Initialize(mapload)
	. = ..()
	update_icon()
	for(var/atom/movable/AM in src)
		throw_atom(AM)

/turf/open/space/transit/update_icon()
	. = ..()
	transform = turn(matrix(), get_transit_angle(src))

/turf/open/space/transit/update_icon_state()
	icon_state = "speedspace_ns_[get_transit_state(src)]"

/proc/get_transit_state(turf/T)
	var/p = 9
	. = 1
	switch(T.dir)
		if(NORTH)
			. = ((-p*T.x+T.y) % 15) + 1
			if(. < 1)
				. += 15
		if(EAST)
			. = ((T.x+p*T.y) % 15) + 1
		if(WEST)
			. = ((T.x-p*T.y) % 15) + 1
			if(. < 1)
				. += 15
		else
			. = ((p*T.x+T.y) % 15) + 1

/proc/get_transit_angle(turf/T)
	. = 0
	switch(T.dir)
		if(NORTH)
			. = 180
		if(EAST)
			. = 90
		if(WEST)
			. = -90

///Dump a movable in a random valid spacetile
/proc/dump_in_space(atom/movable/dumpee)
	if(HAS_TRAIT(dumpee, TRAIT_DEL_ON_SPACE_DUMP))
		qdel(dumpee)
		return

	var/max = world.maxx-TRANSITIONEDGE
	var/min = 1+TRANSITIONEDGE

	var/list/possible_transtitons = list()
	for(var/datum/space_level/level as anything in SSmapping.z_list)
		if (level.linkage == CROSSLINKED)
			possible_transtitons += level.z_value
	if(!length(possible_transtitons)) //No space to throw them to - try throwing them onto mining
		possible_transtitons = SSmapping.levels_by_trait(ZTRAIT_MINING)
		if(!length(possible_transtitons)) //Just throw them back on station, if not just runtime.
			possible_transtitons = SSmapping.levels_by_trait(ZTRAIT_STATION)

	//move the dumpee to a random coordinate turf
	dumpee.forceMove(locate(rand(min,max), rand(min,max), pick(possible_transtitons)))
