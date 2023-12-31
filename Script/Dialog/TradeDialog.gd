extends ConfirmationDialog
## Resource trader

const Market = preload("res://Script/Data/Market.gd")

## Air owned
var air_owned_spin_box: SpinBox
## Air available for trade
var air_available_spin_box: SpinBox
## Tracker to determine if a trade can happen
var can_trade: bool
## Staging area for current trade
var current_trade: Dictionary
## Energy owned
var energy_owned_spin_box: SpinBox
## Energy available for trade
var energy_available_spin_box: SpinBox
## Fish owned
var fish_owned_spin_box: SpinBox
## Fish available for trade
var fish_available_spin_box: SpinBox
## Food owned
var food_owned_spin_box: SpinBox
## Food available for trade
var food_available_spin_box: SpinBox
## Fuel owned
var fuel_owned_spin_box: SpinBox
## Fuel available for trade
var fuel_available_spin_box: SpinBox
## Market data
var market: Market
## Money owned
var money_owned_spin_box: SpinBox
## Money available for trade
var money_available_spin_box: SpinBox
## Plant owned
var plant_owned_spin_box: SpinBox
## Plant available for trade
var plant_available_spin_box: SpinBox
## Space available
var space_available_spin_box: SpinBox
## Space used
var space_used_spin_box: SpinBox
## Spare_part owned
var spare_part_owned_spin_box: SpinBox
## Spare_part available for trade
var spare_part_available_spin_box: SpinBox
## Waste owned
var waste_owned_spin_box: SpinBox
## Waste available for trade
var waste_available_spin_box: SpinBox
## Water owned
var water_owned_spin_box: SpinBox
## Water available for trade
var water_available_spin_box: SpinBox

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Check if trade can proceed
func complete_trade() -> void:
	if self.can_trade:
		Inventory.air = self.air_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Air] = self.air_available_spin_box.value
		Inventory.energy = self.energy_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Energy] = self.energy_available_spin_box.value
		Inventory.fish = self.fish_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Fish] = self.fish_available_spin_box.value
		Inventory.food = self.food_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Food] = self.food_available_spin_box.value
		Inventory.fuel = self.fuel_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Fuel] = self.fuel_available_spin_box.value
		Inventory.money -= self.current_trade[Inventory.TrackedResources.Money]
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Money] = self.money_available_spin_box.value
		Inventory.plant = self.plant_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Plant] = self.plant_available_spin_box.value
		Inventory.spare_part = self.spare_part_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.SparePart] = self.spare_part_available_spin_box.value
		Inventory.waste = self.waste_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Waste] = self.waste_available_spin_box.value
		Inventory.water = self.water_owned_spin_box.value
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Water] = self.water_available_spin_box.value
	else:
		Log.error("Unable to trade")

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	about_to_popup.connect(self.update_inventory)
	get_ok_button().pressed.connect(self.complete_trade)

	self.air_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Air)
	)
	self.energy_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Energy)
	)
	self.fish_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Fish)
	)
	self.food_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Food)
	)
	self.fuel_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Fuel)
	)
	self.money_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Money)
	)
	self.plant_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Plant)
	)
	self.spare_part_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.SparePart)
	)
	self.waste_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Waste)
	)
	self.water_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.TrackedResources.Water)
	)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.air_owned_spin_box = get_node("%AirOwnedSpinBox")
	self.air_available_spin_box = get_node("%AirAvailableSpinBox")
	self.energy_owned_spin_box = get_node("%EnergyOwnedSpinBox")
	self.energy_available_spin_box = get_node("%EnergyAvailableSpinBox")
	self.fish_owned_spin_box = get_node("%FishOwnedSpinBox")
	self.fish_available_spin_box = get_node("%FishAvailableSpinBox")
	self.food_owned_spin_box = get_node("%FoodOwnedSpinBox")
	self.food_available_spin_box = get_node("%FoodAvailableSpinBox")
	self.fuel_owned_spin_box = get_node("%FuelOwnedSpinBox")
	self.fuel_available_spin_box = get_node("%FuelAvailableSpinBox")
	self.money_owned_spin_box = get_node("%MoneyOwnedSpinBox")
	self.money_available_spin_box = get_node("%MoneyAvailableSpinBox")
	self.plant_owned_spin_box = get_node("%PlantOwnedSpinBox")
	self.plant_available_spin_box = get_node("%PlantAvailableSpinBox")
	self.space_available_spin_box = get_node("%SpaceAvailableSpinBox")
	self.space_used_spin_box = get_node("%SpaceUsedSpinBox")
	self.spare_part_owned_spin_box = get_node("%SparePartOwnedSpinBox")
	self.spare_part_available_spin_box = get_node("%SparePartAvailableSpinBox")
	self.waste_owned_spin_box = get_node("%WasteOwnedSpinBox")
	self.waste_available_spin_box = get_node("%WasteAvailableSpinBox")
	self.water_owned_spin_box = get_node("%WaterOwnedSpinBox")
	self.water_available_spin_box = get_node("%WaterAvailableSpinBox")

	return

## Reset current trade staging area
func reset_current_trade() -> void:
	self.current_trade = {
		Inventory.TrackedResources.Air: 0,
		Inventory.TrackedResources.Energy: 0,
		Inventory.TrackedResources.Fish: 0,
		Inventory.TrackedResources.Food: 0,
		Inventory.TrackedResources.Fuel: 0,
		Inventory.TrackedResources.Money: 0,
		Inventory.TrackedResources.Plant: 0,
		Inventory.TrackedResources.Space: 0,
		Inventory.TrackedResources.SparePart: 0,
		Inventory.TrackedResources.Waste: 0,
		Inventory.TrackedResources.Water: 0,
	}

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.market = Market.new()
	self.market.name = "Market"
	add_child(self.market)
	self.market.reset()

	return

## Handle initial trade calculations
func trade_resource(value: float, item: int) -> void:
	if value > self.market.inventory[Controller.current_waypoint][item]:
		value = self.market.inventory[Controller.current_waypoint][item]

	var change: float = value - self.current_trade[item]

	self.current_trade[item] = value
	self.current_trade[Inventory.TrackedResources.Money] += change * Inventory.base_cost[item]
	self.current_trade[Inventory.TrackedResources.Space] += change * Inventory.space_use[item]
	self.money_owned_spin_box.set_value_no_signal(Inventory.money - self.current_trade[Inventory.TrackedResources.Money])
	self.money_available_spin_box.set_value_no_signal(self.money_available_spin_box.value + self.current_trade[Inventory.TrackedResources.Money])

	match item:
		Inventory.TrackedResources.Air:
			self.air_owned_spin_box.set_value_no_signal(value)
			self.air_available_spin_box.set_value_no_signal(self.air_available_spin_box.value - change)
		Inventory.TrackedResources.Energy:
			self.energy_owned_spin_box.set_value_no_signal(value)
			self.energy_available_spin_box.set_value_no_signal(self.energy_available_spin_box.value - change)
		Inventory.TrackedResources.Fish:
			self.fish_owned_spin_box.set_value_no_signal(value)
			self.fish_available_spin_box.set_value_no_signal(self.fish_available_spin_box.value - change)
		Inventory.TrackedResources.Food:
			self.food_owned_spin_box.set_value_no_signal(value)
			self.food_available_spin_box.set_value_no_signal(self.food_available_spin_box.value - change)
		Inventory.TrackedResources.Fuel:
			self.fuel_owned_spin_box.set_value_no_signal(value)
			self.fuel_available_spin_box.set_value_no_signal(self.fuel_available_spin_box.value - change)
		Inventory.TrackedResources.Plant:
			self.plant_owned_spin_box.set_value_no_signal(value)
			self.plant_available_spin_box.set_value_no_signal(self.plant_available_spin_box.value - change)
		Inventory.TrackedResources.SparePart:
			self.spare_part_owned_spin_box.set_value_no_signal(value)
			self.spare_part_available_spin_box.set_value_no_signal(self.spare_part_available_spin_box.value - change)
		Inventory.TrackedResources.Waste:
			self.waste_owned_spin_box.set_value_no_signal(value)
			self.waste_available_spin_box.set_value_no_signal(self.waste_available_spin_box.value - change)
		Inventory.TrackedResources.Water:
			self.water_owned_spin_box.set_value_no_signal(value)
			self.water_available_spin_box.set_value_no_signal(self.water_available_spin_box.value - change)
		_:
			Log.error("Unknown trade resource: %s" % [item])

	if Inventory.space_available >= self.current_trade[Inventory.TrackedResources.Space] and \
	self.current_trade[Inventory.TrackedResources.Money] <= Inventory.money:
		self.can_trade = true
	else:
		self.can_trade = false

	return

## Update trade interface with current inventory
func update_inventory() -> void:
	self.reset_current_trade()
	Inventory.calculate_space()
	self.update_inventory_player()
	self.update_inventory_waypoint()

	Log.debug("Inventory updated")

	return

## Update inventory spin boxes with player inventory
func update_inventory_player() -> void:
	self.air_owned_spin_box.set_value_no_signal(Inventory.air)
	self.energy_owned_spin_box.set_value_no_signal(Inventory.energy)
	self.fish_owned_spin_box.set_value_no_signal(Inventory.fish)
	self.food_owned_spin_box.set_value_no_signal(Inventory.food)
	self.fuel_owned_spin_box.set_value_no_signal(Inventory.fuel)
	self.money_owned_spin_box.set_value_no_signal(Inventory.money)
	self.plant_owned_spin_box.set_value_no_signal(Inventory.plant)
	self.space_available_spin_box.set_value_no_signal(Inventory.space_available)
	self.space_used_spin_box.set_value_no_signal(
		Inventory.starting_values[Inventory.TrackedResources.Space] - \
		Inventory.space_available
	)
	self.spare_part_owned_spin_box.set_value_no_signal(Inventory.spare_part)
	self.waste_owned_spin_box.set_value_no_signal(Inventory.waste)
	self.water_owned_spin_box.set_value_no_signal(Inventory.water)

	return

## Update inventory spin boxes with waypoint inventory
func update_inventory_waypoint() -> void:
	self.air_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Air]
	)
	self.energy_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Energy]
	)
	self.fish_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Fish]
	)
	self.food_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Food]
	)
	self.fuel_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Fuel]
	)
	self.money_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Money]
	)
	self.plant_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Plant]
	)
	self.spare_part_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.SparePart]
	)
	self.waste_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Waste]
	)
	self.water_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.TrackedResources.Water]
	)

	return
