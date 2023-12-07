extends Control

@onready var inventory_slots = $TextureRect/GridContainer
var holding_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input",slot_gui_input.bind(inv_slot));
		
	call_deferred("initInventory")
	
	# slots the items textures in the GUI
func initInventory():
	appendItem( preload("res://EquippedItems/ItemList/item_firestaff.tscn").instantiate() )
	appendItem( preload("res://EquippedItems/ItemList/item_Sword.tscn").instantiate() )
	appendItem( preload("res://EquippedItems/ItemList/item_Knife.tscn").instantiate() )
	appendItem( preload("res://EquippedItems/ItemList/item_HP.tscn").instantiate() )
	
# Re-Slotting the GUI with mouse 
func slot_gui_input(event: InputEvent, slot:SlotClass):
	print("AAAA")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			if holding_item != null:
				if !slot.item:
					slot.putIntoSlot(holding_item)
					holding_item = null
				else:
					var temp_item = slot.pickFromSlot()
					temp_item.global_position = get_global_mouse_position()
					
					slot.call_deferred("putIntoSlot",holding_item)
					holding_item = temp_item
					
			elif slot.item:
				holding_item = slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()
				
# Checks if item is currently slotted
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
		
# Equips first slot
func equippedItemSlot():
	return inventory_slots.get_child(0);


func appendItem(item:Node):
	for slot in inventory_slots.get_children():
		if !slot.item: 
			slot.putIntoSlot(item)
			return true
