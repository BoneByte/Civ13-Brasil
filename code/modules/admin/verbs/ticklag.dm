//Merged Doohl's and the existing ticklag as they both had good elements about them ~Carn

/client/proc/ticklag()
	set category = "Debug"
	set name = "Set Ticklag"
	set desc = "Sets a new tick lag. Recommend you don't mess with this too much! Stable, time-tested ticklag value is 0.9"

	if (!check_rights(R_DEBUG))	return

	var/newtick = input("Sets a new tick lag. Please don't mess with this too much! The stable, time-tested ticklag value is 0.9","Lag of Tick", world.tick_lag) as num|null
	//I've used ticks of 2 before to help with serious singulo lags
	if (newtick && newtick <= 2 && newtick > 0)
		log_admin("[key_name(src)] has modified world.tick_lag to [newtick]", FALSE)
		message_admins("[key_name(src)] has modified world.tick_lag to [newtick]", FALSE)
		world.tick_lag = newtick


		switch(WWinput(src, "Enable Tick Compensation?", "Tick Compensation is currently: [config.Tickcomp]", "Yes", list("Yes","No")))
			if ("Yes")	config.Tickcomp = TRUE
			else		config.Tickcomp = FALSE
	else
		src << "<span class = 'red'>Error: ticklag(): Invalid world.ticklag value. No changes made.</span>"


