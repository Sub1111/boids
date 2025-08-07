extends Node2D

var detector: Area2D
var flock_mates: Array[Node2D]

const max_speed := 10.0
const min_speed := 0.0
const max_steer_force := max_speed
const avoidance_radius := 1.

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
		flock_mates.append(fish_area.get_parent())
	
	acceleration += calculate_avoidance_force()
	
	velocity += acceleration
	var speed: float = velocity.length()
	var dir: Vector2 = velocity / speed
	speed = clamp(speed, min_speed, max_speed)
	velocity = dir * speed
	
	rotation = atan2(velocity.y, velocity.x)
	move(velocity, delta)



func move(velocity: Vector2, delta: float):
	position += velocity * delta * scale

func calculate_avoidance_force():
	var avg_dir: Vector2 = Vector2(0., 0.)
	var dir: Vector2
	
	for fish in flock_mates:
		dir = (position - fish.position)
		if dir.length() <= avoidance_radius * scale.x:
			avg_dir += (dir.normalized()) * (1 / (dir.length() + 1.))
	
	avg_dir *= max_steer_force
	avg_dir = avg_dir.normalized() * clamp(avg_dir.length(), 0., max_steer_force)
	
	return avg_dir
