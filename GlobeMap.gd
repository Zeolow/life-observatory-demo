extends Node3D

@export var yaw: float = 0
@export var pitch: float = 0
@export var dist_from_sphere = 2

@onready var mesh_1 = $MeshInstance3D
@onready var mesh_2 = $MeshInstance3D2

var locations: Dictionary = {"china": Vector2(1.583,0.704), "india": Vector2(1.817,0.392), "indonesia": Vector2(1.167, 0.009), "australien": Vector2(0.0783, -0.408), "USA_W": Vector2(-1.167, 0.675), "USA_E": Vector2(-1.6, 0.742), "brazil": Vector2(-2.183,-0.141), "chile": Vector2(-1.917, 0.591), "south_africa": Vector2(-3.566,-0.441), "madagascar": Vector2(-3.95,-0.341), "EU": Vector2(-3.45,0.859), "morocco": Vector2(-3.066, 0.709), "spain": Vector2(-3.066,0.709), "arabian_peninsula": Vector2(-3.916, 0.442)}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		#yaw += delta * 10.0
		pitch += delta * 1.0
	if Input.is_action_pressed("ui_right"):
		pitch -= delta * 1.0
	if Input.is_action_pressed("ui_up"):
		yaw += delta * 1.0
	if Input.is_action_pressed("ui_down"):
		yaw -= delta * 1.0
	mesh_2.set_position(sphere_coordinates(yaw, pitch, 6))
	

func sphere_coordinates(yaw, pitch, radius) -> Vector3:
	var x = radius * cos(pitch) * cos(yaw)
	var z = radius * cos(pitch) * sin(yaw)
	var y = radius * sin(pitch)
	return Vector3(x,y,z)

func get_rand_pos() -> Vector3:
	var positions = locations.values()
	var rand_pos = positions.pick_random()
	return sphere_coordinates(rand_pos.x,rand_pos.y,dist_from_sphere)
