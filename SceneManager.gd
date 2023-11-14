extends Node2D

@export var PlayerScene : PackedScene = preload("res://Entities/Player/Player.tscn")

func _ready(): call_deferred("preparePlayers")
	
func preparePlayers():
	if len(Multiplayer.Players):
		var spawners = get_tree().get_nodes_in_group("PlayerSpawn")
		var index = 0
		for x in Multiplayer.Players:
			spawnPlayer(spawners[index].global_position,x)
			index+=1
	else:
		var pos = get_tree().get_first_node_in_group("PlayerSpawn").global_position
		spawnPlayer(pos)
			
			
func spawnPlayer(pos:Vector2,id:int=1):
	var player = PlayerScene.instantiate()
	player.global_position = pos
	add_child(player)
	player.set_multiplayer(id)
