extends MarginContainer

## Button to Depart from current stop / waypoint
var depart_button: Button
var main_menu_button: Button
var options_button: Button
var pause_button: Button
var settle_button: Button
var space_dock_button: Button
var trade_button: Button
var trade_dialog: ConfirmationDialog
var travel_slider: VSlider
var travel_tab_container: TabContainer
var use_fuel_button: Button
var waypoint_dialog: AcceptDialog
var winner_dialog: AcceptDialog

func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_APPLICATION_FOCUS_OUT:
			if Controller.travel_state == State.Traveling:
				Controller.set_pause_mode(true)
				self.pause_button.text = tr("UNPAUSE")

	return

func _process(delta) -> void:
	if !Controller.playing:
		return

	if Controller.current_waypoint != Controller.Waypoint.Travel:
		return

	Controller.travel_timer -= delta
	if Controller.travel_timer <= 0.0:
		self.arrive_at_waypoint()
	else:
		self.set_travel_slider(Controller.travel_timer)

	return

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.check_start()

	return

## Arrive at waypoint
func arrive_at_waypoint() -> void:
	Controller.arrive_at_waypoint()
	match Controller.current_waypoint:
		Controller.Waypoint.Travel:
			return
		Controller.Waypoint.Wolf1061c:
			self.depart_button.visible = false
			self.main_menu_button.visible = false
			self.settle_button.visible = true
			self.space_dock_button.visible = false
			self.trade_button.visible = false
			self.pause_button.visible = false
			self.options_button.visible = false
			self.use_fuel_button.visible = false
		_:
			self.depart_button.visible = true
			self.main_menu_button.visible = true
			self.settle_button.visible = false
			self.space_dock_button.visible = true
			self.trade_button.visible = true
			self.use_fuel_button.visible = true

	self.set_travel_view()
	self.waypoint_dialog.set_dialog_tab()
	self.waypoint_dialog.popup_centered_ratio()

	return

## Check if this is a new game or continuation
func check_start() -> void:
	# Empty start
	if Controller.current_waypoint == Controller.Waypoint.Travel and \
	Controller.last_waypoint == Controller.Waypoint.Travel:
		self.arrive_at_waypoint()
	else:
		set_travel_view()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.depart_button.pressed.connect(self.depart_waypoint)
	self.main_menu_button.pressed.connect(Controller.return_to_main_menu)
	self.options_button.pressed.connect(Controller.show_options)
	self.pause_button.pressed.connect(self.handle_pause_button)
	self.settle_button.pressed.connect(self.start_colony)
	self.trade_button.pressed.connect(self.show_trade)
	self.use_fuel_button.pressed.connect(Controller.use_fuel)

	return

## Leave current waypoint and travel to next
func depart_waypoint() -> void:
	Controller.depart_waypoint()
	self.depart_button.visible = false
	self.settle_button.visible = false
	self.space_dock_button.visible = false
	self.trade_button.visible = false
	self.set_travel_view()

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.depart_button = get_node("%DepartButton")
	self.main_menu_button = get_node("%MainMenuButton")
	self.options_button = get_node("%OptionsButton")
	self.pause_button = get_node("%PauseButton")
	self.settle_button = get_node("%SettleButton")
	self.space_dock_button = get_node("%SpaceDockButton")
	self.trade_button = get_node("%TradeButton")
	self.trade_dialog = get_node("Dialogs/TradeDialog")
	self.travel_slider = get_node("%TripProgressVSlider")
	self.travel_tab_container = get_node("%TravelTabContainer")
	self.use_fuel_button = get_node("%UseFuelButton")
	self.waypoint_dialog = get_node("Dialogs/WaypointDialog")
	self.winner_dialog = get_node("Dialogs/WinnerDialog")

	return

func handle_pause_button() -> void:
	if self.pause_button.text == tr("UNPAUSE"):
		self.pause_button.text = tr("PAUSE")
		Controller.set_pause_mode(false)
	else:
		self.pause_button.text = tr("UNPAUSE")
		Controller.set_pause_mode(true)

	return

## Set Travel Slider value
func set_travel_slider(value: float = 0.0) -> void:
	if Controller.travel_time == 0 or Controller.travel_timer == 0:
		self.travel_slider.set_value_no_signal(0)
	else:
		self.travel_slider.set_value_no_signal(roundi(
			(Controller.travel_time - Controller.travel_timer) /
			Controller.travel_time * 100
		))

	return

## Adjust travel tab container based on current state
func set_travel_view() -> void:
	self.travel_tab_container.set_current_tab(Controller.current_waypoint)
	Log.verbose("Travel tab set to %s" % [Controller.current_waypoint])

	return

## Show trade window when appropriate
func show_trade() -> void:
	if Controller.travel_state == State.Traveling:
		return

	self.trade_dialog.popup_centered_ratio(0.9)

	return

## Begin the colony
func start_colony() -> void:
	self.winner_dialog.popup_centered_ratio()

	return
