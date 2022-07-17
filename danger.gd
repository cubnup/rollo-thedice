extends RigidBody2D

onready var coll = $coll
onready var block = $block

export(Vector2)var size = Vector2(2,1)
export(int) var timer = 200
var clock = timer
var which = false
export(Vector2) var p1 = Vector2(0,0)
export(Vector2)var p2 = Vector2(0,0)
var target = Vector2(0,0)

func _ready():
	p1 = global_position + p1
	p2 = global_position + p2
	global_position=p1
	target = p1


func _process(delta):
	coll.shape.extents=size*30
	block.scale = size
	clock -= 1 if clock>0 else 0
	if clock==0: 
		clock=timer
	if clock==timer-1: which=!which
	if which:
		target = target.linear_interpolate(p1,0.1)
	else:
		target = target.linear_interpolate(p2,0.1)
	global_position = global_position.linear_interpolate(target,0.1)

func _on_danger_body_entered(body):
	print(body.name)
	if body.name=="dicespr":
		get_tree().change_scene(get_tree().current_scene.filename)
