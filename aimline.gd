extends Node2D

onready var vars = get_node("/root/global")
onready var line = $line
onready var line2 = $Line2D
onready var rc = $rc
onready var x = get_parent().get_node("x")
var xpos = Vector2.ZERO
var points = [Vector2.ZERO,Vector2.ZERO]
var aimdir = Vector2.ZERO

func _process(delta):
	line.points = points
	rc.enabled=true
	if rc.get_collider()!=null and vars.specialendclock==0:
		x.global_position = rc.get_collision_point()
		vars.d5x = rc.get_collision_point().distance_to(position)
	else:
		if vars.specialstartclock>0:xpos=x.global_position
		x.position = rc.cast_to
		if vars.specialendclock>0: x.global_position=xpos
		vars.d5x = 250
	line2.points = [Vector2.ZERO, rc.cast_to]
	x.visible=[4,5].has(vars.state) and (vars.specialstartclock>0 or vars.specialendclock>0)
	x.frame=vars.state
