extends Control



	
func _hostGame(): Multiplayer._hostGame()

func _joinGame():  Multiplayer._joinGame()

func _startGame(): if Multiplayer.isHost(): GoToGame.rpc()

var scene = preload("res://start_screen.tscn")

@rpc("call_local")
func GoToGame(): Global.changeScene( scene.instantiate() )


