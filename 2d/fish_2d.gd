extends Node2D

var detector: Area2D
var flockmates: Array[Node2D]

var avoidance_strength = 1.0
var alignment_strength = 1.0
var cohesion_strength = 1.0

const max_speed := 10.0
const min_speed := 3.0
const max_steer_force := max_speed / 3.
const forward_acceleration: float = max_speed / 2.

const avoidance_radius := 5.
const vision_cone_threshhold := -0.7
const vision_distance = 20.

const ray_direction_amount = 50
var ray_directions: Array[Vector2]
var ray: RayCast2D
var colision_avoid_strength = 20.

var velocity: Vector2
var acceleration: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector = get_child(2)
	velocity = (max_speed + min_speed) / 2. * Vector2(cos(rotation), sin(rotation))
	
	ray = get_child(3)
	ray.add_exception(get_child(0))
	ray_directions.resize(ray_direction_amount)
	calculate_ray_directions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acceleration = Vector2.ZERO
	flockmates = []
	for fish_area in detector.get_overlapping_areas():
		var fish = fish_area.get_parent()
		if in_vision_cone(fish.position) and fish.get_parent().name == "fish":
			flockmates.append(fish)
	
	if flockmates.size() > 0:
		acceleration += calculate_avoidance_force()
		acceleration += calculate_alignment_force()
		acceleration += calculate_cohesion_force()
	
	if is_heading_for_colision() and GlobalVars2d.is_colision_avoidance_enabled:
		acceleration += calculate_colision_avoid_force()
	
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
# Colision avoidance
#================================================================================

func calculate_ray_directions() -> void:
	var angle: float
	var t: float
	
	for i in range(ray_direction_amount):
		t = i / float(ray_direction_amount)
		angle = acos(1 - 2 * t)
		angle = -angle if i % 2 == 1 else angle
		ray_directions[i] = Vector2(cos(angle), sin(angle))

func is_heading_for_colision() -> bool:
	var colider: Area2D = ray.get_collider()
	
	if colider == null:
		return false
	if colider.get_parent().get_parent().name != "fish":
		return true
	return false

func get_colision_avoid_dir() -> Vector2:
	var fish_direction = velocity.normalized()
	var colider: Area2D
	for dir in ray_directions:
		ray.target_position = dir * vision_distance
		ray.force_raycast_update()
		colider = ray.get_collider()
		if colider == null:
			ray.target_position = Vector2(1 * vision_distance, 0)
			ray.force_raycast_update()
			# Converting local directon to global direction
			return Vector2(dir.x * fish_direction.x - dir.y * fish_direction.y, dir.x * fish_direction.y + dir.y * fish_direction.x)
	return fish_direction

func calculate_colision_avoid_force() -> Vector2:
	var dist: float = (position - ray.get_collision_point()).length()
	var dist_strength = 1 / (dist + 1)
	return ray.get_collision_normal() * max_steer_force * colision_avoid_strength * dist_strength

#================================================================================
# Flock forces
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
