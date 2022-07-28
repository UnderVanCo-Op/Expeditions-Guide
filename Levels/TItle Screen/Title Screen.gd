extends Control
# This is Title Screen.gd (landing scene)

func _ready() -> void:
	get_tree().paused = false # принудительно убираем паузу физики и UI на всякий
#warning-ignore:RETURN_VALUE_DISCARDED
	$Fade/AnimationPlayer.connect("animation_finished", self, "FadeAnimFinished")
	pass

func FadeAnimFinished(anim_name) -> void:
	print("TS: fade anim finished")
	Global.goto_scene("res://Levels/Tests/Andrey.tscn")
	pass


func _on_Start_pressed() -> void:
	$Fade/AnimationPlayer.play("UIFadeAnim")
	print("TS: Start pressed")
	pass # Replace with function body.


func _on_Options_pressed() -> void:
	print("TS: Options pressed")
	pass # Replace with function body.


func _on_Quit_pressed() -> void:
	print("TS: Quit pressed")
	pass # Replace with function body.
