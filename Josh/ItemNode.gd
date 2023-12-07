extends Node2D

#Setting Item Variables for Item Resources made.
@export var itemResource : ItemResources = null : set = setItem
@export var useNode : PackedScene = preload("res://EquippedItems/equipped_sword.tscn")

@export var useCooldown : float = 0.2

@export_group("Projectile Info")
@export var projectile : PackedScene = null
@export var projectileType : int = 0
@export var speed : float = 600
@export var damage : int = 1

@export_group("Consumable Info")
@export var hp_up : int = 0

# Checks Resources for specific variables to set categories types.
func setItem(item:ItemResources):
	if itemResource and is_in_group(itemResource.category):
		remove_from_group(itemResource.category)
		
	itemResource = item
	
	if itemResource:
		$TextureRect.texture = itemResource.gui_texture
		add_to_group(itemResource.category)

func _ready(): setItem(itemResource)
