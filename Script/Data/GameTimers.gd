extends Node
## Game timers

## Base timer that triggers default processing
var base: Timer
var base_interval: float = 1
## Fish aging
var fish: Timer
var fish_interval: float = 10
## Food
var food: Timer
var food_interval: float = 10
## Fuel
var fuel: Timer
var fuel_interval: float = 60
## Random events
var random_bad: Timer
var random_good: Timer
var random_neutral: Timer

func configure_timers() -> void:
	self.configure_base_timer()
	self.configure_fish_timer()
	self.configure_food_timer()
	self.configure_fuel_timer()

	Log.verbose("Game timers configured")

	return

func configure_base_timer() -> void:
	self.base = Timer.new()
	self.base.name = "Base"
	add_child(self.base)
	self.base.autostart = true
	self.base.one_shot = false
	self.base.paused = false
	self.base.wait_time = self.base_interval
	self.base.call_deferred("start")
	self.base.timeout.connect(Controller.process_default_resources)

	return

func configure_fish_timer() -> void:
	self.fish = Timer.new()
	self.fish.name = "Fish"
	add_child(self.fish)
	self.fish.autostart = true
	self.fish.one_shot = false
	self.fish.paused = false
	self.fish.wait_time = self.fish_interval
	self.fish.call_deferred("start")
	self.fish.timeout.connect(Controller.process_resource.bind(Inventory.TrackedResources.Fish))

	return

func configure_food_timer() -> void:
	self.food = Timer.new()
	self.food.name = "Food"
	add_child(self.food)
	self.food.autostart = true
	self.food.one_shot = false
	self.food.paused = false
	self.food.wait_time = self.food_interval
	self.food.call_deferred("start")
	self.food.timeout.connect(Controller.process_resource.bind(Inventory.TrackedResources.Food))

	return

func configure_fuel_timer() -> void:
	self.fuel = Timer.new()
	self.fuel.name = "Fuel"
	add_child(self.fuel)
	self.fuel.autostart = true
	self.fuel.one_shot = false
	self.fuel.paused = false
	self.fuel.wait_time = self.fuel_interval
	self.fuel.call_deferred("start")
	self.fuel.timeout.connect(Controller.process_resource.bind(Inventory.TrackedResources.Fuel))

	return

func pause_all(paused: bool) -> void:
	self.base.set_paused(paused)
	self.fish.set_paused(paused)
	self.food.set_paused(paused)
	self.fuel.set_paused(paused)
#	self.random_bad.set_paused(paused)
#	self.random_good.set_paused(paused)
#	self.random_neutral.set_paused(paused)

	return
