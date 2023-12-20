extends Node
## Ship's inventory

## Indicate a resource has been consumed
signal resource_added(resource: int, quantity: float)
## Indicate a resource has been consumed
signal resource_consumed(resource: int, quantity: float)

## List resources that have an entry in the conversions dictionary
enum Converters {
	AirGenerator,
	Aquaponic,
	Battery,
	Bot,
	CryoPod,
	Fishery,
	FusionGenerator,
	Human,
	Hydroponic,
	WaterGenerator,
}

## List of tracked resources
enum Type {
	Air,
	AirGenerator,
	Aquaponic,
	Battery,
	Bot,
	BotBench,
	Cryopod,
	Energy,
	EnergyCapacity,
	Fish,
	Fishery,
	Food,
	Fuel,
	FusionGenerator,
	Hydroponic,
	Human,
	Money,
	Plant,
	Recycling,
	Space,
	SparePart,
	Waste,
	Water,
	WaterGenerator,
	Work
}

## Conversion dictionary
const conversions: Dictionary = {
	Inventory.Type.Aquaponic: {
		Inventory.Type.Air: 10,
		Inventory.Type.Plant: 5,
		Inventory.Type.Fish: 5,
		Inventory.Type.Waste: -2,
		Inventory.Type.Water: -1,
		Inventory.Type.Food: 5,
	},
	Inventory.Type.Battery: {
		Inventory.Type.Space: -10,
		Inventory.Type.EnergyCapacity: 100,
	},
	Inventory.Type.Bot: {
		Inventory.Type.Energy: -1,
		Inventory.Type.Work: 1,
	},
	Inventory.Type.Cryopod: {
		Inventory.Type.Energy: -1,
		Inventory.Type.Work: -1,
	},
	Inventory.Type.Fishery: {
		Inventory.Type.Fish: 5,
		Inventory.Type.Food: 5,
		Inventory.Type.Waste: 1,
		Inventory.Type.Water: -1,
		Inventory.Type.Work: -1,
	},
	Inventory.Type.FusionGenerator: {
		Inventory.Type.Fuel: -1,
		Inventory.Type.Energy: 100,
	},
	Inventory.Type.Human: {
		Inventory.Type.Air: -2,
		Inventory.Type.Energy: 2,
		Inventory.Type.Food: -2,
		Inventory.Type.Waste: 2,
		Inventory.Type.Water: -2,
		Inventory.Type.Work: 5,
	},
	Inventory.Type.Hydroponic: {
		Inventory.Type.Air: 5,
		Inventory.Type.Food: 5,
		Inventory.Type.Plant: 5,
		Inventory.Type.Waste: -1,
		Inventory.Type.Water: -2,
		Inventory.Type.Work: -1,
	},
	Inventory.Type.AirGenerator: {
		Inventory.Type.Air: 100,
		Inventory.Type.Energy: -10,
	},
	Inventory.Type.WaterGenerator: {
		Inventory.Type.Water: 100,
		Inventory.Type.Energy: -10,
	},
}

## Space usage
const required_space: Dictionary = {
	Inventory.Type.Air: 0.0001,
	Inventory.Type.Aquaponic: 0,
	Inventory.Type.Battery: 2,
	Inventory.Type.Bot: 1,
	Inventory.Type.Cryopod: 4,
	Inventory.Type.Energy: 0,
	Inventory.Type.EnergyCapacity: 0,
	Inventory.Type.Fish: 0.1,
	Inventory.Type.Fishery: 10,
	Inventory.Type.Food: 0.1,
	Inventory.Type.Fuel: 1,
	Inventory.Type.FusionGenerator: 25,
	Inventory.Type.Human: 2,
	Inventory.Type.Hydroponic: 1,
	Inventory.Type.Money: 0,
	Inventory.Type.AirGenerator: 10,
	Inventory.Type.Plant: 0.1,
	Inventory.Type.Space: 0,
	Inventory.Type.SparePart: 10,
	Inventory.Type.Waste: 1,
	Inventory.Type.Water: 2,
	Inventory.Type.WaterGenerator: 10,
	Inventory.Type.Work: 0,
}

## Oxygen for active humans
var air: float
## Oxygen generator: consumes energy, produces oxygen
var air_generator: float
## Energy storage device
var battery: float
## Worker bots
var bot: float
## Inactive humands
var cryopod: float
## Electricty
var energy: float
## Capacity of energy storage
var energy_capacity: float
## Active fish
var fish: float
## Fishery to process fish
var fishery: float
## Food for active humans
var food: float
## Fuel to power energy generators and propulsion
var fuel: float
## Fuel burn rate during travel
var fuel_burn_rate: float
## Fusion generator: consumes fuel, produces energy
var fusion_generator: float
## Hydroponic gardens to tend plants
var hydroponic: float
## Active human workers
var human: float
## Cash for trade
var money: float
## Plants to grow for food and air
var plant: float
## Available space for stuff
var space_available: float
## Spare parts for repairs
var spare_part: float
## Starting values
var starting_values: Dictionary = {
	Inventory.Type.Bot: 1,
	Inventory.Type.Cryopod: 100,
	Inventory.Type.EnergyCapacity: 100,
	Inventory.Type.Human: 5,
	Inventory.Type.Money: 1000,
	Inventory.Type.Space: 1000,
}
## Fish, Human, and Plant waste-matter
var waste: float
## Water for active humans, plants, and fish
var water: float
## Water generator: consumes energy, produces water
var water_generator: float
## Accumulated effort put forth by the workers
var work: float
## Workstation efficiency. Unmaintained workstations don't work as well
var workstation_efficiency: Dictionary = {
	Inventory.Type.Aquaponic: 1.0,
	Inventory.Type.BotBench: 1.0,
	Inventory.Type.Fishery: 1.0,
	Inventory.Type.Hydroponic: 1.0,
}

func _init(
	bots_in: int = self.starting_values[Inventory.Type.Bot],
	cryopod_in: int = self.starting_values[Inventory.Type.Cryopod],
	energy_capacity_in: int = self.starting_values[Inventory.Type.EnergyCapacity],
	humans_in: int = self.starting_values[Inventory.Type.Human],
	money_in: int = self.starting_values[Inventory.Type.Money],
	space_in: int = self.starting_values[Inventory.Type.Space],
) -> void:
	self.starting_values[Inventory.Type.Bot] = bots_in
	self.starting_values[Inventory.Type.Cryopod] = cryopod_in
	self.starting_values[Inventory.Type.EnergyCapacity] = energy_capacity_in
	self.starting_values[Inventory.Type.Human] = humans_in
	self.starting_values[Inventory.Type.Money] = money_in
	self.starting_values[Inventory.Type.Space] = space_in

	return

## Add a specified resource to the Inventory
func add_resource(resource: Inventory.Type, quantity: float) -> bool:
	if Inventory.space_available < Inventory.calculate_space_used_by(resource, quantity):
		return false

	match resource:
		Inventory.Type.Air:
			Inventory.air += quantity
		Inventory.Type.Battery:
			Inventory.battery += quantity
		Inventory.Type.Bot:
			Inventory.bot += quantity
		Inventory.Type.Energy:
			Inventory.energy += quantity
		Inventory.Type.Fish:
			Inventory.fish += quantity
		Inventory.Type.Food:
			Inventory.food += quantity
		Inventory.Type.Fuel:
			Inventory.fuel += quantity
		Inventory.Type.Human:
			Inventory.human += quantity
		Inventory.Type.Money:
			Inventory.money += quantity
		Inventory.Type.Plant:
			Inventory.plant += quantity
		Inventory.Type.SparePart:
			Inventory.spare_part += quantity
		Inventory.Type.Waste:
			Inventory.waste += quantity
		Inventory.Type.Water:
			Inventory.water += quantity
		_:
			Log.error("Unknown resource: %s (%s)." % [
				resource, Inventory.Type.keys()[resource]
			])

			return false
	Inventory.space_available -= Inventory.calculate_space_used_by(resource, quantity)
	Inventory.resource_added.emit(resource, quantity)

	return true

## Calcuate Air production / consumption based on time
func calculate_air_rate(by_time: float) -> float:
	var air_per_time: float = 0

	# Human consume air
	air_per_time -= Inventory.human * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Air] * Inventory.human * by_time

	# Oxygen generators creates air
	air_per_time += Inventory.air_generator * Inventory.conversions[
		Inventory.Type.AirGenerator
	][Inventory.Type.Air] * Inventory.air_generator * by_time

	if Inventory.plant > 0:
		# Plants produce air
		air_per_time += Inventory.plant * by_time

		# Hydroponics add air
		air_per_time += (
			Inventory.plant * Inventory.hydroponic * by_time * \
			Inventory.workstation_efficiency[Inventory.Type.Hydroponic] * \
			Inventory.conversions[Inventory.Type.Hydroponic][Inventory.Type.Air]
		)

		# Aquaponic adds air
		air_per_time += (
			Inventory.count_aquaponic() * Inventory.plant * by_time * \
			Inventory.workstation_efficiency[Inventory.Type.Hydroponic] * \
			Inventory.conversions[Inventory.Type.Aquaponic][Inventory.Type.Air]
		)

	return air_per_time

## Calculate bot breakdown rate
func calculate_bot_rate(by_time: float) -> float:
	var bot_per_time: float = 0

	if Controller.travel_state == State.Traveling:
		bot_per_time += randf_range(0.0, 0.01) * by_time

	return bot_per_time

## Calculate CryoPod breakdown rate
func calculate_cryopod_rate(by_time: float) -> float:
	var pod_per_time: float = 0

	if Controller.travel_state == State.Traveling:
		pod_per_time += randf_range(0.0, 0.01) * by_time

	return pod_per_time

## Calcuate Energy production / consumption based on time
func calculate_energy_rate(by_time: float) -> float:
	var energy_per_time: float = 0

	# Bots consume energy
	energy_per_time += Inventory.bot * Inventory.conversions[
		Inventory.Type.Bot
	][Inventory.Type.Energy] * by_time

	# Humans exercise, producing energy
	energy_per_time += Inventory.human * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Energy] * by_time

	# Cryopods utilize energy
	energy_per_time += Inventory.cryopod * Inventory.conversions[
		Inventory.Type.Cryopod
	][Inventory.Type.Energy] * by_time

	# Fusion generators creates energy as fallback

	return energy_per_time

## Calcuate Fish production / consumption based on time
func calculate_fish_rate(by_time: float) -> float:
	if Inventory.fish <= 0:
		return 0

	var fish_per_time: float = Inventory.fish * by_time

	# Aquaponic adds fish
	fish_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.Type.Aquaponic
	][Inventory.Type.Fish] * Inventory.fish * by_time

	# Fisheries add fish
	fish_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.Type.Fishery
	][Inventory.Type.Fish] * Inventory.fish * by_time

	# Birth/Death rate
	fish_per_time += fish_per_time * randf_range(-0.2, 0.2)

	return fish_per_time

## Calcuate Food production / consumption based on time
func calculate_food_rate(by_time: float) -> float:
	var food_per_time: float = 0

	# Aquaponics add food
	food_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.Type.Aquaponic
	][Inventory.Type.Food] * by_time

	# Fisheries add food
	food_per_time += Inventory.bot * Inventory.conversions[
		Inventory.Type.Fishery
	][Inventory.Type.Food] * by_time

	# Humans eat food
	food_per_time += Inventory.bot * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Food] * by_time

	# Hydroponics add food
	food_per_time += Inventory.bot * Inventory.conversions[
		Inventory.Type.Hydroponic
	][Inventory.Type.Food] * by_time

	return food_per_time

## Calcuate Fuel production / consumption based on time
func calculate_fuel_rate(by_time: float) -> float:
	var fuel_per_time: float = 0

	if Controller.travel_state == State.Traveling:
		fuel_per_time += Inventory.fuel_burn_rate * by_time

	return fuel_per_time

## Calculate natural human decay rate
func calculate_human_rate(by_time: float) -> float:
	var human_per_time: float = 0

	if Controller.travel_state == State.Traveling:
		human_per_time += randf_range(0.0, 0.01) * by_time

	return human_per_time

## Calcuate Plant production / consumption based on time
func calculate_plant_rate(by_time: float) -> float:
	if Inventory.plant <= 0:
		return 0

	var plant_per_time: float = 0

	# Aquaponics add plants
	plant_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.Type.Aquaponic
	][Inventory.Type.Plant] * Inventory.plant * by_time

	# Hydroponics add plants
	plant_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.Type.Hydroponic
	][Inventory.Type.Plant] * Inventory.plant * by_time

	# Birth/Death rate
	plant_per_time += plant_per_time * randf_range(-0.2, 0.2)

	return plant_per_time

## Calculate the amount of space currently used in the inventory
func calculate_space() -> void:
	var space_used: float = 0

	space_used += Inventory.air * Inventory.required_space[Inventory.Type.Air]
	space_used += Inventory.battery * Inventory.required_space[Inventory.Type.Battery]
	space_used += Inventory.bot * Inventory.required_space[Inventory.Type.Bot]
	space_used += Inventory.cryopod * Inventory.required_space[Inventory.Type.Cryopod]
	space_used += Inventory.fish * Inventory.required_space[Inventory.Type.Fish]
	space_used += Inventory.fishery * Inventory.required_space[Inventory.Type.Fishery]
	space_used += Inventory.food * Inventory.required_space[Inventory.Type.Food]
	space_used += Inventory.fuel * Inventory.required_space[Inventory.Type.Fuel]
	space_used += Inventory.fusion_generator * Inventory.required_space[Inventory.Type.FusionGenerator]
	space_used += Inventory.hydroponic * Inventory.required_space[Inventory.Type.Hydroponic]
	space_used += Inventory.human * Inventory.required_space[Inventory.Type.Human]
	space_used += Inventory.air_generator * Inventory.required_space[Inventory.Type.AirGenerator]
	space_used += Inventory.plant * Inventory.required_space[Inventory.Type.Plant]
	space_used += Inventory.spare_part * Inventory.required_space[Inventory.Type.SparePart]
	space_used += Inventory.waste * Inventory.required_space[Inventory.Type.Waste]
	space_used += Inventory.water * Inventory.required_space[Inventory.Type.Water]
	space_used += Inventory.water_generator * Inventory.required_space[Inventory.Type.WaterGenerator]

	Inventory.space_available = float(Inventory.starting_values[Inventory.Type.Space])
	Inventory.space_available -= space_used

	Log.verbose("Using %s units of space, leaving %s available." % [
		space_used, Inventory.space_available
	])

	return

## Calculate the amount of space used by a given resource
func calculate_space_used_by(resource: int, quantity: float) -> float:

	return Inventory.required_space[resource] * quantity

## Calcuate Waste production / consumption based on time
func calculate_waste_rate(by_time: float) -> float:
	var waste_per_time: float = 0

	# Aquaponic consume waste
	waste_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.Type.Aquaponic
	][Inventory.Type.Waste] * by_time

	# Fisheries produce waste
	waste_per_time += Inventory.human * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Waste] * by_time

	# Humans produce waste
	waste_per_time += Inventory.human * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Waste] * by_time

	# Hydroponics consume waste
	waste_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.Type.Hydroponic
	][Inventory.Type.Waste] * by_time

	return waste_per_time

## Calcuate Water production / consumption based on time
func calculate_water_rate(by_time: float) -> float:
	var water_per_time: float = 0

	# Aquaponics give back water used in fisheries and hydroponics
	water_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.Type.Aquaponic
	][Inventory.Type.Water] * by_time

	# Fisheries consume water
	water_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.Type.Fishery
	][Inventory.Type.Water] * by_time

	# Humans consume water
	water_per_time += Inventory.human * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Water] * by_time

	# Hydroponics consume water
	water_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.Type.Hydroponic
	][Inventory.Type.Water] * by_time

	return water_per_time

## Calcuate Work production / consumption based on time
func calculate_work_rate(by_time: float) -> float:
	var work_per_time: float = 0

	# Bots produce work
	work_per_time += Inventory.bot * Inventory.conversions[
		Inventory.Type.Bot
	][Inventory.Type.Work] * by_time

	# Cryopods consume work
	work_per_time += Inventory.cryopod * Inventory.conversions[
		Inventory.Type.Cryopod
	][Inventory.Type.Work] * by_time

	# Fisheries consume work
	work_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.Type.Fishery
	][Inventory.Type.Work] * by_time

	# Humans produce work
	work_per_time += Inventory.human * Inventory.conversions[
		Inventory.Type.Human
	][Inventory.Type.Work] * by_time

	# Humans produce work
	work_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.Type.Hydroponic
	][Inventory.Type.Work] * by_time

	return work_per_time

## How many combined fishery and hyrdoponic stations can we make
func count_aquaponic() -> int:
	if Inventory.fish <= 0 or Inventory.plant <= 0:
		return 0

	return min(Inventory.fishery, Inventory.hydroponic)

## Reset inventory to initial state
func reset() -> void:
	Inventory.air = 250
	Inventory.battery = 0
	Inventory.bot = Inventory.starting_values[Inventory.Type.Bot]
	Inventory.cryopod = Inventory.starting_values[Inventory.Type.Cryopod]
	Inventory.energy = 10
	Inventory.energy_capacity = Inventory.starting_values[Inventory.Type.EnergyCapacity]
	Inventory.fish = 0
	Inventory.fishery = 0
	Inventory.food = 10
	Inventory.fuel = 5
	Inventory.fuel_burn_rate = 1
	Inventory.fusion_generator = 0
	Inventory.hydroponic = 0
	Inventory.human = Inventory.starting_values[Inventory.Type.Human]
	Inventory.money = Inventory.starting_values[Inventory.Type.Money]
	Inventory.air_generator = 0
	Inventory.plant = 0
	Inventory.space_available = Inventory.starting_values[Inventory.Type.Space]
	Inventory.spare_part = 0
	Inventory.waste = 0
	Inventory.water = 10
	Inventory.water_generator = 0
	Inventory.work = 0
	Inventory.calculate_space()

	return

func use_resource_by_time(delta: float, resource: int) -> void:
	var quantity: float
	var resource_key: String = Inventory.Type.keys()[resource]

	match resource:
		Inventory.Type.Air:
			quantity = Inventory.calculate_air_rate(delta)
			Inventory.air += quantity
		Inventory.Type.Bot:
			quantity = Inventory.calculate_bot_rate(delta)
			Inventory.bot += quantity
		Inventory.Type.Cryopod:
			quantity = Inventory.calculate_cryopod_rate(delta)
			Inventory.cryopod += quantity
		Inventory.Type.Energy:
			quantity = Inventory.calculate_energy_rate(delta)
			Inventory.energy += quantity
		Inventory.Type.Fish:
			quantity = Inventory.calculate_fish_rate(delta)
			Inventory.fish += quantity
		Inventory.Type.Food:
			quantity = Inventory.calculate_food_rate(delta)
			Inventory.food += quantity
		Inventory.Type.Fuel:
			quantity = Inventory.calculate_fuel_rate(delta)
			Inventory.fuel += quantity
		Inventory.Type.Human:
			quantity = Inventory.calculate_human_rate(delta)
			Inventory.human += quantity
		Inventory.Type.Plant:
			quantity = Inventory.calculate_plant_rate(delta)
			Inventory.plant += quantity
		Inventory.Type.Waste:
			quantity = Inventory.calculate_waste_rate(delta)
			Inventory.waste += quantity
		Inventory.Type.Water:
			quantity = Inventory.calculate_water_rate(delta)
			Inventory.water += quantity
		Inventory.Type.Work:
			quantity = Inventory.calculate_work_rate(delta)
			Inventory.work += quantity
		_:
			Log.error("Unknown resource: %s" % [resource])
	Inventory.space_available += quantity * Inventory.required_space[resource]
	Inventory.resource_consumed.emit(resource, quantity)
	Log.debug("Use %s units of %s." % [quantity, resource_key])

	return

## Use a set amount of a resource
func use_set_resource(resource: Inventory.Type, quantity: float) -> void:
	match resource:
		Inventory.Type.Cryopod:
			if Inventory.cryopod < quantity:
				quantity = Inventory.cryopod

			Inventory.cryopod -= quantity
			if !Inventory.add_resource(Inventory.Type.Human, quantity):
				Log.error("Failed to add resource: Human")
			if !Inventory.add_resource(Inventory.Type.SparePart, quantity):
				Log.error("Failed to add resource: Spare part")

		Inventory.Type.SparePart:
			if Inventory.spare_part < quantity:
				quantity = Inventory.spare_part

			Inventory.spare_part -= quantity
			if !Inventory.add_resource(Inventory.Type.Bot, quantity / 2):
				Log.error("Failed to add resource: Bot")
	Inventory.space_available += quantity * Inventory.required_space[resource]
	Inventory.resource_consumed.emit(resource, quantity)

	return
