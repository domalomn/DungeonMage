extends State

@export var user : CharacterBody2D

@export var AttackState : String = "Attack"

@export var CancelState : String = "Idle"

@export var attackDistance : float = 45

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Move")
	$AttackCooldown.start(0.5)

func physics_update(delta): 
	var direction = user.global_position.direction_to( user.player.global_position ) 
	var distance_to_player = user.global_position.distance_to(user.player.global_position) / 3
	
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	
	user.facing( sign(direction.x) )
	user.velocity.x = move_toward(user.velocity.x,direction.x * user.speed,1000*delta)
	
	
	if distance_to_player <= attackDistance and $AttackCooldown.is_stopped() and user.is_on_floor():
		Machine.goto_state(AttackState)
	elif distance_to_player > attackDistance:
		user.move_and_slide()

func _on_chase_timer_timeout():
	user.player = null
	Machine.goto_state(CancelState)

func _on_player_detection_body_exited(body):
	if body == user.player and Machine.current == self:
		$ChaseTimer.start(1.0)


func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		$ChaseTimer.stop()