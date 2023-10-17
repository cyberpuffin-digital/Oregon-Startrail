extends Node
## Trade Market
##
## Manage and track market information for and between waypoints

## Base cost for resources
const base_cost: Dictionary = {
	Inventory.ShipResource.Air: 0.1,
	Inventory.ShipResource.Energy: 0.05,
	Inventory.ShipResource.Fish: 2,
	Inventory.ShipResource.Food: 2,
	Inventory.ShipResource.Fuel: 10,
	Inventory.ShipResource.Money: 1,
	Inventory.ShipResource.Plant: 2,
	Inventory.ShipResource.SparePart: 5,
	Inventory.ShipResource.Waste: 1,
	Inventory.ShipResource.Water: 5,
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
			Inventory.ShipResource.Air,
			Inventory.ShipResource.Fish,
			Inventory.ShipResource.SparePart,
			Inventory.ShipResource.Waste
		],
	},
	Controller.Waypoint.Moon: {
		"multiplier": 1.2,
		"specials": [
			Inventory.ShipResource.Fuel
		],
	},
	Controller.Waypoint.Mars: {
		"multiplier": 1.4,
		"specials": [
			Inventory.ShipResource.Energy,
			Inventory.ShipResource.Waste
		],
	},
	Controller.Waypoint.Europa: {
		"multiplier": 1.5,
		"specials": [
			Inventory.ShipResource.Fish,
			Inventory.ShipResource.Food,
			Inventory.ShipResource.Water,
		],
	},
	Controller.Waypoint.KuiperBelt: {
		"multiplier": 2,
		"specials": [
			Inventory.ShipResource.Bot,
			Inventory.ShipResource.SparePart
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
	resource: Inventory.ShipResource, waypoint: Controller.Waypoint = Controller.current_waypoint
) -> float:
	if Market.current_pricing[resource] == 0:
		var current_cost: float = Market.base_cost[resource] * Market.data[waypoint]["multiplier"]
		if resource in Market.data[waypoint]["specials"]:
			current_cost *= randf_range(0.75, 0.9)
		Market.current_pricing[resource] = snappedf(current_cost, 0.001)

	return Market.current_pricing[resource]

## Check is there is a credit in the current waypoint
func has_credit(waypoint: int = Controller.current_waypoint) -> bool:

	return Market.inventory[waypoint][Inventory.ShipResource.Money] < 0

## Remove resource from waypoint's market inventory
func remove_inventory(
	waypoint: Controller.Waypoint, resource: Inventory.ShipResource, quantity: float
) -> void:
	if quantity == 0:
		return

	if Market.inventory[waypoint][resource] >= quantity:
		Market.inventory[waypoint][resource] -= quantity
		Log.verbose("Bots from %s transfer %s unit(s) of %s to the Space Wagon." % [
			Controller.Waypoint.keys()[waypoint], quantity,
			Inventory.ShipResource.keys()[resource],
		])

		return
	Log.error("%s refuses to transfer %s unit(s) of %s to the Space Wagon." % [
		Controller.Waypoint.keys()[waypoint], quantity,
		Inventory.ShipResource.keys()[resource],
	])

	return

## Reset Market to starting conditions
func reset() -> void:
	Market.reset_current_pricing()
	Market.inventory = {
		Controller.Waypoint.Travel: {
			Inventory.ShipResource.Air: 0,
			Inventory.ShipResource.Energy: 0,
			Inventory.ShipResource.Fish: 0,
			Inventory.ShipResource.Food: 0,
			Inventory.ShipResource.Fuel: 0,
			Inventory.ShipResource.Money: 0,
			Inventory.ShipResource.Plant: 0,
			Inventory.ShipResource.SparePart: 0,
			Inventory.ShipResource.Waste: 0,
			Inventory.ShipResource.Water: 0,
		},
		Controller.Waypoint.Earth: {
			Inventory.ShipResource.Air: 10000,
			Inventory.ShipResource.Energy: 1000,
			Inventory.ShipResource.Fish: 1000,
			Inventory.ShipResource.Food: 100,
			Inventory.ShipResource.Fuel: 50,
			Inventory.ShipResource.Money: -200,
			Inventory.ShipResource.Plant: 1000,
			Inventory.ShipResource.SparePart: 200,
			Inventory.ShipResource.Waste: 10000,
			Inventory.ShipResource.Water: 250,
		},
		Controller.Waypoint.Moon: {
			Inventory.ShipResource.Air: 1000,
			Inventory.ShipResource.Energy: 100,
			Inventory.ShipResource.Fish: 5,
			Inventory.ShipResource.Food: 10,
			Inventory.ShipResource.Fuel: 500,
			Inventory.ShipResource.Money: 5000,
			Inventory.ShipResource.Plant: 5,
			Inventory.ShipResource.SparePart: 100,
			Inventory.ShipResource.Waste: 200,
			Inventory.ShipResource.Water: 100
		},
		Controller.Waypoint.Mars: {
			Inventory.ShipResource.Air: 2500,
			Inventory.ShipResource.Energy: 500,
			Inventory.ShipResource.Fish: 25,
			Inventory.ShipResource.Food: 100,
			Inventory.ShipResource.Fuel: 50,
			Inventory.ShipResource.Money: 2500,
			Inventory.ShipResource.Plant: 10,
			Inventory.ShipResource.SparePart: 200,
			Inventory.ShipResource.Waste: 0,
			Inventory.ShipResource.Water: 100
		},
		Controller.Waypoint.Europa: {
			Inventory.ShipResource.Air: 1000,
			Inventory.ShipResource.Energy: 100,
			Inventory.ShipResource.Fish: 100,
			Inventory.ShipResource.Food: 100,
			Inventory.ShipResource.Fuel: 25,
			Inventory.ShipResource.Money: 1000,
			Inventory.ShipResource.Plant: 10,
			Inventory.ShipResource.SparePart: 10,
			Inventory.ShipResource.Waste: 100,
			Inventory.ShipResource.Water: 1000
		},
		Controller.Waypoint.KuiperBelt: {
			Inventory.ShipResource.Air: 1000,
			Inventory.ShipResource.Energy: 50,
			Inventory.ShipResource.Fish: 10,
			Inventory.ShipResource.Food: 25,
			Inventory.ShipResource.Fuel: 10,
			Inventory.ShipResource.Money: 500,
			Inventory.ShipResource.Plant: 10,
			Inventory.ShipResource.SparePart: 100,
			Inventory.ShipResource.Waste: 100,
			Inventory.ShipResource.Water: 100
		},
	}

## Reinitialize current market pricing
func reset_current_pricing() -> void:
	Market.current_pricing = {
		Inventory.ShipResource.Air: 0,
		Inventory.ShipResource.Energy: 0,
		Inventory.ShipResource.Fish: 0,
		Inventory.ShipResource.Food: 0,
		Inventory.ShipResource.Fuel: 0,
		Inventory.ShipResource.Money: 0,
		Inventory.ShipResource.Plant: 0,
		Inventory.ShipResource.SparePart: 0,
		Inventory.ShipResource.Waste: 0,
		Inventory.ShipResource.Water: 0,
	}

	return
