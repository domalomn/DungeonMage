extends CharacterBody2D

# Get the default gravity from the project
var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Signal emitted when the player is lost
signal lost_player()

# Character attributes
var speed = 195
var attackRange = 50
@export var maxHealth = 10
var currentHealth = maxHealth
var isAttacking = false

# Flag to indicate if the Goblin is chasing the player
var chasing : bool

# Reference to the player
var player = null

# Reference to the Finite State Machine (FSM)
@onready var fsm : FSM = $FSM

# Function called when the node is ready
func _ready():
	# Initialize the Goblin's state and play the "Idle" animation
	$AnimationPlayer.play("Idle")
	chasing = false

# Function called during the physics process
func _physics_process(delta):
	# Call the physics_update function of the current FSM state
	fsm.current.physics_update(delta)

# Function called when the Goblin dies
func die():
	# Remove the Goblin from the scene
	queue_free()
	# Instantiate an HP item and a dropped item
	var item = null
	match randi_range(0,1):
		0:
			item = preload("res://EquippedItems/ItemList/item_HP.tscn").instantiate()
		1:
			item = preload("res://EquippedItems/ItemList/item_Knife.tscn").instantiate()
		
	
	var itemDropped = preload("res://EquippedItems/dropped_item.tscn").instantiate()
	# Add the dropped item to the parent
	get_parent().add_child(itemDropped)
	# Set the itemNode of the dropped item
	itemDropped.itemNode = item
	# Set the position of the dropped item
	itemDropped.position = global_position

# Function to set the facing direction of the Goblin
func facing(f:int):
	if f < 0:
		$AnimatedSprite2D.flip_h = true
		$Hitbox.scale.x = -1
		$GroundDetection.scale.x = -1
	elif f > 0:
		$AnimatedSprite2D.flip_h = false
		$Hitbox.scale.x = 1
		$GroundDetection.scale.x = 1

# Function called when the player detection body is entered
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		print("Player Entered")
		# Player entered, connect to the player's death signal
		player = body
		player.connect("death", player_died)

# Function called when the player is lost
func player_lost():
	if player.is_connected("death", player_died):
		# Disconnect from the player's death signal and set player to null
		player.disconnect("death", player_died)
		player = null

# Function called when the player dies
func player_died():
	# Transition to the "Idle" state in the FSM and set player to null
	fsm.goto_state("Idle")
	player = null

# Function called when the hurtbox detects a hitbox
func _on_hurtbox_hitbox_detected(area, boxowner):
	var dmg = area.damage
	var knockDir = Vector2(velocity.x, -300)
	# Adjust knockback direction based on the player's position
	if is_instance_valid(player): 
		knockDir.x = sign(player.global_position.direction_to(global_position).x) * 500
	# If the hitbox owner is a projectile, nullify the knockback direction
	if is_instance_valid(boxowner) and boxowner.is_in_group("Projectile"):
		knockDir = null
		
	# Call the getHurt RPC with damage and knockback direction
	getHurt.rpc(dmg, knockDir,area.iFrames)

# RPC function to handle taking damage
@rpc("any_peer", "call_local")
func getHurt(dmg, knockDir,iFrames):
	# Reduce current health by the damage amount
	currentHealth -= dmg
	# Make the hurtbox invincible for a short duration
	$Hurtbox.go_invincible(iFrames)
	
	# If knockback direction is provided, set the velocity and transition to "Idle" state
	if knockDir:
		velocity = knockDir
		fsm.goto_state("Idle")
	# If health drops to or below 0, call the die function
		if currentHealth <= 0:
			die()

# Function called when the hitbox hits a target
func _on_hitbox_hit(target):
	print("Goblin hit you")
