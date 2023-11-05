extends Node2D

var speed = 150
var spacing = 0.1
var velocity

var damage
var affliction

const pelletPath = preload("res://Entities/Projectiles/shotgun_pellet.tscn")

var alreadySplit = false
var rotation_degree = 0.16667 * PI
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _process(delta):
	#if Input.is_action_just_pressed("Split"):
		#split()
		
		for n in 5:
			generateRandomPellet()
			
		
		queue_free()

func generateRandomPellet():
	var newBullet = pelletPath.instantiate()
	newBullet.position = position
	newBullet.velocity = velocity
	print(velocity)
	
	get_parent().add_child(newBullet)
	var my_random_number = rng.randf_range(-rotation_degree, rotation_degree)
	
	newBullet.velocity = rotate_vel(newBullet.velocity, my_random_number)

func split():
	
	var newBullet = pelletPath.instantiate()
	
	newBullet.position = position
	newBullet.velocity = velocity
	
	get_parent().add_child(newBullet)
	
	newBullet.position += rotate_vel(newBullet.velocity, 0.5 * PI) * spacing
	position += rotate_vel(velocity, -0.5 * PI) * spacing
	
	newBullet.velocity = rotate_vel(newBullet.velocity, rotation_degree)
	velocity = rotate_vel(velocity, -rotation_degree)
	
func rotate_vel(velocity, angle):
	var new_velocity = Vector2.ZERO
		
	new_velocity.x = (velocity.x * cos(angle) - velocity.y * sin(angle))
	new_velocity.y = (velocity.x * sin(angle) + velocity.y * cos(angle))
	
	return new_velocity
		
