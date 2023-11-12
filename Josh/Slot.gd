class_name SlotClass
extends Panel

## This is an item class
var ItemClass = preload("res://Item.tscn")
var item = null

var default_tex = preload("res://Art/Button.png")
var empty_tex = preload("res://Art/ButtonEmpty.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
# Called when the node enters the scene tree for the first time.
func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
	randomize()
	if randi() % 2 == 0:
		print("is it working?")
		item = ItemClass.instantiate()
		add_child(item)
	refresh_style()
	
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func pickFromSlot():
	var inventoryNode = find_parent("Inventory_Gui")
	item.reparent(inventoryNode)
	inventoryNode.holding_item = self
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventoryNode = find_parent("Inventory_Gui")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
