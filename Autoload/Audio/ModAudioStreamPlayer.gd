class_name ModAudioStreamPlayer extends AudioStreamPlayer

## Master Volume
@export_range(-80,24) var master_volume : float = 0 : set = set_volume

## Volume Modifier for fade-in
@export_range(-80,24) var volume_modifier : float = 0 : set = mod_volume

## Updates volume
func updateVolume(): volume_db = master_volume + volume_modifier

## Modifies master volume
func set_volume(val):
	master_volume = val
	updateVolume()

## MOdifier volume mod
func mod_volume(val):
	volume_modifier = val
	updateVolume()

## Fades in audio
func fadein(time:float = 1.0):
	var tween : Tween = create_tween()
	volume_modifier = -80
	tween.tween_property(self,"volume_modifier",0,time)
	await  tween.finished

## Fades out audio
func fadeout(time:float = 1.0):
	var tween : Tween = create_tween()
	volume_modifier = 0
	tween.tween_property(self,"volume_modifier",-80,time)
	await  tween.finished
