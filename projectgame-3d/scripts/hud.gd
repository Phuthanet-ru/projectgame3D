extends Control


func _on_nissan_gtr_coin_collected(coins):
	
	$Coins.text = str(coins)

@onready var bar: TextureProgressBar = $HealthBar
@export var player_path: NodePath

var player

func _ready():
	player = get_node_or_null(player_path)
	if player:
		player.health_changed.connect(_on_health_changed)
		player.player_died.connect(_on_player_died)
		bar.max_value = player.max_health
		bar.value = player.health

func _on_health_changed(current):
	bar.value = current

func _on_player_died():
	bar.value = 0
