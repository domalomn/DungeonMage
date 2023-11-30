extends State

@export var user : CharacterBody2D

@export var AttackAnim : String = "Attack"

@export var bulletPath : PackedScene

func enter_state(arg:Dictionary = {}): 
	print("skelwizattack")
	var direction = user.global_position.direction_to( user.player.global_position ) 
	animation_player.play(AttackAnim)
	animation_player.seek(0)
	var bullet = bulletPath.instantiate()
			

	bullet.damage = user.damage;
			#bullet.affliction = currentItemSelected.affliction;
		
	get_parent().add_child(bullet)
			# starts at player position
	bullet.position = user.global_position
			# fires from unit vector pointing from player to cursor, speed is determined from staff data
	bullet.velocity = (user.player.global_position - bullet.position).normalized() * bullet.speed
	
	call_deferred("awaitAttackAnim")
	
func physics_update(delta): 
	
	print(user.velocity)
	
	user.velocity.x = move_toward(user.velocity.x,0,200*delta)
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	user.move_and_slide()
	
func awaitAttackAnim():
	if await animation_player.animation_finished == "Attack":
		Machine.goto_state("Idle")
