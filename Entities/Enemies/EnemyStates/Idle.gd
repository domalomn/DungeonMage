extends State


@export var user : CharacterBody2D
@export var groundDetection : Area2D
@export var wallDetector : RayCast2D

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Idle")
	print("back to idle")
	
func physics_update(delta): 
	if user.player: Machine.goto_state("Chase")
	elif (wallDetector.is_colliding() || not groundDetection.has_overlapping_bodies()) && user.is_on_floor():
		Machine.goto_state("Wander")
	
	user.velocity.x = move_toward(user.velocity.x,0,5*delta)
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	user.move_and_slide()
