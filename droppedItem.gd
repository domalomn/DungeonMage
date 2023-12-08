extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var itemNode = Node : set = textureSet

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func textureSet(setNode):
	itemNode = setNode
	$TextureRect.texture = itemNode.itemResource.gui_texture

