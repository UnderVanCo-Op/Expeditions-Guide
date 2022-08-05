extends Control
var next_scene := ""		# path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MarginC/VBoxC/HBoxC/1B").connect("pressed", self, "On1Bpressed")
	$Fade/AnimationPlayer.connect("animation_finished", self, "FadeAnimFinished")
	pass # Replace with function body.


func On1Bpressed() -> void:
	next_scene = "res://Levels/Tests/Andrey.tscn"
	$Fade/AnimationPlayer.play("UIFadeAnim")


func _on_BackToMenuB_pressed() -> void:
	next_scene = "res://Levels/UI/TItle Screen/Title Screen.tscn"
	$Fade/AnimationPlayer.play("UIFadeAnim")


func FadeAnimFinished(anim_name) -> void:
	print("LS: fade anim finished")
	if(!next_scene.empty()):
		Global.goto_scene(next_scene)
	else:
		push_error("LS: next_scene is empty!")
	next_scene = ""
	pass
