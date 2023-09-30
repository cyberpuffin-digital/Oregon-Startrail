extends Control

var continue_button: Button
var exit_button: Button
var options_button: Button
var start_button: Button

func _exit_tree() -> void:
	Config.save_file()
	Log.clear_message_queue()

	return

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.continue_button.pressed.connect(continue_game)
	self.exit_button.pressed.connect(exit_game)
	self.options_button.pressed.connect(show_options)
	self.start_button.pressed.connect(start_game)

	return

func continue_game() -> void:
	get_tree().change_scene_to_file("res://Scene/GameWindow.tscn")

	return

## Callback function for exit button
func exit_game() -> void:
	get_tree().quit()

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.continue_button = get_node("%Continue")
	self.exit_button = get_node("%ExitGame")
	self.options_button = get_node("%Options")
	self.start_button = get_node("%StartGame")

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.continue_button.visible = !(
		Controller.current_waypoint == 0 and Controller.last_waypoint == 0
	)

	return

## Show Options dialog
func show_options() -> void:
	Controller.show_options()

	return

## Callback function for start button
func start_game() -> void:
	Controller.reset()
	get_tree().change_scene_to_file("res://Scene/GameWindow.tscn")

	return
