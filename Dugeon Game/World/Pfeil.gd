extends KinematicBody2D

const SPEED = 100

var state_Machine
var velocity = Vector2()

func _physics_process(delta):	
	var collision = move_and_collide(velocity*delta)
	#if collision:
		#queue_free()
	#if collision:
		#velocity = velocity.bounce(collision.normal)
#func _on_Player_area_entered(area):
	#if "Pfeil" in area.get_name():
		#queue_free()


func set_bullet_direction(direction):
	velocity = direction * SPEED



func _on_Area2D_area_entered(area):
	if area.get_name() == "Player":
		queue_free()
		
