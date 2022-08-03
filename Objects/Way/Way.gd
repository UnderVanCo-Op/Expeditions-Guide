extends Line2D
# This is Way.gd

#signal ShowContextMenu(refToSelf)
#signal HideContextMenu(refToSelf)
var FirstPoint : StaticBody2D = null
var SecondPoint : StaticBody2D = null
#var isMenuShowing := false
var ContextMenu : Control
var EnergyLabel : Label
var DangerLabel : Label
var danger := 0
var energy := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var line_poly = Geometry.offset_polyline_2d(points, width / 2)
	for poly in line_poly:
		var cllsn = CollisionPolygon2D.new()
		cllsn.polygon = poly
		$StaticBody2D.add_child(cllsn)
		
	$StaticBody2D.input_pickable = true		# very important line
#warning-ignore:RETURN_VALUE_DISCARDED
#	$StaticBody2D.connect("input_event", self, "InputMouse")
	$StaticBody2D.connect("mouse_entered", self, "InputMouse")		# self-connecting
	$StaticBody2D.connect("mouse_exited", self, "ExitMouse")		# self-connecting
	
	ContextMenu = get_node("WayContextMenu")
	EnergyLabel = ContextMenu.get_node("VBoxC/Energy_NPR/Label")
	DangerLabel = ContextMenu.get_node("VBoxC/Danger_NPR/Label")	
	
	UpdateStats(2,3)
	ContextMenu.hide()		# hiding on load as default
	

func UpdateStats(_newdanger : int, _newenergy : int) -> void:
	danger = _newdanger
	energy = _newenergy
	EnergyLabel.text = "Энергия: " + str(energy) + "/10"
	DangerLabel.text = "Опасность: " + str(danger) + "/10"
	



func InputMouse() -> void:
#	print("TEST WORKED")
#	emit_signal("ShowContextMenu", self, get_global_mouse_position())
#	if(event.is_action_pressed("LMB")):
#		print("LMB on Path!!!")
	ContextMenu.rect_position = get_global_mouse_position()		# update menu pos
	ContextMenu.show()		# show


func ExitMouse() -> void:
	ContextMenu.hide()		# hide
#	print("TEST WORKED")
#	emit_signal("HideContextMenu", self)
#	if(event.is_action_pressed("LMB")):
#		print("LMB on Path!!!")
