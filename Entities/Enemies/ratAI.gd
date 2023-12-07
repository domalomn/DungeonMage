extends CharacterBody2D

# Get the default gravity from the project
var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Signal emitted when the player is lost
signal lost_player()

# Attributes for the rat
var speed = 150
var attackRange = 45
var maxHealth = 5
var currentHealth = maxHealth
var isAttacking = false

# Flag indicating if the rat is chasing the player
var chasing: bool

# Reference to the finite state machine
@onready var fsm: FSM = $FSM

# Reference to the player character
var player = null

func _ready():
	# Initialization when the rat is ready
	print("ready rat")

func _process(delta):
	# Process function called every frame
	fsm.current.physics_update(delta)

func die():
	# Remove the Rat from the scene
	queue_free()

func facing(f: int):
	# Set the facing direction of the rat based on the provided parameter
	if f < 0:
		$AnimatedSprite2D.flip_h = true
		$Hitbox.scale.x = -1
		$GroundDetection.scale.x = -1
	elif f > 0:
		$AnimatedSprite2D.flip_h = false
		$Hitbox.scale.x = 1
		$GroundDetection.scale.x = 1

func _on_player_detection_body_entered(body):
	# Event when the rat detects another body
	print("body entered")
	if body.is_in_group("Player"):
		print("body is player")
		# Check if already pursuing the player
		if is_instance_valid(player):
			player_lost()
		player = body
		player.connect("death", player_died)

# Function called when the player is lost
func player_lost():
	if player.is_connected("death", player_died):
		player.disconnect("death", player_died)
		player = null

# Function called when the player dies
func player_died():
	player = null

# Function for when the hurtbox detects a hitbox
func _on_hurtbox_hitbox_detected(area, boxowner):
	var dmg = area.damage
	print(dmg)
	var knockDir = Vector2(velocity.x, -300)
	if is_instance_valid(player): 
		# Calculate knockback direction based on player's position
		knockDir.x = sign(player.global_position.direction_to(global_position).x) * 500
	if is_instance_valid(boxowner) and boxowner.is_in_group("Projectile"):
		# Nullify knockback if hit by a projectile
		knockDir = null

	# Call the getHurt RPC function to handle damage
	getHurt.rpc(dmg,knockDir,area.iFrames)

# RPC function to handle taking damage
@rpc("any_peer", "call_local")
func getHurt(dmg, knockDir,iFrames):
	# Reduce current health by the damage amount
	
	currentHealth -= dmg
	print(currentHealth)
	# Make the hurtbox invincible for a short duration
	$Hurtbox.go_invincible(iFrames)
	
	# If knockback direction is provided, set the velocity and transition to "Idle" state
	if knockDir:
		velocity = knockDir
		fsm.goto_state("Idle")
	# If health drops to or below 0, call the die function
	if currentHealth <= 0:
			die()

func _on_chase_timer_timeout():
	# Event when the chase timer times out, indicating the rat is no longer chasing
	chasing = false
