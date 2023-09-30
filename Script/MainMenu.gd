extends Control

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

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.exit_button.pressed.connect(exit_game)
	self.options_button.pressed.connect(show_options)
	self.start_button.pressed.connect(start_game)

	return

## Callback function for exit button
func exit_game() -> void:
	get_tree().quit()

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.exit_button = get_node("%ExitGame")
	self.options_button = get_node("%Options")
	self.start_button = get_node("%StartGame")

	return

## Show Options dialog
func show_options() -> void:
	Controller.show_options()

	return

## Callback function for start button
func start_game() -> void:
	get_tree().change_scene_to_file("res://Scene/GameWindow.tscn")

	return
