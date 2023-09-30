extends MarginContainer

## Button to Depart from current stop / waypoint
var depart_button: Button
var pause_button: Button
var settle_button: Button
var space_dock_button: Button
var trade_button: Button
var travel_tab_container: TabContainer
var waypoint_dialog: AcceptDialog

func _process(delta) -> void:
	if Controller.current_waypoint != Controller.Waypoint.Travel:
		return

	Controller.travel_timer -= delta
	if Controller.travel_timer <= 0.0:
		self.arrive_at_waypoint()

	return

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.check_start()

	return

## Arrive at waypoint
func arrive_at_waypoint() -> void:
	Controller.arrive_at_waypoint()
	if Controller.current_waypoint == Controller.Waypoint.Travel:
		return
	elif Controller.current_waypoint == Controller.Waypoint.Wolf1061c:
		self.settle_button.visible = true
		self.depart_button.visible = false
	else:
		self.settle_button.visible = false
		self.depart_button.visible = true

	self.space_dock_button.visible = true
	self.trade_button.visible = true
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

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.depart_button.pressed.connect(self.depart_waypoint)
	self.pause_button.pressed.connect(Controller.toggle_pause_game)

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
	self.pause_button = get_node("%PauseButton")
	self.settle_button = get_node("%SettleButton")
	self.space_dock_button = get_node("%SpaceDockButton")
	self.trade_button = get_node("%TradeButton")
	self.travel_tab_container = get_node("%TravelTabContainer")
	self.waypoint_dialog = get_node("Dialogs/WaypointDialog")

	return

## Adjust travel tab container based on current state
func set_travel_view() -> void:
	self.travel_tab_container.set_current_tab(Controller.current_waypoint)
	Log.verbose("Travel tab set to %s" % [Controller.current_waypoint])

	return
