extends Node3D

@export var player_path: NodePath
@export var enemy_scene: PackedScene
@export var spawn_interval: float = 10.0  # ทุก 5 วิจะเกิดใหม่ 1 ตัว
@export var spawn_distance: float = 20.0 # ระยะห่างจาก Player ตอนเกิด

var player: Node3D
var timer: float = 0.0

func _ready():
	player = get_node(player_path)

func _process(delta):
	if not player:
		return
	
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_enemy()

func spawn_enemy():
	if not enemy_scene or not player:
		return
	
	var enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	
	# ให้ศัตรูเกิด "ข้างหลัง" Player
	var back_dir = -player.transform.basis.z.normalized()
	var spawn_pos = player.global_position + back_dir * spawn_distance
	enemy.global_position = spawn_pos

	# ส่งตำแหน่ง Player ให้ Enemy รู้จัก (เชื่อม path)
	if enemy.has_method("set_player"):
		enemy.set_player(player)

	print("Enemy spawned at: ", spawn_pos)
	
	
