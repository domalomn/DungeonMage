extends CharacterBody2D

var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal lost_player()

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
		$GroundDetection.scale.x = -1
	elif f > 0:
		$AnimatedSprite2D.flip_h = false
		$Hitbox.scale.x = 1
		$GroundDetection.scale.x = 1


func _on_player_detection_body_entered(body):
	print("body entered")
	if body.is_in_group("Player"):
		print("body is player")
		# temp check if already pursuing player?
		if is_instance_valid(player):
			player_lost()
		player = body
		player.connect("death", player_died)

func player_lost():
	if player.is_connected("death", player_died):
		player.disconnect("death", player_died)
		player = null

func player_died():
	player = null


func _on_hurtbox_hitbox_detected(area, boxowner):
	var knockDir = Vector2(velocity.x,-300)
	if player:
		knockDir.x = sign( player.global_position.direction_to( global_position ).x ) * 500
		
	getHurt.rpc(area.damage,knockDir)

@rpc("any_peer","call_local")
func getHurt(dmg,knockDir):
	currentHealth -= dmg
	$Hurtbox.go_invincible(0.4)
	velocity = knockDir
	
	if currentHealth <= 0:
		die()
		
func _on_chase_timer_timeout():
	chasing = false
