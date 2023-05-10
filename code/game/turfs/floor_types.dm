#define NORTH_EDGING	"north"
#define SOUTH_EDGING	"south"
#define EAST_EDGING		"east"
#define WEST_EDGING		"west"

/turf/floor/wood
	name = "chão"
	icon_state = "wood"
	stepsound = "wood"

/turf/floor/wood/ship
	name = "chão"
	icon_state = "wood_ship"
	stepsound = "wood"

/turf/floor/wood/fancywood
	name = "chão"
	icon_state = "fancywood"

/turf/floor/blackslateroof
	name = "telhado"
	icon = 'icons/turf/roofs.dmi'
	icon_state = "black_slateroof_dm"

/* when this is a subtype of /turf/floor/wood, it doesn't get the right icon.
 * not sure why right now - kachnov */

/turf/floor/wood_broken
	name = "chão"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "broken0"
	stepsound = "wood"

/turf/floor/wood_broken/New()
	..()
	icon_state = "broken[rand(0,6)]"
/turf/floor/plating
	name = "chapeamento"
	icon_state = "plating"
	floor_type = null
	intact = FALSE

/turf/floor/plating/ex_act(severity)
		//set src in oview(1)
	switch(severity)
		if (1.0)
			ChangeTurf(get_base_turf_by_area(src))
		if (2.0)
			if (prob(40))
				ChangeTurf(get_base_turf_by_area(src))
	return

/turf/floor/grass
	name = "canteiro de grama"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass0"
	var/deadicon = 'icons/turf/floors.dmi'//Rad stuff what to turn into
	var/deadicon_state = "ndead_grass1"//Rad stuff what to turn into
	var/grassamt = 1
	New()
		icon_state = "grass[pick("0","1","2","3")]"
		deadicon_state = "dead_grass[pick("0","1","2","3")]"//Rad stuff what to turn into
		..()
		spawn(4)
			if (src)
				update_icon()
				for (var/direction in cardinal)
					if (istype(get_step(src,direction),/turf/floor))
						var/turf/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/floor/carpet
	name = "Tapete"
	icon_state = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	flooring = null
	New()
		if (!icon_state)
			icon_state = "carpet"
		..()
		spawn(4)
			if (src)
				update_icon()
				for (var/direction in list(1,2,4,8,5,6,9,10))
					if (istype(get_step(src,direction),/turf/floor))
						var/turf/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

//Carpets - To be Expanded Upon

/turf/floor/carpet/pinkcarpet
	name = "Tapete rosa"
	icon_state = "gaycarpet"

/turf/floor/carpet/redcarpet
	name = "Tapete vermelho"
	icon_state = "carpet"

/turf/floor/carpet/orangecarpet
	name = "Tapete laranja"
	icon_state = "oracarpet"

/turf/floor/carpet/purplecarpet
	name = "Tapete roxo"
	icon_state = "purcarpet"

/turf/floor/carpet/bluecarpet
	name = "Tapete azul"
	icon_state = "blucarpet"

/turf/floor/carpet/tealcarpet
	name = "Tapete azul-petróleo"
	icon_state = "sblucarpet"

/turf/floor/carpet/greencarpet
	name = "Tapete verde"
	icon_state = "turcarpet"

/turf/floor/carpet/blackcarpet
	name = "Tapete preto"
	icon_state = "bcarpet"

/turf/floor/carpet/whitecarpet
	name = "Tapete branco"
	icon_state = "wcarpet"
//Continue

/turf/floor/plating/ironsand/New()
	..()
	icon = 'icons/turf/floors.dmi'
	name = "Areia de ferro"
	icon_state = "ironsand[rand(1,15)]"

/turf/floor/grass/jungle
	name = "grama de selva"
	
	overlay_priority = 0
	is_diggable = TRUE
	may_become_muddy = TRUE
	initial_flooring = null

/turf/floor/grass/edge
	name = "borda da grama"
	icon_state = "grass_edges"
	is_diggable = FALSE
	may_become_muddy = FALSE

/turf/floor/grass/edge/dead
	name = "borda de grama morta"
	icon_state = "dead_grass_edges"
	is_diggable = FALSE
	may_become_muddy = FALSE

/turf/floor/grass/jungle/savanna
	name = "grama seca"
	icon_state = "dry_grass"
	initial_flooring = null

/turf/floor/grass/jungle/savanna/New()
	..()
	icon_state = "dry_grass"
	deadicon_state = "dead_grass[pick("0","1","2","3")]"//Rad stuff what to turn into

/turf/floor/winter
	name = "neve"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	is_diggable = TRUE
	available_snow = 3
	initial_flooring = /decl/flooring/snow

/turf/floor/winter/ex_act(severity)
	return

/turf/floor/winter/grass
	name = "grama nevada"
	icon = 'icons/turf/snow.dmi'
	icon_state = "grass2"
	is_diggable = TRUE
	available_snow = 2
	initial_flooring = /decl/flooring/snow_grass
	var/deadicon = 'icons/turf/snow.dmi'//Rad stuff what to turn into
	var/deadicon_state = "dead_snowgrass"//Rad stuff what to turn into

/turf/floor/winter/grass/New()
	..()
	icon = 'icons/turf/snow.dmi'
	icon_state = "grass[rand(0,6)]"
	initial_flooring = null

/turf/floor/beach
	name = "praia"
	icon = 'icons/misc/beach.dmi'
	initial_flooring = null

/turf/floor/beach/drywater
	name = "leito de rio seco"
	icon = 'icons/turf/floors.dmi'
	icon_state = "sand1"
	is_diggable = FALSE
	initial_flooring = null

/turf/floor/beach/drywater2
	name = "leito de rio seco"
	icon = 'icons/turf/floors.dmi'
	icon_state = "sand1"
	is_diggable = FALSE
	initial_flooring = null

/turf/floor/beach/sand
	name = "areia"
	icon_state = "sand"
	is_diggable = TRUE
	available_sand = 22
	initial_flooring = /decl/flooring/sand_beach

/turf/floor/beach/sand/edges
	name = "areia"
	icon_state = "sand_edges"
	is_diggable = TRUE
	available_sand = 11
	initial_flooring = /decl/flooring/sand_beach

/turf/floor/beach/sand/dark
	name = "areia negra"
	icon = 'icons/turf/floors.dmi'
	icon_state = "darksand"
	is_diggable = TRUE
	available_sand = 4
	initial_flooring = null

/turf/floor/beach/coastline
	name = "litoral"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	watertile = TRUE
//water level is measured in centimeters. the maximum is 200 (2 meters). up to 1.5 will make movement progressively slower, up from that you will drown if you stay for too long.

/turf/floor/beach/water
	name = "águas rasas"
	desc = "Água. Parece ser rasa."
	icon_state = "seashallow"
	move_delay = 3
	water_level = 30 // in centimeters
	salty = FALSE
	var/sickness = 1 //amount of toxins, from 0 to 3
	initial_flooring = /decl/flooring/water
	watertile = TRUE
	var/image/water_overlay = null

/turf/floor/beach/water/New()
	..()
	water_turf_list += src
	spawn(1)
		water_overlay = image(icon='icons/misc/beach.dmi')
		water_overlay.icon_state= "[icon_state]_ov"
		water_overlay.layer= 10

/turf/floor/beach/water/coastwater
	name = "água da costa"
	desc = "água adorável atingindo a linha costeira"
	icon_state = "beach"

/turf/floor/beach/water/coastwater/corner
	name = "canto da água costeira"
	desc = "água adorável atingindo a linha costeira"
	icon_state = "beachcorner"

/turf/floor/beach/water/coastwater/layer
	name = "água da costa"
	desc = "água adorável atingindo a linha costeira"
	icon_state = "seashallow_edgesX"

/turf/floor/beach/water/shallowsaltwater
	name = "água salgada"
	salty = TRUE
	initial_flooring = /decl/flooring/water_salt

/turf/floor/beach/water/deep
	name = "águas profundas"
	icon_state = "seadeep"
	desc = "Água. Parece ser muito profundo, você não pode ver o fundo."
	water_level = 200
	density = FALSE
	initial_flooring = /decl/flooring/water_deep
	move_delay = 20

/turf/floor/beach/water/deep/saltwater/shipline
	icon_state = "ship_line"
	initial_flooring = /decl/flooring/water_deep_salt/shipline

/turf/floor/beach/water/deep/Crossed(atom/A)
	..()
	check_sinking(A)
/turf/floor/beach/water/deep/Entered(atom/movable/A)
	..()
	check_sinking(A)

/turf/floor/beach/water/proc/check_sinking(atom/movable/A)
	if(iscovered())
		return
	if (!istype(A, /mob) && !istype(A, /obj/structure/vehicle) && !istype(A, /obj/structure/fishing_cage) && !istype(A, /obj/covers) && !istype(A, /obj/structure/barricade) && !istype(A, /obj/effect/sailing_effect))
		spawn(60)
			var/turf/TF = A.loc
			if (istype(TF,/turf/floor/beach/water/deep) && !TF.iscovered())
				qdel(A)
	if(istype(A, /mob/living))
		var/mob/living/ML = A
		if (ishuman(ML))
			var/mob/living/human/H = ML
			if (H.driver_vehicle)
				return
			if (istype(H.wear_suit, /obj/item/clothing/suit/lifejacket))
				return
		if (ML && ML.stat == DEAD)
			spawn(60)
				if (A && A.loc == src)
					qdel(A)
/turf/floor/beach/water/deep/jungle
	name = "rio da selva profunda"
	icon_state = "seashallow_jungle3"
	desc = "Água. Parece ser muito profundo, você não pode ver o fundo."
	water_level = 200
	density = FALSE
	initial_flooring = /decl/flooring/water_jungle3

/turf/floor/beach/water/deep/swamp
	name = "pântano profundo"
	icon_state = "seashallow_swamp"
	desc = "Água. Parece ser muito profundo, você não pode ver o fundo."
	water_level = 200
	density = FALSE
	initial_flooring = /decl/flooring/water_swamp

/turf/floor/beach/water/deep/saltwater
	name = "água salgada profunda"
	salty = TRUE
	initial_flooring = /decl/flooring/water_deep_salt

/turf/floor/beach/water/deep/saltwater/underwater
	name = "água salgada profunda"
	salty = TRUE
	initial_flooring = /decl/flooring/water_deep_salt


/turf/floor/beach/water/deep/CanPass(atom/movable/mover)
	if (istype(mover, /obj/effect/effect/smoke))
		return TRUE
	else if (istype(mover, /obj/item/projectile))
		return TRUE
	else if (istype(mover, /mob) && !iscovered())
		if (ishuman(mover))
			var/mob/living/human/H = mover
			if(istype(H.wear_suit, /obj/item/clothing/suit/lifejacket))
				return TRUE
		return FALSE
	else
		return ..()

/turf/proc/iscovered()
	for(var/obj/covers/C in src.contents)
		return TRUE
	for (var/obj/structure/vehicleparts/frame/ship/S in src.contents)
		return TRUE
	for(var/obj/structure/STR in src.contents)
		var/obj/structure/vehicleparts/frame/ship/S
		if (S in src.contents)
			return TRUE
		else
			return FALSE
	for(var/obj/item/OB in src.contents)
		var/obj/structure/vehicleparts/frame/ship/S
		if (S in src.contents)
			return TRUE
		else
			return FALSE
	for(var/obj/structure/multiz/ladder/ST in src.contents)
		return TRUE
	for (var/obj/structure/vehicleparts/axis/ship/SA in src.contents)
		return TRUE
	for (var/obj/structure/vehicleparts/shipwheel/SW in src.contents)
		return TRUE
	for (var/obj/structure/vehicleparts/movement/sails/SM in src.contents)
		return TRUE
	for (var/obj/structure/vehicle/boat/B in src.contents)
		return TRUE
	for (var/obj/structure/vehicle/raft/R in src.contents)
		return TRUE
	return FALSE
/turf/floor/beach/water/swamp
	name = "pântano"
	move_delay = 3
	icon_state = "seashallow_swamp"
	sickness = 3
	initial_flooring = /decl/flooring/water_swamp

/turf/floor/beach/water/jungle
	name = "rio da selva"
	move_delay = 5
	icon_state = "seashallow_jungle1"
	sickness = 2
	initial_flooring = /decl/flooring/water_jungle1

/turf/floor/beach/water/flooded
	name = "leito do rio inundado"
	move_delay = 5
	icon_state = "seashallow_jungle2"
	sickness = 2
	initial_flooring = /decl/flooring/water_jungle2

/turf/floor/beach/water/proc/Extinguish(var/mob/living/L)
	if (istype(L))
		L.ExtinguishMob()
		L.fire_stacks = FALSE

/turf/floor/beach/water/ex_act(severity)
	return

/turf/floor/beach/water/ice
	name = "gelo"
	icon_state = "seashallow_frozen"
	move_delay = 0
	initial_flooring = null

/turf/floor/beach/water/ice/salty
	name = "gelo de água salgada"

/turf/floor/beach/sand/desert
	name = "areia do deserto"
	icon = 'icons/misc/beach.dmi'
	icon_state = "desert1"
	interior = FALSE
	stepsound = "dirt"
	is_diggable = TRUE
	available_sand = 2
	initial_flooring = /decl/flooring/desert

/turf/floor/beach/sand/desert/New()
	..()
	icon_state = "desert[rand(0,4)]"

/turf/floor/plating/concrete
	name = "concreto"
	icon = 'icons/turf/floors.dmi'
	icon_state = "concrete6"
	interior = FALSE

/turf/floor/plating/marble
	name = "chão de mármore cru"
	icon = 'icons/turf/floors.dmi'
	icon_state = "raw_marble0"
	interior = FALSE

/turf/floor/plating/marble/ornate
	name = "piso de mármore ornamentado"
	icon_state = "ornate_marble"

/turf/floor/plating/marble/grid
	name = "chão de grade de mármore"
	icon_state = "marble_grid"

/turf/floor/plating/marble/raw
	name = "chão de mármore cru"
	icon_state = "raw_marble0"
	New()
		..()
		icon_state = "raw_marble[rand(0,2)]"

/turf/floor/plating/marble/pink
	name = "piso de mármore rosa"
	icon_state = "pink_marble0"
	New()
		..()
		icon_state = "pink_marble[rand(0,2)]"

/turf/floor/plating/marble/black
	name = "chão de mármore preto"
	icon_state = "black_marble0"
	New()
		..()
		icon_state = "black_marble[rand(0,3)]"

/turf/floor/plating/marble/tile
	name = "piso de mármore"
	icon_state = "marble_tile0"
	New()
		..()
		icon_state = "marble_tile[rand(0,2)]"

/turf/floor/plating/marble/decorative_tile
	name = "piso de mármore decorativo"
	icon_state = "decorative_marble_tile0"
	New()
		..()
		icon_state = "decorative_marble_tile[rand(0,2)]"

/turf/floor/plating/metro
	name = "chão do metrô"
	icon = 'icons/turf/floors.dmi'
	icon_state = "metro"
	interior = FALSE

/turf/floor/plating/metroline
	name = "chão do metrô"
	icon = 'icons/turf/floors.dmi'
	icon_state = "metroline"
	interior = FALSE

/turf/floor/plating/tiled
	name = "chão de ladrilhos"
	icon = 'icons/turf/floors.dmi'
	icon_state = "wooden_floor_s1"
	interior = TRUE
/turf/floor/plating/tiled/dark
	icon_state = "wooden_floor_s2"

/turf/floor/plating/tiled/darker
	icon_state = "wooden_floor_s3"

/turf/floor/plating/tiled/woodh
	icon_state = "wooden_floor_s4"

/turf/floor/plating/tiled/woodv
	icon_state = "wooden_floor_s5"

/turf/floor/plating/road
	name = "rua"
	icon = 'icons/turf/floors.dmi'
	icon_state = "road_1"
	interior = FALSE

/turf/floor/plating/road/whiteline
	icon_state = "road_line"

/turf/floor/plating/road/yellowline
	icon_state = "road_yellowline"

/turf/floor/plating/road/yellowline_center
	icon_state = "road_center_yellowline"

/turf/floor/plating/concrete/New()
	..()
	icon_state = pick("road_1","road_2","road_3")

/turf/floor/plating/concrete/New()
	..()
	if (icon_state == "concrete2")
		icon_state = pick("concrete2", "concrete3")
		return
	if (icon_state == "concrete6")
		icon_state = pick("concrete6", "concrete7")
		return
	if (icon_state == "concrete10")
		icon_state = pick("concrete10", "concrete11")
		return

/turf/floor/plating/steel
	name = "piso laminado de aço"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	interior = TRUE

/turf/floor/plating/dark
	name = "chapeamento escuro"
	icon = 'icons/turf/floors.dmi'
	icon_state = "dark"
	interior = TRUE

/turf/floor/plating/white
	name = "piso laminado branco"
	icon = 'icons/turf/floors.dmi'
	icon_state = "white"
	interior = TRUE

/turf/floor/plating/cobblestone
	name = "rua"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_horizontal"
	interior = FALSE

/turf/floor/plating/stone_old
	name = "chão de pedra"
	icon = 'icons/turf/floors.dmi'
	icon_state = "stone_old"
	interior = FALSE

/turf/floor/plating/cobblestone/dark
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_horizontal_dark"
	interior = FALSE

/turf/floor/plating/cobblestone/vertical
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_vertical"
	interior = FALSE

/turf/floor/plating/cobblestone/vertical/dark
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_vertical_dark"
	interior = FALSE
