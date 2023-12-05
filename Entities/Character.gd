class_name Character extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentItemSelected

@export var State_Machine : FSM = null
@export var Stats : CharacterStats = null
@export var aimStartPos : Marker2D = null
@export var meleeHitbox : Hitbox = null
@export var meleeTimer : Timer = null

var InventoryRef : Control
var lifeBar : LifeBar

var itemInRange

signal death()

var isHolding: bool = false

func setAuth(id:int): 
	name = "Player" + str(id)
	%MultiplayerSynchronizer.set_multiplayer_authority(id)
	$Camera2D.enabled = %MultiplayerSynchronizer.is_multiplayer_authority()
	if id != 1: 
		$AnimatedSprite2D.material.set_shader_parameter("paletteMix",1.0)
		$Flipper.material.set_shader_parameter("paletteMix",1.0)
	else: 
		$AnimatedSprite2D.material.set_shader_parameter("paletteMix",0.0)
		$Flipper.material.set_shader_parameter("paletteMix",0.0)

func _ready():
	currentItemSelected = get_tree().get_first_node_in_group("InventoryGui").equippedItemSlot().item
	

func _input(event): if %MultiplayerSynchronizer.is_multiplayer_authority(): State_Machine.current.handle_input(event)

var facing = 1
func _physics_process(delta): 
	State_Machine.current.physics_update(delta)
	
	if Input.is_action_just_pressed("A") and  %MultiplayerSynchronizer.is_multiplayer_authority():
		useItem() 
		
	if Input.is_action_just_pressed("Y") and  %MultiplayerSynchronizer.is_multiplayer_authority():
		pickUp()
		
	if facing < 0:
		$AnimatedSprite2D.flip_h = true
		$Flipper.scale.x = -3
		if $Flipper.position.x < 0:
			$Flipper.position *= Vector2(-1, 1)
	elif facing > 0:
		$AnimatedSprite2D.flip_h = false
		$Flipper.scale.x = 3
		if $Flipper.position.x > 0:
			$Flipper.position *= Vector2(-1, 1)

func _process(delta): State_Machine.current.update(delta)

func die():
	emit_signal("death")
	$AnimationPlayer.play("Die")
	
	call_deferred("deathAnim")
	
func deathAnim():
	if await $AnimationPlayer.animation_finished == "Die":
		queue_free()

func pickUp():
	if is_instance_valid(itemInRange):
		InventoryRef.appendItem(itemInRange.itemNode)
		itemInRange.queue_free()
		

func useItem():
	currentItemSelected = InventoryRef.equippedItemSlot().item
	
	if !(currentItemSelected and $AttackCooldown.is_stopped()): return
		
	print(currentItemSelected.itemResource.category)
	
	
	if currentItemSelected.itemResource.category == "Staff":
		var bulletPath
		
		# checks enum in staff instance for its projectile type to instantiate bullet upon firing
		match currentItemSelected.projectileType:
			0:
				bulletPath = preload("res://Entities/Projectiles/kinematic_bullet.tscn")
			1:
				bulletPath = preload("res://Entities/Projectiles/heavy_bullet.tscn")
			2:
				bulletPath = preload("res://Entities/Projectiles/shotgun_spray.tscn")
			3:
				bulletPath = preload("res://Entities/Projectiles/sickle_shot.tscn")
			4:
				bulletPath = preload("res://Entities/Projectiles/laser.tscn")
		if currentItemSelected.projectileType != 4:
			var bullet = bulletPath.instantiate()
			
			# any instance of a staff should contain variables that can set the variables of its bullets (such as speed, damage per bullet, and any status affliction)
			bullet.speed = currentItemSelected.speed;
			bullet.damage = currentItemSelected.damage;
			#bullet.affliction = currentItemSelected.affliction;
		
			get_parent().add_child(bullet)
			# starts at player position
			bullet.position = global_position
			# fires from unit vector pointing from player to cursor, speed is determined from staff data
			bullet.velocity = (get_global_mouse_position() - bullet.position).normalized() * bullet.speed
		
		# no velocity value for laser, so it needs a seperate condition.
		else:
			var laser = bulletPath.instantiate()
			laser.damage = currentItemSelected.damage;
			get_parent().add_child(laser)
			laser.position = global_position
		
		# (At the moment) checks for a generic item to perform a melee attack.
		# Enabled hitbox and starts animation and timer.
	elif currentItemSelected.itemResource.category == "Consumable":
			print("using consumable")
			Health += currentItemSelected.hp_up
			InventoryRef.equippedItemSlot().pickFromSlot()
			currentItemSelected.queue_free()
	else:
		var useItem = currentItemSelected.useNode.instantiate()
		$Flipper.add_child(useItem)
		
	$AttackCooldown.start(currentItemSelected.useCooldown)

@export var maxHealth : int = 5
@onready var Health = maxHealth : set = setHealth

func _getHit(area, boxowner):
	
	velocity.y-=300
	Health-=1
	$Hurtbox.go_invincible(0.4)
	if Health <= 0:
		queue_free()
	

func setHealth(newHealth):
	Health = newHealth
	if Health > maxHealth: Health = maxHealth
	if lifeBar:
		lifeBar.currentHealth = Health


func _on_item_detector_area_entered(area):
	itemInRange = area.get_parent()



func _on_item_detector_area_exited(area):
	itemInRange = null


func _on_item_detector_body_entered(body):
	print("item found.")
	itemInRange = body
	



func _on_item_detector_body_exited(body):
	itemInRange = null
