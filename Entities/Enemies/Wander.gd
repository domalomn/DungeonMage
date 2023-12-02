extends State

@export var user : CharacterBody2D

@export var CancelState : String = "Idle"

@export var groundDetector : Area2D

@export var shotChecker : RayCast2D

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Walk")

func physics_update(delta): 
	if user.player: 
		print("found u")
		shotChecker.target_position = shotChecker.to_local(user.player.global_position)
		shotChecker.force_raycast_update()
		
		if not shotChecker.is_colliding():
			print("see u")
			Machine.goto_state("Chase")
	
	var direction = user.global_position.direction_to( groundDetector.get_child(0).global_position ) 
	
	if not user.is_on_floor(): user.velocity.y += 980 * delta
	elif (user.is_on_wall() || (not groundDetector.has_overlapping_bodies())) && $CollisionCooldown.is_stopped():
		direction.x *= -1
		$CollisionCooldown.start()
	
	user.facing( sign(direction.x) )
	user.velocity.x = move_toward(user.velocity.x,direction.x * user.speed,1000*delta)
	user.move_and_slide()
	
func _on_player_detection_body_exited(body):
	if body == user.player and Machine.current == self:
		user.player = null
