extends Control



	
func _hostGame(): Multiplayer._hostGame()

func _joinGame():  Multiplayer._joinGame()

func _startGame(): if Multiplayer.isHost(): GoToGame.rpc()

var scene = preload("res://start_screen.tscn")

@rpc("call_local")
func GoToGame(): 
	var oldScene = get_tree().current_scene
	var newScene = scene.instantiate()
	print(oldScene.name)
	
	get_tree().get_root().add_child(newScene)
	get_tree().current_scene = newScene
	oldScene.queue_free()
	
	print(get_tree().current_scene.name)


