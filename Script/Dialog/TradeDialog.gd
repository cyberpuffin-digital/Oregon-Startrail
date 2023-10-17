extends ConfirmationDialog
## Resource trader

const WarningColor = Color(1, 0, 0, 0.5)

## Air available for trade
var air_available_label: Label
## Cost of air at waypoint
var air_cost_label: Label
## Air buy arrow
var air_left_arrow: TextureButton
## Air owned
var air_owned_spin_box: SpinBox
## Air sell arrow
var air_right_arrow: TextureButton
## Tracker to determine if a trade can happen
var can_trade: bool
## Staging area for current trade
var current_trade: Dictionary
## Resource description
var description: LineEdit
## Energy available for trade
var energy_available_label: Label
## Cost of energy at waypoint
var energy_cost_label: Label
## Energy buy arrow
var energy_left_arrow: TextureButton
## Energy owned
var energy_owned_spin_box: SpinBox
## Energy sell arrow
var energy_right_arrow: TextureButton
## Fish available for trade
var fish_available_label: Label
## Cost of fish at waypoint
var fish_cost_label: Label
## Fish buy arrow
var fish_left_arrow: TextureButton
## Fish owned
var fish_owned_spin_box: SpinBox
## Fish sell arrow
var fish_right_arrow: TextureButton
## Food available for trade
var food_available_label: Label
## Cost of food at waypoint
var food_cost_label: Label
## Food buy arrow
var food_left_arrow: TextureButton
## Food owned
var food_owned_spin_box: SpinBox
## Food sell arrow
var food_right_arrow: TextureButton
## Fuel available for trade
var fuel_available_label: Label
## Cost of fuel at waypoint
var fuel_cost_label: Label
## Fuel buy arrow
var fuel_left_arrow: TextureButton
## Fuel owned
var fuel_owned_spin_box: SpinBox
## Fuel sell arrow
var fuel_right_arrow: TextureButton
## Money available for trade
var money_available_spin_box: SpinBox
## Warning color for money available
var money_available_warning_rect: ColorRect
## Money owned
var money_owned_spin_box: SpinBox
## Warning color for money owned
var money_owned_warning_rect: ColorRect
## Plant available for trade
var plant_available_label: Label
## Cost of plants at waypoint
var plant_cost_label: Label
## Plant buy arrow
var plant_left_arrow: TextureButton
## Plant owned
var plant_owned_spin_box: SpinBox
## Plant sell arrow
var plant_right_arrow: TextureButton
## Space available
var space_available_spin_box: SpinBox
## Space used
var space_used_spin_box: SpinBox
## Space used visual warning
var space_used_warning_rect: ColorRect
## Spare_part available for trade
var spare_part_available_label: Label
## Cost of spare sparts at waypoint
var spare_part_cost_label: Label
## Spare_part buy arrow
var spare_part_left_arrow: TextureButton
## Spare_part owned
var spare_part_owned_spin_box: SpinBox
## Spare_part sell arrow
var spare_part_right_arrow: TextureButton
## Waste available for trade
var waste_available_label: Label
## Cost of waste at waypoint
var waste_cost_label: Label
## Waste buy arrow
var waste_left_arrow: TextureButton
## Waste owned
var waste_owned_spin_box: SpinBox
## Waste sell arrow
var waste_right_arrow: TextureButton
## Water available for trade
var water_available_label: Label
## Cost of water at waypoint
var water_cost_label: Label
## Water buy arrow
var water_left_arrow: TextureButton
## Water owned
var water_owned_spin_box: SpinBox
## Water sell arrow
var water_right_arrow: TextureButton

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Update current trade in-memory object to reflect incoming change
func adjust_current_trade(quantity: float, item: Inventory.ShipResource) -> void:
	# Remove values of [item] from current_trade
	self.current_trade[Inventory.ShipResource.Money] -= self.current_trade[item] * Market.current_pricing[item]
	self.current_trade[Inventory.ShipResource.Space] -= self.current_trade[item] * Inventory.required_space[item]

	# Update the resource
	self.current_trade[item] = quantity

	# Add values of [item] from current trade
	self.current_trade[Inventory.ShipResource.Money] += quantity * Market.current_pricing[item]
	self.current_trade[Inventory.ShipResource.Space] += quantity * Inventory.required_space[item]

	return

## Adjust values for player and market inventories
func adjust_trade_dialog(quantity: float, item: Inventory.ShipResource) -> void:
	self.adjust_trade_dialog_space()

	# Update trade dialog entries
	match item:
		Inventory.ShipResource.Air:
			self.air_owned_spin_box.set_value_no_signal(Inventory.air + quantity)
			self.air_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Air] - quantity
			))
		Inventory.ShipResource.Energy:
			self.energy_owned_spin_box.set_value_no_signal(Inventory.energy + quantity)
			self.energy_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Energy] - quantity
			))
		Inventory.ShipResource.Fish:
			self.fish_owned_spin_box.set_value_no_signal(Inventory.fish + quantity)
			self.fish_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fish] - quantity
			))
		Inventory.ShipResource.Food:
			self.food_owned_spin_box.set_value_no_signal(Inventory.food + quantity)
			self.food_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Food] - quantity
			))
		Inventory.ShipResource.Fuel:
			self.fuel_owned_spin_box.set_value_no_signal(Inventory.fuel + quantity)
			self.fuel_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fuel] - quantity
			))
		Inventory.ShipResource.Plant:
			self.plant_owned_spin_box.set_value_no_signal(Inventory.plant + quantity)
			self.plant_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Plant] - quantity
			))
		Inventory.ShipResource.SparePart:
			self.spare_part_owned_spin_box.set_value_no_signal(Inventory.spare_part + quantity)
			self.spare_part_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.SparePart] - quantity
			))
		Inventory.ShipResource.Waste:
			self.waste_owned_spin_box.set_value_no_signal(Inventory.waste + quantity)
			self.waste_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Waste] - quantity
			))
		Inventory.ShipResource.Water:
			self.water_owned_spin_box.set_value_no_signal(Inventory.water + quantity)
			self.water_available_label.set_text(str(
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Water] - quantity
			))
		_:
			Log.error("Unknown trade resource: %s" % [item])

	# Set money values
	# Buy
	if self.current_trade[Inventory.ShipResource.Money] > 0:
		# Credit available
		if Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] < 0:
			# Purchase is bigger than credit
			if -Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] <= self.current_trade[Inventory.ShipResource.Money]:
				self.money_owned_spin_box.set_value_no_signal(snappedf(
					Inventory.money - (
						self.current_trade[Inventory.ShipResource.Money] + \
						Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money]
					), 0.01
				))

		self.money_available_spin_box.set_value_no_signal(snappedf(
			Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] + \
			self.current_trade[Inventory.ShipResource.Money], 0.01
		))
	# Sale
	else:
		self.money_available_spin_box.set_value_no_signal(snappedf(
			Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] - \
			self.current_trade[Inventory.ShipResource.Money], 0.01
		))

	if self.money_owned_spin_box.value <= 0:
		self.money_owned_warning_rect.set_color(self.WarningColor)
	else:
		self.money_owned_warning_rect.set_color(Color.TRANSPARENT)

	if self.money_available_spin_box.value <= 0:
		self.money_available_warning_rect.set_color(self.WarningColor)
	else:
		self.money_available_warning_rect.set_color(Color.TRANSPARENT)

	return

## Make adjustments to the trade dialog respective to the space used and available
func adjust_trade_dialog_space() -> void:
	# Set space values
	self.space_available_spin_box.set_value_no_signal(
		Inventory.space_available - self.current_trade[Inventory.ShipResource.Space]
	)
	if Inventory.space_available - self.current_trade[Inventory.ShipResource.Space] < 0:
		self.space_used_warning_rect.set_color(self.WarningColor)
	else:
		self.space_used_warning_rect.set_color(Color.TRANSPARENT)
	self.space_used_spin_box.set_value_no_signal(
		Inventory.starting_values[Inventory.ShipResource.Space] - \
		Inventory.space_available + self.current_trade[Inventory.ShipResource.Space]
	)

	return

## Check if trade can proceed
func check_tradable() -> void:
	if Inventory.space_available < self.current_trade[Inventory.ShipResource.Space]:
		Log.verbose("Cannot trade, space not available.")
		self.can_trade = false
	elif self.current_trade[Inventory.ShipResource.Money] + min(
		# potential trader credit
		0, Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money]
	) > Inventory.money:
		Log.verbose("Cannot trade, not enough money.")
		self.can_trade = false
	else:
		self.can_trade = true

	return

## Calculate the difference from [value] and current inventory of [item]
func calculate_change_from_inventory(value: float, item: Inventory.ShipResource) -> float:
	var change: float = 0

	# Calculate change in resource from current inventory
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

	# Check market has requested amount, fall back to inventory total
	if abs(change) > Market.inventory[Controller.current_waypoint][item]:
		if change < 0:
			change = -Market.inventory[Controller.current_waypoint][item]
		else:
			change = Market.inventory[Controller.current_waypoint][item]

	# TODO: add check to max amount merchant can afford

	return change

## Check if trade can proceed
func complete_trade() -> void:
	if self.can_trade:
		self.complete_trade_resources()
		self.complete_trade_handle_credits()

		# Pay remainder of the bill
		Inventory.add_resource(
			Inventory.ShipResource.Money, -self.current_trade[Inventory.ShipResource.Money]
		)
		Market.remove_inventory(
			Controller.current_waypoint, Inventory.ShipResource.Money,
			-self.current_trade[Inventory.ShipResource.Money]
		)

		# Mark if credit remains
		Controller.trader_credit = Market.has_credit(Controller.current_waypoint)
	else:
		Log.error("Unable to trade")

	return

## Handle credits on player buys
func complete_trade_handle_credits() -> void:
	if self.can_trade:
		# Current trade is a player buy
		if self.current_trade[Inventory.ShipResource.Money] > 0 and \
		# Trader has a credit available
		Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] < 0:
			# If the credit is greater than the value of the current trade
			if -Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] > self.current_trade[Inventory.ShipResource.Money]:
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] += self.current_trade[Inventory.ShipResource.Money]
				self.current_trade[Inventory.ShipResource.Money] = 0
			# else the credit just reduces the bill
			else:
				self.current_trade[Inventory.ShipResource.Money] += Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money]
				Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] = 0

	return

## Move the resource from the staged trade
func complete_trade_resources() -> void:
	if self.can_trade:
		for resource in [
			Inventory.ShipResource.Air, Inventory.ShipResource.Energy,
			Inventory.ShipResource.Fish, Inventory.ShipResource.Food,
			Inventory.ShipResource.Fuel, Inventory.ShipResource.Plant,
			Inventory.ShipResource.SparePart, Inventory.ShipResource.Waste,
			Inventory.ShipResource.Water,
		]:
			Inventory.add_resource(resource, self.current_trade[resource])
			Market.remove_inventory(
				Controller.current_waypoint, resource, self.current_trade[resource]
			)

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	about_to_popup.connect(self.update_inventory)
	get_ok_button().pressed.connect(self.complete_trade)

	self.air_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Air, 10)
	)
	self.air_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Air)
	)
	self.air_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Air)
	)
	self.air_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Air)
	)
	self.air_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Air, -10)
	)
	self.energy_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Energy, 10)
	)
	self.energy_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Energy)
	)
	self.energy_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Energy)
	)
	self.energy_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Energy)
	)
	self.energy_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Energy, -10)
	)
	self.fish_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Fish, 10)
	)
	self.fish_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Fish)
	)
	self.fish_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Fish)
	)
	self.fish_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Fish)
	)
	self.fish_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Fish, -10)
	)
	self.food_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Food, 10)
	)
	self.food_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Food)
	)
	self.food_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Food)
	)
	self.food_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Food)
	)
	self.food_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Food, -10)
	)
	self.fuel_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Fuel, 10)
	)
	self.fuel_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Fuel)
	)
	self.fuel_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Fuel)
	)
	self.fuel_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Fuel)
	)
	self.fuel_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Fuel, -10)
	)
	self.plant_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Plant, 10)
	)
	self.plant_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Plant)
	)
	self.plant_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Plant)
	)
	self.plant_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Plant)
	)
	self.plant_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Plant, -10)
	)
	self.spare_part_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.SparePart, 10)
	)
	self.spare_part_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.SparePart)
	)
	self.spare_part_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.SparePart)
	)
	self.spare_part_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.SparePart)
	)
	self.spare_part_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.SparePart, -10)
	)
	self.waste_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Waste, 10)
	)
	self.waste_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Waste)
	)
	self.waste_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Waste)
	)
	self.waste_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Waste)
	)
	self.waste_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Waste, -10)
	)
	self.water_left_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Water, 10)
	)
	self.water_owned_spin_box.focus_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Water)
	)
	self.water_owned_spin_box.mouse_entered.connect(
		self.set_description.bind(Inventory.ShipResource.Water)
	)
	self.water_owned_spin_box.value_changed.connect(
		self.trade_resource.bind(Inventory.ShipResource.Water)
	)
	self.water_right_arrow.pressed.connect(
		self.trade_resource_by.bind(Inventory.ShipResource.Water, -10)
	)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.air_available_label = get_node("%AirAvailableLabel")
	self.air_cost_label = get_node("%AirCostLabel")
	self.air_left_arrow = get_node("%AirBuyTextureButton")
	self.air_owned_spin_box = get_node("%AirOwnedSpinBox")
	self.air_right_arrow = get_node("%AirSellTextureButton")
	self.description = get_node("%DescriptionLineEdit")
	self.energy_available_label = get_node("%EnergyAvailableLabel")
	self.energy_cost_label = get_node("%EnergyCostLabel")
	self.energy_left_arrow = get_node("%EnergyBuyTextureButton")
	self.energy_owned_spin_box = get_node("%EnergyOwnedSpinBox")
	self.energy_right_arrow = get_node("%EnergySellTextureButton")
	self.fish_available_label = get_node("%FishAvailableLabel")
	self.fish_cost_label = get_node("%FishCostLabel")
	self.fish_left_arrow = get_node("%FishBuyTextureButton")
	self.fish_owned_spin_box = get_node("%FishOwnedSpinBox")
	self.fish_right_arrow = get_node("%FishSellTextureButton")
	self.food_available_label = get_node("%FoodAvailableLabel")
	self.food_cost_label = get_node("%FoodCostLabel")
	self.food_left_arrow = get_node("%FoodBuyTextureButton")
	self.food_owned_spin_box = get_node("%FoodOwnedSpinBox")
	self.food_right_arrow = get_node("%FoodSellTextureButton")
	self.fuel_available_label = get_node("%FuelAvailableLabel")
	self.fuel_cost_label = get_node("%FuelCostLabel")
	self.fuel_left_arrow = get_node("%FuelBuyTextureButton")
	self.fuel_owned_spin_box = get_node("%FuelOwnedSpinBox")
	self.fuel_right_arrow = get_node("%FuelSellTextureButton")
	self.money_available_spin_box = get_node("%MoneyAvailableSpinBox")
	self.money_available_warning_rect = get_node("%MoneyAvailableColorRect")
	self.money_owned_spin_box = get_node("%MoneyOwnedSpinBox")
	self.money_owned_warning_rect = get_node("%MoneyOwnedColorRect")
	self.plant_available_label = get_node("%PlantAvailableLabel")
	self.plant_cost_label = get_node("%PlantCostLabel")
	self.plant_left_arrow = get_node("%PlantBuyTextureButton")
	self.plant_owned_spin_box = get_node("%PlantOwnedSpinBox")
	self.plant_right_arrow = get_node("%PlantSellTextureButton")
	self.space_available_spin_box = get_node("%SpaceAvailableSpinBox")
	self.space_used_spin_box = get_node("%SpaceUsedSpinBox")
	self.space_used_warning_rect = get_node("%SpaceUsedColorRect")
	self.spare_part_available_label = get_node("%SparePartAvailableLabel")
	self.spare_part_cost_label = get_node("%SparePartCostLabel")
	self.spare_part_left_arrow = get_node("%SparePartBuyTextureButton")
	self.spare_part_owned_spin_box = get_node("%SparePartOwnedSpinBox")
	self.spare_part_right_arrow = get_node("%SparePartSellTextureButton")
	self.waste_available_label = get_node("%WasteAvailableLabel")
	self.waste_cost_label = get_node("%WasteCostLabel")
	self.waste_left_arrow = get_node("%WasteBuyTextureButton")
	self.waste_owned_spin_box = get_node("%WasteOwnedSpinBox")
	self.waste_right_arrow = get_node("%WasteSellTextureButton")
	self.water_available_label = get_node("%WaterAvailableLabel")
	self.water_cost_label = get_node("%WaterCostLabel")
	self.water_left_arrow = get_node("%WaterBuyTextureButton")
	self.water_owned_spin_box = get_node("%WaterOwnedSpinBox")
	self.water_right_arrow = get_node("%WaterSellTextureButton")

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

## Set the descriptive text for the resource
func set_description(resource: Inventory.ShipResource = Inventory.ShipResource.Human) -> void:
	match resource:
		Inventory.ShipResource.Air:
			self.description.text = "%s: %s" % [tr("AIR"), tr("TOOLTIP_RESOURCE_AIR")]
		Inventory.ShipResource.Energy:
			self.description.text = "%s: %s" % [tr("ENERGY"), tr("TOOLTIP_RESOURCE_ENERGY")]
		Inventory.ShipResource.Fish:
			self.description.text = "%s: %s" % [tr("FISH"), tr("TOOLTIP_RESOURCE_FISH")]
		Inventory.ShipResource.Food:
			self.description.text = "%s: %s" % [tr("FOOD"), tr("TOOLTIP_RESOURCE_FOOD")]
		Inventory.ShipResource.Fuel:
			self.description.text = "%s: %s" % [tr("FUEL"), tr("TOOLTIP_RESOURCE_FUEL")]
		Inventory.ShipResource.Human:
			self.description.text = "%s: %s" % [tr("HUMANS"), tr("TOOLTIP_RESOURCE_HUMAN")]
		Inventory.ShipResource.Plant:
			self.description.text = "%s: %s" % [tr("PLANTS"), tr("TOOLTIP_RESOURCE_PLANT")]
		Inventory.ShipResource.SparePart:
			self.description.text = "%s: %s" % [tr("SPAREPARTS"), tr("TOOLTIP_RESOURCE_SPARE_PART")]
		Inventory.ShipResource.Waste:
			self.description.text = "%s: %s" % [tr("WASTE"), tr("TOOLTIP_RESOURCE_WASTE")]
		Inventory.ShipResource.Water:
			self.description.text = "%s: %s" % [tr("WATER"), tr("TOOLTIP_RESOURCE_WATER")]
		_:
			self.description.text = ""

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	Market.reset()
	self.set_description()

	return

## Callback handler for label changes on tradable
func trade_string_resource(value_in: String, item: Inventory.ShipResource) -> void:
	self.trade_resource(float(value_in), item)

	return

## Callback handler for spin box changes on tradeable resources[br]
## [b]Input[/b]:[br]
##   value (float): New value of calling spinbox
##   item (int): Inventory.ShipResource to trade
func trade_resource(value: float, item: Inventory.ShipResource) -> void:
	var change: float = self.calculate_change_from_inventory(value, item)
	self.adjust_current_trade(change, item)
	self.adjust_trade_dialog(change, item)
	self.check_tradable()

	return

func trade_resource_by(resource: Inventory.ShipResource, quantity: float) -> void:
	if quantity < 0:
		# check player spin box
		match resource:
			Inventory.ShipResource.Air:
				self.trade_resource(
					self.air_owned_spin_box.value - (min(
						self.air_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.Energy:
				self.trade_resource(
					self.energy_owned_spin_box.value - (min(
						self.energy_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.Fish:
				self.trade_resource(
					self.fish_owned_spin_box.value - (min(
						self.fish_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.Food:
				self.trade_resource(
					self.food_owned_spin_box.value - (min(
						self.food_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.Fuel:
				self.trade_resource(
					self.fuel_owned_spin_box.value - (min(
						self.fuel_owned_spin_box.value, -quantity
					)), resource
				)
			Inventory.ShipResource.Plant:
				self.trade_resource(
					self.plant_owned_spin_box.value - (min(
						self.plant_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.SparePart:
				self.trade_resource(
					self.spare_part_owned_spin_box.value - (min(
						self.spare_part_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.Waste:
				self.trade_resource(
					self.waste_owned_spin_box.value - (min(
						self.waste_owned_spin_box.value, -quantity
					)), resource)
			Inventory.ShipResource.Water:
				self.trade_resource(
					self.water_owned_spin_box.value - (min(
						self.water_owned_spin_box.value, -quantity
					)), resource)
			_:
				Log.error("Unknown resource to trade by: %s" % [resource])
	else:
		# check market label
		match resource:
			Inventory.ShipResource.Air:
				self.trade_resource(self.air_owned_spin_box.value + min(
					float(self.air_available_label.text), quantity
				), resource)
			Inventory.ShipResource.Energy:
				self.trade_resource(self.energy_owned_spin_box.value + min(
					float(self.energy_available_label.text), quantity
				), resource)
			Inventory.ShipResource.Fish:
				self.trade_resource(self.fish_owned_spin_box.value + min(
					float(self.fish_available_label.text), quantity
				), resource)
			Inventory.ShipResource.Food:
				self.trade_resource(self.food_owned_spin_box.value + min(
					float(self.food_available_label.text), quantity
				), resource)
			Inventory.ShipResource.Fuel:
				self.trade_resource(
					self.fuel_owned_spin_box.value + min(
						float(self.fuel_available_label.text), quantity
					), resource)
			Inventory.ShipResource.Plant:
				self.trade_resource(self.plant_owned_spin_box.value + min(
					float(self.plant_available_label.text), quantity
				), resource)
			Inventory.ShipResource.SparePart:
				self.trade_resource(self.spare_part_owned_spin_box.value + min(
					float(self.spare_part_available_label.text), quantity
				), resource)
			Inventory.ShipResource.Waste:
				self.trade_resource(self.waste_owned_spin_box.value + min(
					float(self.waste_available_label.text), quantity
				), resource)
			Inventory.ShipResource.Water:
				self.trade_resource(self.water_owned_spin_box.value + min(
					float(self.water_available_label.text), quantity
				), resource)
			_:
				Log.error("Unknown resource to trade by: %s" % [resource])

	return

## Update trade interface with current inventory
func update_inventory() -> void:
	self.reset_current_trade()
	Inventory.calculate_space()
	self.update_inventory_costs()
	self.update_inventory_player()
	self.update_inventory_waypoint()

	Log.debug("Inventory updated")

	return

## Update the trade window with the current waypoint's pricing
func update_inventory_costs() -> void:
	self.air_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Air)]
	self.energy_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Energy)]
	self.fish_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Fish)]
	self.food_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Food)]
	self.fuel_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Fuel)]
	self.plant_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Plant)]
	self.spare_part_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.SparePart)]
	self.waste_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Waste)]
	self.water_cost_label.text = "¤%s" % [Market.calculate_resource_cost(Inventory.ShipResource.Water)]

	return

## Update inventory spin boxes with player inventory
func update_inventory_player() -> void:
	self.air_owned_spin_box.set_value_no_signal(Inventory.air)
	self.energy_owned_spin_box.set_value_no_signal(Inventory.energy)
	self.fish_owned_spin_box.set_value_no_signal(Inventory.fish)
	self.food_owned_spin_box.set_value_no_signal(Inventory.food)
	self.fuel_owned_spin_box.set_value_no_signal(Inventory.fuel)
	self.money_owned_spin_box.set_value_no_signal(Inventory.money)
	if Inventory.money <= 0:
		self.money_owned_warning_rect.set_color(self.WarningColor)
	else:
		self.money_owned_warning_rect.set_color(Color.TRANSPARENT)
	self.plant_owned_spin_box.set_value_no_signal(Inventory.plant)
	self.space_available_spin_box.set_value_no_signal(round(Inventory.space_available))
	self.space_used_spin_box.set_value_no_signal(round(
		Inventory.starting_values[Inventory.ShipResource.Space] - \
		Inventory.space_available
	))
	if Inventory.space_available <= 0:
		self.space_used_warning_rect.set_color(self.WarningColor)
	else:
		self.space_used_warning_rect.set_color(Color.TRANSPARENT)
	self.spare_part_owned_spin_box.set_value_no_signal(Inventory.spare_part)
	self.waste_owned_spin_box.set_value_no_signal(Inventory.waste)
	self.water_owned_spin_box.set_value_no_signal(Inventory.water)

	return

## Update inventory spin boxes with waypoint inventory
func update_inventory_waypoint() -> void:
	self.air_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Air])
	)
	self.energy_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Energy])
	)
	self.fish_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fish])
	)
	self.food_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Food])
	)
	self.fuel_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Fuel])
	)
	self.money_available_spin_box.set_value_no_signal(
		Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money]
	)
	if Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Money] <= 0:
		self.money_available_warning_rect.set_color(self.WarningColor)
	else:
		self.money_available_warning_rect.set_color(Color.TRANSPARENT)
	self.plant_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Plant])
	)
	self.spare_part_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.SparePart])
	)
	self.waste_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Waste])
	)
	self.water_available_label.set_text(
		str(Market.inventory[Controller.current_waypoint][Inventory.ShipResource.Water])
	)

	return
