extends Node

# Adds an array of button children to node that are connected to connectFunc
static func get_button_list(node:Node,items:Array,connectFunc:Callable,args:Dictionary={}) -> Array[Button]:
	if args.has("purge"): for x in node.get_children(): if x is Button: x.queue_free()
	
	var Buttons : Array[Button] = []
	
	for x in items:
		var newButton = Button.new()
		var itemIndex = items.find(x)
		
		newButton.connect("pressed",connectFunc.bind(x))
		Buttons.append(newButton)
		
		if args.has("name") and len(args["name"]) > itemIndex: newButton.text = args["name"][itemIndex]
		
		if args.has("hover") and len(args["hover"]) > itemIndex: 
			newButton.connect("focus_entered", args["hover"][itemIndex])
			newButton.connect("mouse_entered", args["hover"][itemIndex])
		
		if args.has("unhover") and len(args["unhover"]) > itemIndex: 
			newButton.connect("focus_exited", args["unhover"][itemIndex])
			newButton.connect("mouse_exited", args["unhover"][itemIndex])
		
			
		node.add_child(newButton)
		
		var fontSize = newButton.get_theme_font_size("font_size")
		if args.has("max_length") and newButton.size.x > args["max_length"]:
			var ratio = float(args["max_length"])/float(newButton.size.x)
			newButton.add_theme_font_size_override("font_size",snapped(fontSize*ratio,0.5))
	
	if len(Buttons):
		Buttons[0].call_deferred("grab_focus")
		
		if len(Buttons) > 1:
			Buttons[-1].focus_neighbor_bottom = Buttons[-1].get_path_to(Buttons[0])
			Buttons[0].focus_neighbor_top  = Buttons[0].get_path_to(Buttons[-1])
			
	return Buttons

# Adds a dictionary of button children to node that are connected to connectFunc. The Keys must be strings and are used for the button text
static func get_button_list_dict(node:Node,items:Dictionary,connectFunc:Callable,args:Dictionary={}):
	var itemArray : Array = []
	args["name"] = []
	
	for x in items.keys():
		itemArray.append(items[x])
		args["name"].append(x)
	
	return get_button_list(node,itemArray,connectFunc,args)
	
## Returns a float rounded and converted to an integer
static func toInt(f : float)	->	int	:	return int( round(f) )

## Checks if num is in Bit
static func isNumInBit(num:int = 0,bit:int =1) -> bool:
	var maxPow : int = 0
	while pow(2,maxPow) < bit: maxPow+=1
	
	for x in range(maxPow,-1,-1) :
		var checkBit : int = Global.toInt(pow(2,x))
		
		if checkBit <= bit: 
			if checkBit == num: return true
			bit-= checkBit
				
	return false
