extends VehicleBody3D

signal coin_collected

var coins = 0

const MAX_STEER = 0.8
const ENGING_POWER = 300

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	steering = move_toward(steering, Input.get_axis("ui_right","ui_left") * MAX_STEER , delta * 2.5)
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGING_POWER
   

# Collecting coins

func collect_coin():

	coins += 1

	coin_collected.emit(coins)
