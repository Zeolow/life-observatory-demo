extends Node3D

var block_scene = preload("res://scenes/block.tscn")
var selected_block: BlockData
var hovered_block: BlockData
var mouse_over_UI : bool = false
var block_data_in_world: Array[BlockData]
var grid_is_small = false
var globe_view_on = false
var data_view_on = false
var camera_zoomed_in = true

@export var limit_block_to_grid: bool = true

@export_category("BlockData")
@export var block_data: Array[BlockData]

@onready var blocks = $Blocks
@onready var HUD = $HUD
@onready var dataViewer = $DataViewer
@onready var bigGrid = $StaticBody3D/BigGrid
@onready var smallGrid = $StaticBody3D/SmallGrid
@onready var globeMap = $GlobeMap
@onready var dataViewToggle = $HUD/RightPanel/VBoxContainer2/DataViewer/DataViewer
@onready var gridSizeToggle = $HUD/RightPanel/VBoxContainer2/GridSize/GridSize
@onready var camera = $CameraParent/Camera3D
@onready var animator = $AnimationPlayer

#TODO
#block mouse on UI
#interface block data with UI
#create block_select UI
#block info square
#data view (?)

func _ready():
	globeMap.visible = false
	HUD.create_food_items(block_data)
	selected_block = block_data[0]
	bigGrid.visible = false
	dataViewer.visible = false


func _process(delta):
	handle_block_placement()
	
	var m_pos = get_viewport().get_mouse_position()
	if m_pos.x > 600 and m_pos.x < 3300 and mouse_over_UI:
		mouse_over_UI = false
	elif not mouse_over_UI:
		mouse_over_UI = true
	
	if Input.is_action_just_pressed("data_view_toggle") and not globe_view_on:
		data_view_on = !data_view_on
		_on_data_viewer_toggled(data_view_on)
	if Input.is_action_just_pressed("globe_view_toggle"):
		globe_view_on = !globe_view_on
		_on_globe_view_toggled(globe_view_on)
	
	if camera.size > 15.0 and camera_zoomed_in:
		print("camera zoomed out")
		camera_zoomed_in = false
		animator.play("fade_in_grid")
		toggle_forests(true)
	if camera.size < 15.0 and not camera_zoomed_in:
		print("camera zoomed in")
		camera_zoomed_in = true
		animator.play("fade_out_grid")
		toggle_forests(false)
		

func toggle_forests(on:bool) -> void:
	for block in blocks.get_children():
		if block.block_data.type == 1:
			block.visible = on

func handle_block_placement() -> void:
	var mouse_pos = screen_point_to_ray()
	var mouse_grid_pos = pos_to_grid_pos(mouse_pos)
	if limit_block_to_grid:
		if check_pos_within_area(mouse_grid_pos, grid_is_small):
			$grid_marker.visible = true
			$grid_marker.set_position(mouse_grid_pos)
			check_create_block(mouse_grid_pos)
		else:
			$grid_marker.visible = false
	else:
		if not mouse_over_UI and not globe_view_on:
			$grid_marker.visible = true
			$grid_marker.set_position(mouse_grid_pos)
			check_create_block(mouse_grid_pos)
		else:
			$grid_marker.visible = false

func check_pos_within_area(pos: Vector3, is_small: bool = true) -> bool:
	if globe_view_on:
		return false
	
	if is_small:
		if not abs(pos.x) > 5.0 and not abs(pos.z) > 5.0:
			return true
		else:
			return false
	else:
		if not abs(pos.x) > 11.0 and not abs(pos.z) > 11.0:
			return true
		else:
			return false

func check_create_block(pos) -> void:
	if Input.is_action_pressed("create_block") and not mouse_over_UI:
		if not check_block_exists(pos):
			instance_block(pos, selected_block)
	if Input.is_action_pressed("remove_block"):
		check_block_exists(pos, true)

func check_block_exists(pos, delete = false) -> bool:
	var block_exists = false
	for b in blocks.get_children():
		if b.get_position() == pos:
			block_exists = true
			if delete:
				delete_block(b)
				$GlobeLineGenerator.generate_lines_from_blocks(blocks.get_children())
			break
	return block_exists

func instance_block(pos, block_data: BlockData) -> void:
	var instance = block_scene.instantiate()
	instance.block_data = block_data
	instance.set_position(pos)
	instance.set_grid_position(pos)
	instance.set_globe_position(globeMap.get_rand_pos())
	block_data_in_world.append(block_data)
	blocks.add_child(instance)
	$GlobeLineGenerator.generate_lines_from_blocks(blocks.get_children())
	
	update_output_data()
	set_target_array_data(pos, block_data.co2)

func set_target_array_data(pos: Vector3, data: float) -> void:
	if check_pos_within_area(pos, false):
		var i = pos_to_index(pos)
		var target_array = dataViewer.get_influence_array().duplicate()
		target_array[i] = data
		dataViewer.set_target_array(target_array)

func pos_to_index(pos:Vector3) -> int:
	var remaped_pos_x = remap(pos.x,-10,10,0,10)
	var remaped_pos_y = remap(pos.z,-10, 10, 0,10)
	
	var index: int = int(remaped_pos_y*11.0 + remaped_pos_x)
	return index

func delete_block(block: Block):
	block_data_in_world.erase(block.block_data) # might cause errors
	block.queue_free()
	update_output_data()
	set_target_array_data(block.position, 0.0)

func update_output_data():
	HUD.set_output_data(block_data_in_world)
	print("setting output data")

func update_info_data(block: BlockData, is_info: bool):
	HUD.set_info_data(block, is_info)

func check_block_pos(pos) -> void:
	#checks if pos is taken or not by looping through blocks.get_children() (pos)
	#if not taken, instance block on pos
	pass

func pos_to_grid_pos(pos) -> Vector3:
	var scaled_pos = pos / 2.0
	scaled_pos = round(scaled_pos)
	var grid_pos = scaled_pos  * 2.0
	return grid_pos

func screen_point_to_ray() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * 200
	var ray_query = PhysicsRayQueryParameters3D.create(ray_from,ray_to)
	
	# could check by looping blocks and using pos also
	var ray_area_query = PhysicsRayQueryParameters3D.create(ray_from,ray_to)
	ray_area_query.collide_with_areas = true
	ray_area_query.collide_with_bodies = false
	var area_collision = space_state.intersect_ray(ray_area_query)
	if area_collision.has("collider"):
		if hovered_block != area_collision["collider"].block_data:
			update_info_data(area_collision["collider"].block_data, true) #many calls (maybe bad)
	else:
		update_info_data(selected_block, false)
	
	var result = space_state.intersect_ray(ray_query)
	if result.has("position"):
		return result["position"]
	return Vector3()

func toggle_block_pos(on_grid: bool) -> void:
	for block in blocks.get_children():
		block.on_grid = on_grid

func _on_panel_mouse_entered():
	mouse_over_UI = true

func _on_panel_mouse_exited():
	mouse_over_UI = false

func _on_hud_food_item_selected(item_name):
	for block in block_data:
		if block.item == item_name:
			selected_block = block
	HUD.set_info_data(selected_block, false)

func _on_grid_size_toggled(toggled_on):
	bigGrid.visible = toggled_on
	smallGrid.visible = !toggled_on
	grid_is_small = !toggled_on

func _on_data_viewer_toggled(toggled_on):
	dataViewer.visible = toggled_on
	if !toggled_on:
		bigGrid.visible = !grid_is_small
		smallGrid.visible = grid_is_small
	else:
		bigGrid.visible = !toggled_on
		smallGrid.visible = !toggled_on

func _on_globe_view_toggled(toggled_on):
	if !toggled_on:
		bigGrid.visible = !grid_is_small
		#smallGrid.visible = grid_is_small
		dataViewer.visible = dataViewToggle.button_pressed
	else:
		bigGrid.visible = !toggled_on
		#smallGrid.visible = !toggled_on
		dataViewer.visible = !toggled_on
	$GlobeLineGenerator.visible = toggled_on
	$HUD/BoundarySliders.visible = !toggled_on
	dataViewToggle.disabled = toggled_on
	gridSizeToggle.disabled = toggled_on
	globeMap.visible = toggled_on
	globe_view_on = toggled_on
	$grid_marker.visible = !toggled_on
	toggle_block_pos(!toggled_on)
	
