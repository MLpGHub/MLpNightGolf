extends Button

export(String) var scene


func _load_scene():
	get_node("AudioStreamPlayer").play()
	get_tree().get_root().get_node("Spatial/Control/Fade").show()
	get_tree().get_root().get_node("Spatial/Control/Fade/AnimationPlayer").play("fade_out")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene(scene)


func _on_Exit_pressed():
	get_tree().get_root().get_node("Spatial/Control/Fade").show()
	get_tree().get_root().get_node("Spatial/Control/Fade/AnimationPlayer").play("fade_out")
	yield(get_tree().create_timer(0.5), "timeout")	
	get_tree().quit()
