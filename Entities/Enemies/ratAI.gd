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

@onready var fsm : FSM = $FSM

var prevVel

func _ready():
	pass

func _process(delta):
	fsm.current.physics_update(delta)
		
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

func facing(f:int):
	if f < 0:
		$AnimatedSprite2D.flip_h = true
		$Hitbox.scale.x = -1
		$GroundDetection.scale.x = -1
		$WallDetector.scale.x = -1
	elif f > 0:
		$AnimatedSprite2D.flip_h = false
		$Hitbox.scale.x = 1
		$GroundDetection.scale.x = 1
		$WallDetector.scale.x = 1


func _on_player_detection_body_entered(body):
	print("body entered")
	if body.is_in_group("Player"):
		print("body is player")
		player = body


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Bite":
		$AnimationPlayer.play("Move")


func _on_hurtbox_hitbox_detected(area, boxowner):
	currentHealth -= area.damage
	print("hit the rat")
	$Hurtbox.go_invincible(0.4)
	velocity.y = -300
	if player:
		velocity.x = sign( player.global_position.direction_to( global_position ).x ) * 500
	
	fsm.goto_state("Idle")
	if currentHealth <= 0:
		die()


func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		$ChaseTimer.start()


func _on_chase_timer_timeout():
	chasing = false
