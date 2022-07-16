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
var specialslow = 0.9
var specialtime = 200
var specialtimes = [20,20,20,20,20,20]
var specialpos = Vector2.ZERO
var specialstartclock = 0
var specialendclock = 0
var specialenddir = Vector2.RIGHT
var specialendcharge
var aimlinealpha = 1.0
var timespd = 1.0
var move = true
var jump = true
var special = true

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

	input()
	move()
	jump()
	start_special()
	aim_special()
	end_special()
	
	
	vars.lrdir = lrdir
	vars.uddir = uddir
	
	
	
	
	
	var coll = move_and_slide_with_snap(vel, Vector2.DOWN,Vector2.UP)

func input():
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
	inputdir = inputdir.linear_interpolate(Vector2.ZERO,0.1)
	lrdir = lerp(lrdir,0,friction)
	uddir = lerp(uddir,0,friction)

func move():
	
	vel.x=lerp(vel.x,lrdir*movspd,0.1)
	vel.x=lerp(vel.x,0,0.01)
	vel.y=lerp(vel.y,0,0.01)

func jump():
	if jump:
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
				
		if Input.is_action_pressed("down") and specialstartclock==0:
			fallspd = fallspds[2]
		if Input.is_action_just_released("down"):
			fallspd = fallspds[0]
	vel.y+=fallspd

func start_special():
	specialstartclock -= 1 if specialstartclock>0 else 0
	var rng = RandomNumberGenerator.new()
	if Input.is_action_just_pressed("special") and specialstartclock ==0:
		specialstartclock=specialtime
		inputdir = Vector2.ZERO
		aimline.aimdir = vel.normalized()
	if specialstartclock==specialtime:
		timespd=specialslow
	elif specialstartclock > specialtime-15 and specialstartclock%2==0:
		specialpos = position
		rng.randomize()
		vars.state=rng.randi_range(0,5)
		vars.state=0
	if !Input.is_action_pressed("special") and specialstartclock<specialtime-20 and specialstartclock>0:
		specialenddir = aimline.aimdir
		specialendcharge = specialtime-specialstartclock
		specialstartclock=0
		specialendclock = specialtimes[vars.state]
	if specialendclock > 0: end_special()
	if specialstartclock==0:
		timespd=1.0
	if specialstartclock > 0 and specialstartclock < specialtime-15: 
		position = position.linear_interpolate(specialpos,0.05)
		fallspd = 0
	Engine.time_scale=lerp(Engine.time_scale,timespd,0.02)

func end_special():
	print(inputdir)
	specialendclock -= 1 if specialendclock>0 else 0
	if specialendclock>0:match vars.state:
		0:
			print(fallspd," ",specialendclock, " ", specialendcharge)
			fallspd = -30
			move_and_slide(specialenddir.normalized()*specialendcharge*10)
			jump = false
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
	if specialendclock==0:
		move = true
		jump = true
	
func aim_special():
	aimline.modulate = Color(1.0,1.0,1.0,aimlinealpha)
	if specialstartclock==0:
		aimlinealpha = lerp(aimlinealpha,0.0,0.2) 
	if specialstartclock>0:
		aimlinealpha = lerp(aimlinealpha,1.0,0.2) 
		if !aimline.aimdir.normalized().is_equal_approx(Vector2.RIGHT.rotated(snap_angle(inputdir.angle()))):
			aimline.aimdir = (aimline.aimdir.normalized()).slerp(Vector2.RIGHT.rotated(snap_angle(inputdir.angle())),0.05)
	aimline.points[0] = aimline.aimdir*25
	if specialstartclock>0:
		aimline.points[1] = aimline.aimdir*max(30,min(specialtime,(specialtime-specialstartclock)*2))
	else:
		aimline.points[1] = aimline.points[1].linear_interpolate(Vector2.ZERO,0.4)
		aimline.points[0] = aimline.points[1].linear_interpolate(Vector2.ZERO,0.4)
	aimline.rc.cast_to = aimline.aimdir*1000

func snap_angle(angle):
	return PI/4 * round(angle / (PI/4));
