extends Node
## Game timers

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
	self.get_the_children()
	self.connect_to_signals()
	self.configure_timers()

	return

func configure_timers() -> void:
	self.pause_all(false)
	self.start_all()
	Log.verbose("Game timers configured")

	return

## Connect to signals
func connect_to_signals() -> void:
	self.base.timeout.connect(Controller.process_default_resources.bind(
		self.base_interval
	))
	self.fish.timeout.connect(Controller.process_resource.bind(
		self.fish_interval, Inventory.Type.Fish
	))
	self.food.timeout.connect(Controller.process_resource.bind(
		self.food_interval, Inventory.Type.Food
	))
	self.fuel.timeout.connect(Controller.process_resource.bind(
		self.fuel_interval, Inventory.Type.Fuel
	))
	self.random_bad.timeout.connect(Controller.random_event.bind(
		Controller.RandomEvent.Bad
	))
	self.random_good.timeout.connect(Controller.random_event.bind(
		Controller.RandomEvent.Good
	))
	self.random_neutral.timeout.connect(Controller.random_event.bind(
		Controller.RandomEvent.Neutral
	))
	self.water.timeout.connect(Controller.process_resource.bind(
		self.water_interval, Inventory.Type.Water
	))

	return

## Get the timers in the GameWindow
func get_the_children() -> void:
	self.base = get_node("Base")
	self.fish = get_node("Fish")
	self.food = get_node("Food")
	self.fuel = get_node("Fuel")
	self.random_bad = get_node("RandomBad")
	self.random_good = get_node("RandomGood")
	self.random_neutral = get_node("RandomNeutral")
	self.water = get_node("Water")

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
	self.stop_all()
	self.set_wait_time()

	return

## Set wait intervals for all timers
func set_wait_time() -> void:
	self.base.set_wait_time(self.base_interval)
	self.fish.set_wait_time(self.fish_interval)
	self.food.set_wait_time(self.food_interval)
	self.fuel.set_wait_time(self.fuel_interval)
	self.random_bad.set_wait_time(
		self.random_interval(self.random_bad_interval)
	)
	self.random_good.set_wait_time(
		self.random_interval(self.random_good_interval)
	)
	self.random_neutral.set_wait_time(
		self.random_interval(self.random_neutral_interval)
	)
	self.water.set_wait_time(self.water_interval)

	return

## Start all timers
func start_all() -> void:
	self.base.call_deferred("start")
	self.fish.call_deferred("start")
	self.food.call_deferred("start")
	self.fuel.call_deferred("start")
	self.random_bad.call_deferred("start")
	self.random_good.call_deferred("start")
	self.random_neutral.call_deferred("start")
	self.water.call_deferred("start")

	return

## Stop all timers
func stop_all() -> void:
	self.base.stop()
	self.fish.stop()
	self.food.stop()
	self.fuel.stop()
	self.random_bad.stop()
	self.random_good.stop()
	self.random_neutral.stop()
	self.water.stop()

	return
