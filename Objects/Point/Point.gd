extends StaticBody2D
# This is Point.gd

signal WayButPressed(Point)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_TextureButton_pressed() -> void:
	print("Button ", self, " pressed")
	emit_signal("WayButPressed", self)
	pass # Replace with function body.
