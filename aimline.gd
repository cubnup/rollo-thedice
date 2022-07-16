extends Node2D

onready var vars = get_node("/root/global")
onready var line = $line
onready var line2 = $Line2D
onready var rc = $rc
onready var x = get_parent().get_node("x")
var points = [Vector2.ZERO,Vector2.ZERO]
var aimdir = Vector2.ZERO

func _process(delta):
	line.points = points
	rc.enabled=true
	if rc.get_collider()!=null:
		x.global_position = rc.get_collision_point()
		vars.d5x = rc.get_collision_point().distance_to(position)
	else: 
		x.position = rc.cast_to
		vars.d5x = 250
	line2.points = [Vector2.ZERO, rc.cast_to]
	x.visible=vars.state==4
