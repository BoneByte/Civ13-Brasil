#define PROCESS_REACTION_ITER 5 //when processing a reaction, iterate this many times

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null

/datum/reagents/New(var/max = 100, atom/A = null)
	..()
	maximum_volume = max
	my_atom = A

	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	if (!chemical_reagents_list)
		//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
		var/paths = typesof(/datum/reagent) - /datum/reagent
		chemical_reagents_list = list()
		for (var/path in paths)
			var/datum/reagent/D = new path()
			if (!D.name)
				continue
			chemical_reagents_list[D.id] = D

/datum/reagents/Destroy()
	if (processes.chemistry)
		processes.chemistry.active_holders -= src

	for (var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list.Cut()
	reagent_list = null
	if (my_atom && my_atom.reagents == src)
		my_atom.reagents = null
	..()
/* Internal procs */

/datum/reagents/proc/get_free_space() // Returns free space.
	return maximum_volume - total_volume

/datum/reagents/proc/get_master_reagent() // Returns reference to the reagent with the biggest volume.
	var/the_reagent = null
	var/the_volume = 0

	for (var/datum/reagent/A in reagent_list)
		if (A.volume > the_volume)
			the_volume = A.volume
			the_reagent = A

	return the_reagent

/datum/reagents/proc/get_master_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/the_name = null
	var/the_volume = 0
	for (var/datum/reagent/A in reagent_list)
		if (A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_id() // Returns the id of the reagent with the biggest volume.
	var/the_id = null
	var/the_volume = 0
	for (var/datum/reagent/A in reagent_list)
		if (A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagents/proc/update_total() // Updates volume.
	total_volume = 0
	for (var/datum/reagent/R in reagent_list)
		if (R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R.id)
		else
			total_volume += R.volume
	return

/datum/reagents/proc/delete()
	for (var/datum/reagent/R in reagent_list)
		R.holder = null
	if (my_atom)
		my_atom.reagents = null

/datum/reagents/proc/handle_reactions()
	if (processes.chemistry)
		processes.chemistry.mark_for_update(src)

//returns TRUE if the holder should continue reactiong, FALSE otherwise.
/datum/reagents/proc/process_reactions()
	if (!my_atom) // No reactions in temporary holders
		return FALSE
	if (!my_atom.loc) //No reactions inside GC'd containers
		return FALSE
	if (my_atom.flags & NOREACT) // No reactions here
		return FALSE

	var/reaction_occured
	var/list/effect_reactions = list()
	var/list/eligible_reactions = list()
	for (var/i in TRUE to PROCESS_REACTION_ITER)
		reaction_occured = FALSE

		//need to rebuild this to account for chain reactions
		for (var/datum/reagent/R in reagent_list)
			eligible_reactions |= chemical_reactions_list[R.id]

		for (var/datum/chemical_reaction/C in eligible_reactions)
			if (C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occured = TRUE

		eligible_reactions.Cut()

		if (!reaction_occured)
			break

	for (var/datum/chemical_reaction/C in effect_reactions)
		C.post_reaction(src)

	update_total()
	return reaction_occured

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/id, var/amount, var/data = null, var/safety = FALSE)
	if (!isnum(amount) || amount <= 0)
		return FALSE

	update_total()
	amount = min(amount, get_free_space())

	for (var/datum/reagent/current in reagent_list)
		if (current.id == id)
			current.volume += amount
			if (!isnull(data)) // For all we know, it could be zero or empty string and meaningful
				current.mix_data(data, amount)
			update_total()
			if (!safety)
				handle_reactions()
			if (my_atom)
				my_atom.on_reagent_change()
			return TRUE
	var/datum/reagent/D = chemical_reagents_list[id]
	if (D)
		var/datum/reagent/R = new D.type()
		reagent_list += R
		R.holder = src
		R.volume = amount
		R.initialize_data(data)
		update_total()
		if (!safety)
			handle_reactions()
		if (my_atom)
			my_atom.on_reagent_change()
		return TRUE
	else
		warning("[my_atom] attempted to add a reagent called '[id]' which doesn't exist. ([usr])")

	return FALSE

/datum/reagents/proc/multiply_reagent(var/id, var/mult = 2.0)
	if (get_reagent_amount(id) > 0)
		return add_reagent(id, get_reagent_amount(id)*(mult-1.0))
	return FALSE

/datum/reagents/proc/remove_reagent(var/id, var/amount, var/safety = FALSE)
	if (!isnum(amount))
		return FALSE
	for (var/datum/reagent/current in reagent_list)
		if (id == "ethanol")
			if (istype(current,/datum/reagent/ethanol))
				current.volume -= amount // It can go negative, but it doesn't matter
				update_total() // Because this proc will delete it then
				if (!safety)
					handle_reactions()
				if (my_atom)
					my_atom.on_reagent_change()

			return TRUE

		else if (current.id == id)
			current.volume -= amount // It can go negative, but it doesn't matter
			update_total() // Because this proc will delete it then
			if (!safety)
				handle_reactions()
			if (my_atom)
				my_atom.on_reagent_change()
			// if we're losing blood (amount > 0), loose some nutrition too
			if (id == "blood" && amount > 0)
				if (my_atom && ishuman(my_atom))
					var/mob/living/human/H = my_atom
					if (H.nutrition > (H.max_nutrition * 0.33))
						H.nutrition -= amount/8
						H.nutrition = min(H.nutrition, H.max_nutrition)
						H.nutrition = max(H.nutrition, -H.max_nutrition)
			return TRUE
	return FALSE

/datum/reagents/proc/del_reagent(var/id)
	for (var/datum/reagent/current in reagent_list)
		if (current.id == id || id == TRUE)
			reagent_list -= current
			qdel(current)
			update_total()
			if (my_atom)
				my_atom.on_reagent_change()
			return FALSE

/datum/reagents/proc/del_reagents()
	return del_reagent(TRUE)

/datum/reagents/proc/has_reagent(var/id, var/amount = 0)
	for (var/datum/reagent/current in reagent_list)
		if (id == "ethanol")
			if (istype(current,/datum/reagent/ethanol))
				if (current.volume >= amount)
					return TRUE
		else if (current.id == id)
			if (current.volume >= amount)
				return TRUE
			else
				return FALSE
	return FALSE

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for (var/datum/reagent/current in reagent_list)
		if (current.id in check_reagents)
			if (current.volume >= check_reagents[current.id])
				return TRUE
			else
				return FALSE
	return FALSE

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	//this only works if check_reagents has no duplicate entries... hopefully okay since it expects an associative list
	var/missing = check_reagents.len
	for (var/datum/reagent/current in reagent_list)
		if (current.id in check_reagents)
			if (current.volume >= check_reagents[current.id])
				missing--
	return !missing

/datum/reagents/proc/clear_reagents()
	for (var/datum/reagent/current in reagent_list)
		del_reagent(current.id)
	return

/datum/reagents/proc/get_reagent_amount(var/id)
	if (id == "ethanol")
		var/tvol = 0
		for (var/datum/reagent/current in reagent_list)
			if (istype(current,/datum/reagent/ethanol))
				tvol += current.volume
		return tvol
	else
		for (var/datum/reagent/current in reagent_list)
			if (current.id == id)
				return current.volume
	return FALSE

/datum/reagents/proc/get_data(var/id)
	for (var/datum/reagent/current in reagent_list)
		if (current.id == id)
			return current.get_data()
	return FALSE

/datum/reagents/proc/get_reagents()
	. = list()
	for (var/datum/reagent/current in reagent_list)
		. += "[current.id] ([current.volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)
	if (!amount)
		return 0
	var/part = amount / total_volume
	for (var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, TRUE)
	update_total()
	handle_reactions()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = TRUE, var/multiplier = TRUE, var/copy = FALSE) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).
	if (!target || !istype(target))
		return 0
	amount = max(0, min(amount, total_volume, target.get_free_space() / multiplier))
	if (!amount)
		return 0
	var/part = amount / total_volume
	for (var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), safety = TRUE) // We don't react until everything is in place
		if (!copy)
			remove_reagent(current.id, amount_to_transfer, TRUE)
	if (!copy)
		handle_reactions()
	target.handle_reactions()
	return amount

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(var/atom/target, var/amount = TRUE, var/multiplier = TRUE, var/copy = FALSE)
	touch(target) //First, handle mere touch effects

	if (ismob(target))
		return splash_mob(target, amount, copy)
	if (isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if (isobj(target) && target.is_open_container())
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagents/proc/splash(var/atom/target, var/amount = TRUE, copy = FALSE)

	trans_to(target, amount, 1, copy)
	if (istype(target, /turf/floor/dirt))
		for (var/obj/structure/farming/plant/P in target)
			P.water = min(P.water+amount,P.max_water)


/datum/reagents/proc/trans_id_to(var/atom/target, var/id, var/amount = TRUE)
	if (!target || !target.reagents || !target.simulated)
		return

	amount = min(amount, get_reagent_amount(id))

	if (!amount)
		return

	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = get_data(id)
	F.add_reagent(id, amount, tmpdata)
	remove_reagent(id, amount)

	return F.trans_to(target, amount) // Let this proc check the atom's type

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagents/proc/touch(var/atom/target)
	if (ismob(target))
		touch_mob(target)
	if (isturf(target))
		touch_turf(target)
	if (isobj(target))
		touch_obj(target)
	return

/datum/reagents/proc/touch_mob(var/mob/target)
	if (!target || !istype(target) || !target.simulated)
		return

	for (var/datum/reagent/current in reagent_list)
		current.touch_mob(target, current.volume)

	update_total()

/datum/reagents/proc/touch_turf(var/turf/target)
	if (!target || !istype(target) || !target.simulated)
		return

	for (var/datum/reagent/current in reagent_list)
		current.touch_turf(target, current.volume)

	update_total()

/datum/reagents/proc/touch_obj(var/obj/target)
	if (!target || !istype(target) || !target.simulated)
		return

	for (var/datum/reagent/current in reagent_list)
		current.touch_obj(target, current.volume)

	update_total()

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target, var/amount = TRUE, var/copy = FALSE)
	var/perm = TRUE
	if (isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount, CHEM_TOUCH, perm, copy)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = TRUE, var/type = CHEM_BLOOD, var/multiplier = TRUE, var/copy = FALSE, var/smoked = FALSE) // Transfer after checking into which holder...
	if (!target || !istype(target) || !target.simulated)
		return
	if (ishuman(target))
		var/mob/living/human/C = target
		if (type == CHEM_BLOOD)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if (type == CHEM_INGEST)
			var/datum/reagents/R = C.ingested
			return C.ingest(src,R, amount, multiplier, copy, smoked)
		if (type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagents/R = new /datum/reagents(amount)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_mob(target)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = TRUE, var/multiplier = TRUE, var/copy = FALSE) // Turfs don't have any reagents (at least, for now). Just touch it.
	if (!target || !target.simulated)
		return

	var/datum/reagents/R = new /datum/reagents(amount * multiplier)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target)
	return

/datum/reagents/proc/trans_to_obj(var/obj/target, var/amount = TRUE, var/multiplier = TRUE, var/copy = FALSE) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if (!target || !target.simulated)
		return 0
	if (!target.reagents)
		var/datum/reagents/R = new /datum/reagents(amount * multiplier)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_obj(target)
		return 0
	return trans_to_holder(target.reagents, amount, multiplier, copy)

/atom/proc/create_reagents(var/max_vol) /* Atom reagent creation - use it all the time */
	reagents = new/datum/reagents(max_vol, src)
