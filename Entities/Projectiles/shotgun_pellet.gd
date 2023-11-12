extends CharacterBody2D

var speed = 500
var spacing = 0.1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if collision_info:
		queue_free()
