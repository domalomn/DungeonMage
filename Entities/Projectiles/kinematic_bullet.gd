extends CharacterBody2D

@export var speed = 500
var spacing = 0.1
var damage
var affliction

var alreadySplit = false
var rotation_degree = 0.16667 * PI
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if collision_info:
		queue_free()
	
func _process(delta):
	#if Input.is_action_just_pressed("Split"):
		#split()
	pass

func split():
	if alreadySplit:
		return
	
	var newBullet = duplicate()
	
	newBullet.position = position
	newBullet.velocity = velocity
	
	get_parent().add_child(newBullet)
	
	newBullet.position += rotate_vel(newBullet.velocity, 0.5 * PI) * spacing
	position += rotate_vel(velocity, -0.5 * PI) * spacing
	
	newBullet.velocity = rotate_vel(newBullet.velocity, rotation_degree)
	velocity = rotate_vel(velocity, -rotation_degree)
	
	alreadySplit = true
	newBullet.alreadySplit = true
	
func rotate_vel(velocity, angle):
	var new_velocity = Vector2.ZERO
		
	new_velocity.x = (velocity.x * cos(angle) - velocity.y * sin(angle))
	new_velocity.y = (velocity.x * sin(angle) + velocity.y * cos(angle))
	
	return new_velocity
		
		


func _on_hitbox_hit(target):
	queue_free()
