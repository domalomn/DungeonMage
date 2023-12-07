extends CharacterBody2D

@export var speed = 500
var bounceNum = 0
var damage
var affliction
var bounceY = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 980

# Called when the node enters the scene tree for the first time.
func _ready():
	bounceY = -abs(velocity.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var vel = velocity
	if move_and_slide(): 
		var collision_info : KinematicCollision2D = get_last_slide_collision()
		var name = get_last_slide_collision().get_collider().name
		
		if vel.y < 0: vel.y = min(vel.y,bounceY)
		
		if name != "Player":
			if bounceNum < 2:
				velocity = vel.bounce(collision_info.get_normal())
				bounceNum += 1
			else:
				queue_free()
	# Add the gravity.
	velocity.y += gravity * delta
	
func rotate_vel(velocity, angle):
	var new_velocity = Vector2.ZERO
		
	new_velocity.x = (velocity.x * cos(angle) - velocity.y * sin(angle))
	new_velocity.y = (velocity.x * sin(angle) + velocity.y * cos(angle))
	
	return new_velocity
		
		



func _on_hitbox_hit(target):
	queue_free()
