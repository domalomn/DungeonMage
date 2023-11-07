class_name Hitbox extends Area2D

## Owner of the hitbox
@export var boxOwner : Node2D

## Iframes given to target on hit
@export var iFrames : float = 0.0

@export_group("Knockback")
## Direction target is knocked into
@export var knockbackDirection : Vector2 = Vector2(0,-1)

@export_enum("Fixed","Away","Towards") var knockbackType : int = 0
@export var knockbackUseBoxownerPos : bool = false

func calcKnockback(targetPos:Vector2) -> Vector2:
	var hPos = global_position
	if knockbackUseBoxownerPos and boxOwner: hPos = boxOwner.global_position
	
	match  (knockbackType):
		0: # FIXED
			return knockbackDirection
			
		1: # AWAY
			return hPos.direction_to(targetPos).normalized()*knockbackDirection.length()
			
		2: # TOWARDS
			return targetPos.direction_to(hPos).normalized()*knockbackDirection.length()
	
	return knockbackDirection

@export var bullet_multiplier : float = 1.0

@export_group("Hit Detection")
@export var damage : int = 1
var potency : float = 1.0

@export_enum("physical","magical","almighty") var damage_type : String = "physical"

@export var continuous_checking : bool = true
## Called when the hitbox hits a target
signal hit(target)

@export_group("Score & Projectile Hit Behaviour")
@export var score_mult : float = 1.0
func calcScore(multiplier:float=1.0,bonus:int=0):
	return bonus + damage*score_mult*multiplier

@export_enum("Ignore","Destroy","Reflect") var projectile_hit_behavior : String = "Ignore"

func canHit(objType:String="Player"):
	var checkNum = 0
	
	match (objType):
		"Player": checkNum = 4
		"Enemy": checkNum = 8
		"Projectile": checkNum = 2
		
	return Global.isNumInBit(checkNum,collision_layer)
	
func set_hittable(objType:String="Player",hittable:bool=true):
	var checkNum = 0
	
	match (objType):
		"Player": checkNum = 4
		"Enemy": checkNum = 8
		"Projectile": checkNum = 2
	
	if Global.isNumInBit(checkNum,collision_layer) and not hittable:
		collision_layer-=checkNum
		
	elif hittable and not Global.isNumInBit(checkNum,collision_layer):
		collision_layer+=checkNum

func set_tracking(track):
	for x in get_children(): 
		if x is CollisionShape2D: 
			x.set_deferred("disabled",!track)
			
func _ready():
	iTimer = Timer.new()
	iTimer.connect("timeout",set_tracking.bind(true))
	add_child(iTimer)
	
var iTimer : Timer
func coolDown(time:float=0.0):
	if time > 0:
		set_tracking(false)
		iTimer.start(time)
