/turf/floor
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "A destroyed floor."
	var/base_icon = 'icons/turf/floors.dmi'
	var/base_icon_state = "dirtnew"

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/decl/flooring/flooring
	var/mineral = DEFAULT_WALL_MATERIAL
	var/set_update_icon
	heat_capacity = 10000
//	var/lava = FALSE
	var/overrided_icon_state

	var/season = "SPRING"
	var/uses_winter_overlay = FALSE

	var/muddy = FALSE
	var/may_become_muddy = FALSE
	var/watertile = FALSE
	plane = FLOOR_PLANE

/turf/floor/is_plating()
	return !flooring

/turf/floor/New(var/newloc, var/floortype)
	..(newloc)
	if (!floortype && initial_flooring)
		floortype = initial_flooring
	if (floortype)
		set_flooring(get_flooring_data(floortype))

/turf/floor/proc/isemptyfloor()
	for(var/obj/O in src)
		if (O.density || istype(O, /obj/structure) || istype(O, /obj/covers))
			return FALSE
	return TRUE

/turf/floor/proc/set_flooring(var/decl/flooring/newflooring)
	make_plating(defer_icon_update = TRUE)
	flooring = newflooring
	update_icon(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	overlays.Cut()
	if (islist(decals))
		decals.Cut()
		decals = null

	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state

	if (flooring)
		if (flooring.build_type && place_product)
			new flooring.build_type(src)
		flooring = null

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null
	levelupdate()

	if (!defer_icon_update)
		update_icon(1)

/turf/floor/proc/make_grass()

	overlays.Cut()
	if (islist(decals))
		decals.Cut()
		decals = null

	set_light(0)
	levelupdate()
	
	ChangeTurf(get_base_turf_by_area(src))

/turf/floor/levelupdate()
	for (var/obj/O in src)
		O.hide(O.hides_under_flooring() && flooring)

