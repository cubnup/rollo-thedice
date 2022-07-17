extends RigidBody2D

onready var vars = get_node("/root/global")
onready var d_anim = $d_anim
onready var particle = $particle

func _ready():
	pass

func _process(delta):
	d_anim.frame=vars.state
	if vars.player.specials==0: d_anim.frame = 6

func _integrate_forces(state): 
	linear_velocity = ((vars.ppos-position)*(vars.ppos.distance_to(position))).clamped(1000)
	angular_velocity+=sign((vars.lrdir+vars.pvel.x)/2)/PI
	if vars.ppos.distance_to(position)>200:
		state.transform = Transform2D(0,vars.ppos)
