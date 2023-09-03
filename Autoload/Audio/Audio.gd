extends Node

## Loads an AudioStream from the string passed
func getAudio(aname:String) -> AudioStream:
	for x in AudioCache:
		if x.resource_path.contains(aname):
			await get_tree().physics_frame
			return x
		
	var paths = File.open_directory("res://Audio","")
	for x in paths: if x.contains(aname):
		File.loadFile(x)
		var file = await File.loadedFile
		
		if file is AudioStream: 
			AudioCache.append(file)
			return file
	
	await get_tree().physics_frame
	return null

## Stored Audio Files
var AudioCache : Array[AudioStream]

## Clears stored audio files
func clearAudioCache(): AudioCache = []

## Audio Channels
var Channels : Dictionary = {}	

## Audio Players
var Streams : Dictionary = {}

## Audio Cue
var Queue : Dictionary = {}

## Readies the first 3 channels
func _ready():
	Channels["Music"]	= $Music
	Channels["Sfx"]		= $Sfx
	Channels["Ambiance"]= $Ambiance
	
	for x in Channels.keys():
		Streams[x] = {}
		Queue[x] = {}
		
		for y in Channels[x].get_children():
			Streams[x][y.name] = y
			Queue[x][y.name] = []
			y.connect("finished",checkQueue.bind(y.name,x))
			
## Adds a new audio Stream to a channel
func addStream(channel:String, streamName:String):
	if hasChannel(channel) and not hasStream(channel,streamName):
		var newPlayer : ModAudioStreamPlayer = ModAudioStreamPlayer.new()
		newPlayer.name = streamName
		newPlayer.connect("finished",checkQueue.bind(streamName,channel))
		
		Streams[channel][streamName] = newPlayer
		Queue[channel][streamName] = []
		
		Channels[channel].add_child(newPlayer)

## Returns if channel exists
func hasChannel(channel:String) -> bool: return Channels.keys().has(channel)

## Returns if stream exists
func hasStream(channel:String, streamName:String) -> bool:
	
	if hasChannel(channel):
		for x in Channels[channel].get_children():
			if streamName == x.name: return true
		
	return false

## plays next Audio in queue
func checkQueue(stream:String="A", channel:String="Music"):
	if len( Queue[channel][stream] ):
		Streams[channel][stream].stream = Queue[channel][stream].pop_front()
		Streams[channel][stream].play(0)
	else: Streams[channel][stream].stream = null

## Plays Audio
func playAudio(audio:String, channel:String, stream:String, params:Dictionary={}):
	var songFile = await getAudio(audio)
	
	if hasChannel(channel):
		
		var playing = true
		
		if not hasStream(channel,stream):
			addStream(channel,stream)
			playing = false
			
		if playing and not Streams[channel][stream].stream: playing = false
		
		if params.has("volume"): Streams[channel][stream].master_volume = params["volume"]
		
		if playing:
			if params.has("queue"):
				Queue[channel][stream].append(songFile)
			elif params.has("override"):
				if params.has("fadeout"): await Streams[channel][stream].fadeout( params["fadeout"] )
				playFile(Streams[channel][stream],songFile,params)
		else:
			playFile(Streams[channel][stream],songFile,params)

## Plays audio from file				
func playFile(stream:ModAudioStreamPlayer,songFile:AudioStream,params={}):
	stream.stream = songFile
	stream.play(0)
	
	if params.has("fadein"): stream.fadein(params["fadein"])
