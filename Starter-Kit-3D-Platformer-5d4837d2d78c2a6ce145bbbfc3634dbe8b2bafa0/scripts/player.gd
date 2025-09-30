# player.gd
extends CharacterBody3D
signal coin_collected
@export var acceleration: float = 40.0
@export var turn_speed: float = 2.5
@export var max_speed: float = 60.0
@export var turbo_force: float = 120.0
@export var turbo_duration: float = 1.5
@export var gravity: float = 500.0  # แรงโน้มถ่วง

var velocity_forward: float = 0.0
var turbo_timer: float = 0.0
var coins = 1

@onready var engine_sound = $EngineSound
@onready var turbo_particles = $TurboParticles
@onready var speed_label = $"/root/Main/CanvasLayer/SpeedLabel"
signal turbo_state_changed(active: bool)

func _physics_process(delta: float) -> void:
	var throttle = Input.get_axis("move_back", "move_forward")
	var steer = Input.get_axis("move_left", "move_right")

	velocity_forward += throttle * acceleration * delta
	velocity_forward = clamp(velocity_forward, -max_speed, max_speed)
	
	if position.y < -10:
		get_tree().reload_current_scene()
		
	if turbo_timer > 0:
		velocity_forward = max_speed * 2
		turbo_timer -= delta

	rotation.y -= steer * turn_speed * delta * sign(velocity_forward)

	var direction = transform.basis.z.normalized()
	velocity = direction * velocity_forward
	move_and_slide()

	engine_sound.pitch_scale = 1.0 + (abs(velocity_forward) / max_speed)

	turbo_particles.emitting = turbo_timer > 0
	emit_signal("turbo_state_changed", turbo_timer > 0)
	
		# ความเร็ว (เมตรต่อวินาที → km/h คูณ 3.6)
	var speed = velocity.length() * 3.6
	speed_label.text = str(round(speed)) + " km/h"
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

func activate_turbo():
	if turbo_timer <= 0:
		turbo_timer = turbo_duration
		$TurboSound.play()
		
# Collecting coins

func collect_coin():

	coins += 1

	coin_collected.emit(coins)




	
