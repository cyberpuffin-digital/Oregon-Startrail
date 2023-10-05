extends ScrollContainer
## Ship details display

## Interval between resource data updates
const UPDATE_INTERVAL: float = 2.0

## Ship detail resource label: Aquaponic
var aquaponic_count_label: Label
## Ship detail resource label: Battery
var battery_count_label: Label
## Ship detail resource label: Cyropod
var cryopod_count_label: Label
## Ship detail resource label: Energy Capacity
var energy_capacity_label: Label
## Ship detail resource label: Fishery
var fishery_count_label: Label
## Ship detail resource label: Fusion Generator
var fusion_generator_count_label: Label
## Ship detail resource label: Hydroponic
var hydroponic_count_label: Label
## Ship detail resource label: Oxygen Generator
var oxygen_generator_count_label: Label
## Ship detail resource label: Space available
var space_count_label: Label
## Timer to delay between data updates
var update_timer: Timer
## Ship detail resource label: Water Generator
var water_generator_count_label: Label

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Configure update timer
func configure_timer() -> void:
	self.update_timer = Timer.new()
	self.update_timer.name = "Ship Update Timer"
	add_child(self.update_timer)
	self.update_timer.autostart = true
	self.update_timer.one_shot = false
	self.update_timer.paused = false
	self.update_timer.wait_time = self.UPDATE_INTERVAL
	self.update_timer.start()
	self.update_timer.timeout.connect(self.update_ship_details)

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	visibility_changed.connect(self.handle_visibility_change)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	# Details
	self.battery_count_label = get_node("%BatteryCountLabel")
	self.cryopod_count_label = get_node("%CryoCountLabel")
	self.energy_capacity_label = get_node("%EnergyCapacityCountLabel")
	self.space_count_label = get_node("%SpaceCountLabel")

	# Generators
	self.fusion_generator_count_label = get_node("%FusionGenCountLabel")
	self.oxygen_generator_count_label = get_node("%OxygenGenCountLabel")
	self.water_generator_count_label = get_node("%WaterGenCountLabel")

	# Workstations
	self.aquaponic_count_label = get_node("%AquaponicCountLabel")
	self.fishery_count_label = get_node("%FisheryCountLabel")
	self.hydroponic_count_label = get_node("%HydroponicCountLabel")

	return

## Handle visibility changes
func handle_visibility_change() -> void:
	self.update_timer.paused = !visible

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.configure_timer()
	self.update_ship_details()

	return

## Update details related to the ship
func update_ship_details() -> void:
	# Details
	self.battery_count_label.text = str(Inventory.battery)
	self.cryopod_count_label.text = str(Inventory.cryopod)
	self.energy_capacity_label.text = str(Inventory.energy_capacity)
	self.space_count_label.text = str(Inventory.space_available)

	# Generators
	self.fusion_generator_count_label.text = str(Inventory.fusion_generator)
	self.oxygen_generator_count_label.text = str(Inventory.oxygen_generator)
	self.water_generator_count_label.text = str(Inventory.water_generator)

	# Workstations
	self.aquaponic_count_label.text = str(Inventory.count_aquaponic())
	self.fishery_count_label.text = str(Inventory.fishery)
	self.hydroponic_count_label.text = str(Inventory.hydroponic)

	Log.silly("Ship detail list updated")

	return
