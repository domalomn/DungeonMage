extends State

@export var Idle_State : String = "Idle"
@export var user : Character
@export var idle_timer : Timer 
@export var idle_time : float = 0.25

## called every physics frame when active
func physics_update(_delta): 
	var movement : Vector2 = Vector2(user.Stats.Ground_Speed, 0)*Input.get_axis("left","right")
	var isMoving = abs(movement.x) > 0.2
	if isMoving: idle_timer.start(idle_time)
	
	if abs( movement.angle_to(user.velocity) ) > PI/2 or not isMoving:
		user.velocity = Global.move_vector_to(user.velocity, movement, user.Stats.Ground_Friction, true)
	else:
		user.velocity = Global.move_vector_to(user.velocity, movement, user.Stats.Ground_Acceleration, false)
	user.move_and_slide()
	
	if not user.is_on_floor(): Machine.goto_state("Falling",{})

func _on_timer_timeout(): Machine.goto_state(Idle_State,{})
