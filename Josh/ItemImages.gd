extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("it works")
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://Art/Sword.png")
	else:
		$TextureRect.texture = load("res://Art/Throwing Knife.png")
