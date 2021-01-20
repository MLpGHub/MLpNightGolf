extends ColorRect


func _ready():
	show()

func _on_AnimationPlayer2_animation_finished(_anim_name):
	hide()
