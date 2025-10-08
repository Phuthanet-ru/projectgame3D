extends Node3D

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("โครงร่างAction")
	$Area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("Red เตะโดน Player แล้ว!")  # ทดสอบก่อน
		body.queue_free()  # ลบ Player ออกจากเกม (ตาย)
