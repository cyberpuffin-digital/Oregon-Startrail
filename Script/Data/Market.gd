extends Node
## Market data

## Market rates
const data: Dictionary = {
	Controller.Waypoint.Travel: {
		"fluctuation": 0.25,
		"multiplier": 2,
		"specials": [],
	},
	Controller.Waypoint.Earth: {
		"fluctuation": 0,
		"multiplier": 1,
		"specials": [
			Inventory.TrackedResources.Air,
			Inventory.TrackedResources.Fish,
			Inventory.TrackedResources.SparePart,
			Inventory.TrackedResources.Waste
		],
	},
	Controller.Waypoint.Moon: {
		"fluctuation": 0.1,
		"multiplier": 1.2,
		"specials": [
			Inventory.TrackedResources.Fuel
		],
	},
	Controller.Waypoint.Mars: {
		"fluctuation": 0.2,
		"multiplier": 1.4,
		"specials": [
			Inventory.TrackedResources.Energy,
			Inventory.TrackedResources.Waste
		],
	},
	Controller.Waypoint.Europa: {
		"fluctuation": 0.4,
		"multiplier": 1.5,
		"specials": [
			Inventory.TrackedResources.Fish,
			Inventory.TrackedResources.Food,
			Inventory.TrackedResources.Water,
		],
	},
	Controller.Waypoint.KuiperBelt: {
		"fluctuation": 0.5,
		"multiplier": 2,
		"specials": [
			Inventory.TrackedResources.Bot,
			Inventory.TrackedResources.SparePart
		],
	},
}

## Market inventory at the various waystops
var inventory: Dictionary

func reset() -> void:
	self.inventory = {
		Controller.Waypoint.Travel: {
			Inventory.TrackedResources.Air: 0,
			Inventory.TrackedResources.Energy: 0,
			Inventory.TrackedResources.Fish: 0,
			Inventory.TrackedResources.Food: 0,
			Inventory.TrackedResources.Fuel: 0,
			Inventory.TrackedResources.Money: 0,
			Inventory.TrackedResources.Plant: 0,
			Inventory.TrackedResources.SparePart: 0,
			Inventory.TrackedResources.Waste: 0,
			Inventory.TrackedResources.Water: 0,
		},
		Controller.Waypoint.Earth: {
			Inventory.TrackedResources.Air: 100,
			Inventory.TrackedResources.Energy: 1000,
			Inventory.TrackedResources.Fish: 1000,
			Inventory.TrackedResources.Food: 100,
			Inventory.TrackedResources.Fuel: 50,
			Inventory.TrackedResources.Money: 10000,
			Inventory.TrackedResources.Plant: 1000,
			Inventory.TrackedResources.SparePart: 200,
			Inventory.TrackedResources.Waste: 10000,
			Inventory.TrackedResources.Water: 250,
		},
		Controller.Waypoint.Moon: {
			Inventory.TrackedResources.Air: 10,
			Inventory.TrackedResources.Energy: 100,
			Inventory.TrackedResources.Fish: 5,
			Inventory.TrackedResources.Food: 10,
			Inventory.TrackedResources.Fuel: 500,
			Inventory.TrackedResources.Money: 5000,
			Inventory.TrackedResources.Plant: 5,
			Inventory.TrackedResources.SparePart: 100,
			Inventory.TrackedResources.Waste: 200,
			Inventory.TrackedResources.Water: 100
		},
		Controller.Waypoint.Mars: {
			Inventory.TrackedResources.Air: 25,
			Inventory.TrackedResources.Energy: 500,
			Inventory.TrackedResources.Fish: 25,
			Inventory.TrackedResources.Food: 100,
			Inventory.TrackedResources.Fuel: 50,
			Inventory.TrackedResources.Money: 2500,
			Inventory.TrackedResources.Plant: 10,
			Inventory.TrackedResources.SparePart: 200,
			Inventory.TrackedResources.Waste: 0,
			Inventory.TrackedResources.Water: 100
		},
		Controller.Waypoint.Europa: {
			Inventory.TrackedResources.Air: 25,
			Inventory.TrackedResources.Energy: 100,
			Inventory.TrackedResources.Fish: 100,
			Inventory.TrackedResources.Food: 100,
			Inventory.TrackedResources.Fuel: 25,
			Inventory.TrackedResources.Money: 1000,
			Inventory.TrackedResources.Plant: 10,
			Inventory.TrackedResources.SparePart: 10,
			Inventory.TrackedResources.Waste: 100,
			Inventory.TrackedResources.Water: 1000
		},
		Controller.Waypoint.KuiperBelt: {
			Inventory.TrackedResources.Air: 10,
			Inventory.TrackedResources.Energy: 50,
			Inventory.TrackedResources.Fish: 10,
			Inventory.TrackedResources.Food: 25,
			Inventory.TrackedResources.Fuel: 10,
			Inventory.TrackedResources.Money: 500,
			Inventory.TrackedResources.Plant: 10,
			Inventory.TrackedResources.SparePart: 100,
			Inventory.TrackedResources.Waste: 100,
			Inventory.TrackedResources.Water: 100
		},
	}
