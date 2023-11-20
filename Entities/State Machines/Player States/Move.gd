extends State

@export var Idle_State : String = "Idle"
@export var user : Character

@export var idle_time : float = 0.25

@export var speed : float = 300
@export var acceleration : float = 50

func enter_state(arg:Dictionary = {}):
	animation_player.play("Walk")

## called every physics frame when active 
var idleTime = 0.25
func physics_update(delta): 
	var direction : Vector2 = get_direction()
	
	user.velocity = user.velocity.move_toward(direction*speed,acceleration)
	
	user.move_and_slide()
	
	if direction.length() > 0: idleTime = idle_time
	else: 
		
		idleTime -= delta
		if idleTime <= 0: Machine.goto_state(Idle_State,{})

func handle_input(event : InputEvent): 
	
	if Input.is_action_just_pressed("up"): 
		Machine.goto_state("Falling",{"jumpHeight":-600})
		
func get_direction() -> Vector2: 
	return Vector2(Input.get_axis("left","right"),0)
