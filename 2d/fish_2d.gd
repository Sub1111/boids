extends Node2D

var detector: Area2D
var flockmates: Array[Node2D]

var avoidance_strength = 1.0
var alignment_strength = 1.0
var cohesion_strength = 1.0

const max_speed := 15.0
const min_speed := 2.0
const max_steer_force := max_speed / 3.
const forward_acceleration: float = max_speed / 2.
const avoidance_radius := 2.
const vision_cone_threshhold := -0.7

var velocity: Vector2
var acceleration: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector = get_child(2)
	velocity = (max_speed + min_speed) / 2. * Vector2(cos(rotation), sin(rotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acceleration = Vector2.ZERO
	flockmates = []
	for fish_area in detector.get_overlapping_areas():
		var fish = fish_area.get_parent()
		if in_vision_cone(fish.position):
			flockmates.append(fish)
	
	if flockmates.size() > 0:
		acceleration += calculate_avoidance_force()
		acceleration += calculate_alignment_force()
		acceleration += calculate_cohesion_force()
	
	velocity += acceleration
	var speed: float = velocity.length()
	var dir: Vector2 = velocity / speed
	if speed < (max_speed + min_speed) / 2.:
		speed += forward_acceleration * delta
	speed = clamp(speed, min_speed, max_speed)
	velocity = dir * speed
	
	
	rotation = atan2(velocity.y, velocity.x)
	move(velocity, delta)



func in_vision_cone(fish_pos: Vector2) -> bool:
	return (velocity.normalized().dot((fish_pos - position).normalized()) > vision_cone_threshhold)

func move(velocity: Vector2, delta: float) -> void:
	position += velocity * delta * scale

#================================================================================
# Forces
#================================================================================

# Avoidance
func calculate_avoidance_force() -> Vector2:
	var avg_dir: Vector2 = Vector2(0., 0.)
	var dir: Vector2
	
	for fish in flockmates:
		dir = (position - fish.position)
		if dir.length() <= avoidance_radius * scale.x:
			avg_dir += (dir.normalized()) * (1 / (dir.length() + 1.))
	
	avg_dir *= max_steer_force
	avg_dir = avg_dir.normalized() * clamp(avg_dir.length(), 0., max_steer_force)
	
	return avg_dir * avoidance_strength

# Alignment
func calculate_alignment_force() -> Vector2:
	var avg_dir: Vector2 = Vector2.ZERO
	
	for fish in flockmates:
		avg_dir += fish.velocity.normalized() * (1 / ((position - fish.position).length() + 1.))
	avg_dir *= max_steer_force
	avg_dir = avg_dir.normalized() * clamp(avg_dir.length(), 0., max_steer_force)
	
	return avg_dir * alignment_strength

# Cohesion
func calculate_cohesion_force() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	
	for fish in flockmates:
		offset += (fish.position - position).normalized() * (1 / ((position - fish.position).length() + 1.))
	offset /= flockmates.size()
	
	
	offset *= max_steer_force
	offset = offset.normalized() * clamp(offset.length(), 0., max_steer_force)
	
	return offset * cohesion_strength
	
