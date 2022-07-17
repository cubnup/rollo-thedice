extends Camera2D

onready var vars = get_node("/root/global")
var camarea = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if vars.doorclock>0:
		zoom = Vector2((vars.doorclock)/50.0,(vars.doorclock)/50.0)
		global_position = global_position.linear_interpolate(vars.doorpos,0.05)
	else: 
		zoom = Vector2(1,1)
		if camarea!=null: global_position = global_position.linear_interpolate(camarea,0.05)
		else: position = position.linear_interpolate(vars.ppos+Vector2.UP*100,0.05)
	zoom = zoom*1.2
