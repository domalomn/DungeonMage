extends State

# Exported variables
@export var user: CharacterBody2D
@export var AttackState: String = "Attack"
@export var CancelState: String = "Idle"
@export var groundDetector: Area2D
@export var shotChecker: RayCast2D
@export var attackDistance: float = 125

# Function called when entering the state
func enter_state(arg: Dictionary = {}): 
	# Play the walking animation
	animation_player.play("Walk")
	
	# Start the attack cooldown timer
	$AttackCooldown.start(0.5)

# Function called for physics updates
func physics_update(delta): 
	# Check if the player associated with the user character is valid
	if is_instance_valid(user.player):
		# Calculate the direction and distance to the player
		var direction = user.global_position.direction_to(user.player.global_position) 
		var distance_to_player = user.global_position.distance_to(user.player.global_position) / 3
		
		# Set the target position for the shot checker to the local position of the player
		shotChecker.target_position = shotChecker.to_local(user.player.global_position)
		
		# Apply gravity if the user is not on the floor
		if not user.is_on_floor(): 
			user.velocity.y += 980 * delta
		
		# Check conditions for movement based on ground detection and distance to player
		elif (not groundDetector.has_overlapping_bodies()) or distance_to_player <= attackDistance:
			user.velocity.x = move_toward(user.velocity.x, 0 * user.speed, 1000 * delta)
		
		# Set the user's facing direction and move toward the player
		user.facing(sign(direction.x))
		user.velocity.x = move_toward(user.velocity.x, direction.x * user.speed, 1000 * delta)
		
		# Adjust velocity if within attack distance and not colliding with obstacles
		if distance_to_player <= attackDistance and not shotChecker.is_colliding():
			user.velocity.x = move_toward(user.velocity.x, 0, 1000 * delta)
		
		# Move and slide the user
		user.move_and_slide()
	
	# Check conditions for transitioning to the AttackState
	if (not shotChecker.is_colliding()) and $AttackCooldown.is_stopped() and user.is_on_floor():
		Machine.goto_state(AttackState)

# Function called when the chase timer times out
func _on_chase_timer_timeout():
	# Emit signal indicating the player is lost
	if is_instance_valid(user.player):
		user.emit_signal("lost_player")
	
	# Transition to the CancelState
	Machine.goto_state(CancelState)

# Function called when a body exits the player detection area
func _on_player_detection_body_exited(body):
	# Check if the body is the player and the current state is this state
	if body == user.player and Machine.current == self:
		# Start the chase timer
		$ChaseTimer.start()

# Function called when a body enters the player detection area
func _on_player_detection_body_entered(body):
	# Check if the body is in the Player group
	if body.is_in_group("Player"):
		# Stop the chase timer
		$ChaseTimer.stop()
