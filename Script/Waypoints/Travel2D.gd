extends Node2D
## Travel2D controller

## Base X position for particle emitter
const EMITTER_X: int = 1200
## Base Y position for particle emitter
const EMITTER_Y: int = 170
## Base X position for ship
const SHIP_POS_X: int = 150
## Base X position for ship
const SHIP_POS_Y: int = 150

## Animation player
var anim_player: AnimationPlayer
## Particle emitter
var particles: CPUParticles2D
## Ship sprite
var ship: Sprite2D

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()
	self.update_for_scale()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	Config.scale_updated.connect(self.update_for_scale)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.anim_player = get_node("%AnimationPlayer")
	self.particles = get_node("%StarCPUParticles2D")
	self.ship = get_node("%ShipSprite2D")

	return

## Handle changes to the UI scale
func update_for_scale() -> void:
	var working: float = 1 / Config.ui_scale
	self.particles.emission_rect_extents = Vector2i(0, self.EMITTER_Y * working)
	self.particles.position = Vector2i(self.EMITTER_X * working, self.EMITTER_Y)
	self.ship.scale = Vector2(working, working)
	self.ship.position = Vector2(self.SHIP_POS_X, self.SHIP_POS_Y * pow(working, 2))

	return

## Set initial state for children in the scene
func set_the_children() -> void:

	return

