extends Node

var is_colision_avoidance_enabled
var is_color_changing_enabled
var is_color_dependency_enabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_colision_avoidance_enabled = true
	is_color_changing_enabled = false
	is_color_dependency_enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("colision_avoidance_switch"):
		is_colision_avoidance_enabled = !is_colision_avoidance_enabled
	if event.is_action_released("color_changing_switch"):
		is_color_changing_enabled = !is_color_changing_enabled
	if event.is_action_released("color_denependency_switch"):
		is_color_dependency_enabled = !is_color_dependency_enabled
	
