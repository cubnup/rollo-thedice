extends RigidBody2D

onready var vars = get_node("/root/global")
onready var d_anim = $d_anim

func _ready():
	pass

func _process(delta):
	d_anim.frame=vars.state

func _integrate_forces(state): 
	linear_velocity = (vars.ppos-position)*(vars.ppos.distance_to(position))*1.5
	angular_velocity+=sign((vars.lrdir+vars.pvel.x)/2)/PI
