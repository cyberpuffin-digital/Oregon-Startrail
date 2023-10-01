extends ScrollContainer
## Rate of conversion data display

## Interval between resource data updates
const UPDATE_INTERVAL: float = 2.0

# Rate label: Air
var air_rate_label: Label
# Rate label: Energy
var energy_rate_label: Label
# Rate label: Fish
var fish_rate_label: Label
# Rate label: Food
var food_rate_label: Label
# Rate label: Fuel
var fuel_rate_label: Label
# Rate label: Plant
var plant_rate_label: Label
# Rate label: Repair
var repair_rate_label: Label
# Rate label: Waste
var waste_rate_label: Label
# Rate label: Water
var water_rate_label: Label
## Timer to delay between data updates
var update_timer: Timer
# Rate label: Work
var work_rate_label: Label

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Configure update timer
func configure_timer() -> void:
	self.update_timer = Timer.new()
	self.update_timer.name = "Rate Update Timer"
	add_child(self.update_timer)
	self.update_timer.autostart = true
	self.update_timer.one_shot = false
	self.update_timer.paused = false
	self.update_timer.wait_time = self.UPDATE_INTERVAL
	self.update_timer.start()
	self.update_timer.timeout.connect(self.update_rates)

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	visibility_changed.connect(self.handle_visibility_change)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.air_rate_label = get_node("%AirRateLabel")
	self.energy_rate_label = get_node("%EnergyRateLabel")
	self.fish_rate_label = get_node("%FishRateLabel")
	self.food_rate_label = get_node("%FoodRateLabel")
	self.fuel_rate_label = get_node("%FuelRateLabel")
	self.plant_rate_label = get_node("%PlantRateLabel")
	self.repair_rate_label = get_node("%RepairRateLabel")
	self.waste_rate_label = get_node("%WasteRateLabel")
	self.water_rate_label = get_node("%WaterRateLabel")
	self.work_rate_label = get_node("%WorkRateLabel")

	return

## Handle visibility changes
func handle_visibility_change() -> void:
	self.update_timer.paused = !visible

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.configure_timer()

	return

## Update resource list from Controller
func update_rates() -> void:
	self.air_rate_label.text = str(Controller.calculate_air_rate(1.0))
	self.energy_rate_label.text = str(Controller.calculate_energy_rate(1.0))
	self.fish_rate_label.text = str(Controller.calculate_fish_rate(1.0))
	self.food_rate_label.text = str(Controller.calculate_food_rate(1.0))
	self.fuel_rate_label.text = str(Controller.calculate_fuel_rate(1.0))
	self.plant_rate_label.text = str(Controller.calculate_plant_rate(1.0))
	self.repair_rate_label.text = str(Controller.calculate_repair_rate(1.0))
	self.waste_rate_label.text = str(Controller.calculate_waste_rate(1.0))
	self.water_rate_label.text = str(Controller.calculate_water_rate(1.0))
	self.work_rate_label.text = str(Controller.calculate_work_rate(1.0))

	Log.silly("Rates list updated")

	return
