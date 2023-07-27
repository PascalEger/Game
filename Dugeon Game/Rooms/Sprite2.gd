extends Sprite

func _process(delta):
	look_at(get_global_mouse_position() )

# Shooting
const BULLET = preload("res://World/Pfeil.tscn")
const  global = 10

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (event.position != position):
				var direction = (get_global_mouse_position()- global_position).normalized()
				var bullet = BULLET.instance()
				get_parent().add_child(bullet)
				bullet.global_position = global_position 
				bullet.set_bullet_direction(direction)
