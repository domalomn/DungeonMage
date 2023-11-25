extends CharacterBody2D

var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed = 150
var attackRange = 45
var maxHealth = 5
var currentHealth = maxHealth
var isAttacking = false

var chasing : bool

var player = null
var state = "idle"

func _ready():
	# Initialize the Rat's state and find the player
	$AnimationPlayer.play("Move")
	player = get_tree().get_first_node_in_group("Player")
	chasing = false

func _process(delta):
	if chasing == true && $AttackCooldown.is_stopped():
		var direction = (player.global_position - global_position).normalized()
		var distance_to_player = global_position.distance_to(player.global_position) / 3
		velocity.y += world_gravity
		
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
			$Hitbox.scale.x = -3
		else:
			$AnimatedSprite2D.flip_h = false
			$Hitbox.scale.x = 3
			
		if distance_to_player <= attackRange:
			$AnimationPlayer.play("Bite")
			$AttackCooldown.start()
			
		velocity.x = direction.x * speed
		
		move_and_slide()
		
#		if state == "idle":
#			# Rat is not attacking and is idle
#			if distance_to_player <= attackRange:
#				# Transition to attacking state when the player is in range
#				state = "attacking"
#			else:
#				pass
#				#move(direction * speed * delta)  # Chase the player
#
#		if state == "attacking":
#			# Rat is in the attacking state
#			if distance_to_player <= attackRange:
#				if timeSinceLastAttack >= attackCooldown:
#					attackPlayer()
#					timeSinceLastAttack = 0
#				else:
#					isAttacking = false  # Reset the attack flag
#			else:
#				state = "idle"  # Transition back to idle state if the player is out of range
#			timeSinceLastAttack += delta
	

func die():
	# Remove the Rat from the scene
	queue_free()


func _on_player_detection_body_entered(body):
	print("body entered")
	if body.is_in_group("Player"):
		print("body is player")
		player = body
		chasing = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Bite":
		$AnimationPlayer.play("Move")


func _on_hurtbox_hitbox_detected(area, boxowner):
	currentHealth -= area.damage
	print("hit the rat")
	$Hurtbox.go_invincible(0.4)
	if currentHealth <= 0:
		die()


func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		$ChaseTimer.start()


func _on_chase_timer_timeout():
	chasing = false
