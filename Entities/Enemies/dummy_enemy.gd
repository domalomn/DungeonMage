extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if health <= 0:
		queue_free()
	move_and_slide()
	
	


func _on_hurtbox_hitbox_detected(area, boxowner):
	health -= area.damage
	print("hit the rat")
	$Hurtbox.go_invincible(1.0)
