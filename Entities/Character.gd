class_name Character extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentItemSelected

@export var State_Machine : FSM = null
@export var Stats : CharacterStats = null
@export var aimStartPos : Marker2D = null
@export var meleeHitbox : Hitbox = null
@export var meleeTimer : Timer = null

func setAuth(id:int): 
	name = "Player" + str(id)
	%MultiplayerSynchronizer.set_multiplayer_authority(id)

func _ready():
	currentItemSelected = get_tree().get_first_node_in_group("InventoryGui").equippedItem()
	meleeHitbox.get_child(0).disabled = true

func _input(event): if %MultiplayerSynchronizer.is_multiplayer_authority(): State_Machine.current.handle_input(event)

func _physics_process(delta): 
	State_Machine.current.physics_update(delta)
	if Input.is_action_just_pressed("A"):
		useItem() 
	#aimStartPos.look_at(get_global_mouse_position())
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		meleeHitbox.get_child(1).flip_h = true
		if meleeHitbox.position.x > 0:
			meleeHitbox.position *= Vector2(-1, 1)
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		meleeHitbox.get_child(1).flip_h = false
		if meleeHitbox.position.x < 0:
			meleeHitbox.position *= Vector2(-1, 1)

func _process(delta): State_Machine.current.update(delta)

func useItem():
	print("Using item.")
	currentItemSelected = get_tree().get_first_node_in_group("InventoryGui").equippedItem()
	if currentItemSelected == null: 
		return
	print(currentItemSelected.get_groups())
	var bulletPath
	if currentItemSelected.is_in_group("Staff"):
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
			bullet.affliction = currentItemSelected.affliction;
		
			get_parent().add_child(bullet)
			# starts at player position
			bullet.position = global_position
			# fires from unit vector pointing from player to cursor, speed is determined from staff data
			bullet.velocity = (get_global_mouse_position() - bullet.position).normalized() * bullet.speed
		
		
		else:
			var laser = bulletPath.instantiate()
			get_parent().add_child(laser)
			laser.position = global_position
		
		# returns fire rate given by staff instance so a timer can be determined for outside function calling UseItem (likely phsyics_process)
		# laser-class staffs should have a fire rate of zero as there should be no delay for an active laser.
		# as should consumable items (if godot requires a return throughout func when a return is specified i'm not sure)
		return currentItemSelected.firerate
	elif currentItemSelected.is_in_group("Item") && meleeTimer.is_stopped():
		print("Item found.")
		meleeHitbox.get_child(0).disabled = false
		meleeHitbox.get_child(2).play("Slash")
		meleeTimer.start()

func _on_melee_timer_timeout():
	meleeHitbox.get_child(0).disabled = true
	print("Attack ended.")
