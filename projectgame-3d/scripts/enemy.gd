extends CharacterBody3D

@export var player_path: NodePath
@export var speed: float = 50.0
@export var gravity: float = 1.0
@export var detect_range: float = 500.0

@onready var area: Area3D = $Area3D
var player: Node3D

func _ready():
	# หา player
	if player_path and str(player_path) != "":
		player = get_node(player_path)
	else:
		player = get_tree().get_root().find_child("Player", true, false)

	# เชื่อม signal ตรวจจับชน
	if area:
		area.body_entered.connect(_on_body_entered)
	else:
		push_warning("⚠️ Missing Area3D node under enemy!")

func _physics_process(delta):
	if not player:
		return

	# แรงโน้มถ่วง
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# ตรวจระยะห่าง ถ้าใกล้พอค่อยวิ่งตาม
	var dist = global_position.distance_to(player.global_position)
	if dist < detect_range:
		var dir = (player.global_position - global_position).normalized()
		dir.y = 0  # ไม่ปีนขึ้นลง
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		look_at(player.global_position, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * speed)
		velocity.z = move_toward(velocity.z, 0, delta * speed)

	move_and_slide()

# === เมื่อศัตรูชน Player ===
func _on_body_entered(body):
	if player and body == player:
		print("💥 Enemy hit player! Reloading scene (deferred)...")
		call_deferred("_reload_scene_safe")

func _reload_scene_safe():
	get_tree().reload_current_scene()
	
func set_player(p):
	player = p
