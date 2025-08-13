extends Node2D

@export var fish_amount := 160
var fish_instance = preload("res://2d/fish_2d.tscn")
var fish_main_node: Node2D

func _ready() -> void:
	fish_main_node = get_child(2)
	for i in range(fish_amount):
		var pos: Vector2 = Vector2(randi_range(500, 1200), randi_range(500, 510))
		var rot: float = randf_range(0, 360)
		inst(pos, rot)

func inst(pos: Vector2, rot: float):
	var fish: Node2D = fish_instance.instantiate()
	fish.position = pos
	fish.rotation = rot
	fish_main_node.add_child(fish)
