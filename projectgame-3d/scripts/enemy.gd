extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var player_path: NodePath  # ลิงก์ไปยัง Player ใน Inspector
@export var speed: float = 6.0
@export var gravity: float = 20.0

var player: Node3D

func _ready():
	player = get_node(player_path)
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 1.0

func _physics_process(delta):
	if not player:
		return
	
	# ตั้งเป้าหมายเป็นตำแหน่งของ Player
	nav.target_position = player.global_position
	
	# แรงโน้มถ่วง
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	# คำนวณการเคลื่อนที่
	var next_position = nav.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	var move_vec = direction * speed
	
	velocity.x = move_vec.x
	velocity.z = move_vec.z
	
	move_and_slide()
	
	# ตรวจจับการชนกับ Player
	if global_position.distance_to(player.global_position) < 1.5:
		get_tree().reload_current_scene()
