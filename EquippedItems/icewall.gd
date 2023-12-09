extends CharacterBody2D

var speed = 500

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	speed = move_toward(speed,0,700*delta)
	rotation = velocity.angle()
