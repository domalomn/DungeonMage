extends State

const FLOOR_NORMAL: = Vector2.UP
@export var Idle_State : String = "Idle"
@export var user : Character
@export var idle_timer : Timer 
@export var idle_time : float = 0.25
@export var speed: = Vector2(300.0, 400.0)
@export var gravity: = 1000.0

var velocity: = Vector2.ZERO

func enter_state(arg:Dictionary = {}): animation_player.play("Walk")

## called every physics frame when active 
func physics_update(_delta): 
	
	velocity.y += gravity * _delta
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	user.velocity = velocity
	
	
	user.move_and_slide()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-Input.get_action_strength("up") 
		if user.is_on_floor() and Input.is_action_just_pressed("up") 
		else 0.0)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
		
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	return velocity

func _on_timer_timeout(): Machine.goto_state(Idle_State,{})
