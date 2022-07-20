tool
extends EditorScript
# This is WayTool.gd
# CAREFUL!!! Use properly (currently only script is in print mode)

export var Way = preload("res://Objects/Way.tscn")

func _run() -> void:
	var points = get_scene().find_node("Points") # could be any node in the scene
	if(!points):
		print("WayTool: NO POINTS NODE!!!")
		return
	
	for p in points.get_children():
		for s in p.sosedi:
			print(s)
		print("\n")
		pass
	
#	var newWay = Way.instance()
#	newWay.set_owner(get_scene())
#
#	player = playerScene.instance()
#	get_parent().add_child(player)
#	player.position = get_global_mouse_position()
	pass
