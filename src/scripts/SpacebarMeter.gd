extends VSlider

var stamina = 0;


func _process(_delta):
	if get_parent().get_parent().turn:
		if Input.is_action_pressed("press_spacebar"):
			if stamina<100:
				stamina += 1
			if stamina==100:
				_restart()
		elif stamina > 0:
			get_tree().get_root().get_node("Spatial/GolfBall")._throw(stamina)
			if stamina>1:
				stamina *= 0.5
			else: 
				stamina=0
	elif stamina > 0:
		if stamina>1:
			stamina *= 0.5
		else: 
			stamina=0
	set_value(stamina)
	update()

func _restart():
	if stamina==100:
		yield(get_tree().create_timer(1), "timeout")
		if stamina==100:
			 stamina=0
	
