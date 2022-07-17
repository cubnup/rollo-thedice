extends RigidBody2D


var lifetime 
var goto = position

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime = 200
	mode = RigidBody2D.MODE_KINEMATIC

func _process(delta):
	lifetime-=1
	position = position.linear_interpolate(goto,0.1)
	modulate=Color(1.0,1.0,1.0,lifetime/100.0)
	if lifetime==0:queue_free()
