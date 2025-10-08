extends Node

var is_colision_avoidance_enabled
var is_color_changing_enabled
var is_color_dependency_enabled

var is_moving_enabled
var is_avoidance_enabled
var is_alignment_enabled
var is_cohesion_enabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_colision_avoidance_enabled = false
	is_color_changing_enabled = false
	is_color_dependency_enabled = false
	
	is_moving_enabled = false
	is_avoidance_enabled = false
	is_alignment_enabled = false
	is_cohesion_enabled = false


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
	
	if event.is_action_released("moving"):
		is_moving_enabled = !is_moving_enabled
	if event.is_action_released("avoidance"):
		is_avoidance_enabled = !is_avoidance_enabled
	if event.is_action_released("alignment"):
		is_alignment_enabled = !is_alignment_enabled
	if event.is_action_released("cohesion"):
		is_cohesion_enabled = !is_cohesion_enabled
	
	
