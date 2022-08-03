extends Line2D
# This is TestLine2d.gd, script related to testing functionality of lines in the Andrey.tscn test scene

var FirstPoint : StaticBody2D = null
var SecondPoint : StaticBody2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var line_poly = Geometry.offset_polyline_2d(points, width / 2)
	for poly in line_poly:
		var cllsn = CollisionPolygon2D.new()
		cllsn.polygon = poly
		$StaticBody2D.add_child(cllsn)
		pass
	$StaticBody2D.input_pickable = true
	#warning-ignore:RETURN_VALUE_DISCARDED
	$StaticBody2D.connect("input_event", self, "InputMouse")
	pass


func InputMouse(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#	print("TEST WORKED")
	if(event.is_action_pressed("LMB")):	
		print("LMB on TestLine!!!")
	pass


#func _exit_tree() -> void:
#	print("Testline exit tree worked!")
#	pass
