extends Control

@onready var inventory_slots = $TextureRect/GridContainer
var holding_item = null
var equipSlotIndex = 0
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
	appendItem( preload("res://EquippedItems/ItemList/item_Bomb.tscn").instantiate() )
	appendItem( preload("res://EquippedItems/ItemList/item_ice.tscn").instantiate() )
# Re-Slotting the GUI with mouse 
func slot_gui_input(event: InputEvent, slot:SlotClass):
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
		
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && event.pressed: incrementEquipSlot(1)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && event.pressed: incrementEquipSlot(-1)
		
# Equips first slot
func equippedItemSlot():
	return inventory_slots.get_child(equipSlotIndex);


func appendItem(item:Node) -> bool:
	for slot in inventory_slots.get_children():
		if !slot.item: 
			slot.putIntoSlot(item)
			return true
			
	return false

func incrementEquipSlot(amount=1):
	equippedItemSlot().material = null
	while true:
		equipSlotIndex += amount
		if equipSlotIndex > 9: equipSlotIndex = 0
		
		if equippedItemSlot() and equippedItemSlot().item: break
		
	equippedItemSlot().material = preload("res://Josh/Art/equipShader.tres")
