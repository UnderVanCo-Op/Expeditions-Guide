extends Control
# This is Pause.gd

# PAUSE MENU

func _input(event):
	if event.is_action_pressed("Pause"):	# в этом случае использования action Pause переключает физику (и вкл и выкл)
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state		# переключить всю физику дерева сцены
		visible = new_pause_state


#func _on_MainMenu_pressed():
#	#get_tree().paused = false	# выключаем паузу физики принудительно
#	$Fade/AnimationPlayer.play("Anim_FadebtwScenes")
#
#
#func _on_Continue_pressed():
#	var new_pause_state = not get_tree().paused
#	get_tree().paused = new_pause_state		# переключить всю физику дерева сцены
#	visible = new_pause_state
#
#
##func _on_Restart_pressed():
#	get_tree().paused = false	# выключаем паузу физики принудительно
#	Main.goto_scene("res://Levels/" + get_tree().get_current_scene().get_name() + ".tscn")
#

#func _on_AnimationPlayer_animation_finished(anim_name):
#	Main.goto_scene("res://UI/Title Screen.tscn")
#	get_tree().paused = false	# иначе в главном меню пауза будет
	
#PAUSE MENU


func _on_Continue_pressed() -> void:	# а здесь назачем переключать физику - по нажатию на Продолжение её всего лишь нужно включить
	
#	var new_pause_state = not get_tree().paused
#	get_tree().paused = new_pause_state		# переключить всю физику дерева сцены
#	visible = new_pause_state
	get_tree().paused = false
	self.visible = false
	pass


func _on_Restart_Level_pressed() -> void:
#	get_tree().paused = false	# выключаем паузу физики принудительно
#	Main.goto_scene("res://Levels/" + get_tree().get_current_scene().get_name() + ".tscn")
	print("Pause: Restart button pressed, but for now there is no Level of restarting) + need to load save...")
	pass


func _on_Quit_to_Menu_pressed() -> void:
#	get_tree().paused = false	# выключаем паузу физики принудительно
	print("Pause: Quit to Main Menu button pressed, but for now there is no Main Menu Scene")
#	$Fade/AnimationPlayer.play("FadeAnim")
	pass



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	#	Main.goto_scene("res://UI/Title Screen.tscn")
#	get_tree().paused = false	# иначе в главном меню пауза будет
	print("Pause: Animation finished, but for now there is no Main Menu Scene")
	pass # Replace with function body.
