extends CharacterBody2D

var speed = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	rotation = velocity.angle()
	if collision_info:
		queue_free()
	
func _on_hitbox_hit(target):
	queue_free()
