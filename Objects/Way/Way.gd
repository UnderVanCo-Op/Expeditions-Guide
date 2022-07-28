extends Line2D
# This is Way.gd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var line_poly = Geometry.offset_polyline_2d(points, width / 2)
	for poly in line_poly:
		var cllsn = CollisionPolygon2D.new()
		cllsn.polygon = poly
		$StaticBody2D.add_child(cllsn)
		
	$StaticBody2D.input_pickable = true
#warning-ignore:RETURN_VALUE_DISCARDED
	$StaticBody2D.connect("input_event", self, "InputMouse")


func InputMouse(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#	print("TEST WORKED")
	if(event.is_action_pressed("LMB")):
		print("LMB on Path!!!")
	pass
