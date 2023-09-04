class_name State extends Node

## Finite State Machine
var Machine : FSM = null : set = set_machine

## Animation Player for states
var animation_player : AnimationPlayer = null

## Sets Finite state machine and animation player
func set_machine(new_machine : FSM):
	if new_machine: 
		Machine = new_machine
		
		if animation_player: animation_player.disconnect("animation_finished", _on_anim_finished )
		animation_player = Machine.animation_player
		if animation_player: animation_player.connect("animation_finished", _on_anim_finished )

## called when state is entered
func enter_state(arg:Dictionary = {}): pass


## called when state is exited
func exit_state(arg:Dictionary = {}): pass

## called when input is passed
func handle_input(_event): pass

## called every physics frame when active
func physics_update(_delta): pass

## called every process frame when active
func update(_delta): pass

## Called when animation player finishes animationi
func _on_anim_finished(anim:String): pass
