extends VehicleBody3D

signal coin_collected

var coins = 0

const MAX_STEER = 0.8
const ENGING_POWER = 300

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D

var look_at


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position

func _physics_process(delta):
	steering = move_toward(steering, -Input.get_axis("move_left","move_right") * MAX_STEER , delta * 2.5)
	engine_force = -Input.get_axis("move_forward","move_back") * ENGING_POWER
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(look_at)
   

# Collecting coins

func collect_coin():

	coins += 1

	coin_collected.emit(coins)
