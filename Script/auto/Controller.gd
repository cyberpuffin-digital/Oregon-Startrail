extends Node
## Game controller

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

enum RandomEvent {
	Bad,
	Good,
	Neutral,
}

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

## Current waypoint
var current_waypoint: int
## Game timers to process resources
var game_timers: Node
## Most recent waypoint
var last_waypoint: int
## Next target waypoint
var next_waypoint: int
## Track when we're playing the game
var playing: bool
## Trader has credit
var trader_credit: bool
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
	Controller.trader_credit = false
	Controller.travel_state = State.Stopped_At_Waypoint
	if Controller.last_waypoint == 0:
		Controller.last_waypoint = Controller.current_waypoint
	Controller.current_waypoint = Controller.next_waypoint
	Controller.game_timers.pause_all(true)

	return

## Calculate the time to arrive at the next waypoint
func calculate_travel_time(quick: bool = false) -> void:
	if quick:
		Controller.travel_time = 5
		Controller.travel_timer = 5

		return

	Controller.travel_time = Controller.travel_time_base * \
		Controller.next_waypoint * \
		Controller.travel_time_multiplier * \
		randf_range(0.9, 1.1)
	Controller.travel_timer = Controller.travel_time

	return

## Handle Controller actions when departing a waypoint
func depart_waypoint(quick: bool = false) -> void:
	Controller.travel_state = State.Traveling
	Controller.last_waypoint = Controller.current_waypoint
	Controller.next_waypoint = clampi(
		Controller.current_waypoint + 1, 0, Controller.Waypoint.size()
	)
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.calculate_travel_time(quick)
	Controller.game_timers.pause_all(false)

	return

## Return the game time from the timers child
func get_game_time() -> float:

	return self.game_timers.game_timer

## Process the resources running on base timer
func process_default_resources(delta: float) -> void:
	for resource in [
		Inventory.Type.Air, Inventory.Type.Bot,
		Inventory.Type.Cryopod, Inventory.Type.Energy,
		Inventory.Type.Human, Inventory.Type.Plant,
		Inventory.Type.Waste, Inventory.Type.Work
	]:
		Controller.process_resource(delta, resource)

	return

## Run the numbers for the requested resource
func process_resource(delta: float, item: int) -> void:
	Inventory.use_resource_by_time(delta, item)
	match item:
		Inventory.Type.Air:
			if Inventory.air <= 0 and Inventory.air_generator > 0:
				if Inventory.fuel >= 1:
					Inventory.calculate_air_generation(1)
				elif Inventory.fuel > 0 and Inventory.fuel < 1:
					Inventory.calculate_air_generation(Inventory.fuel)
				else:
					out_of_air.emit()
			else:
				out_of_air.emit()
		Inventory.Type.Energy:
			if Inventory.energy <= 0 and Inventory.fusion_generator > 0:
				if Inventory.fuel > 0:
					Inventory.calculate_energy_generation(min(1, Inventory.fuel))
				else:
					out_of_energy.emit()
			else:
				out_of_energy.emit()
		Inventory.Type.Food:
			if Inventory.food <= 0:
				out_of_food.emit()
		Inventory.Type.Fuel:
			if Inventory.fuel <= 0:
				out_of_fuel.emit()
		Inventory.Type.Human:
			if Inventory.human <= 0:
				if Inventory.cryopod <= 0:
					Controller.out_of_human.emit()
				else:
					Inventory.use_set_resource(Inventory.Type.Cryopod, 5)
		Inventory.Type.Water:
			if Inventory.water < 0 and Inventory.water_generator > 0:
				if Inventory.fuel > 0:
					Inventory.calculate_water_generation(min(1, Inventory.fuel))
				else:
					out_of_water.emit()
			else:
				out_of_water.emit()

	return

## Random events
func random_event(event_type: Controller.RandomEvent) -> void:
	match event_type:
		Controller.RandomEvent.Bad:
			pass
		Controller.RandomEvent.Good:
			pass
		Controller.RandomEvent.Neutral:
			pass

	return

## GameWindow timers register with the controller
func register_timers(timers: Node) -> void:
	Controller.game_timers = timers

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
	Log.verbose("Game controller reset.")

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
		Inventory.use_set_resource(Inventory.Type.Fuel, 1)
		Inventory.add_resource(Inventory.Type.Energy, 1000)
		Inventory.add_resource(Inventory.Type.Water, 100)
		Inventory.add_resource(Inventory.Type.Air, 50)

	return
