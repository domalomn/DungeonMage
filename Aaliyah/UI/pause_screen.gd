extends Control

@onready var pause_screen = $/root/GameRoom/PauseScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_resume_pressed():
	#hide pause menu
	pause_screen.visible = false
	#set pauses state to be false
	get_tree().paused = false
	#accept movement and input
	set_process_input(true)
	set_physics_process(true)

func _on_save_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Main Menu.gd")
	get_tree().paused = false

