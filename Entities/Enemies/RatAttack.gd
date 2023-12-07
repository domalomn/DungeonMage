extends State

# Exported variables
@export var user: CharacterBody2D
@export var AttackAnim: String = "Bite"

# Function called when entering the state
func enter_state(arg: Dictionary = {}): 
	# Check if the player associated with the user character is valid
	if not is_instance_valid(user.player):
		# If not valid, go back to the Idle state
		Machine.goto_state("Idle")
	else:
		# Calculate the direction from the user to the player
		var direction = user.global_position.direction_to(user.player.global_position) 
		
		# Play the attack animation
		animation_player.play(AttackAnim)
		animation_player.seek(0)
		
		# Call the awaitAttackAnim function using deferred execution
		call_deferred("awaitAttackAnim")

# Function called for physics updates
func physics_update(delta): 
	# Set the user's horizontal velocity to zero
	user.velocity.x = 0
	
	# If the user is not on the floor, apply gravity
	if not user.is_on_floor(): 
		user.velocity.y += 980 * delta
	
	# Move and slide the user
	user.move_and_slide()

# Function called to await the completion of the attack animation
func awaitAttackAnim():
	# Check if the attack animation ("Bite") has finished
	if await animation_player.animation_finished == "Bite":
		# If finished, go back to the Idle state
		Machine.goto_state("Idle")
