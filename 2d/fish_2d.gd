extends Node2D

var detector: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector = get_child(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
