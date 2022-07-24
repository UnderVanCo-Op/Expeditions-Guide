extends StaticBody2D
# This is Point.gd

var sosedi := []				# where can we go from here
var newWay = null

signal WayButPressed(Point)

func _ready() -> void:
#	print("ready of a point")
	print("Point: ", self, ", sosedi: ", sosedi)
	pass # Replace with function body.


func _on_TextureButton_pressed() -> void:
#	print("Button ", self, " pressed")
	if OS.has_feature("editor") and get_node("../../GameManager").ToolModeToggle:	# if we are in editor / in game launched from editor and togglemode == true
		print("Entering tool part of a Point...")
		
		if(!get_node("../../GameManager").lastPTool):		# start if there is no start
			newWay = Line2D.new()
#			newWay.points.resize(0)		# clearing (not worked, btw)
			newWay.default_color = Color(255, 254, 246, 255)		# Color
			newWay.texture = load("res://Objects/WayTile3.png")		# Texture
			newWay.texture_mode = 1									# Tile mode
			newWay.points = PoolVector2Array([self.position])		# Trick to make this thing work
			print("newWay size after all actions: ", newWay.points.size())	# test print
			
			get_node("../../Lines").add_child(newWay)				# add to scene
			newWay.set_owner(get_tree().current_scene)	# required to make the node visible in the Scene tree dock and persist changes made by the tool script to the saved scene file.
			get_node("../../GameManager").lastPTool = self				# update last point in GM
			
			pass
		
		else:				# end (there was start)
			var lP = get_node("../../GameManager").lastPTool	# get start in variable
			lP.sosedi.append(name)		# append self to start sosedi's
			sosedi.append(lP.name)		# append start to self sosedi's
			newWay = lP.newWay			# get ref to the same line2d
			var arr : PoolVector2Array = newWay.points	# trick, again, to make this all work
			arr.append(self.position)	# add end point pos
			newWay.points = arr			# end of a trick
			print("newWay size after all actions2: ", newWay.points.size())	# test print 2
			
			get_node("../../GameManager").lastPTool = null		# update last point in GM to null (since there is no start now)
			
			# resaving scene with 2 point for line
#			var packed_scene = PackedScene.new()
#			packed_scene.pack(get_tree().get_current_scene())
#			ResourceSaver.save(get_tree().current_scene.filename, packed_scene)
			
			get_node("../../GameManager").SaveGame()
			
#			get_tree().reload_current_scene()
			pass
	else:
		emit_signal("WayButPressed", self)
	pass # Replace with function body.
