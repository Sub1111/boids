extends MeshInstance2D

var flockmates: Array[Node2D]
var flockmates_avg_color: Color
var r: float
var g: float
var b: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flockmates = get_parent().flockmates
	r = modulate.r
	g = modulate.g
	b = modulate.b
	
	if flockmates.size() > 0 and GlobalVars2d.is_color_dependency_enabled:
		r = 0
		g = 0
		b = 0
		for fish in flockmates:
			var mesh_modulate: Color = fish.get_child(1).modulate
			r += mesh_modulate.r
			g += mesh_modulate.g
			b += mesh_modulate.b
		r /= flockmates.size()
		g /= flockmates.size()
		b /= flockmates.size()
	
	if GlobalVars2d.is_color_changing_enabled:
		modulate = Color(r + randf_range(-0.01,0.01), g + randf_range(-0.1,0.1), b + randf_range(-0.1,0.1), 1.)
	else:
		modulate = Color(r, g, b, 1.)
