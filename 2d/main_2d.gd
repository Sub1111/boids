extends Node2D

@export var fish_amount := 40
var fish_instance = preload("res://2d/fish_2d.tscn")

func _ready() -> void:
	for i in range(fish_amount):
		var pos: Vector2 = Vector2(randi_range(10, 1200), randi_range(10, 1200))
		var rot: float = randf_range(0, 360)
		inst(pos, rot)

func inst(pos: Vector2, rot: float):
	var fish: Node2D = fish_instance.instantiate()
	fish.position = pos
	fish.rotation = rot
	add_child(fish)
