extends State

# Exported variables
@export var user: CharacterBody2D
@export var CancelState: String = "Idle"
@export var groundDetector: Area2D
@export var shotChecker: RayCast2D

@export var speedMod : float = 1.0

# Function called when entering the state
func enter_state(arg: Dictionary = {}): 
	# Play the walking animation
	animation_player.play("Walk")

# Function called for physics updates
func physics_update(delta): 
	# Check if the player associated with the user character is valid
	if is_instance_valid(user.player): 
		print("found u")
		
		# Set the target position for the shot checker to the local position of the player
		shotChecker.target_position = shotChecker.to_local(user.player.global_position)
		# Update the raycast
		shotChecker.force_raycast_update()
		
		# Check if the shot checker is not colliding
		if not shotChecker.is_colliding():
			print("see u")
			# Transition to the Chase state
			Machine.goto_state("Chase")
	
	# Calculate the direction to the ground detection point
	var direction = user.global_position.direction_to(groundDetector.get_child(0).global_position)
	
	# Apply gravity if the user is not on the floor
	if not user.is_on_floor(): 
		user.velocity.y += 980 * delta
	# Check conditions for movement based on wall detection and ground detection
	elif (user.is_on_wall() or (not groundDetector.has_overlapping_bodies())) and $CollisionCooldown.is_stopped():
		# Reverse the direction if on a wall or no overlapping bodies detected
		direction.x *= -1
		# Start the collision cooldown timer
		$CollisionCooldown.start()
	
	# Set the user's facing direction and move toward the ground detection point
	user.facing(sign(direction.x))
	user.velocity.x = move_toward(user.velocity.x, direction.x * user.speed*speedMod, 1000 * delta)
	# Move and slide the user
	user.move_and_slide()

# Function called when a body exits the player detection area
func _on_player_detection_body_exited(body):
	# Check if the body is the player and the current state is this state
	if body == user.player and Machine.current == self:
		# Emit signal indicating the player is lost
		user.emit_signal("lost_player")
