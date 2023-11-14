extends Node2D

@export var PlayerScene : PackedScene = preload("res://Entities/Player/Player.tscn")



func _ready(): if Multiplayer.isHost(): spawnPlayers.rpc()
	
@rpc("call_local")
func spawnPlayers():
	
	if Multiplayer.Players.size():
		var spawners = get_tree().get_nodes_in_group("PlayerSpawn")
		var index = 0
		for x in Multiplayer.Players.keys():
			var player = PlayerScene.instantiate()
			add_child(player)
			player.setAuth(Multiplayer.Players[x].id)
			player.global_position = spawners[index].global_position
			index+=1
			
	else:
		var pos = get_tree().get_first_node_in_group("PlayerSpawn").global_position
		var player = PlayerScene.instantiate()
		add_child(player)
		player.setAuth(multiplayer.get_unique_id())
		player.global_position = pos
	
	
