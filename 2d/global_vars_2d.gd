extends Node

var is_colision_avoidance_enabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_colision_avoidance_enabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("colision_avoidance_switch"):
		is_colision_avoidance_enabled = !is_colision_avoidance_enabled
