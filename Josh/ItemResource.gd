class_name ItemResources extends Resource

# Basic Variables initalized to call under resource.
@export var itemName: String = "Sword"
@export var category: String = "Weapon"
@export var isStaff: bool = false
@export var stackSize: int = 1
@export var timeDelay: float = 3.0

@export var gui_texture : Texture = preload("res://Josh/Art/Sword.png")
