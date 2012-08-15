var/elevator_location = 1 // 0 -spess, 1 - First level, 2 - Second level, 3 - Third level
var/start_elevator_location = 0 // for coordinate, frome where flying shuttle
var/elevator_moving_down = 10
var/elevator_moving_up = 30
var/elevator_moving = 0

/obj/machinery/elevator_button
	name = "Elevator button"
	icon = 'stationobjs.dmi'
	icon_state = "doorctrl0"
	var/allowedtocall = 0
	var/location = 0 // 0 -spess, 1 - CK, 2 - NSS Exodus


/obj/machinery/elevator_button/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat
	dat += text("<center>Arrival shuttle:</center><br> <b><A href='?src=\ref[src];move1=[1]'>Send</A>First level</b>")
	dat += text("<b><A href='?src=\ref[src];move2=[1]'>Send</A>Second level</b>")
	dat += text("<b><A href='?src=\ref[src];move3=[1]'>Send</A>Third level</b>")
	user << browse("[dat]", "window=Elevator;size=200x100")


/obj/machinery/arrival_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["move1"])
		if (!elevator_moving)
			move_elevator(1)
			//sound placeholder
		else

	if(href_list["move2"])
		if (!elevator_moving)
			move_elevator(2)
			//sound placeholder
		else

	if(href_list["move3"])
		if (!elevator_moving)
			move_elevator(3)
			//sound placeholder
		else

proc/move_elevator(var/lvl)
	if (elevator_moving)
		return
	elevator_moving = 1
	var/area/fromArea
	var/area/toArea
	switch (elevator_location)
		if(1)
			fromArea = locate(/area/mars_station/elevator/layer1)
		if(2)
			fromArea = locate(/area/mars_station/elevator/layer2)
		if(3)
			fromArea = locate(/area/mars_station/elevator/layer3)
	toArea = locate(/area/mars_station/elevator/moving)
	start_elevator_location = lvl
	if (elevator_location > lvl)
		sleep(10 * elevator_moving_down * (elevator_location - lvl))
	else
		sleep(10 * elevator_moving_up * (lvl - elevator_location))
	fromArea.move_contents_to(toArea)
	////////////////////
	for(var/turf/T in fromArea)
		del(T)
	//////////////////
//	var/T = 0
//	while(T < flying_time_from_station)
	elevator_location = 0
	switch(lvl)
		if(1)
			toArea = locate(/area/mars_station/elevator/layer1)
		if(2)
			toArea = locate(/area/mars_station/elevator/layer2)
		if(3)
			toArea = locate(/area/mars_station/elevator/layer3)
	fromArea = locate(/area/mars_station/elevator/moving)
	while(var/T < flying_time_to_station)
		sleep(2)
		for(var/mob/M in toArea)
			if(M.client)
				spawn()
					if(M.buckled)
						shake_camera(M, 1, 1)
					else
						shake_camera(M, 2, 1)
					//sound placeholder
		T += 1
	fromArea.move_contents_to(toArea)
	elevator_location = lvl
	return