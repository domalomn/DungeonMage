extends CharacterBody2D

var speed = 100
var attackRange = 30
var attackCooldown = 1.5
var timeSinceLastAttack = 0.0
var maxHealth = 30
var currentHealth = maxHealth
var isAttacking = false

var player = null
var state = "idle"

func _ready():
	# Initialize the Goblin's state and find the player
	state = "idle"
	player = get_node("/root/Player")

func _process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if state == "idle":
			# Goblin is not attacking and is idle
			if distance_to_player <= attackRange:
				# Transition to attacking state when the player is in range
				state = "attacking"
			else:
				move(direction * speed * delta)  # Chase the player
			
		if state == "attacking":
			# Goblin is in the attacking state
			if distance_to_player <= attackRange:
				if timeSinceLastAttack >= attackCooldown:
					attackPlayer()  
					timeSinceLastAttack = 0
				else:
					isAttacking = false  # Reset the attack flag
			else:
				state = "idle"  # Transition back to idle state if the player is out of range
			timeSinceLastAttack += delta

func attackPlayer():
	if not isAttacking:
		isAttacking = true
		player.takeDamage(10)

func takeDamage(damage):
	currentHealth -= damage
	if currentHealth <= 0:
		die()

func die():
	# Remove the Goblin from the scene
	queue_free()
