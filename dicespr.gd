extends RigidBody2D

onready var vars = get_node("/root/global")
onready var d_anim = $d_anim

func _ready():
	pass


func _integrate_forces(state):
	if vars.ppos.distance_to(position) > PI: linear_velocity = (vars.ppos-position)*(vars.ppos.distance_to(position))
#	add_torque(sign(vars.lrdir)*PI/2)
	angular_velocity+=sign((vars.lrdir+vars.pvel.x)/2)/PI
		
