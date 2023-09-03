extends CanvasLayer

var scene : String = "res://world.tscn"
var progress = []
var loading_status

## Stops processing so that 
func _ready():
	# $AnimationPlayer.play("Invisible")
	set_process(false)

## Changes scene based on nodePath / String
func change_scene(new_scene="res://world.tscn"):
	
	%Screenshot.texture = await screenshot()
	
	scene = new_scene
	if ResourceLoader.load_threaded_request(scene): # Check for errors.
		set_process(false)
		return
	
	get_tree().paused = true
	
	# $AnimationPlayer.play("Fade_In")
	# $Control/ProgressBar.value = 0
	
	
	## Await Scene Change Animation to finish
	# await $AnimationPlayer.animation_finished
	
	await get_tree().create_timer(0.25).timeout
	set_process(true)
	
	
func goto_scene():
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene))
		#$AnimationPlayer.play("Fadeout")
		get_tree().paused = false
		
func _process(_time):
	loading_status = ResourceLoader.load_threaded_get_status(scene,progress)
	
	
	# Update Progress
	## $Control/ProgressBar.value = progress[0]*100.0
	
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		call_deferred("goto_scene")
		set_process(false)

func screenshot() -> ImageTexture:
	await RenderingServer.frame_post_draw
	var capture = get_viewport().get_texture().get_image()
	return ImageTexture.create_from_image(capture)
