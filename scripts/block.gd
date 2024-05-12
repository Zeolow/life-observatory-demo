extends Area3D

class_name Block

var globe_position: Vector3 = Vector3.ZERO
var grid_position: Vector3 = Vector3.ZERO
var move_speed: float = 28.0
var min_distance: float = 3.0

var on_grid: bool = true

@export var block_data: BlockData
@onready var globe_representation = $GlobeRepresentation

func _ready():
	var visual_object = block_data.visual_object.instantiate() 
	visual_object.name = "VisualObject"
	add_child(visual_object)
	
	var dup_mat = globe_representation.get_active_material(0).duplicate()
	dup_mat.albedo_color = block_data.color
	globe_representation.set_surface_override_material(0, dup_mat)
	#globe_representation.mesh.material.albedo_color = block_data.color
	
	
func _process(delta):
	if on_grid:
		if position.distance_to(grid_position) > 0.01:
			if block_data.type == 1:
				visible = true
			var new_pos = move_toward_v3(get_position(), grid_position, delta * move_speed)
			set_position(new_pos)
			$VisualObject.visible = true
			globe_representation.visible = false
	else:
		if position.distance_to(globe_position) > 0.01:
			if block_data.type == 1:
				visible = false
			var new_pos = move_toward_v3(get_position(), globe_position, delta * move_speed)
			#var move_away_vector = move_away_from_overlapping_areas()
			set_position(new_pos)
			$VisualObject.visible = false
			globe_representation.visible = true

#DOES NOT WORK YET, OUT OF SCOPE
func move_away_from_overlapping_areas() -> Vector3:
	var move_vector := Vector3.ZERO
	if get_overlapping_areas().size() > 0:
		for a in get_overlapping_areas():
			if a.get_position().distance_to(get_position()) > min_distance:
				move_vector += a.get_position().direction_to(get_position()).normalized() *0.01
	return move_vector

func move_toward_v3(v3_from: Vector3, v3_to: Vector3, delta: float) -> Vector3:
	var x = move_toward(v3_from.x, v3_to.x, delta)
	var y = move_toward(v3_from.y, v3_to.y, delta)
	var z = move_toward(v3_from.z, v3_to.z, delta)
	return Vector3(x,y,z)

func get_grid_position() -> Vector3:
	return grid_position

func set_grid_position(pos: Vector3) -> void:
	grid_position = pos

func get_globe_position() -> Vector3:
	return globe_position

func set_globe_position(pos: Vector3) -> void:
	globe_position = pos
	#var line_mesh = line(Vector3(0,0,0), pos)
	#print(line_mesh)
	#line_mesh.name = "Line3D"
	#line_mesh.set_global_position(Vector3(0,0,0))
	#add_child(line_mesh)

