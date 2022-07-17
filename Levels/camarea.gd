extends Area2D

onready var vars = get_node("/root/global")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_overlapping_bodies().has(vars.player):
		vars.player.cam.camarea = global_position
	



func _on_camarea_body_entered(body):
	if body == vars.player:
		vars.player.cam.camarea = global_position


func _on_camarea_body_exited(body):
	if body == vars.player:
		vars.player.cam.camarea = null
