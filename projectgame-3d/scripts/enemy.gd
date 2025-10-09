extends CharacterBody3D

@export var player_path: NodePath
@export var speed: float = 40.0
@export var gravity: float = 1.0
@export var detect_range: float = 500.0
@export var damage: int = 20
@export var attack_interval: float = 1.5  # เวลาระหว่างการโจมตีแต่ละครั้ง

@onready var area: Area3D = $Area3D
var player: VehicleBody3D
var can_attack := true

func _ready():
	# หา player (แบบอัตโนมัติหรือใช้ Path)
	if player_path and str(player_path) != "":
		player = get_node_or_null(player_path)
	else:
		player = get_tree().get_root().find_child("Player", true, false)

	# เชื่อม signal ตรวจจับการชน
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

	# ตรวจระยะห่าง ถ้าใกล้พอให้วิ่งตาม
	var dist = global_position.distance_to(player.global_position)
	if dist < detect_range:
		var dir = (player.global_position - global_position).normalized()
		dir.y = 0
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		look_at(player.global_position, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * speed)
		velocity.z = move_toward(velocity.z, 0, delta * speed)

	move_and_slide()

# === เมื่อชน Player ===
func _on_body_entered(body):
	if body == player and can_attack:
		_attack_player()

# === ฟังก์ชันโจมตี Player ===
func _attack_player():
	if not is_inside_tree():
		return  # ป้องกัน error จาก get_tree() เป็น null

	if player and player.has_method("take_damage"):
		player.take_damage(damage)
		print("💥 Enemy attacked Player! Damage:", damage)
	else:
		print("⚠️ Player ไม่มีฟังก์ชัน take_damage()")

	can_attack = false

	# ป้องกันกรณี get_tree() == null
	if get_tree():
		await get_tree().create_timer(attack_interval).timeout

	can_attack = true

func set_player(p):
	player = p
