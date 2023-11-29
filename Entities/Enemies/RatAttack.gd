extends State

@export var user : CharacterBody2D

@export var AttackAnim : String = "Bite"


func enter_state(arg:Dictionary = {}): 
	
	var direction = user.global_position.direction_to( user.player.global_position ) 
	
	animation_player.play(AttackAnim)
	animation_player.seek(0)
	
	
	
	call_deferred("awaitAttackAnim")
	
func physics_update(delta): 
	
	print(user.velocity)
	
	user.velocity.x = 0
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	user.move_and_slide()
	
func awaitAttackAnim():
	if await animation_player.animation_finished == "Bite":
		Machine.goto_state("Idle")
	
