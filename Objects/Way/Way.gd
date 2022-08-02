extends Line2D
# This is Way.gd
signal ShowContextMenu(refToSelf)
signal HideContextMenu(refToSelf)
var FirstPoint : StaticBody2D = null
var SecondPoint : StaticBody2D = null
var isMenuShowing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var line_poly = Geometry.offset_polyline_2d(points, width / 2)
	for poly in line_poly:
		var cllsn = CollisionPolygon2D.new()
		cllsn.polygon = poly
		$StaticBody2D.add_child(cllsn)
		
	$StaticBody2D.input_pickable = true
#warning-ignore:RETURN_VALUE_DISCARDED
#	$StaticBody2D.connect("input_event", self, "InputMouse")
	$StaticBody2D.connect("mouse_entered", self, "InputMouse")
	$StaticBody2D.connect("mouse_exited", self, "ExitMouse")
	


func InputMouse() -> void:
#	print("TEST WORKED")
	emit_signal("ShowContextMenu", self, get_global_mouse_position())
#	if(event.is_action_pressed("LMB")):
#		print("LMB on Path!!!")
	pass


func ExitMouse() -> void:
#	print("TEST WORKED")
	emit_signal("HideContextMenu", self)
#	if(event.is_action_pressed("LMB")):
#		print("LMB on Path!!!")
	pass
