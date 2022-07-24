extends Reference
class_name SaveMaster
# This is SaveMaster.gd, low-level save work script
const PathsPath = "res://Paths.json"

var version := 1
var PathsFile := File.new()


func DoesSaveExists() -> bool:
	return PathsFile.file_exists(PathsPath)


# Low-level here
func Save_paths(_data : Dictionary) -> void:
	var error := PathsFile.open(PathsPath, File.WRITE)
	if error != OK:
		printerr("SaveMaster: Could not open the file %s. Aborting load operation. Error code: %s" % [PathsPath, error])
		return
	var json_str := JSON.print(_data)
	PathsFile.store_string(json_str)
	PathsFile.close()
	

# Low-level here
func Load_paths():
	
	var error := PathsFile.open(PathsPath, File.READ)
	if error != OK:
		printerr("SaveMaster: Could not open the file %s. Aborting load operation. Error code: %s" % [PathsPath, error])
		return
	
	# mb clearing data?
	
	var text = PathsFile.get_as_text()
	PathsFile.close()
	
	var res = JSON.parse(text).result
	if(!res):
		print("SM: error parsing JSON: null, returning...")
		return
#	if res.error != OK:
#		print("SM: error parsing JSON, text: ", res.error, " returning...")
#		return
	
	var data : Dictionary = res
	print("SaveMaster: received data: ", data)
	return data







