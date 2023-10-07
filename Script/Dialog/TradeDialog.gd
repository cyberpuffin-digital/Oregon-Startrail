extends ConfirmationDialog
## Resource trader

const Market = preload("res://Script/Data/Market.gd")

## Air owned
var air_owned_spin_box: SpinBox
## Air available for trade
var air_available_label: Label
## Tracker to determine if a trade can happen
var can_trade: bool
## Staging area for current trade
var current_trade: Dictionary
## Energy owned
var energy_owned_spin_box: SpinBox
## Energy available for trade
var energy_available_label: Label
## Fish owned
var fish_owned_spin_box: SpinBox
## Fish available for trade
var fish_available_label: Label
## Food owned
var food_owned_spin_box: SpinBox
## Food available for trade
var food_available_label: Label
## Fuel owned
var fuel_owned_spin_box: SpinBox
## Fuel available for trade
var fuel_available_label: Label
## Market data
var market: Market
## Money owned
var money_owned_spin_box: SpinBox
## Money available for trade
var money_available_spin_box: SpinBox
## Plant owned
var plant_owned_spin_box: SpinBox
## Plant available for trade
var plant_available_label: Label
## Space available
var space_available_spin_box: SpinBox
## Space used
var space_used_spin_box: SpinBox
## Spare_part owned
var spare_part_owned_spin_box: SpinBox
## Spare_part available for trade
var spare_part_available_label: Label
## Waste owned
var waste_owned_spin_box: SpinBox
## Waste available for trade
var waste_available_label: Label
## Water owned
var water_owned_spin_box: SpinBox
## Water available for trade
var water_available_label: Label

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Check if trade can proceed
func complete_trade() -> void:
	if self.can_trade:
		for resource in [
			Inventory.ShipResource.Air, Inventory.ShipResource.Energy,
			Inventory.ShipResource.Fish, Inventory.ShipResource.Food,
			Inventory.ShipResource.Fuel, Inventory.ShipResource.Money,
			Inventory.ShipResource.Plant, Inventory.ShipResource.SparePart,
			Inventory.ShipResource.Waste, Inventory.ShipResource.Water,
		]:
			Inventory.add_resource(resource, self.current_trade[resource])
			self.market.remove_inventory(
				Controller.current_waypoint, resource, self.current_trade[resource]
			)
	else:
		Log.error("Unable to trade")

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	about_to_popup.connect(self.update_inventory)
	get_ok_button().pressed.connect(self.complete_trade)

	self.air_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Air)
	)
	self.energy_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Energy)
	)
	self.fish_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Fish)
	)
	self.food_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Food)
	)
	self.fuel_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Fuel)
	)
	self.money_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Money)
	)
	self.plant_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Plant)
	)
	self.spare_part_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.SparePart)
	)
	self.waste_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Waste)
	)
	self.water_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Water)
	)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.air_owned_spin_box = get_node("%AirOwnedSpinBox")
	self.air_available_label = get_node("%AirAvailableLabel")
	self.energy_owned_spin_box = get_node("%EnergyOwnedSpinBox")
	self.energy_available_label = get_node("%EnergyAvailableLabel")
	self.fish_owned_spin_box = get_node("%FishOwnedSpinBox")
	self.fish_available_label = get_node("%FishAvailableLabel")
	self.food_owned_spin_box = get_node("%FoodOwnedSpinBox")
	self.food_available_label = get_node("%FoodAvailableLabel")
	self.fuel_owned_spin_box = get_node("%FuelOwnedSpinBox")
	self.fuel_available_label = get_node("%FuelAvailableLabel")
	self.money_owned_spin_box = get_node("%MoneyOwnedSpinBox")
	self.money_available_spin_box = get_node("%MoneyAvailableSpinBox")
	self.plant_owned_spin_box = get_node("%PlantOwnedSpinBox")
	self.plant_available_label = get_node("%PlantAvailableLabel")
	self.space_available_spin_box = get_node("%SpaceAvailableSpinBox")
	self.space_used_spin_box = get_node("%SpaceUsedSpinBox")
	self.spare_part_owned_spin_box = get_node("%SparePartOwnedSpinBox")
	self.spare_part_available_label = get_node("%SparePartAvailableLabel")
	self.waste_owned_spin_box = get_node("%WasteOwnedSpinBox")
	self.waste_available_label = get_node("%WasteAvailableLabel")
	self.water_owned_spin_box = get_node("%WaterOwnedSpinBox")
	self.water_available_label = get_node("%WaterAvailableLabel")

	return

## Reset current trade staging area
func reset_current_trade() -> void:
	self.current_trade = {
		Inventory.ShipResource.Air: 0,
		Inventory.ShipResource.Energy: 0,
		Inventory.ShipResource.Fish: 0,
		Inventory.ShipResource.Food: 0,
		Inventory.ShipResource.Fuel: 0,
		Inventory.ShipResource.Money: 0,
		Inventory.ShipResource.Plant: 0,
		Inventory.ShipResource.Space: 0,
		Inventory.ShipResource.SparePart: 0,
		Inventory.ShipResource.Waste: 0,
		Inventory.ShipResource.Water: 0,
	}

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.market = Market.new()
	self.market.name = "Market"
	add_child(self.market)
	self.market.reset()

	return

## Callback handler for spin box changes on tradeable resources[br]
## [b]Input[/b]:[br]
##   value (float): New value of calling spinbox
##   item (int): Inventory.ShipResource to trade
func trade_resource(value: float, item: int) -> void:
	var change: float = 0

	match item:
		Inventory.ShipResource.Air:
			change = value - Inventory.air
		Inventory.ShipResource.Energy:
			change = value - Inventory.energy
		Inventory.ShipResource.Fish:
			change = value - Inventory.fish
		Inventory.ShipResource.Food:
			change = value - Inventory.food
		Inventory.ShipResource.Fuel:
			change = value - Inventory.fuel
		Inventory.ShipResource.Plant:
			change = value - Inventory.plant
		Inventory.ShipResource.SparePart:
			change = value - Inventory.spare_part
		Inventory.ShipResource.Waste:
			change = value - Inventory.waste
		Inventory.ShipResource.Water:
			change = value - Inventory.water
		_:
			Log.error("Unknown trade resource: %s" % [item])
			return

	if change > self.market.inventory[Controller.current_waypoint][item]:
		change = self.market.inventory[Controller.current_waypoint][item]

	self.current_trade[Inventory.ShipResource.Money] -= self.current_trade[item] * self.market.base_cost[item]
	self.current_trade[Inventory.ShipResource.Space] -= self.current_trade[item] * Inventory.required_space[item]

	self.current_trade[item] = change

	self.current_trade[Inventory.ShipResource.Money] += change * self.market.base_cost[item]
	self.current_trade[Inventory.ShipResource.Space] += change * Inventory.required_space[item]

	self.money_owned_spin_box.set_value_no_signal(Inventory.money - self.current_trade[Inventory.ShipResource.Money])
	self.money_available_spin_box.set_value_no_signal(self.money_available_spin_box.value + self.current_trade[Inventory.ShipResource.Money])

	match item:
		Inventory.ShipResource.Air:
			self.air_owned_spin_box.set_value_no_signal(Inventory.air + change)
			self.air_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Air] - change
			))
		Inventory.ShipResource.Energy:
			self.energy_owned_spin_box.set_value_no_signal(Inventory.energy + change)
			self.energy_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Energy] - change
			))
		Inventory.ShipResource.Fish:
			self.fish_owned_spin_box.set_value_no_signal(Inventory.fish + change)
			self.fish_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fish] - change
			))
		Inventory.ShipResource.Food:
			self.food_owned_spin_box.set_value_no_signal(Inventory.food + change)
			self.food_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Food] - change
			))
		Inventory.ShipResource.Fuel:
			self.fuel_owned_spin_box.set_value_no_signal(Inventory.fuel + change)
			self.fuel_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fuel] - change
			))
		Inventory.ShipResource.Plant:
			self.plant_owned_spin_box.set_value_no_signal(Inventory.plant + change)
			self.plant_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Plant] - change
			))
		Inventory.ShipResource.SparePart:
			self.spare_part_owned_spin_box.set_value_no_signal(Inventory.spare_part + change)
			self.spare_part_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.SparePart] - change
			))
		Inventory.ShipResource.Waste:
			self.waste_owned_spin_box.set_value_no_signal(Inventory.waste + change)
			self.waste_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Waste] - change
			))
		Inventory.ShipResource.Water:
			self.water_owned_spin_box.set_value_no_signal(Inventory.water + change)
			self.water_available_label.set_text(str(
				self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Water] - change
			))
		_:
			Log.error("Unknown trade resource: %s" % [item])

	if Inventory.space_available >= self.current_trade[Inventory.ShipResource.Space] and \
	self.current_trade[Inventory.ShipResource.Money] <= Inventory.money:
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
		Inventory.starting_values[Inventory.ShipResource.Space] - \
		Inventory.space_available
	)
	self.spare_part_owned_spin_box.set_value_no_signal(Inventory.spare_part)
	self.waste_owned_spin_box.set_value_no_signal(Inventory.waste)
	self.water_owned_spin_box.set_value_no_signal(Inventory.water)

	return

## Update inventory spin boxes with waypoint inventory
func update_inventory_waypoint() -> void:
	self.air_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Air])
	)
	self.energy_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Energy])
	)
	self.fish_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fish])
	)
	self.food_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Food])
	)
	self.fuel_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fuel])
	)
	self.money_available_spin_box.set_value_no_signal(
		self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money]
	)
	self.plant_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Plant])
	)
	self.spare_part_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.SparePart])
	)
	self.waste_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Waste])
	)
	self.water_available_label.set_text(
		str(self.market.inventory[Controller.current_waypoint][Inventory.ShipResource.Water])
	)

	return
