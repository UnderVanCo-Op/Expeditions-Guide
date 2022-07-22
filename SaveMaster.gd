extends Reference
class_name SaveMaster

const PathsPath = "res://Paths.json"

var version := 1
var PathsFile := File.new()


func DoesSaveExists() -> bool:
	return PathsFile.file_exists(PathsPath)


func Save_paths() -> void:
	var error := PathsFile.open(PathsPath, File.WRITE)
	if error != OK:
		printerr("SaveMaster: Could not open the file %s. Aborting load operation. Error code: %s" % [PathsPath, error])
		return
	
	var data := {}
	
	
	pass


func Load_paths() -> void:
	
	var error := PathsFile.open(PathsPath, File.READ)
	if error != OK:
		printerr("SaveMaster: Could not open the file %s. Aborting load operation. Error code: %s" % [PathsPath, error])
		return
	
	# mb clearing data?
	
	var text = PathsFile.get_as_text()
	PathsFile.close()
	
	var data : Dictionary = JSON.parse(text).result
	print("SaveMaster: received data: ", data)
	
	pass







