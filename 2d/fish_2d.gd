extends Node2D

var detector: Area2D
var flock_mates: Array[Node2D]

var avoidance_strength = 1.0
var alignment_strength = 1.0

const max_speed := 10.0
const min_speed := 0.0
const max_steer_force := max_speed / 2.
const forward_acceleration: float = max_speed / 2.
const avoidance_radius := 1.
const vision_cone_threshhold := -0.7

var velocity: Vector2
var acceleration: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector = get_child(2)
	velocity = max_speed * Vector2(cos(rotation), sin(rotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acceleration = Vector2.ZERO
	flock_mates = []
	for fish_area in detector.get_overlapping_areas():
		var fish = fish_area.get_parent()
		if in_vision_cone(fish.position):
			flock_mates.append(fish)
	
	if flock_mates.size() > 0:
		acceleration += calculate_avoidance_force()
		acceleration += calculate_alignment_force()
	
	velocity += acceleration
	var speed: float = velocity.length()
	var dir: Vector2 = velocity / speed
	if speed < max_speed:
		speed += forward_acceleration * delta
	speed = clamp(speed, min_speed, max_speed)
	velocity = dir * speed
	
	
	rotation = atan2(velocity.y, velocity.x)
	move(velocity, delta)



func in_vision_cone(fish_pos: Vector2) -> bool:
	return (velocity.normalized().dot((fish_pos - position).normalized()) > vision_cone_threshhold)

func move(velocity: Vector2, delta: float) -> void:
	position += velocity * delta * scale

# Avoidance
func calculate_avoidance_force() -> Vector2:
	var avg_dir: Vector2 = Vector2(0., 0.)
	var dir: Vector2
	
	for fish in flock_mates:
		dir = (position - fish.position)
		if dir.length() <= avoidance_radius * scale.x:
			avg_dir += (dir.normalized()) * (1 / (dir.length() + 1.))
	
	avg_dir *= max_steer_force
	avg_dir = avg_dir.normalized() * clamp(avg_dir.length(), 0., max_steer_force)
	
	return avg_dir * avoidance_strength

# Alignment
# TODO: add dependency between distantion and impact of each fish
func calculate_alignment_force() -> Vector2:
	var avg_dir: Vector2 = Vector2.ZERO
	
	for fish in flock_mates:
		avg_dir += fish.velocity.normalized() * (1 / ((position - fish.position).length() + 1.))
	avg_dir *= max_steer_force
	avg_dir = avg_dir.normalized() * clamp(avg_dir.length(), 0., max_steer_force)
	
	return avg_dir * alignment_strength
