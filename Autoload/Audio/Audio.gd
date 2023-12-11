extends Node

signal audioFinished(Channel,Stream)

func getAudio(aname:String) -> AudioStream:
	for x in AudioCache:
		if x.resource_path.contains(aname):
			await get_tree().physics_frame
			return x
		
	var paths = FileLoader.open_directory("res://Audio","")
	for x in paths: if x.contains(aname):
		
		var file = await FileLoader.loadFile(x)
		
		if file is AudioStream: 
			AudioCache.append(file)
			return file
	
	await get_tree().physics_frame
	return null


var AudioCache : Array[AudioStream] = []
func clearAudioCache(): AudioCache = []

var Channels : Dictionary = {}	
var Streams : Dictionary = {}
var Queue : Dictionary = {}

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
			

func addStream(channel:String, streamName:String):
	if hasChannel(channel) and not hasStream(channel,streamName):
		var newPlayer : ModAudioStreamPlayer = ModAudioStreamPlayer.new()
		newPlayer.bus = channel
		newPlayer.name = streamName
		newPlayer.connect("finished",checkQueue.bind(streamName,channel))
		
		Streams[channel][streamName] = newPlayer
		Queue[channel][streamName] = []
		
		Channels[channel].add_child(newPlayer)

func hasChannel(channel:String) -> bool: return Channels.keys().has(channel)
func hasStream(channel:String, streamName:String) -> bool:
	
	if hasChannel(channel):
		for x in Channels[channel].get_children():
			if streamName == x.name: return true
		
	return false
		
func checkQueue(stream:String="A", channel:String="Music"):
	if len( Queue[channel][stream] ):
		Streams[channel][stream].stream = Queue[channel][stream].pop_front()
		Streams[channel][stream].play(0)
	else: Streams[channel][stream].stream = null
	
	emit_signal("audioFinished",channel,stream)

func playAudioFromFilepath(audio:String, channel:String, stream:String, params:Dictionary={}):
	playAudio(await getAudio(audio), channel, stream, params)

func playAudio(songFile:AudioStream, channel:String, stream:String, params:Dictionary={}):
	
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
			elif params.has("parallel"): 
				stream = getParallelStream(channel,stream,params["parallel"])
				
				if len(stream): 
					if params.has("volume"): Streams[channel][stream].master_volume = params["volume"]
					playFile(Streams[channel][stream],songFile,params)
		else:
			playFile(Streams[channel][stream],songFile,params)


	
func getParallelStream(channel,stream,maxParallel):
	var useStream = stream
	if hasChannel(channel) and hasStream(channel,stream) and Streams[channel][stream].stream:
		var index = 1
		
		Streams[channel][stream].get_time_left()
		var closestToDone = stream
		while hasStream(channel,stream+str(index)) and Streams[channel][stream+str(index)].stream and index <= maxParallel: 
			index+= 1
			if hasStream(channel,stream+str(index)) and Streams[channel][closestToDone].get_time_left() > Streams[channel][stream+str(index)].get_time_left():
				closestToDone = stream+str(index)
				
		if index == maxParallel: #and hasStream(channel,useStream):
			return ""
			#useStream = closestToDone
		else:
			useStream = stream+str(index)
			if not hasStream(channel,useStream): addStream(channel,useStream)
	
	return useStream			


func playFile(stream:ModAudioStreamPlayer,songFile:AudioStream,params={}):
	stream.stream = songFile
	
	stream.play(0)
	
	if params.has("fadein"): stream.fadein(params["fadein"])
