extends AcceptDialog
## Winner Dialog

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	canceled.connect(Audio.play_sfx)
	close_requested.connect(Audio.play_sfx)
	confirmed.connect(Audio.play_sfx)
	confirmed.connect(Controller.return_to_main_menu.bind(true))

	return

## Get the relevant children in the scene
func get_the_children() -> void:

	return

## Set initial state for children in the scene
func set_the_children() -> void:

	return

