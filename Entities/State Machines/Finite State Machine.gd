class_name FSM extends Node


@export var animation_player : AnimationPlayer = null

## List of States
var state_list : Dictionary = {}

## Verifies Child States and sets the starting state when readied
func _ready():
	verify_states()
	if readyState: current = readyState
	else: current = state_list[ state_list.keys()[0] ]

## Current State 
var current : State = null

## Starting State
@export var readyState : State = null

## Sets State via exiting the old and entering the new.
func set_state(newState:State,args:Dictionary={}):
	
	if current: current.exit_state()
		
	if newState:
		current = newState
		current.enter_state(args)

## Sets state via the name of the state
func goto_state(newState:String,args:Dictionary={}): set_state(state_list[newState],args)

## Verifies the list of states that are children to the Finite State Machine
func verify_states(): 
	state_list = {}
	for x in get_state_children(): 
		state_list[x.name] = x
		x.Machine = self
		
## Compiles of list of States that are children of the Node, as well as the children's children
func get_state_children(node:Node = self) -> Array:
	var tempList: Array[State] = []
	
	for x in get_children():
		if x is State: tempList.append(x)
		
		if x.get_child_count() and not x is FSM: for y in x.get_children(): if y is State:
			tempList.append_array( get_state_children(x) )
			break
		
	return tempList
