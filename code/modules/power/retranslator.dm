/obj/machinery/retranslator
	name = "Energy relay"
	desc = "."
	icon = 'power.dmi'
	icon_state = "sp_base"
	var/charge = 0
	var/input = 10000
	var/output = 10000
	var/output_wave = 0
	var/transmite = 0
	var/id = "layer2"
	var/list/reciever = list("layer3" , "layer1")
	var/obj/machinery/power/terminal/terminal = null

	New()
		..()
		spawn(11)
			find_dir:
				for(var/d in cardinal)
					var/turf/T = get_step(src, d)
					for(var/obj/machinery/power/terminal/term in T)
						if(term && term.dir == turn(d, 180))
							terminal = term
							break find_dir:
			if(!terminal)
				stat |= BROKEN
				return
			terminal.master = src
			updateicon()
		return

	process()
		if(terminal)
			if(input)
				if(transmite)
					charge += input
					add_load(input)
				else
					online = 0
					transmite = 0

		if(transmite)
			if(charge)
				var/targets = 0
				var/power
				var/list/recievers = new
				for(var/obj/machinery/retranslator/RT in world)
					if(RT.id |= reciever)
						targets += 1
						recievers += RT
				if(recievers)
					output_wave = output
					charge -= output
					for(var/obj/machinery/retranslator/RT in recievers)
						power = output_wave / targets
						RT.charge += min(power,RT.input)
						output_wave -= min(power,RT.input)
						targets -= 1
					output_wave = 0

		if(terminal)
			if(output)
				add_avail(min(output,charge))
				charge -=min (output,charge)

