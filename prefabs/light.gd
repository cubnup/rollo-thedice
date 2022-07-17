extends Light2D

onready var vars = get_node("/root/global")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.linear_interpolate(vars.ppos,0.1)
	global_rotation=0.0
