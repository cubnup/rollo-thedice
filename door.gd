extends Area2D

onready var vars = get_node("/root/global")
export(String) var scene = "res://Levels/Menu.tscn"
onready var coll
onready var doorclock=0


func _ready():
	if scene == null: scene = get_tree().current_scene.filename


func _process(delta):
	vars.doorpos = global_position
	vars.doorclock = doorclock
	doorclock -= 1 if doorclock>0 else 0
	if get_overlapping_bodies().has(vars.player):
		doorclock=50
	if doorclock==1:
		get_tree().change_scene(scene)
