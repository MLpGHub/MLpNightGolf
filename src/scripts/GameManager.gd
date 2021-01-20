extends Spatial

var Ball
var turn
var game
var moves = 0
var moves_label
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Ball=get_node("GolfBall")
	turn=false 
	game=true
	moves_label=get_node("Control/Moves")

func _process(_delta):
	if !game: turn=false
	if game && !turn:
		if (Ball.linear_velocity.length()<0.01):
		#if ((Ball.linear_velocity.x+Ball.linear_velocity.y+Ball.linear_velocity.z)<0.001) \
		#and ((Ball.linear_velocity.x+Ball.linear_velocity.y+Ball.linear_velocity.z)>-0.001):
			print("your turn")
			moves+=1
			moves_label.set_text("Move: " + str(moves))
			turn=true

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
