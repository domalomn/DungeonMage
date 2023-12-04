class_name Spawner extends Node2D

@export var SpawnNode : Node2D
@export var SpawnObject : PackedScene 
@export var isActive : bool = true : set = setActive

signal deactivated
func setActive(active):
	isActive = active
	if not active: emit_signal("deactivated")

@export var coreSpawner : bool = false

@export_group("Spawn Position")
@export var useSpawnerX : bool = false
@export var useSpawnerY : bool = false
@export var spawnPosition : Vector2 = Vector2.ZERO

@export_group("Spawn Time")
@export var spawnTime : float = 5.0
@export var initialDelay : float = 1.0

@export_group("Max Entities")
@export_range(0,20) var maxSpawnObjects = 10
@export_range(0,100) var persistentMaxSpawn = 100
@export var isInfinite : bool = false

@onready var spawnQuantity = 0
@onready var persistSpawnQuantity = 0


signal objectSpawned
signal spawnedObjectFreed
signal allFreed

func _ready(): $Timer.start(initialDelay)

func can_spawn(checkType:int = 0):
	var valid = true
	
	if checkType in [1,3]: valid = valid and spawnQuantity < maxSpawnObjects
	
	if checkType in [2,3]: valid = valid and (persistSpawnQuantity < persistentMaxSpawn or isInfinite)
		
	return valid
	
func spawn():
	if isActive and can_spawn(3):
		if not SpawnNode: SpawnNode = get_tree().get_first_node_in_group("SpawnNode")
		$MPSpawner.spawn_path = $MPSpawner.get_path_to(SpawnNode)
		
		
		var obj = SpawnObject.instantiate()
	
		var pos = spawnPosition
		if useSpawnerX: pos.x = position.x
		if useSpawnerY: pos.y = position.y
		
		obj.position = pos
		
		obj.connect("tree_exited",spawnObjectFreed)
		connect("deactivated",obj.queue_free)
		
		spawnQuantity+= 1
		persistSpawnQuantity += 1
		
		SpawnNode.add_child(obj)
		emit_signal("objectSpawned")
	
		if can_spawn(3):  $Timer.start(spawnTime)
	
func spawnObjectFreed(): 
	spawnQuantity-= 1
	if spawnQuantity == maxSpawnObjects - 1 and can_spawn(2): $Timer.start(spawnTime)
	
	emit_signal("spawnedObjectFreed")
	if spawnQuantity == 0 and not can_spawn(2):
		emit_signal("allFreed")
