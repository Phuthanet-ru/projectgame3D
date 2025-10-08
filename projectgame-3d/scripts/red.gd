extends Node3D

@onready var anim := $AnimationPlayer
@onready var hitbox := $Area3D
@onready var nav =$NavigationAgent3D

func _ready():
	anim.play("โครงร่างAction")
	hitbox.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# สั่งให้รถตาย
		if body.has_method("die"):
			body.die()
