class_name SlotClass
extends Panel

## This is an item class
var ItemClass = preload("res://Josh/Item.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomize()
	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		add_child(item)
	refresh_style()
	
func refresh_style():
	if item == null: theme_type_variation = "Empty"
	else: theme_type_variation = "Held"

func pickFromSlot():
	var inventoryNode = get_tree().get_first_node_in_group("InventoryGui")
	remove_child(item)
	inventoryNode.add_child(item)
	
	set_deferred("item",null)
	call_deferred("refresh_style")
	return item
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventoryNode = get_tree().get_first_node_in_group("InventoryGui")
	inventoryNode.remove_child(item)
	add_child(item)
	call_deferred("refresh_style")
