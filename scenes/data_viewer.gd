extends Node3D

@onready var meshInstance = $MeshInstance3D
var material = ShaderMaterial
var influence_array: Array[float]
var change_speed = 1.0
var test_target_pos = 1.0
var target_array: Array[float]
var elapsed_time = 0

func _ready():
	influence_array = [0.0]
	influence_array.resize(121)
	for i in influence_array.size():
		influence_array[i] = 0.0
	target_array = influence_array.duplicate(true)
	material = meshInstance.get_active_material(0)

func _process(delta):
	#if target_array != influence_array:
	#OPTIMIZE (don't set every frame and only set specific index)
	elapsed_time += delta * change_speed
	var value_changed = false
	for i in influence_array.size():
		if influence_array[i] != target_array[i]:
			value_changed = true
			var current = influence_array[i]
			var target = target_array[i]
			if elapsed_time <= 1.0:
				var easing = ease(elapsed_time, 0.2)
				influence_array[i] = lerp(current, target, easing)
			else:
				influence_array[i] = target_array[i]
	if value_changed:
		set_influence_array(influence_array)

func get_influence_array() -> Array:
	return influence_array

func set_target_array(target: Array) -> void:
	if target.size() > 121.0:
		print("TOO BIG TARGET")
	elapsed_time = 0
	target_array = target
	

func set_influence_array(influence: Array) ->void :
	var packedArray = PackedFloat32Array(influence)
	material.set_shader_parameter("influence", packedArray)
