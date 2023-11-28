extends CharacterBody2D

var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed = 195
var attackRange = 50
var maxHealth = 5
var currentHealth = maxHealth
var isAttacking = false

var chasing : bool

var player = null

@onready var fsm : FSM = $FSM

func _ready():
	# Initialize the Rat's state and find the player
	$AnimationPlayer.play("Idle")
	chasing = false

func _physics_process(delta):
	fsm.current.physics_update(delta)
	

func die():
	queue_free()

func facing(f:int):
	if f < 0:
		$AnimatedSprite2D.flip_h = true
		$Hitbox.scale.x = -1
		$GroundDetection.scale.x = -1
	elif f > 0:
		$AnimatedSprite2D.flip_h = false
		$Hitbox.scale.x = 1
		$GroundDetection.scale.x = 1

func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		print("Player Entered")
		player = body

func _on_hurtbox_hitbox_detected(area, boxowner):
	currentHealth -= area.damage
	print("hit the gobbin")
	$Hurtbox.go_invincible(0.4)
	velocity.y = -300
	if playerd:
		velocity.x = sign( player.global_position.direction_to( global_position ).x ) * 500
	
	fsm.goto_state("Idle")
	if currentHealth <= 0:
		die()
		
func _on_chase_timer_timeout():
	chasing = false
	$AnimationPlayer.play("Idle")

