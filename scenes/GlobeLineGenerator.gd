extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_lines_from_blocks(blocks: Array[Node]) -> void:
	for line in get_children(): #INEFFICIENT ONLY FOR DISPLAY
		line.queue_free()
	for b in blocks:
		if b.block_data.type != 1:
			var line = line(Vector3(0,0,0), b.globe_position)
			add_child(line)
		

func line(pos1: Vector3, pos2: Vector3, color = Color.GRAY) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immidiate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immidiate_mesh
	mesh_instance.cast_shadow = 0
	
	immidiate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immidiate_mesh.surface_add_vertex(pos1)
	immidiate_mesh.surface_add_vertex(pos2)
	immidiate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	return mesh_instance
