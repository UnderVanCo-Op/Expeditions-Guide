tool
extends Node2D

var PathScene = preload("res://Objects/Way.tscn")
var togglePathLoading = true		# will load paths from save file on scene reload (CTRL+R), DELETING others


func _ready() -> void:
	if not Engine.editor_hint:
		print("PL: in game, so quitting for now")
		return
	if(!togglePathLoading):
		print("PL: Ready of a PathsLoader, but Path Loading is off, returning...")
		return
	print("PL: Ready of a PathsLoader, Path Loading is on; deleting Lines node contents...")
	
	for child in get_node("../../Lines").get_children():	# removing existing paths
		child.queue_free()
	
	# Paths work (visual part)
	var PathsPath = "res://Paths.json"
	var PathsFile := File.new()
	
	var error := PathsFile.open(PathsPath, File.READ)
	if error != OK:
		printerr("PL: Could not open the file %s. Aborting load operation. Error code: %s" % [PathsPath, error])
		return
	
	# mb clearing data?
	
	var text = PathsFile.get_as_text()
	PathsFile.close()
	
	var data : Dictionary = JSON.parse(text).result
	print("PL: received data: ", data)
	
	var ps = get_node_or_null("../../Points")
	if(!ps):
		printerr("PL: could not get Points node, no Paths will be drawn")
		return
	
	var ParList := []				# only for editor purposes
	for p in ps.get_children():		# for each node of a point in Points
		if(p.name in data.keys()):	# if this point is in save file
#			print("\nPL: Found some point in saved data: ", p.name, ", data: ", data[p.name])
			var content = data[p.name] as Array
			for adjps in content:
#				print("PL: Adj point '", adjps,"' found!")
				var _adjp = get_node_or_null("../../Points/" + str(adjps))
				if(!_adjp):
					printerr("PL: could not get adjacent point from save, do you have old save file?")
					return
				
				if([p.position, _adjp.position] in ParList or [_adjp.position, p.position] in ParList):
#					print("PL: this way is already on the map, skipping...")
					continue	# (for next adjpoint of this point) 
				
				ParList.append([p.position, _adjp.position])
				var newWay = PathScene.instance()
				newWay.points = PoolVector2Array([p.position, _adjp.position])		# Trick to make this thing work
#				print("PL: newWay size after all actions: ", newWay.points.size())	# test print
				
				get_node("../../Lines").add_child(newWay)				# add to scene
				newWay.set_owner(get_tree().edited_scene_root)	# required to make the node visible in the Scene tree dock and persist changes made by the tool script to the saved scene file.
