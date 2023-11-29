extends CharacterBody2D

var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed = 150
var attackRange = 45
var maxHealth = 5
var currentHealth = maxHealth
var isAttacking = false

var chasing : bool

@onready var fsm : FSM = $FSM

var player = null

func _ready():
	print("ready rat")

func _process(delta):
	fsm.current.physics_update(delta)

func die():
	# Remove the Rat from the scene
	queue_free()
	
func facing(f:int):
	if f < 0:
		$AnimatedSprite2D.flip_h = true
		$Hitbox.scale.x = -1
	elif f > 0:
		$AnimatedSprite2D.flip_h = false
		$Hitbox.scale.x = 1


func _on_player_detection_body_entered(body):
	print("body entered")
	if body.is_in_group("Player"):
		print("body is player")
		player = body
		chasing = true


func _on_hurtbox_hitbox_detected(area, boxowner):
	currentHealth -= area.damage
	print("hit the rat")
	
	
	velocity.y = -300
	if player:
		velocity.x = sign( player.global_position.direction_to( global_position ).x ) * 500
		
	$Hurtbox.go_invincible(0.4)
	if currentHealth <= 0:
		die()

func _on_chase_timer_timeout():
	chasing = false
