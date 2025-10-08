extends VehicleBody3D

signal coin_collected

var coins = 0

const MAX_STEER = 0.8
const ENGINE_POWER = 300

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D
@onready var engine_sound: AudioStreamPlayer3D = $EngineSound


var look_at

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position
	engine_sound.play() # 🔊 เริ่มเล่นเสียงเครื่องยนต์ทันที (loop)

func _physics_process(delta):
	# การบังคับ
	steering = move_toward(steering, -Input.get_axis("move_left","move_right") * MAX_STEER , delta * 2.5)
	engine_force = -Input.get_axis("move_forward","move_back") * ENGINE_POWER

	# กล้องติดตาม
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(look_at)

	# เอฟเฟกต์เสียงเครื่องยนต์ 🌀
	var speed = linear_velocity.length()
	engine_sound.pitch_scale = 1.0 + (speed / 100.0)   # ยิ่งเร็ว เสียงยิ่งสูง
	engine_sound.volume_db = -3 + clamp(speed / 10.0, 0, 6)  # เพิ่มความดังนิดหน่อยตามความเร็ว

	# รีเซ็ตเมื่อหล่นจากฉาก
	if position.y < -10:
		get_tree().reload_current_scene()

# เก็บเหรียญ
func collect_coin():
	coins += 1
	coin_collected.emit(coins)
