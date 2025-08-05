extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_top_area_entered(area: Area2D) -> void:
	var fish: Node2D = area.get_parent()
	fish.position.y += 1250


func _on_bottom_area_entered(area: Area2D) -> void:
	var fish: Node2D = area.get_parent()
	fish.position.y -= 1250


func _on_left_area_entered(area: Area2D) -> void:
	var fish: Node2D = area.get_parent()
	fish.position.x += 2050


func _on_right_area_entered(area: Area2D) -> void:
	var fish: Node2D = area.get_parent()
	fish.position.x -= 2050
