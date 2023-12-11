extends Control

const gameScene = preload("res://Game_Room.tscn")
const music = preload("res://Music/Undying Menus.ogg")

func _ready():
	Multiplayer.connect("playerInfoUpdated",updatePlayerList)
	Audio.playAudio(music,"Music","Master",{"override":true,"volume":-10})

func _on_start_pressed():
	Global.changeScene( gameScene.instantiate() )

func _on_multiplayer_pressed():
	$Anim.play("MultiplayerState")

func _on_options_pressed():
	# add keycode options
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()

func _hostGame(): 
	Multiplayer._hostGame()
	Multiplayer.updatePlayerName.rpc($PlayerList/Name.text, multiplayer.get_unique_id())

func _joinGame():  Multiplayer._joinGame()

func _startGame(): if Multiplayer.isHost(): GoToGame.rpc()

@rpc("call_local")
func GoToGame(): Global.changeScene( gameScene.instantiate() )



func _nameEdit(): if Multiplayer.peer:
	if Multiplayer.isHost():
		Multiplayer.updatePlayerName($PlayerList/Name.text, multiplayer.get_unique_id())
	else:
		Multiplayer.updatePlayerName.rpc($PlayerList/Name.text, multiplayer.get_unique_id())
	
	
func updatePlayerList():
	var text = " Player List\n---------------"
	for x in Multiplayer.Players.keys():
		text+= "\n" + Multiplayer.Players[x].name 
		if x == multiplayer.get_unique_id(): text+=" (You)"
	
	$PlayerList/List.text = text
	$"HBoxContainer/Start Game".disabled = not (Multiplayer.Players.keys().size() > 1 and Multiplayer.isHost())
		
