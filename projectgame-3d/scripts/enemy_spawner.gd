extends Node3D

@export var enemy_scene: PackedScene
@export var player_path: NodePath
@export var spawn_interval: float = 3.0

var timer := 0.0
var player: Node

func _ready():
	if player_path and str(player_path) != "":
		player = get_node(player_path)
	else:
		player = get_tree().get_root().find_child("Player", true, false)

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_enemy()

func spawn_enemy():
	if not enemy_scene or not player:
		return

	var enemy = enemy_scene.instantiate()
	add_child(enemy)

	# 🔧 กำหนดเป้าหมายให้ enemy
	enemy.player_path = player.get_path()

	# หรือจะส่ง object ตรง ๆ ก็ได้ ถ้าใน enemy.gd มีฟังก์ชัน set_player()
	if enemy.has_method("set_player"):
		enemy.set_player(player)

	# ตั้งตำแหน่งเกิด (ตัวอย่างสุ่ม)
	enemy.global_position = global_position + Vector3(randf() * 10.0 - 5.0, 0, randf() * 10.0 - 5.0)

	
	
