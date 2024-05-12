extends Node3D

@export var camera_reset_size := 20.0
@export var camera_max := 40.0
@export var camera_min := 5.0

@onready var camera = $Camera3D

func _process(delta):
	if Input.is_action_just_pressed("reset_zoom"):
		camera.size = camera_reset_size

func _input(event):
	if event is InputEventPanGesture:
		rotation_degrees.y += event.delta.x
	if event is InputEventMagnifyGesture:
		camera.size /= event.factor
		camera.size = clampf(camera.size, camera_min, camera_max)
