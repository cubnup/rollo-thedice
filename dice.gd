extends KinematicBody2D

onready var vars = get_node("/root/global")
onready var aimline = $aimline
onready var dicespr = get_parent().get_node("dicespr")

var vel = Vector2.ZERO
var lrdir = 0.0
var uddir = 0.0
var inputdir = Vector2.RIGHT
var fallspds = [15,0,45]
var fallspd = fallspds[0]
var movspd = 300
var friction = 0.05
var jumpclock = 0
var jumpornot = false
var jumpimpulse = 50
var specialslow = 0.1
var specialtime = 200
var specialpos = Vector2.ZERO
var specialclock = 0
var aimlinealpha = 1.0
var timespd = 1.0


func _ready():
	vars.ppos = position
	vars.pspeed = vel.length()
	vars.pvel = vel

func _process(delta):
	
	vars.ppos = position
	vars.pspeed = vel.length()
	vars.pgrounded = is_on_floor()
	vars.pvel = vel
	
	if Input.is_action_just_pressed("reload"):get_tree().change_scene(get_tree().current_scene.filename)

	move()
	jump()
	start_special()
	aim_special()
	
	
	vars.lrdir = lrdir
	vars.uddir = uddir
	
	vel.x=lerp(vel.x,0,0.01)
	vel.y=lerp(vel.y,0,0.01)
	
	
	
	var coll = move_and_slide_with_snap(vel, Vector2.DOWN,Vector2.UP)




func move():
	if Input.is_action_pressed("right"):
		lrdir = lerp(lrdir,24.0/19.0,0.2)
		inputdir.x=1.0
	if Input.is_action_pressed("left"):
		lrdir = lerp(lrdir,-24.0/19.0,0.2)
		inputdir.x=-1.0
	if Input.is_action_pressed("up"):
		uddir = lerp(uddir,-24.0/19.0,0.2)
		inputdir.y=-1.0
	if Input.is_action_pressed("down"):
		uddir = lerp(uddir,24.0/19.0,0.2)
		inputdir.y=1.0
	inputdir.x = lerp(inputdir.x,0,friction*3)
	inputdir.y = lerp(inputdir.y,0,friction*3)
	lrdir = lerp(lrdir,0,friction)
	uddir = lerp(uddir,0,friction)
	
	vel.x=lerp(vel.x,lrdir*movspd,0.1)
	
func jump():
	jumpclock -= 1 if jumpclock>0 else 0
	if jumpclock == 99:
		fallspd = fallspds[1]
		vel.y -= jumpimpulse*2
	elif jumpclock >97:
		vel.y -= jumpimpulse*(100-jumpclock)
	elif jumpclock >92:
		if Input.is_action_pressed("up"): vel.y -= jumpimpulse
	elif (jumpclock>0 and !Input.is_action_pressed("up")) or jumpclock <86:
		fallspd = fallspds[0]
	
	if self.is_on_floor():
		if jumpclock <90: jumpclock=0
		if jumpclock==0: vel.y=0
		if Input.is_action_pressed("up"):
			jumpclock = 100
			
	if Input.is_action_pressed("down") and specialclock==0:
		fallspd = fallspds[2]
	if Input.is_action_just_released("down"):
		fallspd = fallspds[0]
	vel.y+=fallspd


func start_special():
	specialclock -= 1 if specialclock>0 else 0
	var rng = RandomNumberGenerator.new()
	if Input.is_action_just_pressed("special"):
		
		specialclock=specialtime
		aimline.aimdir = vel.normalized()
	if specialclock==specialtime:
		timespd=specialslow
	elif specialclock > specialtime-15 and specialclock%2==0:
		specialpos = position
		rng.randomize()
		vars.state=rng.randi_range(0,5)
	if !Input.is_action_pressed("special") and specialclock<specialtime-20 and specialclock>0:
		end_special()
		specialclock=0
	if specialclock==0:
		timespd=1.0
	if specialclock > 0 and specialclock < specialtime-15: 
		position = position.linear_interpolate(specialpos,0.05)
		fallspd = 0
	Engine.time_scale=lerp(Engine.time_scale,timespd,0.05)

func end_special():
	match vars.state:
		0:
			print(1)
		1:
			print(2)
		2:
			print(3)
		3:
			print(4)
		4:
			print(5)
		5:
			print(6)
func aim_special():
	aimline.modulate = Color(1.0,1.0,1.0,aimlinealpha)
	if specialclock==0:
		aimlinealpha = lerp(aimlinealpha,0.0,0.2) 
	if specialclock>0:
		aimlinealpha = lerp(aimlinealpha,1.0,0.2) 
		if !aimline.aimdir.normalized().is_equal_approx(Vector2.RIGHT.rotated(snap_angle(inputdir.angle()))):
			aimline.aimdir = (aimline.aimdir.normalized()).slerp(Vector2.RIGHT.rotated(snap_angle(inputdir.angle())),0.1)
	aimline.points[0] = aimline.aimdir *25
	if specialclock>00:
		aimline.points[1] = aimline.aimdir*max(30,min(specialtime,(specialtime-specialclock)*2))
	else:
		aimline.points[1] = aimline.points[1].linear_interpolate(Vector2.ZERO,0.4)
		aimline.points[0] = aimline.points[1].linear_interpolate(Vector2.ZERO,0.4)



func snap_angle(angle):
	return PI/4 * round(angle / (PI/4));
