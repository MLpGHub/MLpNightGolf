extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible=true

func _on_Area_body_entered(body):
	if body.name=="GolfBall":
		print("Light On")
		visible=false

