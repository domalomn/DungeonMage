extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://start_screen.tscn")


func _on_options_pressed():
	# add keycode options
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_multiplayer_pressed():
	get_tree().change_scene_to_file("res://Networking/PeerToPeerConnection.tscn")
