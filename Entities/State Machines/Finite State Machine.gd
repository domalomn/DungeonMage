class_name FSM extends Node


@export var animation_player : AnimationPlayer = null

## List of States
var state_list : Dictionary = {}

var current : State = null : set = set_state

func set_state(newState:State):
	var args = []
	
	if current: args = current.exit_state()
		
	if newState:
		current = newState
		current.enter_state(args)

## Verifies the list of states that are children to the Finite State Machine
func verify_states(): 
	state_list = {}
	for x in get_state_children(): state_list[x.name] = x

## Compiles of list of States that are children of the Node, as well as the children's children
func get_state_children(node:Node = self) -> Array:
	var tempList: Array[State] = []
	
	for x in get_children():
		x.Machine = self
		if x is State: tempList.append(x)
		
		if x.get_child_count() and not x is FSM: tempList.append_array( get_state_children(x) )
		
	return tempList
	
# Called when the node enters the scene tree for the first time.
func _ready(): verify_states()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
