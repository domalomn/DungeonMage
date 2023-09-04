class_name Character extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var world_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var State_Machine : FSM = null
@export var Stats : CharacterStats = null

func _input(event): State_Machine.current.handle_input(event)

func _physics_process(delta): State_Machine.current.physics_update(delta)

func _process(delta): State_Machine.current.update(delta)
