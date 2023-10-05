extends ScrollContainer
## Graphical Resource dashboard

## Resource update frequency
const UPDATE_FREQ: float = 1.5

## Inventory indicator: Air
var air_progress: ProgressBar
## Inventory status: Air
var air_status: Label
## Inventory indicator: bot
var bot_progress: ProgressBar
## Inventory status: bot
var bot_status: Label
## Inventory indicator: Energy
var energy_progress: ProgressBar
## Inventory status: Energy
var energy_status: Label
## Inventory indicator: Fish
var fish_progress: ProgressBar
## Inventory status: Fish
var fish_status: Label
## Inventory indicator: Food
var food_progress: ProgressBar
## Inventory status: Food
var food_status: Label
## Inventory indicator: Fuel
var fuel_progress: ProgressBar
## Inventory status: Fuel
var fuel_status: Label
## Inventory indicator: Human
var human_progress: ProgressBar
## Inventory status: Human
var human_status: Label
## Inventory indicator: Money
var money_progress: ProgressBar
## Inventory status: Money
var money_status: Label
## Inventory indicator: Plant
var plant_progress: ProgressBar
## Inventory status: Plant
var plant_status: Label
## Inventory indicator: Spare Parts
var spare_parts_progress: ProgressBar
## Inventory status: Spare Parts
var spare_parts_status: Label
## Update resource display on interval
var update_timer: Timer
## Inventory indicator: Waste
var waste_progress: ProgressBar
## Inventory status: Waste
var waste_status: Label
## Inventory indicator: Water
var water_progress: ProgressBar
## Inventory status: Water
var water_status: Label

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.air_progress = get_node("%AirProgressBar")
	self.air_status = get_node("%AirStatusLabel")
	self.bot_progress = get_node("%BotProgressBar")
	self.bot_status = get_node("%BotStatusLabel")
	self.energy_progress = get_node("%EnergyProgressBar")
	self.energy_status = get_node("%EnergyStatusLabel")
	self.fish_progress = get_node("%FishProgressBar")
	self.fish_status = get_node("%FishStatusLabel")
	self.food_progress = get_node("%FoodProgressBar")
	self.food_status = get_node("%FoodStatusLabel")
	self.fuel_progress = get_node("%FuelProgressBar")
	self.fuel_status = get_node("%FuelStatusLabel")
	self.human_progress = get_node("%HumanProgressBar")
	self.human_status = get_node("%HumanStatusLabel")
	self.money_progress = get_node("%MoneyProgressBar")
	self.money_status = get_node("%MoneyStatusLabel")
	self.plant_progress = get_node("%PlantProgressBar")
	self.plant_status = get_node("%PlantStatusLabel")
	self.spare_parts_progress = get_node("%SparePartsProgressBar")
	self.spare_parts_status = get_node("%SparePartsStatusLabel")
	self.waste_progress = get_node("%WasteProgressBar")
	self.waste_status = get_node("%WasteStatusLabel")
	self.water_progress = get_node("%WaterProgressBar")
	self.water_status = get_node("%WaterStatusLabel")

	return

## Set initial state for children in the scene
func set_the_children() -> void:

	return

