extends Node2D

var detector: Area2D
var max_speed := 10.0
var min_speed := 0.0

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector = get_child(2)
	velocity = max_speed * Vector2(cos(rotation), sin(rotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(velocity, delta)

func move(velocity: Vector2, delta: float):
	position += velocity * delta * scale
