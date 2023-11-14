extends Node2D

# Called when the node enters the scene tree for the first time.
const Textures : Array[Texture] = [
	preload("res://Josh/Art/Sword.png"),
	preload("res://Josh/Art/Throwing Knife.png")
]

func _ready(): $TextureRect.texture = Textures[randi_range(0,1)]
