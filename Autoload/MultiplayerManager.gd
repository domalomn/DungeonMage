extends Node

var Players = {}

@export var ipAddress = "127.0.0.1"
@export var port = 8910
var peer : ENetMultiplayerPeer

func isHost(): return multiplayer.get_unique_id() == get_multiplayer_authority()

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
	
	sendPlayerInfo("Host",multiplayer.get_unique_id())

func _joinGame():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ipAddress,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
func _playerConnected(id):
	print("Connected " + str(id))
		
func _playerDisconnected(id):
	print("Connection Failed " + str(id))

func _serverConnected():
	print("Connected to Server")
	
	sendPlayerInfo.rpc_id(1,"Groupie",multiplayer.get_unique_id())
	
func _failedConnection():
	print("Connection Failed")

@rpc("any_peer")
func sendPlayerInfo(n,id):
	if !Multiplayer.Players.has(id):
		Multiplayer.Players[id] = {
			"name": n,
			"id": id
		}
	
	emit_signal("playerInfoUpdated")
	if multiplayer.is_server():
		for x in Multiplayer.Players.keys(): 
			sendPlayerInfo.rpc(Multiplayer.Players[x]["name"],Multiplayer.Players[x]["id"])

signal playerInfoUpdated

@rpc("any_peer")
func updatePlayerName(n,id):
	if Multiplayer.Players.has(id): 
		Multiplayer.Players[id].name = n
		emit_signal("playerInfoUpdated")
		
		if multiplayer.is_server():
			for x in Multiplayer.Players.keys():
				updatePlayerName.rpc(n,id)

