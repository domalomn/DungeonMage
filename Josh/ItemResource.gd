class_name ItemResources extends Resource

@export var itemName: String = "Sword"
@export var category: String = "Weapon"
@export var stackSize: int = 1
@export var damage: int = 5
@export var multipleTargets: bool = false
@export var radius: int = 2
@export var stunTime: int = 0
@export var timeDelay: float = 3.0

@export var gui_texture : Texture = preload("res://Josh/Art/Sword.png")
@export var use_texture : Texture = preload("res://Josh/Art/Sword.png")
