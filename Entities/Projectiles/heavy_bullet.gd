extends CharacterBody2D

var speed = 500
var bounceNum = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var vel = velocity
	if move_and_slide(): 
		var collision_info : KinematicCollision2D = get_last_slide_collision()
		var name = get_last_slide_collision().get_collider().name
		if name != "Player":
			if bounceNum <= 1:
				velocity = vel.bounce(collision_info.get_normal())
				bounceNum += 1
				print(bounceNum)
			else:
				queue_free()
	# Add the gravity.
	velocity.y += gravity * delta
	
func rotate_vel(velocity, angle):
	var new_velocity = Vector2.ZERO
		
	new_velocity.x = (velocity.x * cos(angle) - velocity.y * sin(angle))
	new_velocity.y = (velocity.x * sin(angle) + velocity.y * cos(angle))
	
	return new_velocity
		
		

