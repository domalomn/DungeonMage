extends State

# Exported variables
@export var user: CharacterBody2D
@export var AttackAnim: String = "Attack"
@export var bulletPath: PackedScene

# Function called when entering the state
func enter_state(arg: Dictionary = {}): 
	print("skelwizattack")
	
	# Check if the player associated with the user character is valid
	if not is_instance_valid(user.player):
		# Go to the Idle state if the player is not valid
		Machine.goto_state("Idle")
	else:
		# Calculate the direction from the user to the player
		var direction = user.global_position.direction_to(user.player.global_position) 
		
		# Play the attack animation
		animation_player.play(AttackAnim)
		animation_player.seek(0)
		
		# Instantiate a bullet from the bullet scene
		var bullet = bulletPath.instantiate()
		
		# Note: Affliction property commented out as it is not defined in the provided code
		
		# Add the bullet as a child of the parent node
		get_parent().add_child(bullet)
		
		# Set the bullet's position to the user's global position
		bullet.position = user.global_position
		
		# Calculate the velocity of the bullet based on the direction to the player and the bullet's speed
		bullet.velocity = (user.player.global_position - bullet.position).normalized() * bullet.speed
		
		# Call the awaitAttackAnim function after a delay
		call_deferred("awaitAttackAnim")

# Function called for physics updates
func physics_update(delta): 
	print(user.velocity)
	
	# Move the user horizontally
	user.velocity.x = move_toward(user.velocity.x, 0, 200 * delta)
	
	# Apply gravity if the user is not on the floor
	if not user.is_on_floor(): 
		user.velocity.y += 980 * delta
	
	# Move and slide the user
	user.move_and_slide()

# Function called when awaiting the completion of the attack animation
func awaitAttackAnim():
	# Go to the Idle state when the attack animation is finished
	if await animation_player.animation_finished == "Attack":
		Machine.goto_state("Idle")
