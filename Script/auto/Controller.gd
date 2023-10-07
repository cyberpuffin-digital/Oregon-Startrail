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

## Process the resources running on base timer
func process_default_resources(delta: float) -> void:
	for resource in [
		Inventory.ShipResource.Air, Inventory.ShipResource.Bot,
		Inventory.ShipResource.Cryopod, Inventory.ShipResource.Energy,
		Inventory.ShipResource.Human, Inventory.ShipResource.Plant,
		Inventory.ShipResource.Waste, Inventory.ShipResource.Water,
		Inventory.ShipResource.Work
	]:
		Controller.process_resource(delta, resource)

	return

## Run the numbers for the requested resource
func process_resource(delta: float, item: int) -> void:
	var change: float = 0

	Inventory.use_resource_by_time(delta, item)
	match item:
		Inventory.ShipResource.Air:
			if Inventory.air <= 0:
				out_of_air.emit()
		Inventory.ShipResource.Bot:
			pass
		Inventory.ShipResource.Energy:
			if Inventory.energy <= 0:
				out_of_energy.emit()
		Inventory.ShipResource.Food:
			if Inventory.food <= 0:
				out_of_food.emit()
		Inventory.ShipResource.Fuel:
			if Inventory.fuel <= 0:
				out_of_fuel.emit()
		Inventory.ShipResource.Human:
			if Inventory.human <= 0:
				if Inventory.cryopod <= 0:
					Controller.out_of_human.emit()
				else:
					Inventory.use_set_resource(Inventory.cryopod, 5)
		Inventory.ShipResource.Water:
			if Inventory.water < 0:
				out_of_water.emit()
		Inventory.ShipResource.Work:
			Inventory.work += Inventory.bot
			Inventory.work += Inventory.human
			Inventory.work -= Inventory.cryopod * 0.1

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
		Inventory.fuel -= 1
		Inventory.space_available -= Inventory.required_space[Inventory.ShipResource.Fuel]
		Inventory.energy += 1000
		Inventory.space_available += 1000 * Inventory.required_space[Inventory.ShipResource.Energy]
		Inventory.water += 100
		Inventory.space_available += 100 * Inventory.required_space[Inventory.ShipResource.Water]
		Inventory.air += 50
		Inventory.space_available += 50 * Inventory.required_space[Inventory.ShipResource.Air]

	return
