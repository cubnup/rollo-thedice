extends Node2D

onready var line = $line
var points = [Vector2.ZERO,Vector2.ZERO]
var aimdir = Vector2.ZERO

func _process(delta):
	line.points = points
