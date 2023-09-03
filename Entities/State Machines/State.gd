class_name State extends Node

var Machine : FSM = null : set = set_machine

@export var animation_player : AnimationPlayer = null
@export var animation_player_override : bool = true

func set_machine(new_machine : FSM):
	if new_machine: 
		Machine = new_machine
		
		if animation_player_override:
			if animation_player: animation_player.disconnect("animation_finished", _on_anim_finished )
			animation_player = Machine.animation_player
			animation_player.connect("animation_finished", _on_anim_finished )

func enter_state(arg:Dictionary = {}): pass

func exit_state(arg:Dictionary = {}): pass

func handle_input(_event): pass

func physics_update(_delta): pass

func update(_delta): pass

func _on_anim_finished(anim:String): pass
