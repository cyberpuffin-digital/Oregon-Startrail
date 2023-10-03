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
	Repair,
	WaterGenerator,
}

## List of tracked resources
enum TrackedResources {
	Air,
	Aquaponic,
	Battery,
	Bot,
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
	Repair,
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
	Inventory.TrackedResources.Repair: {
		TrackedResources.Work: -1,
	},
	Inventory.TrackedResources.WaterGenerator: {
		TrackedResources.Water: 100,
		TrackedResources.Energy: -10,
	},
}
## Space usage
const space_use: Dictionary = {
	Inventory.TrackedResources.Air: 0.001,
	Inventory.TrackedResources.Battery: 2,
	Inventory.TrackedResources.Bot: 1,
	Inventory.TrackedResources.Cryopod: 4,
	Inventory.TrackedResources.Energy: 0,
	Inventory.TrackedResources.Fish: 0.1,
	Inventory.TrackedResources.Fishery: 10,
	Inventory.TrackedResources.Food: 0.1,
	Inventory.TrackedResources.Fuel: 1,
	Inventory.TrackedResources.FusionGenerator: 25,
	Inventory.TrackedResources.Human: 2,
	Inventory.TrackedResources.Hydroponic: 1,
	Inventory.TrackedResources.OxygenGenerator: 10,
	Inventory.TrackedResources.Plant: 0.1,
	Inventory.TrackedResources.SparePart: 10,
	Inventory.TrackedResources.Waste: 1,
	Inventory.TrackedResources.Water: 2,
	Inventory.TrackedResources.WaterGenerator: 10,
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
var fuel: int
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

	# Aquaponic adds air
	air_per_time += Controller.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Air] / by_time

	# Human consume air
	air_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Air] / by_time

	# Hydroponics add air
	air_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Air] / by_time

	# Oxygen generators creates air as fallback

	return air_per_time

## Calcuate Energy production / consumption based on time
func calculate_energy_rate(by_time: float) -> float:
	var energy_per_time: float = 0

	# Bots consume energy
	energy_per_time += Inventory.bot * Inventory.conversions[
		Inventory.TrackedResources.Bot
	][Inventory.TrackedResources.Energy] / by_time

	# Human consume air
	energy_per_time += Inventory.human * Inventory.conversions[
		Inventory.TrackedResources.Human
	][Inventory.TrackedResources.Energy] / by_time

	# Hydroponics add air
	energy_per_time += Inventory.cryopod * Inventory.conversions[
		Inventory.TrackedResources.Cryopod
	][Inventory.TrackedResources.Energy] / by_time

	# Fusion generators creates energy as fallback

	return energy_per_time

## Calcuate Fish production / consumption based on time
func calculate_fish_rate(by_time: float) -> float:
	var fish_per_time: float = 0

	# Aquaponic adds fish
	fish_per_time += Controller.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Fish] / by_time

	# Fisheries add fish
	fish_per_time += Inventory.fishery * Inventory.conversions[
		Inventory.TrackedResources.Fishery
	][Inventory.TrackedResources.Fish] / by_time

	return fish_per_time

## Calcuate Food production / consumption based on time
func calculate_food_rate(by_time: float) -> float:
	var food_per_time: float = 0

	# Aquaponics add food
	food_per_time += Controller.count_aquaponic() * Inventory.conversions[
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
func calculate_fuel_rate(_by_time: float) -> float:
	var fuel_per_time: float = 0

	return fuel_per_time

## Calcuate Plant production / consumption based on time
func calculate_plant_rate(by_time: float) -> float:
	var plant_per_time: float = 0

	# Aquaponics add plants
	plant_per_time += Controller.count_aquaponic() * Inventory.conversions[
		Inventory.TrackedResources.Aquaponic
	][Inventory.TrackedResources.Plant] / by_time

	# Hydroponics add plants
	plant_per_time += Inventory.hydroponic * Inventory.conversions[
		Inventory.TrackedResources.Hydroponic
	][Inventory.TrackedResources.Plant] / by_time

	return plant_per_time

## Calcuate Repair production / consumption based on time
func calculate_repair_rate(_by_time: float) -> float:
	var repair_per_time: float = 0

	return repair_per_time

## Calculate the amount of space currently used in the inventory
func calculate_space() -> void:
	var space_used: float = 0

	space_used += Inventory.air * Inventory.space_use[Inventory.TrackedResources.Air]
	space_used += Inventory.battery * Inventory.space_use[Inventory.TrackedResources.Battery]
	space_used += Inventory.bot * Inventory.space_use[Inventory.TrackedResources.Bot]
	space_used += Inventory.cryopod * Inventory.space_use[Inventory.TrackedResources.Cryopod]
	space_used += Inventory.fish * Inventory.space_use[Inventory.TrackedResources.Fish]
	space_used += Inventory.fishery * Inventory.space_use[Inventory.TrackedResources.Fishery]
	space_used += Inventory.food * Inventory.space_use[Inventory.TrackedResources.Food]
	space_used += Inventory.fuel * Inventory.space_use[Inventory.TrackedResources.Fuel]
	space_used += Inventory.fusion_generator * Inventory.space_use[Inventory.TrackedResources.FusionGenerator]
	space_used += Inventory.hydroponic * Inventory.space_use[Inventory.TrackedResources.Hydroponic]
	space_used += Inventory.human * Inventory.space_use[Inventory.TrackedResources.Human]
	space_used += Inventory.oxygen_generator * Inventory.space_use[Inventory.TrackedResources.OxygenGenerator]
	space_used += Inventory.plant * Inventory.space_use[Inventory.TrackedResources.Plant]
	space_used += Inventory.spare_part * Inventory.space_use[Inventory.TrackedResources.SparePart]
	space_used += Inventory.waste * Inventory.space_use[Inventory.TrackedResources.Waste]
	space_used += Inventory.water * Inventory.space_use[Inventory.TrackedResources.Water]
	space_used += Inventory.water_generator * Inventory.space_use[Inventory.TrackedResources.WaterGenerator]

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
	waste_per_time += Controller.count_aquaponic() * Inventory.conversions[
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
	water_per_time += Controller.count_aquaponic() * Inventory.conversions[
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
