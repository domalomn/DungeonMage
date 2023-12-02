extends State


@export var user : CharacterBody2D
@export var shotChecker : RayCast2D

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Idle")
	
func physics_update(delta): 
	if is_instance_valid(user.player): 
		shotChecker.target_position = shotChecker.to_local(user.player.global_position)
		if not shotChecker.is_colliding():
			Machine.goto_state("Chase")
	else:
		Machine.goto_state("Wander")
	
	user.velocity.x = move_toward(user.velocity.x,0,1000*delta)
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	user.move_and_slide()
	
func _on_player_detection_body_exited(body):
	if body == user.player and Machine.current == self:
		user.player = null
