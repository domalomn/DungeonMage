extends Control

@export var ipAddress = "127.0.0.1"
@export var port = 8910
var peer : ENetMultiplayerPeer

func _ready():
	multiplayer.peer_connected.connect(_playerConnected)
	multiplayer.peer_disconnected.connect(_playerDisconnected)
	multiplayer.connected_to_server.connect(_serverConnected)
	multiplayer.connection_failed.connect(_failedConnection)
	
func _hostGame():
	
	#CREATES MULTIPLAYER PEER AND SERVER
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,2)
	
	if error != OK:
		print("CANNOT HOST" + str( error))
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")


func _joinGame():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ipAddress,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)


func isAuthority(): return multiplayer.get_unique_id() == get_multiplayer_authority()
func _startGame():
	if isAuthority(): GoToGame.rpc()

@rpc("call_local")
func GoToGame():
	var scene = preload("res://start_screen.tscn")
	
	print("PLEASE WORK")
	get_tree().change_scene_to_packed(scene)

func _playerConnected(id):
	print("Connected " + str(id))
	
func _playerDisconnected(id):
	print("Connection Failed " + str(id))

func _serverConnected():
	print("Connected to Server")
	
func _failedConnection():
	print("Connection Failed")
