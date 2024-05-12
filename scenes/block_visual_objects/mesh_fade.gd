extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		for g_child in child.get_children():
			for g_g_child in g_child.get_children():
				if g_g_child is GeometryInstance3D:
					g_g_child.transparency = 0.9;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
