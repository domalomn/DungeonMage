extends CharacterBody2D

var speed = 500
var player

enum {FLY, BACK}
var state: int = FLY

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	player = get_tree().get_first_node_in_group("Player")
	print(player.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var backVector: Vector2 = player.position - position
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if state == FLY && Input.is_action_just_pressed("AltFire"):
		velocity = Vector2.ZERO
	
	if collision_info || Input.is_action_just_released("AltFire"):
		state = BACK
		
	
	if state == BACK:
		velocity = backVector
		if backVector.length() < 5:
			queue_free()
			
	$Sprite.rotate(.5)

