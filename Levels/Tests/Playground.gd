extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_StaticBody2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("EVENT", event)
	pass # Replace with function body.
#
#func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			print("Left button was clicked at ", event.position)

func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_pressed("LMB")):
		print("GOTCHAAAA!!")
	pass
