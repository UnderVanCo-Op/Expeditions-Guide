tool
extends Node2D

var PathScene = preload("res://Objects/Way.tscn")
var togglePathLoading = true


func _ready() -> void:
	if(!togglePathLoading):
		print("PL: Ready of a PathsLoader, but Path Loading is off")
		return
	print("PL: Ready of a PathsLoader, Path Loading is on")
	# Paths work (visual part, mostly copied from SaveMaster)
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
	
	for p in ps.get_children():
		if(p.name in data.keys()):
			print("\nPL: Found some point in saved data: ", p.name, ", data: ", data[p.name])
			var content = data[p.name] as Array
			for adjps in content:
				print("PL: Adj point '", adjps,"' found!")
				var _adjp = get_node_or_null("../../Points/" + str(adjps))
				if(!_adjp):
					printerr("PL: could not get adjacent point from save, do you have old save file?")
					return
#				newWay.points.resize(0)		# clearing (not worked, btw)
#				newWay.default_color = Color(255, 254, 246, 255)		# Color
#				newWay.texture = load("res://Objects/WayTile3.png")		# Texture
#				newWay.texture_mode = 1									# Tile mode
				var newWay = PathScene.instance()
				newWay.points = PoolVector2Array([p.position, _adjp.position])		# Trick to make this thing work
#				print("PL: newWay size after all actions: ", newWay.points.size())	# test print
				
				get_node("../../Lines").add_child(newWay)				# add to scene
				newWay.set_owner(get_tree().current_scene)	# required to make the node visible in the Scene tree dock and persist changes made by the tool script to the saved scene file.
				
				
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
