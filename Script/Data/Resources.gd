extends ScrollContainer
## Resource data display

## Interval between resource data updates
const UPDATE_INTERVAL: float = 2.0

## Consumable count label: Air
var air_count_label: Label
## Bot count label
var bot_count_label: Label
## Consumable count label: Energy
var energy_count_label: Label
## Fish count label
var fish_count_label: Label
## Consumable count label: Food
var food_count_label: Label
## Consumable count label: Fuel
var fuel_count_label: Label
## Human count label
var human_count_label: Label
## Consumable count label: Money
var money_count_label: Label
## Plant count label
var plant_count_label: Label
## Consumable count label: Spare Parts
var spare_part_count_label: Label
## Timer to delay between data updates
var update_timer: Timer
## Consumable count label: Waste
var waste_count_label: Label
## Consumable count label: Water
var water_count_label: Label


func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Configure update timer
func configure_timer() -> void:
	self.update_timer = Timer.new()
	self.update_timer.name = "Resource Update Timer"
	add_child(self.update_timer)
	self.update_timer.autostart = true
	self.update_timer.one_shot = false
	self.update_timer.paused = false
	self.update_timer.wait_time = self.UPDATE_INTERVAL
	self.update_timer.start()
	self.update_timer.timeout.connect(self.update_resource_list)

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	visibility_changed.connect(self.handle_visibility_change)
	Controller.out_of_air.connect(self.update_resource_list)
	Controller.out_of_energy.connect(self.update_resource_list)
	Controller.out_of_food.connect(self.update_resource_list)
	Controller.out_of_fuel.connect(self.update_resource_list)
	Controller.out_of_human.connect(self.update_resource_list)
	Controller.out_of_water.connect(self.update_resource_list)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	# Active
	self.bot_count_label = get_node("%BotCountLabel")
	self.fish_count_label = get_node("%FishCountLabel")
	self.human_count_label = get_node("%HumanCountLabel")
	self.plant_count_label = get_node("%PlantCountLabel")

	# Consumables
	self.air_count_label = get_node("%AirCountLabel")
	self.energy_count_label = get_node("%EnergyCountLabel")
	self.food_count_label = get_node("%FoodCountLabel")
	self.fuel_count_label = get_node("%FuelCountLabel")
	self.money_count_label = get_node("%MoneyCountLabel")
	self.spare_part_count_label = get_node("%SparePartsCountLabel")
	self.waste_count_label = get_node("%WasteCountLabel")
	self.water_count_label = get_node("%WaterCountLabel")

	return

## Handle visibility changes
func handle_visibility_change() -> void:
	self.update_timer.paused = !visible

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.configure_timer()
	self.update_resource_list()

	return

## Update resource list from Controller
func update_resource_list() -> void:
	# Active
	self.bot_count_label.text = str(Inventory.bot)
	self.fish_count_label.text = str(Inventory.fish)
	self.human_count_label.text = str(Inventory.human)
	self.plant_count_label.text = str(Inventory.plant)

	# Consumables
	self.air_count_label.text = str(Inventory.air)
	self.energy_count_label.text = str(Inventory.energy)
	self.food_count_label.text = str(Inventory.food)
	self.fuel_count_label.text = str(Inventory.fuel)
	self.money_count_label.text = str(Inventory.money)
	self.spare_part_count_label.text = str(Inventory.spare_part)
	self.waste_count_label.text = str(Inventory.waste)
	self.water_count_label.text = str(Inventory.water)

	Log.silly("Resource list updated")

	return
