extends State

@export var user : CharacterBody2D

@export var AttackAnim : String = "Attack"


func enter_state(arg:Dictionary = {}): 
	
	if not is_instance_valid(user.player):
		Machine.goto_state("Idle")
	else:
		var direction = user.global_position.direction_to( user.player.global_position ) 
		
		animation_player.play(AttackAnim)
		animation_player.seek(0)
		user.velocity.x = 400*sign(direction.x)
		user.velocity.y = -300
		
		
		
		call_deferred("awaitAttackAnim")
	
func physics_update(delta): 
	
	print(user.velocity)
	
	user.velocity.x = move_toward(user.velocity.x,0,200*delta)
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	user.move_and_slide()
	
func awaitAttackAnim():
	if await animation_player.animation_finished == "Attack":
		Machine.goto_state("Idle")
	
