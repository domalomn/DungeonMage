extends CharacterBody2D

var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal lost_player()

var speed = 195
var attackRange = 50
var maxHealth = 10
var currentHealth = maxHealth
var isAttacking = false
var damage = 5

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
	var item = null
	match randi_range(0,1):
		0:
			item = preload("res://EquippedItems/ItemList/item_firestaff.tscn").instantiate()
		1:
			item = preload("res://EquippedItems/ItemList/item_lightningstaff.tscn").instantiate()
		
	var itemDropped = preload("res://EquippedItems/dropped_item.tscn").instantiate()
	get_parent().add_child(itemDropped)
	itemDropped.itemNode = item
	itemDropped.position = global_position

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
		player.connect("death", player_died)
		print(player.is_connected("death", player_died))

func player_lost():
	if player.is_connected("death", player_died):
		player.disconnect("death", player_died)
		player = null

func player_died():
	player = null			


func _on_hurtbox_hitbox_detected(area, boxowner):
	var dmg = area.damage
	var knockDir = Vector2(velocity.x,-300)
	if is_instance_valid(player): knockDir.x = sign( player.global_position.direction_to( global_position ).x ) * 500
	if is_instance_valid(boxowner) and boxowner.is_in_group("Projectile"):
		knockDir = null
	
	currentHealth -= dmg
	$Hurtbox.go_invincible(0.4)
	if knockDir:
		velocity = knockDir
		fsm.goto_state("Idle")
	if currentHealth <= 0:
		die()
		
func _on_chase_timer_timeout():
	chasing = false
	$AnimationPlayer.play("Idle")


