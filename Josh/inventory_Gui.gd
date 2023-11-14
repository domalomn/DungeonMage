extends Control

@onready var inventory_slots = $TextureRect/GridContainer
var holding_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input",slot_gui_input.bind(inv_slot));

func slot_gui_input(event: InputEvent, slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
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
				
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
