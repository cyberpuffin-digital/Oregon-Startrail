extends Node
## Ship's inventory

## List resources that have an entry in the conversions dictionary
enum Converters {
	Aquaponic,
	Battery,
	Bot,
	CryoPod,
	Fishery,
	FusionGenerator,
	Human,
	Hydroponic,
	OxygenGenerator,
	WaterGenerator,
}

## List of tracked resources
enum TrackedResources {
	Air,
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
	OxygenGenerator,
	Plant,
	Recycling,
	Space,
	SparePart,
	Waste,
	Water,
	WaterGenerator,
	Work
}

## Base cost for tracked resource
const base_cost: Dictionary = {
	Inventory.TrackedResources.Air: 1,
	Inventory.TrackedResources.Energy: 1,
	Inventory.TrackedResources.Fish: 2,
	Inventory.TrackedResources.Food: 2,
	Inventory.TrackedResources.Fuel: 10,
	Inventory.TrackedResources.Money: 1,
	Inventory.TrackedResources.Plant: 2,
	Inventory.TrackedResources.SparePart: 5,
	Inventory.TrackedResources.Waste: 1,
	Inventory.TrackedResources.Water: 5,
}

## Conversion dictionary
const conversions: Dictionary = {
	Inventory.TrackedResources.Aquaponic: {
		TrackedResources.Air: 10,
		TrackedResources.Plant: 5,
		TrackedResources.Fish: 5,
		TrackedResources.Waste: -2,
		TrackedResources.Water: -1,
		TrackedResources.Food: 5,
	},
	Inventory.TrackedResources.Battery: {
		TrackedResources.Space: -10,
		TrackedResources.EnergyCapacity: 100,
	},
	Inventory.TrackedResources.Bot: {
		TrackedResources.Energy: -1,
		TrackedResources.Work: 1,
	},
	Inventory.TrackedResources.Cryopod: {
		TrackedResources.Energy: -1,
		TrackedResources.Work: -1,
	},
	Inventory.TrackedResources.Fishery: {
		TrackedResources.Fish: 5,
		TrackedResources.Food: 5,
		TrackedResources.Waste: 1,
		TrackedResources.Water: -1,
		TrackedResources.Work: -1,
	},
	Inventory.TrackedResources.FusionGenerator: {
		TrackedResources.Fuel: -1,
		TrackedResources.Energy: 100,
	},
	Inventory.TrackedResources.Human: {
		TrackedResources.Air: -2,
		TrackedResources.Energy: 2,
		TrackedResources.Food: -2,
		TrackedResources.Waste: 2,
		TrackedResources.Water: -2,
		TrackedResources.Work: 5,
	},
	Inventory.TrackedResources.Hydroponic: {
		TrackedResources.Air: 5,
		TrackedResources.Food: 5,
		TrackedResources.Plant: 5,
		TrackedResources.Waste: -1,
		TrackedResources.Water: -2,
		TrackedResources.Work: -1,
	},
	Inventory.TrackedResources.OxygenGenerator: {
		TrackedResources.Air: 100,
		TrackedResources.Energy: -10,
	},
	Inventory.TrackedResources.WaterGenerator: {
		TrackedResources.Water: 100,
		TrackedResources.Energy: -10,
	},
}
## Space usage
const required_space: Dictionary = {
	Inventory.TrackedResources.Air: 0.001,
	Inventory.TrackedResources.Aquaponic: 0,
	Inventory.TrackedResources.Battery: 2,
	Inventory.TrackedResources.Bot: 1,
	Inventory.TrackedResources.Cryopod: 4,
	Inventory.TrackedResources.Energy: 0,
	Inventory.TrackedResources.EnergyCapacity: 0,
	Inventory.TrackedResources.Fish: 0.1,
	Inventory.TrackedResources.Fishery: 10,
	Inventory.TrackedResources.Food: 0.1,
	Inventory.TrackedResources.Fuel: 1,
	Inventory.TrackedResources.FusionGenerator: 25,
	Inventory.TrackedResources.Human: 2,
	Inventory.TrackedResources.Hydroponic: 1,
	Inventory.TrackedResources.Money: 0,
	Inventory.TrackedResources.OxygenGenerator: 10,
	Inventory.TrackedResources.Plant: 0.1,
	Inventory.TrackedResources.Space: 0,
	Inventory.TrackedResources.SparePart: 10,
	Inventory.TrackedResources.Waste: 1,
	Inventory.TrackedResources.Water: 2,
	Inventory.TrackedResources.WaterGenerator: 10,
	Inventory.TrackedResources.Work: 0,
}

## Oxygen for active humans
var air: float
## Energy storage device
var battery: int
## Worker bots
var bot: int
## Inactive humands
var cryopod: int
## Electricty
var energy: float
## Capacity of energy storage
var energy_capacity: float
## Active fish
var fish: float
## Fishery to process fish
var fishery: int
## Food for active humans
var food: float
## Fuel to power energy generators and propulsion
var fuel: float
## Fuel burn rate during travel
var fuel_burn_rate: float
## Fusion generator: consumes fuel, produces energy
var fusion_generator: int
## Hydroponic gardens to tend plants
var hydroponic: int
## Active human workers
var human: float
## Cash for trade
var money: float
## Oxygen generator: consumes energy, produces oxygen
var oxygen_generator: int
## Plants to grow for food and air
var plant: float
## Available space for stuff
var space_available: float
## Spare parts for repairs
var spare_part: int
## Starting values
var starting_values: Dictionary = {
	Inventory.TrackedResources.Bot: 1,
	Inventory.TrackedResources.Cryopod: 100,
	Inventory.TrackedResources.EnergyCapacity: 100,
	Inventory.TrackedResources.Human: 5,
	Inventory.TrackedResources.Money: 1000,
	Inventory.TrackedResources.Space: 1000,
}
## Fish, Human, and Plant waste-matter
var waste: float
## Water for active humans, plants, and fish
var water: float
## Water generator: consumes energy, produces water
var water_generator: int
## Accumulated effort put forth by the workers
var work: float
## Workstation efficiency. Unmaintained workstations don't work as well
var workstation_efficiency: Dictionary = {
	Inventory.TrackedResources.Aquaponic: 1.0,
	Inventory.TrackedResources.BotBench: 1.0,
	Inventory.TrackedResources.Fishery: 1.0,
	Inventory.TrackedResources.Hydroponic: 1.0,
}

func _init(
	bots_in: int = self.starting_values[Inventory.TrackedResources.Bot],
	cryopod_in: int = self.starting_values[Inventory.TrackedResources.Cryopod],
	energy_capacity_in: int = self.starting_values[Inventory.TrackedResources.EnergyCapacity],
	humans_in: int = self.starting_values[Inventory.TrackedResources.Human],
	money_in: int = self.starting_values[Inventory.TrackedResources.Money],
	space_in: int = self.starting_values[Inventory.TrackedResources.Space],
) -> void:
	self.starting_values[Inventory.TrackedResources.Bot] = bots_in
	self.starting_values[Inventory.TrackedResources.Cryopod] = cryopod_in
	self.starting_values[Inventory.TrackedResources.EnergyCapacity] = energy_capacity_in
	self.starting_values[Inventory.TrackedResources.Human] = humans_in
	self.starting_values[Inventory.TrackedResources.Money] = money_in
	self.starting_values[Inventory.TrackedResources.Space] = space_in

	return

## Calcuate Air production / consumption based on time
func calculate_air_rate(by_time: float) -> float:
	var air_per_time: float = 0

	# Human consume air
	air_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Air] * Inventory.human / by_time

	# Oxygen generators creates air
	air_per_time += Inventory.oxygen_generator * Inventory.conversions[
		Inventory.TrackedResources.OxygenGenerator
	][Inventory.TrackedResources.Air] * Inventory.oxygen_generator / by_time

	if Inventory.plant > 0:
		# Plants produce air
		air_per_time += Inventory.plant / by_time

		# Hydroponics add air
		air_per_time += (
			Inventory.plant * Inventory.hydroponic * \
			Inventory.hydroponic_efficiency * Inventory.conversions[
				Inventory.TrackedResources.Hydroponic
			][Inventory.TrackedResources.Air] / by_time
		)

		# Aquaponic adds air
		air_per_time += (
			Inventory.count_aquaponic() * Inventory.plant * \
			Inventory.aquaponic_efficiency * Inventory.conversions[
				Inventory.TrackedResources.Aquaponic
			][Inventory.TrackedResources.Air] / by_time
		)


	return air_per_time

## Calcuate Energy production / consumption based on time
func calculate_energy_rate(by_time: float) -> float:
	var energy_per_time: float = 0

	# Bots consume energy
	energy_per_time += Inventory.bot * Inventory.conversions[
		Inventory.TrackedResources.Bot
	][Inventory.TrackedResources.Energy] / by_time

	# Humans exercise, producing energy
	energy_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Energy] / by_time

	# Cryopods utilize energy
	energy_per_time += Inventory.cryopod * Inventory.conversions[
		Inventory.TrackedResources.Cryopod
	][Inventory.TrackedResources.Energy] / by_time

	# Fusion generators creates energy as fallback

	return energy_per_time

## Calcuate Fish production / consumption based on time
func calculate_fish_rate(by_time: float) -> float:
	if Inventory.fish <= 0:
		return 0

	var fish_per_time: float = Inventory.fish * by_time

	# Aquaponic adds fish
	fish_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Fish] * Inventory.fish / by_time

	# Fisheries add fish
	fish_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.TrackedResources.Fishery
	][Inventory.TrackedResources.Fish] * Inventory.fish / by_time

	# Birth/Death rate
	fish_per_time += fish_per_time * randf_range(-0.2, 0.2)

	return fish_per_time

## Calcuate Food production / consumption based on time
func calculate_food_rate(by_time: float) -> float:
	var food_per_time: float = 0

	# Aquaponics add food
	food_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Food] / by_time

	# Fisheries add food
	food_per_time += Inventory.bot * Inventory.conversions[
		Inventory.TrackedResources.Fishery
	][Inventory.TrackedResources.Food] / by_time

	# Humans eat food
	food_per_time += Inventory.bot * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Food] / by_time

	# Hydroponics add food
	food_per_time += Inventory.bot * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Food] / by_time

	return food_per_time

## Calcuate Fuel production / consumption based on time
func calculate_fuel_rate(by_time: float) -> float:
	var fuel_per_time: float = 0

	if Controller.travel_state == State.Traveling:
		fuel_per_time += Inventory.fuel_burn_rate * by_time

	return fuel_per_time

## Calcuate Plant production / consumption based on time
func calculate_plant_rate(by_time: float) -> float:
	if Inventory.plant <= 0:
		return 0

	var plant_per_time: float = 0

	# Aquaponics add plants
	plant_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Plant] * Inventory.plant / by_time

	# Hydroponics add plants
	plant_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Plant] * Inventory.plant / by_time

	# Birth/Death rate
	plant_per_time += plant_per_time * randf_range(-0.2, 0.2)

	return plant_per_time

## Calculate the amount of space currently used in the inventory
func calculate_space() -> void:
	var space_used: float = 0

	space_used += Inventory.air * Inventory.required_space[Inventory.TrackedResources.Air]
	space_used += Inventory.battery * Inventory.required_space[Inventory.TrackedResources.Battery]
	space_used += Inventory.bot * Inventory.required_space[Inventory.TrackedResources.Bot]
	space_used += Inventory.cryopod * Inventory.required_space[Inventory.TrackedResources.Cryopod]
	space_used += Inventory.fish * Inventory.required_space[Inventory.TrackedResources.Fish]
	space_used += Inventory.fishery * Inventory.required_space[Inventory.TrackedResources.Fishery]
	space_used += Inventory.food * Inventory.required_space[Inventory.TrackedResources.Food]
	space_used += Inventory.fuel * Inventory.required_space[Inventory.TrackedResources.Fuel]
	space_used += Inventory.fusion_generator * Inventory.required_space[Inventory.TrackedResources.FusionGenerator]
	space_used += Inventory.hydroponic * Inventory.required_space[Inventory.TrackedResources.Hydroponic]
	space_used += Inventory.human * Inventory.required_space[Inventory.TrackedResources.Human]
	space_used += Inventory.oxygen_generator * Inventory.required_space[Inventory.TrackedResources.OxygenGenerator]
	space_used += Inventory.plant * Inventory.required_space[Inventory.TrackedResources.Plant]
	space_used += Inventory.spare_part * Inventory.required_space[Inventory.TrackedResources.SparePart]
	space_used += Inventory.waste * Inventory.required_space[Inventory.TrackedResources.Waste]
	space_used += Inventory.water * Inventory.required_space[Inventory.TrackedResources.Water]
	space_used += Inventory.water_generator * Inventory.required_space[Inventory.TrackedResources.WaterGenerator]

	Inventory.space_available = float(Inventory.starting_values[Inventory.TrackedResources.Space])
	Inventory.space_available -= space_used

	Log.verbose("Using %s units of space, leaving %s available." % [
		space_used, Inventory.space_available
	])

	return

## Calcuate Waste production / consumption based on time
func calculate_waste_rate(by_time: float) -> float:
	var waste_per_time: float = 0

	# Aquaponic consume waste
	waste_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Waste] / by_time

	# Fisheries produce waste
	waste_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Waste] / by_time

	# Humans produce waste
	waste_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Waste] / by_time

	# Hydroponics consume waste
	waste_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Waste] / by_time

	return waste_per_time

## Calcuate Water production / consumption based on time
func calculate_water_rate(by_time: float) -> float:
	var water_per_time: float = 0

	# Aquaponic consumes water
	water_per_time += Inventory.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Water] / by_time

	# Fisheries consume water
	water_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.TrackedResources.Fishery
	][Inventory.TrackedResources.Water] / by_time

	# Humans consume water
	water_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Water] / by_time

	# Hydroponics consume water
	water_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Water] / by_time

	return water_per_time

## Calcuate Work production / consumption based on time
func calculate_work_rate(by_time: float) -> float:
	var work_per_time: float = 0

	# Bots produce work
	work_per_time += Inventory.bot * Inventory.conversions[
		Inventory.TrackedResources.Bot
	][Inventory.TrackedResources.Work] / by_time

	# Cryopods consume work
	work_per_time += Inventory.cryopod * Inventory.conversions[
		Inventory.TrackedResources.Cryopod
	][Inventory.TrackedResources.Work] / by_time

	# Fisheries consume work
	work_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.TrackedResources.Fishery
	][Inventory.TrackedResources.Work] / by_time

	# Humans produce work
	work_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Work] / by_time

	# Humans produce work
	work_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Work] / by_time

	return work_per_time

## How many combined fishery and hyrdoponic stations can we make
func count_aquaponic() -> int:
	# Empty workstations
	if Inventory.fishery == 0 or Inventory.hydroponic == 0:
		return 0

	# No active fish or plants
	if Controller.resource.fish == 0 or Inventory.plant == 0:
		return 0

	return min(Inventory.fishery, Inventory.hydroponic)

## Reset inventory to initial state
func reset() -> void:
	Inventory.air = 10
	Inventory.battery = 0
	Inventory.bot = Inventory.starting_values[Inventory.TrackedResources.Bot]
	Inventory.cryopod = Inventory.starting_values[Inventory.TrackedResources.Cryopod]
	Inventory.energy = 10
	Inventory.energy_capacity = Inventory.starting_values[Inventory.TrackedResources.EnergyCapacity]
	Inventory.fish = 0
	Inventory.fishery = 0
	Inventory.food = 10
	Inventory.fuel = 5
	Inventory.fuel_burn_rate = 1
	Inventory.fusion_generator = 0
	Inventory.hydroponic = 0
	Inventory.human = Inventory.starting_values[Inventory.TrackedResources.Human]
	Inventory.money = Inventory.starting_values[Inventory.TrackedResources.Money]
	Inventory.oxygen_generator = 0
	Inventory.plant = 0
	Inventory.space_available = Inventory.starting_values[Inventory.TrackedResources.Space]
	Inventory.spare_part = 0
	Inventory.waste = 0
	Inventory.water = 10
	Inventory.water_generator = 0
	Inventory.work = 0
	Inventory.calculate_space()

	return

func use_resource(delta: float, resource: int) -> void:
	var quantity: float

	match resource:
		Inventory.TrackedResources.Air:
			quantity = Inventory.calculate_air_rate(delta)
			Inventory.air -= quantity
		Inventory.TrackedResources.Bot:
			Log.debug("Handled in the controller.")

			return
		Inventory.TrackedResources.Energy:
			quantity = Inventory.calculate_energy_rate(delta)
			Inventory.energy -= quantity
		Inventory.TrackedResources.Fish:
			quantity = Inventory.calculate_fish_rate(delta)
			Inventory.fish -= quantity
		Inventory.TrackedResources.Food:
			quantity = Inventory.calculate_food_rate(delta)
			Inventory.food -= quantity
		Inventory.TrackedResources.Fuel:
			quantity = Inventory.calculate_fuel_rate(delta)
			Inventory.fuel -= quantity
		Inventory.TrackedResources.Human:
			Log.debug("Handled in the controller.")

			return
		Inventory.TrackedResources.Plant:
			quantity = Inventory.calculate_plant_rate(delta)
			Inventory.plant -= quantity
		Inventory.TrackedResources.Waste:
			quantity = Inventory.calculate_waste_rate(delta)
			Inventory.waste -= quantity
		Inventory.TrackedResources.Water:
			quantity = Inventory.calculate_water_rate(delta)
			Inventory.water -= quantity
	Inventory.space_available += quantity * Inventory.required_space[resource]

	return
