extends CharacterBody2D

var moving = true
var speed = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 980

func _physics_process(delta):
	if moving and move_and_slide():
		moving = false
		$AnimationPlayer.play("Explosion")
		
	# Add the gravity.
	velocity.y += gravity * delta
