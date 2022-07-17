extends RigidBody2D

export(int) var timer = 200
var clock = timer
var which = false
export(Vector2)var p1 = Vector2.ZERO
export(Vector2)var p2 = Vector2.ZERO

func _ready():
	global_position=p1


func _process(delta):
	clock -= 1 if clock>0 else 0
	print(clock)
	if clock==0: 
		clock=timer
	if clock==199: which=!which
	if which:
		global_position = global_position.linear_interpolate(p1,0.05)
	else:
		global_position = global_position.linear_interpolate(p2,0.05)
