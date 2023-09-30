extends Node
## Game controller

## Waypoints found along the way
enum Waypoint {
	## Starting position
	Earth,
	## Earth's moon
	Moon,
	## The red planet
	MARS,
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

func show_options() -> void:
	show_options_dialog.emit()

	return

func start_new_game() -> void:
	Controller.current_waypoint = Controller.Waypoint.Earth
	Controller.last_waypoint = Controller.Waypoint.Earth
	Controller.next_waypoint = Controller.Waypoint.Moon
	Controller.travel_state = State.Ready_To_Start
	Controller.ready_to_start.emit()

	return
