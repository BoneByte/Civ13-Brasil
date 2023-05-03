/* what this does:
copies what reagents will be taken out of the holder.
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/mob/living/human/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = TRUE, var/multiplier = TRUE, var/copy = FALSE, var/smoked = FALSE) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	var/datum/reagents/temp = new() //temporary holder used to analyse what gets transfered.
	var/list/tastes = list() //descriptor = strength
	from.trans_to_holder(temp, amount, multiplier, TRUE)
	var/list/out = list()
	var/minimum_percent = 15
	if (istype(src,/mob/living/human))
		var/mob/living/human/H = src
		minimum_percent = round(15/H.species.taste_sensitivity)
	if (minimum_percent < 100)
		var/total_taste = FALSE
		for (var/datum/reagent/R in temp.reagent_list)
			var/desc
			if (!R.taste_mult)
				continue
			if (R.id == "nutriment")
				var/list/t = R.get_data()
				for (var/i in TRUE to t.len)
					var/A = t[i]
					if (!(A in tastes))
						tastes.Add(A)
						tastes[A] = FALSE
					tastes[A] += t[A]
					total_taste += t[A]
				continue
			else
				desc = R.taste_description
			if (!(desc in tastes))
				tastes.Add(desc)
				tastes[desc] = FALSE
			tastes[desc] += temp.get_reagent_amount(R.id) * R.taste_mult
			total_taste += temp.get_reagent_amount(R.id) * R.taste_mult
		if (tastes.len)
			for (var/i in TRUE to tastes.len)
				var/size = "a hint of "
				var/percent = tastes[tastes[i]]/total_taste * 100
				if (percent == 100) //completely TRUE thing, dont need to do anything to it.
					size = ""
				else if (percent > minimum_percent * 3)
					size = "the strong flavor of "
				else if (percent > minimum_percent * 2)
					size = ""
				else if (percent <= minimum_percent)
					continue
				out.Add("[size][tastes[i]]")
	if (!smoked || prob(2)) //to prevent spam of "You taste X" every second
		src << "<span class='notice'>You can taste [english_list(out,"something indescribable")].</span>" //no taste means there are too many tastes and not enough flavor.
	from.trans_to_holder(target,amount,multiplier,copy) //complete transfer