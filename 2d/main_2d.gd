extends Node2D

@export var fish_amount := 160
var fish_instance = preload("res://2d/fish_2d.tscn")
var fish_main_node: Node2D
var first_fish: Node2D

func _ready() -> void:
	fish_main_node = get_child(2)
	for i in range(fish_amount):
		var pos: Vector2 = Vector2(randi_range(100, 1820), randi_range(50, 1030))
		var rot: float = randf_range(0, 360)
		inst(pos, rot)
	first_fish = fish_main_node.get_child(2)

func inst(pos: Vector2, rot: float):
	var fish: Node2D = fish_instance.instantiate()
	fish.position = pos
	fish.rotation = rot
	fish_main_node.add_child(fish)

func _input(event: InputEvent) -> void:
	if event.is_action_released("light_fisrst_one"):
		var mesh: MeshInstance2D = first_fish.get_child(1)
		mesh.modulate = "#ff2c4e"
