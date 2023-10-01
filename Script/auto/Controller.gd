extends Node
## Game controller

## Waypoints found along the way, corresponds to list of tabs in GameWindow
enum Waypoint {
	## Travelling between waypoints
	Travel,
	## Starting position
	Earth,
	## Earth's moon
	Moon,
	## The red planet
	Mars,
	## Jupiter's moon with lots of ice
	Europa,
	## Last part of the solar system where a station could be placed
	KuiperBelt,
	## Destination planet
	Wolf1061c,
}

## Ready to start playing
signal ready_to_start
## Show Options dialog
signal show_options_dialog

## Current waypoint
var current_waypoint: int
## Most recent waypoint
var last_waypoint: int
## Next target waypoint
var next_waypoint: int
## Game resources
var resources: GameResources
## Current state of travel
var travel_state: int
## Show current travel time total
var travel_time
## Countdown until arrival at waypoint
var travel_timer: float

## Handle Controller actions when arriving at a waypoint
func arrive_at_waypoint() -> void:
	Controller.travel_state = State.Stopped_At_Waypoint
	Controller.current_waypoint = Controller.next_waypoint

	return

## Calcuate Air production / consumption based on time
func calculate_air_rate(by_time: float) -> float:
	var air_per_time: float = 0

	# Aquaponic adds air
	air_per_time += Controller.count_aquaponic() * Controller.resources.conversions[
		Controller.resources.Converters.Aquaponic
	][Controller.resources.TrackedResources.Air] / by_time

	# Human consume air
	air_per_time += Controller.resources.human * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Air] / by_time

	# Hydroponics add air
	air_per_time += Controller.resources.hydroponic * Controller.resources.conversions[
		Controller.resources.Converters.Hydroponic
	][Controller.resources.TrackedResources.Air] / by_time

	# Oxygen generators creates air as fallback

	return air_per_time

## Calcuate Energy production / consumption based on time
func calculate_energy_rate(by_time: float) -> float:
	var energy_per_time: float = 0

	# Bots consume energy
	energy_per_time += Controller.resources.bot * Controller.resources.conversions[
		Controller.resources.Converters.Bot
	][Controller.resources.TrackedResources.Energy] / by_time

	# Human consume air
	energy_per_time += Controller.resources.human * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Energy] / by_time

	# Hydroponics add air
	energy_per_time += Controller.resources.cryopod * Controller.resources.conversions[
		Controller.resources.Converters.CryoPod
	][Controller.resources.TrackedResources.Energy] / by_time

	# Fusion generators creates energy as fallback

	return energy_per_time

## Calcuate Fish production / consumption based on time
func calculate_fish_rate(by_time: float) -> float:
	var fish_per_time: float = 0

	# Aquaponic adds fish
	fish_per_time += Controller.count_aquaponic() * Controller.resources.conversions[
		Controller.resources.Converters.Aquaponic
	][Controller.resources.TrackedResources.Fish] / by_time

	# Fisheries add fish
	fish_per_time += Controller.resources.fishery * Controller.resources.conversions[
		Controller.resources.Converters.Fishery
	][Controller.resources.TrackedResources.Fish] / by_time

	return fish_per_time

## Calcuate Food production / consumption based on time
func calculate_food_rate(by_time: float) -> float:
	var food_per_time: float = 0

	# Aquaponics add food
	food_per_time += Controller.count_aquaponic() * Controller.resources.conversions[
		Controller.resources.Converters.Aquaponic
	][Controller.resources.TrackedResources.Food] / by_time

	# Fisheries add food
	food_per_time += Controller.resources.bot * Controller.resources.conversions[
		Controller.resources.Converters.Fishery
	][Controller.resources.TrackedResources.Food] / by_time

	# Humans eat food
	food_per_time += Controller.resources.bot * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Food] / by_time

	# Hydroponics add food
	food_per_time += Controller.resources.bot * Controller.resources.conversions[
		Controller.resources.Converters.Hydroponic
	][Controller.resources.TrackedResources.Food] / by_time

	return food_per_time

## Calcuate Fuel production / consumption based on time
func calculate_fuel_rate(by_time: float) -> float:
	var fuel_per_time: float = 0

	return fuel_per_time

## Calcuate Plant production / consumption based on time
func calculate_plant_rate(by_time: float) -> float:
	var plant_per_time: float = 0

	# Aquaponics add plants
	plant_per_time += Controller.count_aquaponic() * Controller.resources.conversions[
		Controller.resources.Converters.Aquaponic
	][Controller.resources.TrackedResources.Plant] / by_time

	# Hydroponics add plants
	plant_per_time += Controller.resources.hydroponic * Controller.resources.conversions[
		Controller.resources.Converters.Hydroponic
	][Controller.resources.TrackedResources.Plant] / by_time

	return plant_per_time

## Calcuate Repair production / consumption based on time
func calculate_repair_rate(by_time: float) -> float:
	var repair_per_time: float = 0

	return repair_per_time

## Calcuate Waste production / consumption based on time
func calculate_waste_rate(by_time: float) -> float:
	var waste_per_time: float

	# Aquaponic consume waste
	waste_per_time += Controller.count_aquaponic() * Controller.resources.conversions[
		Controller.resources.Converters.Aquaponic
	][Controller.resources.TrackedResources.Waste] / by_time

	# Fisheries produce waste
	waste_per_time += Controller.resources.human * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Waste] / by_time

	# Humans produce waste
	waste_per_time += Controller.resources.human * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Waste] / by_time

	# Hydroponics consume waste
	waste_per_time += Controller.resources.hydroponic * Controller.resources.conversions[
		Controller.resources.Converters.Hydroponic
	][Controller.resources.TrackedResources.Waste] / by_time

	return waste_per_time

## Calcuate Water production / consumption based on time
func calculate_water_rate(by_time: float) -> float:
	var water_per_time: float

	# Aquaponic consumes water
	water_per_time += Controller.count_aquaponic() * Controller.resources.conversions[
		Controller.resources.Converters.Aquaponic
	][Controller.resources.TrackedResources.Water] / by_time

	# Fisheries consume water
	water_per_time += Controller.resources.fishery * Controller.resources.conversions[
		Controller.resources.Converters.Fishery
	][Controller.resources.TrackedResources.Water] / by_time

	# Humans consume water
	water_per_time += Controller.resources.human * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Water] / by_time

	# Hydroponics consume water
	water_per_time += Controller.resources.hydroponic * Controller.resources.conversions[
		Controller.resources.Converters.Hydroponic
	][Controller.resources.TrackedResources.Water] / by_time

	return water_per_time

## Calcuate Work production / consumption based on time
func calculate_work_rate(by_time: float) -> float:
	var work_per_time: float

	# Bots produce work
	work_per_time += Controller.resources.bot * Controller.resources.conversions[
		Controller.resources.Converters.Bot
	][Controller.resources.TrackedResources.Work] / by_time

	# CryoPods consume work
	work_per_time += Controller.resources.cryopod * Controller.resources.conversions[
		Controller.resources.Converters.CryoPod
	][Controller.resources.TrackedResources.Work] / by_time

	# Fisheries consume work
	work_per_time += Controller.resources.fishery * Controller.resources.conversions[
		Controller.resources.Converters.Fishery
	][Controller.resources.TrackedResources.Work] / by_time

	# Humans produce work
	work_per_time += Controller.resources.human * Controller.resources.conversions[
		Controller.resources.Converters.Human
	][Controller.resources.TrackedResources.Work] / by_time

	# Humans produce work
	work_per_time += Controller.resources.hydroponic * Controller.resources.conversions[
		Controller.resources.Converters.Hydroponic
	][Controller.resources.TrackedResources.Work] / by_time

	return work_per_time

## Calculate the time to arrive at the next waypoint
func calculate_travel_time() -> void:
	Controller.travel_time = 1
	Controller.travel_timer = 1

	return

## How many combined fishery and hyrdoponic stations can we make
func count_aquaponic() -> int:
	# Empty workstations
	if Controller.resources.fishery == 0 or Controller.resources.hydroponic == 0:
		return 0

	# No active fish or plants
	if Controller.resource.fish == 0 or Controller.resources.plant == 0:
		return 0

	return min(Controller.resources.fishery, Controller.resources.hydroponic)

## Handle Controller actions when departing a waypoint
func depart_waypoint() -> void:
	Controller.travel_state = State.Traveling
	Controller.last_waypoint = Controller.current_waypoint
	Controller.next_waypoint = clampi(
		Controller.current_waypoint + 1, 0, Controller.Waypoint.size()
	)
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.calculate_travel_time()

	return

## Reset Controller to initial state
func reset() -> void:
	Controller.current_waypoint = Controller.Waypoint.Travel
	Controller.last_waypoint = Controller.Waypoint.Travel
	Controller.next_waypoint = Controller.Waypoint.Earth
	Controller.travel_state = State.Traveling
	if !Controller.resources:
		Controller.resources = GameResources.new()
	Controller.resources.reset()

	return

## Clean up and return to main menu
func return_to_main_menu(reset_controller: bool = false) -> void:
	if reset_controller:
		Controller.reset()
	Log.clear_message_queue()
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")

	return

## Send signal to show options menu
func show_options() -> void:
	show_options_dialog.emit()

	return

## Clear Controller and signal ready to start
func start_new_game() -> void:
	Controller.reset()
	Controller.ready_to_start.emit()

	return

## Pause game processing
func toggle_pause_game() -> void:
	get_tree().paused = !get_tree().paused
	Log.verbose("Game %saused" % ["P" if get_tree().paused else "Unp"])

	return

## Resources tracked in game
##
## Data object for resources to be tracked
class GameResources:
	extends Node

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

	## List of resources with values in the starting_values dictionary
	enum StartingValues {
		Bot,
		CryoPod,
		EnergyCapacity,
		Human,
		Money,
		Space,
	}

	## List of tracked resources
	enum TrackedResources {
		Air,
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
		Space,
		SparePart,
		Waste,
		Water,
		WaterGenerator,
		Work
	}

	## Oxygen for active humans
	var air: float
	## Energy storage device
	var battery: int
	## Worker bots
	var bot: int
	## Conversion dictionary
	var conversions: Dictionary = {
		Converters.Aquaponic: {
			TrackedResources.Air: 10,
			TrackedResources.Plant: 5,
			TrackedResources.Fish: 5,
			TrackedResources.Waste: -2,
			TrackedResources.Water: -1,
			TrackedResources.Food: 5,
		},
		Converters.Battery: {
			TrackedResources.Space: -10,
			TrackedResources.EnergyCapacity: 100,
		},
		Converters.Bot: {
			TrackedResources.Energy: -1,
			TrackedResources.Work: 1,
		},
		Converters.CryoPod: {
			TrackedResources.Energy: -1,
			TrackedResources.Work: -1,
		},
		Converters.Fishery: {
			TrackedResources.Fish: 5,
			TrackedResources.Food: 5,
			TrackedResources.Waste: 1,
			TrackedResources.Water: -1,
			TrackedResources.Work: -1,
		},
		Converters.FusionGenerator: {
			TrackedResources.Fuel: -1,
			TrackedResources.Energy: 100,
		},
		Converters.Human: {
			TrackedResources.Air: -2,
			TrackedResources.Energy: 2,
			TrackedResources.Food: -2,
			TrackedResources.Waste: 2,
			TrackedResources.Water: -2,
			TrackedResources.Work: 5,
		},
		Converters.Hydroponic: {
			TrackedResources.Air: 5,
			TrackedResources.Food: 5,
			TrackedResources.Plant: 5,
			TrackedResources.Waste: -1,
			TrackedResources.Water: -2,
			TrackedResources.Work: -1,
		},
		Converters.OxygenGenerator: {
			TrackedResources.Air: 100,
			TrackedResources.Energy: -10,
		},
		Converters.Repair: {
			TrackedResources.Work: -1,
		},
		Converters.WaterGenerator: {
			TrackedResources.Water: 100,
			TrackedResources.Energy: -10,
		},
	}
	## Inactive humands
	var cryopod: int
	## Electricty
	var energy: float
	## Capacity of energy storage
	var energy_capacity: float
	## Active fish
	var fish: int
	## Fishery to process fish
	var fishery: int
	## Food for active humans
	var food: int
	## Fuel to power energy generators and propulsion
	var fuel: int
	## Fusion generator: consumes fuel, produces energy
	var fusion_generator: int
	## Hydroponic gardens to tend plants
	var hydroponic: int
	## Active human workers
	var human: int
	## Cash for trade
	var money: float
	## Oxygen generator: consumes energy, produces oxygen
	var oxygen_generator: int
	## Plants to grow for food and air
	var plant: int
	## Available space for stuff
	var space: float
	## Spare parts for repairs
	var spare_part: int
	## Starting values
	var starting_values: Dictionary = {
		StartingValues.Bot: 1,
		StartingValues.CryoPod: 100,
		StartingValues.EnergyCapacity: 100,
		StartingValues.Human: 5,
		StartingValues.Money: 1000,
		StartingValues.Space: 1000,
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
		bots_in: int = self.starting_values[StartingValues.Bot],
		cryopod_in: int = self.starting_values[StartingValues.CryoPod],
		energy_capacity_in: int = self.starting_values[StartingValues.EnergyCapacity],
		humans_in: int = self.starting_values[StartingValues.Human],
		money_in: int = self.starting_values[StartingValues.Money],
		space_in: int = self.starting_values[StartingValues.Space],
	) -> void:
		self.starting_values[StartingValues.Bot] = bots_in
		self.starting_values[StartingValues.CryoPod] = cryopod_in
		self.starting_values[StartingValues.EnergyCapacity] = energy_capacity_in
		self.starting_values[StartingValues.Human] = humans_in
		self.starting_values[StartingValues.Money] = money_in
		self.starting_values[StartingValues.Space] = space_in

		return

	func reset() -> void:
		self.air = 0
		self.battery = 0
		self.bot = self.starting_values[StartingValues.Bot]
		self.cryopod = self.starting_values[StartingValues.CryoPod]
		self.energy = 0
		self.energy_capacity = self.starting_values[StartingValues.EnergyCapacity]
		self.fish = 0
		self.fishery = 0
		self.food = 0
		self.fuel = 0
		self.fusion_generator = 0
		self.hydroponic = 0
		self.human = self.starting_values[StartingValues.Human]
		self.money = self.starting_values[StartingValues.Money]
		self.oxygen_generator = 0
		self.plant = 0
		self.space = self.starting_values[StartingValues.Space]
		self.spare_part = 0
		self.waste = 0
		self.water = 0
		self.water_generator = 0
		self.work = 0

		return
