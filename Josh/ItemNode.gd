extends Node2D

@export var itemResource : ItemResources = null : set = setItem
@export var useNode : PackedScene = preload("res://EquippedItems/equipped_sword.tscn")

@export var useCooldown : float = 0.5

@export_group("Projectile Info")
@export var projectileType : int = 0
@export var speed : float = 400
@export var damage : int = 5

func setItem(item:ItemResources):
	if itemResource and is_in_group(itemResource.category):
		remove_from_group(itemResource.category)
		
	itemResource = item
	
	if itemResource:
		$TextureRect.texture = itemResource.gui_texture
		add_to_group(itemResource.category)

func _ready(): setItem(itemResource)
