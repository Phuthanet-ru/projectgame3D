extends ParallaxBackground

@export var parallax_speed = 0.1 # ความเร็วในการขยับของฉากหลัง

@warning_ignore("unused_parameter")
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	
	# คำนวณความแตกต่างระหว่างตำแหน่งเมาส์กับจุดศูนย์กลางของจอ
	var mouse_offset = mouse_position - (viewport_size / 2)
	
	# ปรับตำแหน่งของฉากหลังตามเมาส์
	scroll_offset = -mouse_offset * parallax_speed
