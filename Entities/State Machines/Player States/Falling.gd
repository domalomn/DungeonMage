extends State

@export var Idle_State : String = "Idle"
@export var user : Character

func physics_update(_delta): 
	user.velocity.y+= 6
	user.move_and_slide()
	
	if user.is_on_floor(): 
		Machine.goto_state(Idle_State,{})
		user.velocity.y = 0
