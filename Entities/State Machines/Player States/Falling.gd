extends State

@export var Idle_State : String = "Idle"
@export var user : Character

@export var speed : float = 300
@export var acceleration : float = 50

@export var maxjumps : int = 1
@export var airJumpHeight : float = -500

var jumps = 0
var plummet = false
func enter_state(arg:Dictionary = {}):
	jumps = maxjumps
	plummet = false
	if arg.has("jumpHeight"): jump(arg.jumpHeight)
	user.facing = sign( user.velocity.x)
	animation_player.play("Jump")
	moveControlTimer = 0

func jump(jumpHeight:float=airJumpHeight): 
	user.velocity.y = jumpHeight
	
var moveControlTimer = 0
func physics_update(delta): 
	
	
	if abs(user.velocity.y) > 5:
		if plummet: user.velocity.y+= 250
		elif Input.is_action_pressed("up") and user.velocity.y < 0: user.velocity.y+= 20
		else: user.velocity.y+= 50
	else:
		user.velocity.y+= 1
		
	if moveControlTimer <= 0: 
		var dir = get_direction()
		if abs(dir.x) <= 0.1: dir.x = user.velocity.x
		user.velocity = user.velocity.move_toward(dir,acceleration)
	else: moveControlTimer-=delta
	
	var v = user.velocity
	
	if user.move_and_slide():
		var collision : KinematicCollision2D = user.get_last_slide_collision()
		var collider = collision.get_collider()
		
		if collider is CharacterBody2D:
			user.velocity = v.bounce(collision.get_normal())
			if user.velocity.y < 0 and collision.get_normal().y < -0.8:
				if plummet: user.velocity.y = airJumpHeight*2
				else: user.velocity.y = airJumpHeight
				
				if jumps <= 0: jumps=1
				plummet = false
	
			
	if plummet: user.velocity = user.velocity.limit_length(3000)
	else: user.velocity = user.velocity.limit_length(1400)
	
	if user.is_on_floor() and user.velocity.y >= 0: 
		
		if plummet:
			if Input.is_action_pressed("down"):
				user.velocity.y = airJumpHeight*abs(v.y)*0.0013
			else:
				user.velocity.y = airJumpHeight
				
			user.velocity = user.velocity.rotated(user.get_floor_normal().x)
				
			plummet = false
			jumps = maxjumps
		else:
			plummet = false
			jumps = 0
			
			if abs(get_direction().x) > 0: Machine.goto_state("Move",{})
			else: Machine.goto_state("Idle",{})
			
			user.velocity.y = 0
	
func _input(event):
	if Input.is_action_just_pressed("down"): plummet = true
	
	if Input.is_action_just_pressed("up"):
		if user.is_on_wall() and not user.is_on_floor():
			var dir = user.get_wall_normal()
			dir.x*=speed*1.25
			
			jump()
			dir.y+= user.velocity.y*0.8
			plummet = false
			user.velocity = dir
			
			user.facing = sign(dir.x)
			animation_player.play("Jump")
			moveControlTimer = 0.25
		
		elif jumps > 0:
			plummet = false
			jump()
			user.velocity = get_direction()
			jumps-= 1
			
			user.facing = sign(user.velocity.x)
			
			if user.facing > 0: animation_player.play("AirJumpR")
			else: animation_player.play("AirJumpL")
			moveControlTimer = 0.2
		
	
			
func get_direction() -> Vector2: 
	return Vector2(Input.get_axis("left","right")*speed,user.velocity.y)
