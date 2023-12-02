class_name LifeBar extends HBoxContainer

@export var maxHealth : int = 100 : set = set_max
@export var currentHealth : int = 100 : set = set_current

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

## Sets and unsets hurtbox from tracking hitboxes
func set_current(track):
	currentHealth = track
	print(currentHealth)
	print(maxHealth)
	$"Progress Bar".value = (float(currentHealth) / float(maxHealth)) * 100
	print("progess val:")
	print($"Progress Bar".value)

func set_max(track):
	maxHealth = track
