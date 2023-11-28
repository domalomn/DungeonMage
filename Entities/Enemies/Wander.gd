extends State

@export var user : CharacterBody2D

@export var AttackState : String = "Attack"

@export var CancelState : String = "Idle"

@export var wallDetector : RayCast2D

@export var groundDetector : Area2D

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Move")
	print("wander")

func physics_update(delta):
	if (wallDetector.is_colliding() || not groundDetector.has_overlapping_bodies()) && $CollisionCooldown.is_stopped() && user.is_on_floor():
		var direction = sign(groundDetector.position.x) * -1
		user.velocity.x = move_toward(user.velocity.x,direction * user.speed,1000*delta)
		user.facing( direction )
		$CollisionCooldown.start()
	user.move_and_slide()
