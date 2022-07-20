tool
extends StaticBody2D
# This is Point.gd

var ToolModeToggle := false		# toggle instantiating ways on click
var sosedi := []
var newWay = null

signal WayButPressed(Point)

func _ready() -> void:
	print("ready of a point")
	pass # Replace with function body.


func _on_TextureButton_pressed() -> void:
	print("Button ", self, " pressed")
	if OS.has_feature("editor") and ToolModeToggle:
		print("Entering tool part of a Point...")
		if(!get_node("../../GameManager").lastP):		# start if there is no start
			newWay = Line2D.new()
#			for el in newWay.points:
#				newWay.points.remove(0)
#				pass
#			newWay.points.resize(0)		# clearing (not worked, btw)
			newWay.points = PoolVector2Array([self.position])
			print("newWay size after all actions: ", newWay.points.size())
			
			get_node("../../Lines").add_child(newWay)
			newWay.set_owner(get_tree().current_scene)	# required to make the node visible in the Scene tree dock and persist changes made by the tool script to the saved scene file.
			get_node("../../GameManager").lastP = self	# update last point in GM
			
			# #fbfbec
			
			pass
		else:				# end
			newWay = get_node("../../GameManager").lastP.newWay		# берём этот же путь
			var arr : PoolVector2Array = newWay.points
			arr.append(self.position)
			newWay.points = arr
			print("newWay size after all actions2: ", newWay.points.size())
			
			get_node("../../GameManager").lastP = null
			# resaving scene with 2 point for line
			var packed_scene = PackedScene.new()
			packed_scene.pack(get_tree().get_current_scene())
			ResourceSaver.save(get_tree().current_scene.filename, packed_scene)
			pass
	else:
		emit_signal("WayButPressed", self)
	pass # Replace with function body.
