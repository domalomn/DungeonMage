class_name Hurtbox extends Area2D

## Called when a hitbox is detected in the hurtbox
signal hitbox_detected(area,boxowner)

signal hitbox_exited(area,boxowner)

## Hitbox that is ignored for hit-detection
@export var ignoreBox : Hitbox

## Owner of hurtbox
@export var boxOwner : Node

## Currently tracked hitboxes
var tracked_areas : Array

## Bool for whether the hurtbox is tracking hitboxes
var tracking : bool = true : set = set_tracking

## Sets and unsets hurtbox from tracking hitboxes
func set_tracking(track):
	tracking = track
	
	for x in get_children(): 
		if x is CollisionShape2D: 
			x.set_deferred("disabled",!tracking)

## Fired when an area enters. Fires the hitbox_detected signal if it's a hitbox	
func _area_entered(area):
	print("Hi")
	if area is Hitbox and area != ignoreBox: 
		if (not area in tracked_areas) and area.continuous_checking: 
			tracked_areas.append(area)
		
		area.emit_signal("hit",boxOwner)
		emit_signal("hitbox_detected",area,area.boxOwner)
		
		
func _ready():
	iTimer = Timer.new()
	iTimer.connect("timeout",set_tracking.bind(true))
	add_child(iTimer)
	
var iTimer : Timer
func go_invincible(time:float=0.0):
	if time > 0:
		tracking = false
		iTimer.start(time)
		
## Removes the area from tracked_areas if in the tracked_areas array
func _area_exited(area):
	if area in tracked_areas: 
		tracked_areas.erase(area)
	
	emit_signal("hitbox_exited",area,area.boxOwner)

## Fires hitbox hitting function for each tracked area
func _process(_delta):
	if tracking and tracked_areas.size():
		for x in tracked_areas:
			if not is_instance_valid(x): call_deferred("_area_exited",x)
			else: 
				call_deferred("_area_entered",x)
