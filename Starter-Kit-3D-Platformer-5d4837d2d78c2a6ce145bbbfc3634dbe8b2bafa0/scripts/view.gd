extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 310

# --- Turbo Effect ---
@export var normal_fov: float = 60.0
@export var turbo_fov: float = 90.0
@export var fov_speed: float = 5.0
var turbo_active: bool = false

var camera_rotation: Vector3
var zoom = 10
var shake_strength: float = 0.0   # ค่าความแรงของกล้องสั่น

@onready var camera = $Camera

func _ready():
	camera_rotation = rotation_degrees
	
	# หา Player ใน Scene (แก้ path ให้ตรงกับโครงสร้างจริงของนาย)
	var player = get_parent().get_node("Player")
	if player:
		player.connect("turbo_state_changed", Callable(self, "_on_turbo_state_changed"))

func _physics_process(delta):
	# Follow target
	self.position = self.position.lerp(target.position, delta * 6)
	rotation_degrees.y = lerp_angle(rotation_degrees.y, target.rotation_degrees.y, delta * 12)
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
		# --- หมุนกล้องตามทิศทางรถ ---
	var target_rotation = target.rotation_degrees
	# ให้ตามเฉพาะแกน Y (หมุนซ้ายขวา)
	camera_rotation.y = lerp_angle(camera_rotation.y, target_rotation.y, delta * 4)

	# ทำให้กล้องค่อย ๆ ปรับมุม (ไม่กระชาก)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)

	# Zoom
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)

	handle_input(delta)
	update_fov(delta)
	update_shake(delta)

func handle_input(delta):
	# Rotation (manual camera move)
	var input := Vector3.ZERO
	input.y = Input.get_axis("camera_right", "camera_left")
	input.x = Input.get_axis("camera_up", "camera_down")
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)

	# ติดตามตำแหน่ง
	self.position = self.position.lerp(target.position, delta * 4)

	# หมุนตาม Player (เอาเฉพาะแกน Y)
	var target_rot = camera_rotation
	target_rot.y = target.rotation.y
	rotation_degrees = rotation_degrees.lerp(target_rot, delta * 6)

	# Zoom
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
	
	update_fov(delta)
	update_shake(delta)

func update_fov(delta):
	var target_fov = turbo_fov if turbo_active else normal_fov
	camera.fov = lerp(camera.fov, target_fov, delta * fov_speed)

func update_shake(delta):
	if shake_strength > 0:
		var offset = Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			0
		)
		camera.position += offset * 0.1
		shake_strength = lerp(shake_strength, 0.0, delta * 2) # ค่อย ๆ หายไป

# ---- Signal from Player ----
func _on_turbo_state_changed(active: bool) -> void:
	turbo_active = active
	if active:
		shake_strength = 0.5  # เริ่มสั่นแรงตอนเปิด Turbo
