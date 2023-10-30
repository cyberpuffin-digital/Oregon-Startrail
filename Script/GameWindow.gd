extends MarginContainer
## Primary game window
##
## Main interface for player to play the game.  Aggregates dialogs and waypoint
## scenes in a series of tab containers.

## Tab container holding game details
var data_tab_container: TabContainer
## Button to Depart from current stop / waypoint
var depart_button: Button
## Override button to shorten travel time
var depart_button_quick: Button
## Dialog to indicate when player is about to lose the trader credit by departing
var depart_trader_credit: ConfirmationDialog
## Return to main menu
var main_menu_button: Button
## Show options dialog
var options_button: Button
## Pause game
var pause_button: Button
## Settle the destination
var settle_button: Button
## Button to show space dock
var space_dock_button: Button
## Space dock dialog for upgrading ship
var space_dock_dialog: ConfirmationDialog
## Button to show trade window
var trade_button: Button
## Trade dialog for buying and selling resources
var trade_dialog: ConfirmationDialog
## Slider to show current travel progress
var travel_slider: VSlider
## Tab container showing waypoints and travel
var travel_tab_container: TabContainer
## Button to burn fuel for resources
var use_fuel_button: Button
## Dialog window for interacting with people
var waypoint_dialog: AcceptDialog
## Dialog window for celebrating a new settlement
var winner_dialog: AcceptDialog

func _exit_tree() -> void:
	Controller.game_timers = null
	if get_tree().paused:
		Controller.set_pause_mode(false)

	return

func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_APPLICATION_FOCUS_OUT:
			if Controller.travel_state == State.Traveling:
				Controller.set_pause_mode(true)
				self.pause_button.text = tr("UNPAUSE")

	return

func _process(delta) -> void:
	self.travel(delta)

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
			self.depart_button_quick.visible = false
			self.main_menu_button.visible = false
			self.settle_button.visible = true
			self.space_dock_button.visible = false
			self.trade_button.visible = false
			self.pause_button.visible = false
			self.options_button.visible = false
			self.use_fuel_button.visible = false
		_:
			self.depart_button.visible = true
			if OS.has_feature("editor") or Config.i_want_to_cheat:
				self.depart_button_quick.visible = true
			Controller.trader_credit = Market.has_credit()
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
	self.data_tab_container.tab_clicked.connect(Audio.play_sfx_with_useless_argument)
	self.depart_button.pressed.connect(self.depart_waypoint)
	self.depart_button_quick.pressed.connect(self.depart_waypoint.bind(true))
	self.depart_trader_credit.confirmed.connect(
		self.depart_waypoint.bind(OS.has_feature("editor") or Config.i_want_to_cheat, true)
	)
	self.main_menu_button.pressed.connect(Controller.return_to_main_menu)
	self.options_button.pressed.connect(Controller.show_options)
	self.pause_button.pressed.connect(self.handle_pause_button)
	self.settle_button.pressed.connect(self.start_colony)
	self.trade_button.pressed.connect(self.show_trade)
	self.use_fuel_button.pressed.connect(Controller.use_fuel)
	self.space_dock_button.pressed.connect(self.show_space_dock)

	return

## Leave current waypoint and travel to next
func depart_waypoint(quick: bool = false, force_depart: bool = false) -> void:
	# Return to trader if credit avaible
	if Controller.trader_credit and !force_depart:
		self.trade_dialog.popup_centered_ratio(0.9)
		self.depart_trader_credit.popup_centered_ratio(0.3)
		return

	self.trade_dialog.hide()
	Controller.depart_waypoint(quick)
	Market.reset_current_pricing()
	self.depart_button.visible = false
	self.depart_button_quick.visible = false
	self.settle_button.visible = false
	self.space_dock_button.visible = false
	self.trade_button.visible = false
	self.set_travel_view()

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.data_tab_container = get_node("%DataTabContainer")
	self.depart_button = get_node("%DepartButton")
	self.depart_button_quick = get_node("%DepartQuickButton")
	self.depart_trader_credit = get_node("Dialogs/DepartTraderCreditDialog")
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
	self.space_dock_dialog = get_node("Dialogs/SpaceDock")

	return

## Callback handler for pause button
func handle_pause_button() -> void:
	if get_tree().paused:
		Controller.set_pause_mode(false)
		self.pause_button.text = tr("PAUSE")
	else:
		self.pause_button.text = tr("UNPAUSE")
		Controller.set_pause_mode(true)

	return

## Set Travel Slider value
func set_travel_slider(_value: float = 0.0) -> void:
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
	Log.debug("Travel tab set to %s" % [Controller.current_waypoint])

	return

## Show space dock window when appropriate
func show_space_dock() -> void:
	if Controller.travel_state == State.Traveling:
		return

	self.space_dock_dialog.popup_centered_ratio(0.9)

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

func travel(delta: float) -> void:
	if !Controller.playing:
		return

	if Controller.current_waypoint != Controller.Waypoint.Travel:
		return

	if Inventory.fuel > 0:
		pass

	Controller.travel_timer -= delta
	if Controller.travel_timer <= 0.0:
		self.arrive_at_waypoint()
	else:
		self.set_travel_slider(Controller.travel_timer)

	return
