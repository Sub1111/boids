extends Node2D

@export var speed: int = 1
var detector: Area2D
@export var separation_distance = 40 # minimum distance to another fish, in which this fish turns
var separation_rotation_speed = 20 # speed of rotation during separation
var alignment_rotation_speed = separation_rotation_speed / 2. # speed of rotation during alignment


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector = get_child(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = Vector2(cos(rotation), sin(rotation)) # normolized fish direction
	
	var detected_fish_areas: Array[Area2D] = detector.get_overlapping_areas()
	var detected_fish: Array[Node2D]
	for i in range(detected_fish_areas.size()):
		detected_fish.append(detected_fish_areas[i].get_parent())
	
	# Moving
	position += speed * delta * direction
	
	# Separation
	
	var separation_direction = Vector2(-direction.y, direction.x) # this fish direction rotated by 90 degrees
	for fish in detected_fish:
		var dist: Vector2 = fish.position - position
		if (dist.length() < separation_distance):
			rotation -= sign(dist.dot(separation_direction)) * separation_rotation_speed * delta
	"""
	#Alignment
	var sum_of_rotations: float = 0
	for fish in detected_fish:
		sum_of_rotations += fish.rotation
	if detected_fish.size() > 0:
		var avg_rotation: float = (sum_of_rotations) / (detected_fish.size())
		rotation += sign(avg_rotation - rotation) * alignment_rotation_speed * delta
	"""
