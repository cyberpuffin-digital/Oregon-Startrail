extends Node
## Trade Market
##
## Manage and track market information for and between waypoints

## Base cost for resources
const base_cost: Dictionary = {
	Inventory.Type.Air: 0.1,
	Inventory.Type.Energy: 0.05,
	Inventory.Type.Fish: 2,
	Inventory.Type.Food: 2,
	Inventory.Type.Fuel: 10,
	Inventory.Type.Money: 1,
	Inventory.Type.Plant: 2,
	Inventory.Type.SparePart: 5,
	Inventory.Type.Waste: 1,
	Inventory.Type.Water: 5,
}

## Waypoint-specific fluctuations
const data: Dictionary = {
	Controller.Waypoint.Travel: {
		"multiplier": 2,
		"specials": [],
	},
	Controller.Waypoint.Earth: {
		"multiplier": 1,
		"specials": [
			Inventory.Type.Air,
			Inventory.Type.Fish,
			Inventory.Type.SparePart,
			Inventory.Type.Waste
		],
	},
	Controller.Waypoint.Moon: {
		"multiplier": 1.2,
		"specials": [
			Inventory.Type.Fuel
		],
	},
	Controller.Waypoint.Mars: {
		"multiplier": 1.4,
		"specials": [
			Inventory.Type.Energy,
			Inventory.Type.Waste
		],
	},
	Controller.Waypoint.Europa: {
		"multiplier": 1.5,
		"specials": [
			Inventory.Type.Fish,
			Inventory.Type.Food,
			Inventory.Type.Water,
		],
	},
	Controller.Waypoint.KuiperBelt: {
		"multiplier": 2,
		"specials": [
			Inventory.Type.Bot,
			Inventory.Type.SparePart
		],
	},
}

## Tracking dictionary for waypoint price fluctuations
var current_pricing: Dictionary
## Tracking dictionary for waypoint inventory.
var inventory: Dictionary

func _ready() -> void:
	Market.reset()

	return

## Calculate the cost of the requested resource for the waypoint
func calculate_resource_cost(
	resource: Inventory.Type, waypoint: Controller.Waypoint = Controller.current_waypoint
) -> float:
	if Market.current_pricing[resource] == 0:
		var current_cost: float = Market.base_cost[resource] * Market.data[waypoint]["multiplier"]
		if resource in Market.data[waypoint]["specials"]:
			current_cost *= randf_range(0.75, 0.9)
		Market.current_pricing[resource] = snappedf(current_cost, 0.001)

	return Market.current_pricing[resource]

## Check is there is a credit in the current waypoint
func has_credit(waypoint: int = Controller.current_waypoint) -> bool:

	return Market.inventory[waypoint][Inventory.Type.Money] < 0

## Remove resource from waypoint's market inventory
func remove_inventory(
	waypoint: Controller.Waypoint, resource: Inventory.Type, quantity: float
) -> void:
	if quantity == 0:
		return

	if Market.inventory[waypoint][resource] >= quantity:
		Market.inventory[waypoint][resource] -= quantity
		Log.verbose("Bots from %s transfer %s unit(s) of %s to the Space Wagon." % [
			Controller.Waypoint.keys()[waypoint], quantity,
			Inventory.Type.keys()[resource],
		])

		return
	Log.error("%s refuses to transfer %s unit(s) of %s to the Space Wagon." % [
		Controller.Waypoint.keys()[waypoint], quantity,
		Inventory.Type.keys()[resource],
	])

	return

## Reset Market to starting conditions
func reset() -> void:
	Market.reset_current_pricing()
	Market.inventory = {
		Controller.Waypoint.Travel: {
			Inventory.Type.Air: 0,
			Inventory.Type.Energy: 0,
			Inventory.Type.Fish: 0,
			Inventory.Type.Food: 0,
			Inventory.Type.Fuel: 0,
			Inventory.Type.Money: 0,
			Inventory.Type.Plant: 0,
			Inventory.Type.SparePart: 0,
			Inventory.Type.Waste: 0,
			Inventory.Type.Water: 0,
		},
		Controller.Waypoint.Earth: {
			Inventory.Type.Air: 10000,
			Inventory.Type.Energy: 1000,
			Inventory.Type.Fish: 1000,
			Inventory.Type.Food: 100,
			Inventory.Type.Fuel: 50,
			Inventory.Type.Money: -200,
			Inventory.Type.Plant: 1000,
			Inventory.Type.SparePart: 200,
			Inventory.Type.Waste: 10000,
			Inventory.Type.Water: 250,
		},
		Controller.Waypoint.Moon: {
			Inventory.Type.Air: 1000,
			Inventory.Type.Energy: 100,
			Inventory.Type.Fish: 5,
			Inventory.Type.Food: 10,
			Inventory.Type.Fuel: 500,
			Inventory.Type.Money: 5000,
			Inventory.Type.Plant: 5,
			Inventory.Type.SparePart: 100,
			Inventory.Type.Waste: 200,
			Inventory.Type.Water: 100
		},
		Controller.Waypoint.Mars: {
			Inventory.Type.Air: 2500,
			Inventory.Type.Energy: 500,
			Inventory.Type.Fish: 25,
			Inventory.Type.Food: 100,
			Inventory.Type.Fuel: 50,
			Inventory.Type.Money: 2500,
			Inventory.Type.Plant: 10,
			Inventory.Type.SparePart: 200,
			Inventory.Type.Waste: 0,
			Inventory.Type.Water: 100
		},
		Controller.Waypoint.Europa: {
			Inventory.Type.Air: 1000,
			Inventory.Type.Energy: 100,
			Inventory.Type.Fish: 100,
			Inventory.Type.Food: 100,
			Inventory.Type.Fuel: 25,
			Inventory.Type.Money: 1000,
			Inventory.Type.Plant: 10,
			Inventory.Type.SparePart: 10,
			Inventory.Type.Waste: 100,
			Inventory.Type.Water: 1000
		},
		Controller.Waypoint.KuiperBelt: {
			Inventory.Type.Air: 1000,
			Inventory.Type.Energy: 50,
			Inventory.Type.Fish: 10,
			Inventory.Type.Food: 25,
			Inventory.Type.Fuel: 10,
			Inventory.Type.Money: 500,
			Inventory.Type.Plant: 10,
			Inventory.Type.SparePart: 100,
			Inventory.Type.Waste: 100,
			Inventory.Type.Water: 100
		},
	}

## Reinitialize current market pricing
func reset_current_pricing() -> void:
	Market.current_pricing = {
		Inventory.Type.Air: 0,
		Inventory.Type.Energy: 0,
		Inventory.Type.Fish: 0,
		Inventory.Type.Food: 0,
		Inventory.Type.Fuel: 0,
		Inventory.Type.Money: 0,
		Inventory.Type.Plant: 0,
		Inventory.Type.SparePart: 0,
		Inventory.Type.Waste: 0,
		Inventory.Type.Water: 0,
	}

	return
