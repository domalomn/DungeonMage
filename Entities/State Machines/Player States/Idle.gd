extends State

@export var Move_State : String = "Run"

@export var Jump_State : String = "Jump"

@export var user : Character

func get_friction(): pass

## called every physics frame when active
func physics_update(_delta): 
	user.velocity = Global.move_vector_to(user.velocity, Vector2.ZERO, user.Stats.Ground_Friction, true)
	user.move_and_slide()

## called when input is passed
func handle_input(event : InputEvent): if abs( Input.get_axis("left","right") ) > 0.1: Machine.goto_state(Move_State,{})
