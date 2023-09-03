extends Node
## I'll comment this later, promise

func _ready(): set_process(false)

var progress = []
var loading_status
var fileList = []
var loadedFiles = []

var load_progress : int = 100 : get = getLoadProgress
func getLoadProgress():
	var tFiles : float = fileList.size() + loadedFiles.size()
	if tFiles <= 0: return 0
	
	var loaded : float = loadedFiles.size()/tFiles
	load_progress = Global.toInt((progress[0]/tFiles + loaded)*100.0)
	return load_progress

func loadFile(file:String): loadList([file])
	
func loadList(files:Array[String]):
	fileList = files
	loadedFiles = []
	if fileList.size(): nextFile(fileList[0])
	
func nextFile(file:String):
	
	#Check for errors
	if ResourceLoader.load_threaded_request(file): return false
	
	set_process(true)
	return true
		
signal loadedFile(file)
signal loadedList(files)

func _process(_delta):
	loading_status = ResourceLoader.load_threaded_get_status(fileList[0],progress)
	
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		loadedFiles.append(ResourceLoader.load_threaded_get(fileList.pop_front()))
		emit_signal("loadedFile",loadedFiles[-1])
		
		if fileList.size() > 0 : 
			while (not nextFile(fileList[0]) and fileList.size() > 0): fileList.pop_front()
			
		if not fileList.size() > 0:
			emit_signal("loadedList",loadedFiles)
			set_process(false)


#"res://Battle System/Resources"

# Directory Opening
func get_file_paths(dir:String ,ext:String = "") -> Array[String]:
	var files : Array[String] = []
	
	for x in DirAccess.open(dir).get_files():
		if ext in x or ext == "" : files.append(dir + "/" + str(x))
		
	return files

func get_directory_paths(dir:String) -> Array[String]:
	var dirs : Array[String] = []
	
	for x in DirAccess.open(dir).get_directories():
		dirs.append(str(dir + "/" + x))
		
	return dirs
			
func open_directory(dir:String = "res://",ext:String = ".tres") -> Array[String]:
	var files : Array[String] = get_file_paths(dir,ext)
	var dirs : Array[String] = get_directory_paths(dir)
	
	if dirs.size() > 0:
		for x in dirs:
			files.append_array(open_directory(x,ext))
	
	return files

func load_directory(dir:String = "res://",ext:String = ".tres"):
	loadList(open_directory(dir,ext))
