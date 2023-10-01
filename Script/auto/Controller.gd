extends Node
## Game controller

## Waypoints found along the way, corresponds to list of tabs in GameWindow
enum Waypoint {
	## Travelling between waypoints
	Travel,
	## Starting position
	Earth,
	## Earth's moon
	Moon,
	## The red planet
	Mars,
	## Jupiter's moon with lots of ice
	Europa,
	## Last part of the solar system where a station could be placed
	KuiperBelt,
	## Destination planet
	Wolf1061c,
}

## Out of air
signal out_of_air
## Out of energ
signal out_of_energy
## Out of food
signal out_of_food
## Out of fuel
signal out_of_fuel
## Out of humans
signal out_of_human
## Out of water
signal out_of_water
## Ready to start playing
signal ready_to_start
## Show Options dialog
signal show_options_dialog

const GameTimers = preload("res://Script/Data/GameTimers.gd")

## Current waypoint
var current_waypoint: int
## Game timers to process resources
var game_timers: GameTimers
## Most recent waypoint
var last_waypoint: int
## Next target waypoint
var next_waypoint: int
## Track when we're playing the game
var playing: bool
## Current state of travel
var travel_state: int
## Show current travel time total
var travel_time: float
## Base time between waypoints
var travel_time_base: int
## Time multiplier for exponential growth
var travel_time_multiplier: float
## Countdown until arrival at waypoint
var travel_timer: float

## Handle Controller actions when arriving at a waypoint
func arrive_at_waypoint() -> void:
	Controller.travel_state = State.Stopped_At_Waypoint
	if Controller.last_waypoint == 0:
		Controller.last_waypoint = Controller.current_waypoint
	Controller.current_waypoint = Controller.next_waypoint
	Controller.game_timers.pause_all(true)

	return

## Calculate the time to arrive at the next waypoint
func calculate_travel_time() -> void:
	if OS.has_feature("editor"):
		Controller.travel_time = 5
		Controller.travel_timer = 5

		return

	Controller.travel_time = Controller.travel_time_base * \
		Controller.next_waypoint * \
		Controller.travel_time_multiplier * \
		randf_range(0.9, 1.1)
	Controller.travel_timer = Controller.travel_time

	return

## How many combined fishery and hyrdoponic stations can we make
func count_aquaponic() -> int:
	# Empty workstations
	if Inventory.fishery == 0 or Inventory.hydroponic == 0:
		return 0

	# No active fish or plants
	if Controller.resource.fish == 0 or Inventory.plant == 0:
		return 0

	return min(Inventory.fishery, Inventory.hydroponic)

## Handle Controller actions when departing a waypoint
func depart_waypoint() -> void:
	Controller.travel_state = State.Traveling
	Controller.last_waypoint = Controller.current_waypoint
	Controller.next_waypoint = clampi(
		Controller.current_waypoint + 1, 0, Controller.Waypoint.size()
	)
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.calculate_travel_time()
	Controller.game_timers.pause_all(false)

	return

## Process the resources running on base timer
func process_default_resources() -> void:
	Controller.process_resource(Inventory.TrackedResources.Air)
	Controller.process_resource(Inventory.TrackedResources.Bot)
	Controller.process_resource(Inventory.TrackedResources.Cryopod)
	Controller.process_resource(Inventory.TrackedResources.Energy)
	Controller.process_resource(Inventory.TrackedResources.Human)
	Controller.process_resource(Inventory.TrackedResources.Plant)
	Controller.process_resource(Inventory.TrackedResources.Repair)
	Controller.process_resource(Inventory.TrackedResources.Waste)
	Controller.process_resource(Inventory.TrackedResources.Water)
	Controller.process_resource(Inventory.TrackedResources.Work)

	return

## Run the numbers for the requested resource
func process_resource(item: int) -> void:
	var change: float = 0
	match item:
		Inventory.TrackedResources.Air:
			change -= Inventory.human
			change += Inventory.plant
			if Inventory.hydroponic > 0:
				change += Inventory.plant * Inventory.hydroponic
				if Inventory.fishery > 0:
					change += roundi(
						Inventory.plant * min(Inventory.hydroponic, Inventory.fishery)
					)
			Inventory.air += change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Air]
			if Inventory.air <= 0:
				out_of_air.emit()
		Inventory.TrackedResources.Bot:
			pass
		Inventory.TrackedResources.Cryopod:
			pass
		Inventory.TrackedResources.Energy:
			change -= Inventory.bot
			change -= Inventory.cryopod
			change -= Inventory.fishery
			change += Inventory.human
			change -= Inventory.hydroponic
			Inventory.energy += change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Energy]
			if Inventory.energy <= 0:
				out_of_energy.emit()
		Inventory.TrackedResources.Fish:
			if Inventory.fish <= 0:
				return
			change -= Inventory.fish * randf_range(0, 0.1)

			Inventory.fish += change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Fish]
		Inventory.TrackedResources.Food:
			change += Inventory.fish * 0.5
			change -= Inventory.human
			Inventory.food += change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Food]
			if Inventory.food <= 0:
				out_of_food.emit()
		Inventory.TrackedResources.Fuel:
			if Inventory.fuel <= 0:
				out_of_fuel.emit()

				return
			Inventory.fuel -= 1
			Inventory.space_available -= Inventory.space_use[Inventory.TrackedResources.Fuel]
		Inventory.TrackedResources.Human:
			change -= randf_range(0, 0.05)

			Inventory.human -= change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Human]

			if Inventory.human <= 0:
				if Inventory.cryopod <= 0:
					out_of_human.emit()
				elif Inventory.cryopod < 5:
					Inventory.human = Inventory.cryopod
					Inventory.space_available += Inventory.cryopod * Inventory.space_use[Inventory.TrackedResources.Human]
					Inventory.cryopod = 0
				else:
					Inventory.human = 5
					Inventory.space_available += 5 * Inventory.space_use[Inventory.TrackedResources.Human]
					Inventory.cryopod -= 5
		Inventory.TrackedResources.Plant:
			if Inventory.plant <= 0:
				return
			change += Inventory.fish * 0.1
			change -= Inventory.plant * randf_range(0, 0.1)

			Inventory.plant = change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Plant]
		Inventory.TrackedResources.Repair:
			pass
		Inventory.TrackedResources.Waste:
			if Inventory.waste <= 0:
				return
			change -= Inventory.fish
			change += Inventory.human

			Inventory.waste += change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Waste]
		Inventory.TrackedResources.Water:
			change -= Inventory.fish
			change -= Inventory.human
			change -= Inventory.plant

			Inventory.water += change
			Inventory.space_available -= change * Inventory.space_use[Inventory.TrackedResources.Water]
			if Inventory.water < 0:
				out_of_water.emit()
		Inventory.TrackedResources.Work:
			Inventory.work += Inventory.bot
			Inventory.work += Inventory.human
			Inventory.work -= Inventory.cryopod * 0.1
		_:
			Log.error("Unknown resource: %s" % [item])

	return

## Reset Controller to initial state
func reset() -> void:
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.last_waypoint = Controller.Waypoint.Travel
	Controller.next_waypoint = Controller.Waypoint.Earth
	Controller.playing = true
	Controller.travel_state = State.Traveling
	Controller.travel_time_base = 5
	Controller.travel_time_multiplier = 1.5
	Inventory.reset()
	if !Controller.game_timers:
		Controller.game_timers = GameTimers.new()
		Controller.game_timers.configure_timers()
		add_child(Controller.game_timers)

	return

## Clean up and return to main menu
func return_to_main_menu(reset_controller: bool = false) -> void:
	if reset_controller:
		Controller.reset()
	Log.clear_message_queue()
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")

	return

## Set game pause mode
func set_pause_mode(paused: bool = false) -> void:
	get_tree().paused = paused
	Log.verbose("Game %saused" % ["P" if paused else "Unp"])

	return

## Send signal to show options menu
func show_options() -> void:
	show_options_dialog.emit()

	return

## Clear Controller and signal ready to start
func start_new_game() -> void:
	Controller.reset()
	Controller.ready_to_start.emit()

	return

## Use fuel to regain resources
func use_fuel() -> void:
	if Inventory.fuel >= 1:
		Inventory.fuel -= 1
		Inventory.space_available -= Inventory.space_use[Inventory.TrackedResources.Fuel]
		Inventory.energy += 1000
		Inventory.space_available += 1000 * Inventory.space_use[Inventory.TrackedResources.Energy]
		Inventory.water += 100
		Inventory.space_available += 100 * Inventory.space_use[Inventory.TrackedResources.Water]
		Inventory.air += 50
		Inventory.space_available += 50 * Inventory.space_use[Inventory.TrackedResources.Air]

	return
