extends AcceptDialog
## Winner Dialog

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	confirmed.connect(Controller.return_to_main_menu.bind(true))

	return

## Get the relevant children in the scene
func get_the_children() -> void:

	return

## Set initial state for children in the scene
func set_the_children() -> void:

	return

