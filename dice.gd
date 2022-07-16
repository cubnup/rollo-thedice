extends KinematicBody2D

onready var vars = get_node("/root/global")


var vel = Vector2.ZERO
var lrdir = 0.0
var fallspds = [15,0,45]
var fallspd = fallspds[0]
var movspd = 300
var friction = 0.02
var jumpclock = 0
var jumpornot = false
var jumpimpulse = 50
var specialslow = 0.2
var specialclock = 0
var timespd = 1.0


func _ready():
	vars.ppos = position
	vars.pspeed = vel.length()
	vars.pvel = vel

func _process(delta):
	
	vars.lrdir = lrdir
	vars.ppos = position
	vars.pspeed = vel.length()
	vars.pgrounded = is_on_floor()
	vars.pvel = vel
	
	if Input.is_action_just_pressed("reload"):get_tree().change_scene(get_tree().current_scene.filename)

	move()
	jump()
	special()
	
	vel.x=lerp(vel.x,0,0.01)
	vel.y=lerp(vel.y,0,0.01)
	
	
	
	var coll = move_and_slide_with_snap(vel, Vector2.DOWN,Vector2.UP)




func move():
	if Input.is_action_pressed("right"):
		lrdir = lerp(lrdir,24.0/19.0,0.2)
	if Input.is_action_pressed("left"):
		lrdir = lerp(lrdir,-24.0/19.0,0.2)
	lrdir = lerp(lrdir,0,friction)
	vel.x=lerp(vel.x,lrdir*movspd,0.1)
	
func jump():
	jumpclock -= 1 if jumpclock>0 else 0
	if jumpclock == 99:
		fallspd = fallspds[1]
		vel.y -= jumpimpulse*2
	elif jumpclock >97:
		vel.y -= jumpimpulse*(100-jumpclock)
	elif jumpclock >92:
		if Input.is_action_pressed("jump"): vel.y -= jumpimpulse
	elif (jumpclock>0 and !Input.is_action_pressed("jump")) or jumpclock <86:
		fallspd = fallspds[0]
	
	if self.is_on_floor():
		if jumpclock <90: jumpclock=0
		if jumpclock==0: vel.y=0
		if Input.is_action_pressed("jump"):
			jumpclock = 100
			
	if Input.is_action_pressed("down"):
		fallspd = fallspds[2]
	if Input.is_action_just_released("down"):
		fallspd = fallspds[0]
	vel.y+=fallspd


func special():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	specialclock -= 1 if specialclock>0 else 0
	if Input.is_action_just_pressed("special"):
		specialclock=100
	if specialclock==100:
		timespd=specialslow
		vel=vel.linear_interpolate(Vector2.UP,0.01)
	elif specialclock > 95:
		vars.pstate=rng.randi_range(0,5)
	if Input.is_action_just_released("special"):
		specialclock=10
	if specialclock==0:
		timespd=1.0
	Engine.time_scale=lerp(Engine.time_scale,timespd,0.05)
		
