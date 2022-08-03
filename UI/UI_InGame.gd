extends CanvasLayer
# This is UI_InGame.gd, script should handle all GUI actions during the game (Except Pause)

func _ready() -> void:
#	SignalWork()
	pass # Replace with function body.


func SignalWork() -> void:
	var lines = get_node_or_null("../Lines")
	if(!lines):
		print("UI: no lines node found!")
		return
	
	for way in lines.get_children():
		way.connect("ShowContextMenu", self, "s_ShowContextMenu")
		way.connect("HideContextMenu", self, "s_HideContextMenu")


# Inc signal from some Way (mouse entered)
func s_ShowContextMenu(_way : Line2D, _mousePos : Vector2) -> void:
	print("UI: received signal from: ", _way, " mouse position: ", _mousePos)
	if(_way.isMenuShowing):
		print("UI: already showing menu")
		return
	
	var cntrl = Control.new()
	cntrl.rect_global_position = _mousePos
#	add_child(cntrl)
	_way.add_child(cntrl)
	var label = Label.new()
	label.text = _way.name
	cntrl.add_child(label)
	
	
	_way.isMenuShowing = true


# Inc signal from some Way (mouse exited)
func s_HideContextMenu(_way : Line2D) -> void:
	print("UI: received signal from: ", _way)
	if(!_way.isMenuShowing):
		print("UI: nothing to hide! (menu)")
		return
	
	var cntrl = _way.get_child(1)		# DANGEROUS!
	cntrl.queue_free()
	
	
	
	_way.isMenuShowing = false
#
#	var smth = Control.new()
#	smth.rect_global_position = _mousePos
##	add_child(smth)
#	_way.add_child(smth)
#	var label = Label.new()
#	label.text = "OAWKFAPKWFPKWAPKFPWKFAP{OKF}"
#	smth.add_child(label)
	pass
