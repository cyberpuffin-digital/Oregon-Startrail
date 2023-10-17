extends Node
## Game timers

enum GameTimer {
	Base,
	Fish,
	Food,
	Fuel,
	RandomBad,
	RandomGood,
	RandomNeutral,
	Water,
}
## Base timer that triggers default processing
var base: Timer
## Base timer interval in seconds
@export var base_interval: float = 1
## Fish aging
var fish: Timer
## Fish timer interval in seconds
@export var fish_interval: float = 10
## Food
var food: Timer
## Food timer interval in seconds
@export var food_interval: float = 10
## Fuel
var fuel: Timer
## Fuel timer interval in seconds
@export var fuel_interval: float = 60
## Random events
var random_bad: Timer
## Max time for bad random events randomized interval, in seconds
@export var random_bad_interval: float = 15
var random_good: Timer
## Max time for good random events randomized interval, in seconds
@export var random_good_interval: float = 10
var random_neutral: Timer
## Max time for neutral random events randomized interval, in seconds
@export var random_neutral_interval: float = 12.5
## Water
var water: Timer
## Water timer interval in seconds
@export var water_interval: float = 5

func _ready() -> void:
	Controller.register_timers(self)
	self.configure_timers()

	return

func configure_timers() -> void:
	self.configure_base_timer()
	self.configure_fish_timer()
	self.configure_food_timer()
	self.configure_fuel_timer()
	self.configure_random_bad_timer()
	self.configure_random_good_timer()
	self.configure_random_neutral_timer()
	self.configure_water_timer()

	Log.verbose("Game timers configured")

	return

## Configure Base timer for default resource processing
func configure_base_timer() -> void:
	self.base = Timer.new()
	self.base.name = "Base"
	add_child(self.base)
	self.base.autostart = true
	self.base.one_shot = false
	self.base.paused = false
	self.base.wait_time = self.base_interval
	self.base.call_deferred("start")
	self.base.timeout.connect(Controller.process_default_resources.bind(
		self.base_interval
	))

	return

## Configure Fish timer for fish processing
func configure_fish_timer() -> void:
	self.fish = Timer.new()
	self.fish.name = "Fish"
	add_child(self.fish)
	self.fish.autostart = true
	self.fish.one_shot = false
	self.fish.paused = false
	self.fish.wait_time = self.fish_interval
	self.fish.call_deferred("start")
	self.fish.timeout.connect(Controller.process_resource.bind(
		self.fish_interval, Inventory.Type.Fish
	))

	return

## Configure Food timer for food processing
func configure_food_timer() -> void:
	self.food = Timer.new()
	self.food.name = "Food"
	add_child(self.food)
	self.food.autostart = true
	self.food.one_shot = false
	self.food.paused = false
	self.food.wait_time = self.food_interval
	self.food.call_deferred("start")
	self.food.timeout.connect(Controller.process_resource.bind(
		self.food_interval, Inventory.Type.Food
	))

	return

## Configure Fuel timer for fuel processing
func configure_fuel_timer() -> void:
	self.fuel = Timer.new()
	self.fuel.name = "Fuel"
	add_child(self.fuel)
	self.fuel.autostart = true
	self.fuel.one_shot = false
	self.fuel.paused = false
	self.fuel.wait_time = self.fuel_interval
	self.fuel.call_deferred("start")
	self.fuel.timeout.connect(Controller.process_resource.bind(
		self.fuel_interval, Inventory.Type.Fuel
	))

	return

## Configure random bad events timer
func configure_random_bad_timer() -> void:
	self.random_bad = Timer.new()
	self.random_bad.name = "RandomBad"
	add_child(self.random_bad)
	self.random_bad.autostart = true
	self.random_bad.one_shot = false
	self.random_bad.paused = false
	self.random_bad.wait_time = self.random_interval(self.random_bad_interval)
	self.random_bad.call_deferred("start")
	self.random_bad.timeout.connect(Controller.random_event.bind(
		Controller.RandomEvent.Bad
	))

	return

## Configure random good events timer
func configure_random_good_timer() -> void:
	self.random_good = Timer.new()
	self.random_good.name = "RandomGood"
	add_child(self.random_good)
	self.random_good.autostart = true
	self.random_good.one_shot = false
	self.random_good.paused = false
	self.random_good.wait_time = self.random_interval(self.random_good_interval)
	self.random_good.call_deferred("start")
	self.random_good.timeout.connect(Controller.random_event.bind(
		Controller.RandomEvent.Good
	))

	return

## Configure random neutral events timer
func configure_random_neutral_timer() -> void:
	self.random_neutral = Timer.new()
	self.random_neutral.name = "RandomNeutral"
	add_child(self.random_neutral)
	self.random_neutral.autostart = true
	self.random_neutral.one_shot = false
	self.random_neutral.paused = false
	self.random_neutral.wait_time = self.random_interval(self.random_neutral_interval)
	self.random_neutral.call_deferred("start")
	self.random_neutral.timeout.connect(Controller.random_event.bind(
		Controller.RandomEvent.Neutral
	))

	return

## Configure Water timer for water processing
func configure_water_timer() -> void:
	self.water = Timer.new()
	self.water.name = "Water"
	add_child(self.water)
	self.water.autostart = true
	self.water.one_shot = false
	self.water.paused = false
	self.water.wait_time = self.water_interval
	self.water.call_deferred("start")
	self.water.timeout.connect(Controller.process_resource.bind(
		self.water_interval, Inventory.Type.Water
	))

	return

## Pause all game timers
func pause_all(paused: bool) -> void:
	self.base.set_paused(paused)
	self.fish.set_paused(paused)
	self.food.set_paused(paused)
	self.fuel.set_paused(paused)
	self.random_bad.set_paused(paused)
	self.random_good.set_paused(paused)
	self.random_neutral.set_paused(paused)
	self.water.set_paused(paused)

	return

## Random interval calculation to add a little spice to life
func random_interval(max_interval: float) -> float:
	return randf_range((max_interval * .75), max_interval)

## Reset all game timers
func reset() -> void:
	self.base.stop()
	self.fish.stop()
	self.food.stop()
	self.fuel.stop()
	self.random_bad.stop()
	self.random_bad.set_wait_time(
		self.random_interval(self.random_bad_interval)
	)
	self.random_good.stop()
	self.random_good.set_wait_time(
		self.random_interval(self.random_good_interval)
	)
	self.random_neutral.stop()
	self.random_neutral.set_wait_time(
		self.random_interval(self.random_neutral_interval)
	)
	self.water.stop()

	return
