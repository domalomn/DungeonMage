extends Control

const gameScene = preload("res://Game_Room.tscn")

	
func enableButtons():
	for x in $HBoxContainer.get_children():
		x.disabled = !multiplayer.is_server()

# when retry is pressed, go back to the game room
func _on_retry_pressed():
	retry.rpc()
	
@rpc("call_local")
func retry():
	Global.changeScene( gameScene.instantiate() )

# when quit is pressed, quit the game
func _on_quit_pressed():
	quit.rpc()
	
@rpc("call_local")
func quit():
	get_tree().quit()

# when main menu is pressed, go back to the main menu
func _on_main_menu_pressed():
	mainMenu.rpc()

@rpc("call_local")	
func mainMenu():
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://Aaliyah/UI/main_menu.tscn")
