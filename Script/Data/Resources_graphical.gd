extends ScrollContainer
## Graphical Resource dashboard

const COLOR_CRITICAL: Color = Color.DARK_RED
const COLOR_WARN: Color = Color.DARK_ORANGE
const COLOR_OK: Color = Color.DARK_GREEN

## Resource update frequency in seconds
const UPDATE_FREQ: float = 1

## Inventory indicator: Air
var air_panel: Panel
## Current inventory value: Air
var air_progress: ProgressBar
## Inventory status: Air
var air_status: Label
## Inventory indicator: bot
var bot_progress: ProgressBar
## Inventory status: bot
var bot_status: Label
## Inventory indicator: Energy
var energy_panel: Panel
## Current inventory value: Energy
var energy_progress: ProgressBar
## Inventory status: Energy
var energy_status: Label
## Inventory indicator: Fish
var fish_progress: ProgressBar
## Inventory status: Fish
var fish_status: Label
## Inventory indicator: Food
var food_panel: Panel
## Current inventory value: Food
var food_progress: ProgressBar
## Inventory status: Food
var food_status: Label
## Inventory indicator: Fuel
var fuel_panel: Panel
## Current inventory value: Fuel
var fuel_progress: ProgressBar
## Inventory status: Fuel
var fuel_status: Label
## Inventory indicator: Human
var human_progress: ProgressBar
## Inventory status: Human
var human_status: Label
## Inventory indicator: Money
var money_panel: Panel
## Current inventory value: Money
var money_progress: ProgressBar
## Inventory status: Money
var money_status: Label
## Inventory indicator: Plant
var plant_progress: ProgressBar
## Inventory status: Plant
var plant_status: Label
## Inventory indicator: Spare Parts
var spare_parts_panel: Panel
## Current inventory value: Spare Parts
var spare_parts_progress: ProgressBar
## Inventory status: Spare Parts
var spare_parts_status: Label
## Update resource display on interval
var update_timer: Timer
## Inventory indicator: Waste
var waste_panel: Panel
## Current inventory value: Waste
var waste_progress: ProgressBar
## Inventory status: Waste
var waste_status: Label
## Inventory indicator: Water
var water_panel: Panel
## Current inventory value: Water
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
	Inventory.resource_added.connect(self.update_resource)
	Inventory.resource_consumed.connect(self.update_resource)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.air_panel = get_node("%AirPanel")
	self.air_progress = get_node("%AirProgressBar")
	self.air_status = get_node("%AirStatusLabel")
	self.bot_progress = get_node("%BotProgressBar")
	self.bot_status = get_node("%BotStatusLabel")
	self.energy_panel = get_node("%EnergyPanel")
	self.energy_progress = get_node("%EnergyProgressBar")
	self.energy_status = get_node("%EnergyStatusLabel")
	self.fish_progress = get_node("%FishProgressBar")
	self.fish_status = get_node("%FishStatusLabel")
	self.food_panel = get_node("%FoodPanel")
	self.food_progress = get_node("%FoodProgressBar")
	self.food_status = get_node("%FoodStatusLabel")
	self.fuel_panel = get_node("%FuelPanel")
	self.fuel_progress = get_node("%FuelProgressBar")
	self.fuel_status = get_node("%FuelStatusLabel")
	self.human_progress = get_node("%HumanProgressBar")
	self.human_status = get_node("%HumanStatusLabel")
	self.money_panel = get_node("%MoneyPanel")
	self.money_progress = get_node("%MoneyProgressBar")
	self.money_status = get_node("%MoneyStatusLabel")
	self.plant_progress = get_node("%PlantProgressBar")
	self.plant_status = get_node("%PlantStatusLabel")
	self.spare_parts_panel = get_node("%SparePartsPanel")
	self.spare_parts_progress = get_node("%SparePartsProgressBar")
	self.spare_parts_status = get_node("%SparePartsStatusLabel")
	self.waste_panel = get_node("%WastePanel")
	self.waste_progress = get_node("%WasteProgressBar")
	self.waste_status = get_node("%WasteStatusLabel")
	self.water_panel = get_node("%WaterPanel")
	self.water_progress = get_node("%WaterProgressBar")
	self.water_status = get_node("%WaterStatusLabel")

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.update_all_resources()

	return

func update_all_resources() -> void:
	for resource in [
		Inventory.Type.Air, Inventory.Type.Energy,
		Inventory.Type.Food, Inventory.Type.Fuel,
		Inventory.Type.Money, Inventory.Type.SparePart,
		Inventory.Type.Waste, Inventory.Type.Water
	]:
		self.update_resource(resource, 0)

	return

func update_resource(resource: int, _quantity: float) -> void:
	var indicator_panel: Panel
	var rate: float = 0
	var status: int = 0
	var status_label: Label

	match resource:
		Inventory.Type.Air:
			indicator_panel = self.air_panel
			status_label = self.air_status
			rate = abs(Inventory.calculate_air_rate(5))
			if Inventory.air < rate:
				status = 2
			elif Inventory.air < rate * 2:
				status = 1
			else:
				status = 0
			self.air_progress.set_value(floori(Inventory.air / (rate * 3)))
		Inventory.Type.Energy:
			indicator_panel = self.energy_panel
			status_label = self.energy_status
			rate = abs(Inventory.calculate_energy_rate(5))
			if Inventory.energy < rate:
				status = 2
			elif Inventory.energy < rate * 2:
				status = 1
			else:
				status = 0
			self.energy_progress.set_value(floori(Inventory.energy / rate * 3))
		Inventory.Type.Food:
			indicator_panel = self.food_panel
			status_label = self.food_status
			rate = abs(Inventory.calculate_food_rate(5))
			if Inventory.food < rate:
				status = 2
			elif Inventory.food < rate * 2:
				status = 1
			else:
				status = 0
			self.food_progress.set_value(floori(Inventory.food / rate * 3))
		Inventory.Type.Fuel:
			indicator_panel = self.fuel_panel
			status_label = self.fuel_status
			rate = abs(Inventory.calculate_fuel_rate(5))
			if Inventory.fuel < rate:
				status = 2
			elif Inventory.fuel < rate * 2:
				status = 1
			else:
				status = 0
			self.fuel_progress.set_value(floori(Inventory.fuel / rate * 3))
		Inventory.Type.Money:
			indicator_panel = self.money_panel
			status_label = self.money_status
			if Inventory.money <= 0:
				status = 2
			elif Inventory.money <= 75:
				status = 1
			else:
				status = 0
			self.money_progress.set_value(floori(Inventory.money))
		Inventory.Type.SparePart:
			indicator_panel = self.spare_parts_panel
			status_label = self.spare_parts_status
			if Inventory.spare_part <= 0:
				status = 2
			elif Inventory.spare_part <= 5:
				status = 1
			else:
				status = 0
			self.spare_parts_progress.set_value(floori(Inventory.spare_part * 15))
		Inventory.Type.Water:
			indicator_panel = self.water_panel
			status_label = self.water_status
			rate = abs(Inventory.calculate_water_rate(5))
			if Inventory.water < rate:
				status = 2
			elif Inventory.water < rate * 2:
				status = 1
			else:
				status = 0
			self.water_progress.set_value(floori(Inventory.water / rate * 3))
		Inventory.Type.Waste:
			indicator_panel = self.waste_panel
			status_label = self.waste_status
			rate = abs(Inventory.calculate_waste_rate(5))
			if Inventory.waste > rate:
				status = 2
			elif Inventory.waste > rate * 2:
				status = 1
			else:
				status = 0
			self.waste_progress.set_value(floori(Inventory.waste / rate * 3))

	if !indicator_panel or !status_label:
		return

	match status:
		0:
			indicator_panel.set_modulate(self.COLOR_OK)
			status_label.set_text(tr("OK"))
		1:
			indicator_panel.set_modulate(self.COLOR_WARN)
			status_label.set_text(tr("WARNING"))
		2:
			indicator_panel.set_modulate(self.COLOR_CRITICAL)
			status_label.set_text(tr("CRITICAL"))

	return
