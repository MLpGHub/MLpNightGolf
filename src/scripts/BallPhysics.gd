extends RigidBody

var cam

func _ready():
	cam = get_node("BallCamera")
	var ball = get_node("Ball-Mesh")
	var ball_mat = ball.get_mesh().surface_get_material(0)
	
	var size = get_viewport().size
	var ball_orig = ball.to_global(ball.translation)
	var cam_orig = cam.to_global(cam.translation)
#	var cam_to_ball = ball_orig - cam_orig
#	cam_to_ball.y = 0
#	var screen_center = Vector2(size.x/2, size.y/2)
#	var view_orig = cam.project_position(screen_center, cam_to_ball.length())
	# var diff = ball_orig - view_orig
	var diff = cam.unproject_position(ball_orig)
	print(diff)
	diff.x = diff.x / size.x * 2 - 1
	diff.y = diff.y / size.y * 2 - 1
	
	print(diff)
	print(ball_orig)
	# print(view_orig)
	print(ball.scale.x)
	
	ball_mat.set_shader_param("diff", diff)
	ball_mat.set_shader_param("ball_pos", ball_orig)
	# ball_mat.set_shader_param("view_center_pos", view_orig)
	ball_mat.set_shader_param("scale", ball.scale.x)

func _process(_delta):
	if get_translation().y<0:
		if !get_node("Blub").playing:
			get_node("Blub").play()
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().reload_current_scene()
	
func _input(ev):
	if false and get_parent().turn: # TODO
		if ev is InputEventKey:
			if ev.scancode == KEY_K and not ev.echo:
				_throw(100)
			if ev.scancode == KEY_LEFT:
				rotate(Vector3(0, -1, 0), PI/50)
			if ev.scancode == KEY_RIGHT:
				rotate(Vector3(0, 1, 0), PI/50)
			if ev.scancode == KEY_UP:	
				rotate_object_local(Vector3(1, 0, 0), PI/50)
			if ev.scancode == KEY_DOWN:
				rotate_object_local(Vector3(-1, 0, 0), PI/50)

func _throw(power):
	get_parent().turn=false
	#get_parent().moves+=1
	var forward=-cam.get_transform().basis.z
	apply_impulse(Vector3(0,0,0), Vector3(forward.x, forward.y+1, forward.z)*power*0.9)
	if !get_node("Throw").playing:
		get_node("Throw").volume_db=-30+power*0.3
		get_node("Throw").play()
	if power>40 && !get_node("Fly").playing:
		yield(get_tree().create_timer(0.25), "timeout")
		if (linear_velocity.length()>10):
			get_node("Fly").play()
	print(power)

func _on_Area_body_entered(body):
	if body.name=="GolfBall":
		print("WIN")
		yield(get_tree().create_timer(0.3), "timeout")
		if !get_node("Win").playing:
			get_node("Win").play()
		get_parent().get_node("Control/Win").popup()
		get_parent().get_node("Control/Win/Moves2").set_text("Moves: " + str(get_parent().moves))
		get_parent().game=false
