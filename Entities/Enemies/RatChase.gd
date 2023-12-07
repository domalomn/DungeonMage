extends State

# Exported variables
@export var user: CharacterBody2D
@export var AttackState: String = "Attack"
@export var CancelState: String = "Idle"
@export var attackDistance: float = 45
@export var groundDetector: Area2D

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
		# Calculate the direction from the user to the player
		var direction = user.global_position.direction_to(user.player.global_position) 
		
		# Calculate the distance to the player
		var distance_to_player = user.global_position.distance_to(user.player.global_position) / 3
		
		# If the user is not on the floor, apply gravity
		if not user.is_on_floor(): 
			user.velocity.y += 980 * delta
		
		# Set the user's facing direction based on the sign of the x-component of the direction
		user.facing(sign(direction.x))
		
		# Move the user toward the player if not on a wall and within attack distance
		user.velocity.x = move_toward(user.velocity.x, direction.x * user.speed, 1000 * delta)
		
		# If on a wall or the ground detection area has no overlapping bodies, cancel the chase
		if user.is_on_wall() or (not groundDetector.has_overlapping_bodies()):
			user.player = null
			Machine.goto_state(CancelState)
		
		# If within attack distance, the attack cooldown is stopped, and the user is on the floor, initiate the attack state
		if distance_to_player <= attackDistance and $AttackCooldown.is_stopped() and user.is_on_floor():
			Machine.goto_state(AttackState)
		# If beyond attack distance, move and slide the user
		elif distance_to_player > attackDistance:
			user.move_and_slide()

# Function called when the chase timer times out
func _on_chase_timer_timeout():
	# Emit a signal indicating that the player is lost
	user.emit_signal("lost_player")
	
	# Go to the CancelState
	Machine.goto_state(CancelState)

# Function called when a body exits the player detection area
func _on_player_detection_body_exited(body):
	# Check if the exited body is the player and the current state is this state
	if body == user.player and Machine.current == self:
		# Start the chase timer after a delay
		$ChaseTimer.start(1.0)

# Function called when a body enters the player detection area
func _on_player_detection_body_entered(body):
	# Check if the entering body is in the "Player" group
	if body.is_in_group("Player"):
		# Stop the chase timer
		$ChaseTimer.stop()
