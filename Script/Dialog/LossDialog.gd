extends AcceptDialog
## Loss dialog

## Game over reason
var reason_label: Label

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	confirmed.connect(Controller.return_to_main_menu.bind(true))
	Controller.out_of_air.connect(self.game_over.bind("AIR"))
	Controller.out_of_energy.connect(self.game_over.bind("ENERGY"))
	Controller.out_of_food.connect(self.game_over.bind("FOOD"))
	Controller.out_of_fuel.connect(self.game_over.bind("FUEL"))
	Controller.out_of_human.connect(self.game_over.bind("HUMAN"))
	Controller.out_of_water.connect(self.game_over.bind("WATER"))

	return

func game_over(why: String = "") -> void:
	Controller.playing = false
	if !why.is_empty():
		self.reason_label.text = "%s %s" % [tr("RANOUTOF"), tr(why)]
	Controller.game_timers.pause_all(true)
	popup_centered_ratio(0.6)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.reason_label = get_node("%ReasonLabel")

	return

## Set initial state for children in the scene
func set_the_children() -> void:

	return

