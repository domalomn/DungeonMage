extends Node2D

const slotScene = preload("res://start_screen.tscn")


var Arr : Array = []


func _ready():
	for x in $Rect/GC.get_children():
		Arr.append(x)
		
	
func _button_press(number,string="Hello"):
	print(number)
	print(string)
	
	emit_signal("onMyGrave")
	
	


func _I_Die(val):
	print(val)
