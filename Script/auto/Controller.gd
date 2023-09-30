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

## Ready to start playing
signal ready_to_start
## Show Options dialog
signal show_options_dialog

## Current waypoint
var current_waypoint: int
## Most recent waypoint
var last_waypoint: int
## Next target waypoint
var next_waypoint: int
## Current state of travel
var travel_state: int
## Countdown until arrival at waypoint
var travel_timer: float

## Handle Controller actions when arriving at a waypoint
func arrive_at_waypoint() -> void:
	Controller.travel_state = State.Stopped_At_Waypoint
	Controller.current_waypoint = Controller.next_waypoint

	return

## Calculate the time to arrive at the next waypoint
func calculate_travel_time() -> void:
	Controller.travel_timer = 1

	return

## Handle Controller actions when departing a waypoint
func depart_waypoint() -> void:
	Controller.travel_state = State.Traveling
	Controller.last_waypoint = Controller.current_waypoint
	Controller.next_waypoint = clampi(
		Controller.current_waypoint + 1, 0, Controller.Waypoint.size()
	)
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.calculate_travel_time()

	return

func reset() -> void:
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.last_waypoint = Controller.Waypoint.Travel
	Controller.next_waypoint = Controller.Waypoint.Earth
	Controller.travel_state = State.Traveling

	return

func show_options() -> void:
	show_options_dialog.emit()

	return

func start_new_game() -> void:
	Controller.reset()
	Controller.ready_to_start.emit()

	return

## Pause game processing
func toggle_pause_game() -> void:
	get_tree().paused = !get_tree().paused
	Log.verbose("Game %saused" % ["P" if get_tree().paused else "Unp"])

	return
