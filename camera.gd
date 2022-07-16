extends Camera2D

onready var vars = get_node("/root/global")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position = position.linear_interpolate(vars.ppos,0.05)
