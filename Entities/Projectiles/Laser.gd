extends Node2D

@onready var sender = get_tree().get_first_node_in_group("Player")

var bounces := 1

const MAX_LENGTH := 2000

@onready var line = $Line2D
var max_cast_to
var rot:= 0.0

var lasers := []

func _ready():
	lasers.append($RayCast2D)
	
	for i in range(bounces):
		var raycast = $RayCast2D.duplicate()
		raycast.enabled = false
		raycast.add_exception(sender)
		add_child(raycast)
		lasers.append(raycast)
		
	max_cast_to = Vector2(MAX_LENGTH, 0).rotated(rot)
	$RayCast2D.target_position = max_cast_to
	
	$Line2D.set_as_top_level(true)
	
func _process(delta):
	
	if Input.is_action_just_released("Fire"):
		queue_free()
	
	global_position = sender.get_node("BulletDirection").get_node("BulletStart").global_position
	
	rot = get_local_mouse_position().angle()
	
	line.clear_points()
	
	line.add_point(global_position)
	
	max_cast_to = Vector2(MAX_LENGTH, 0).rotated(rot)
	
	var idx = -1
	for raycast in lasers:
		
		idx += 1
		var raycastcollision = raycast.get_collision_point()
		
		raycast.target_position = max_cast_to
		
		if raycast.is_colliding():
			
			line.add_point(raycastcollision)
			
			var collider = raycast.get_collider()
			
			max_cast_to = max_cast_to.bounce(raycast.get_collision_normal())
			
			if idx < lasers.size() - 1:
				lasers[idx + 1].enabled = true
				lasers[idx + 1].global_position = raycastcollision + (1 * max_cast_to.normalized())
			if idx == lasers.size() - 1:
				$GPUParticles2D.global_position = raycastcollision
		else:
			line.add_point(global_position + max_cast_to)
			
			if idx == 0:
				raycast.target_position = max_cast_to
				$GPUParticles2D.global_position = global_position + max_cast_to
			else:
				$GPUParticles2D.global_position = raycast.global_position + max_cast_to
				
	
