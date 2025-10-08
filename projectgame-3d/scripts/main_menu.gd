extends Control

#@onready var music: AudioStreamPlayer2D = $Music
@onready var menu: AudioStreamPlayer2D = $menu
func _ready() -> void:
	if not menu.playing:
		menu.play()


func _on_start_game_pressed() -> void:
	menu.stop()  # กดเริ่มเกมแล้วหยุดเพลงเมนู
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
