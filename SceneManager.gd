extends Node2D

@export var PlayerScene : PackedScene = preload("res://Entities/Player/Player.tscn")

var controlPlayerHealth : LifeBar
var controlPlayerInventory : Control

func _ready(): 
	controlPlayerHealth = get_tree().get_first_node_in_group("Life Bar")
	controlPlayerInventory = get_tree().get_first_node_in_group("InventoryGui")
	if Multiplayer.isHost(): 
		spawnPlayers.rpc()
	
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
			
			if multiplayer.get_unique_id() == Multiplayer.Players[x].id: 
				linkHealthToHost(player)
			
	else:
		var pos = get_tree().get_first_node_in_group("PlayerSpawn").global_position
		var player = PlayerScene.instantiate()
		add_child(player)
		player.setAuth(multiplayer.get_unique_id())
		player.global_position = pos
		linkHealthToHost(player)
	
func linkHealthToHost(player):
	player.lifeBar = controlPlayerHealth
	player.lifeBar.maxHealth = player.maxHealth
	player.lifeBar.currentHealth = player.Health
	player.InventoryRef = controlPlayerInventory 
