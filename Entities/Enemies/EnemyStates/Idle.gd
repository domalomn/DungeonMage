extends State


@export var user : CharacterBody2D

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Idle")
	
func physics_update(delta): 
	if user.player: Machine.goto_state("Chase")
	
	user.velocity.x = move_toward(user.velocity.x,0,5*delta)
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	user.move_and_slide()
