extends State

@export var Move_State : String = "Move"

@export var Jump_State : String = "Falling"

@export var user : Character

func get_friction(): pass

func enter_state(arg:Dictionary = {}): 
	animation_player.play("Idle")

## called every physics frame when active
func physics_update(_delta): 
	
	user.velocity = Global.move_vector_to(user.velocity, Vector2.ZERO, user.Stats.Ground_Friction, true)
	user.move_and_slide()
	
	if not user.is_on_floor(): Machine.goto_state(Jump_State,{})

## called when input is passed
func handle_input(event : InputEvent): 
	if abs( Input.get_axis("left","right") ) > 0.1: 
		Machine.goto_state(Move_State,{})
	
	if Input.is_action_just_pressed("up"): 
		Machine.goto_state(Jump_State,{"jumpHeight":-600})
	
