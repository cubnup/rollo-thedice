extends Node2D

onready var line = $line
onready var line2 = $Line2D
onready var rc = $rc
onready var icon = $Icon
var points = [Vector2.ZERO,Vector2.ZERO]
var aimdir = Vector2.ZERO

func _process(delta):
	line.points = points
	rc.enabled=true
	if rc.get_collider()!=null:
		icon.global_position = rc.get_collision_point()
	else: icon.position = Vector2.ZERO
	line2.points = [Vector2.ZERO, rc.cast_to]
