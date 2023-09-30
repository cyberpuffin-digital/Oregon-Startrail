extends MarginContainer

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.check_start()

	return

## Check if this is a new game or continuation
func check_start() -> void:
	# Empty start
	if Controller.current_waypoint == 0 and Controller.next_waypoint == 0 and \
	Controller.travel_state == 0:
		Controller.start_new_game()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:

	return

## Get the relevant children in the scene
func get_the_children() -> void:

	return
