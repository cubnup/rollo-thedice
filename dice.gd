extends KinematicBody2D

onready var vars = get_node("/root/global")
onready var aimline = $aimline
onready var gcheck = $groundcheck
onready var dicespr = get_parent().get_node("dicespr")
onready var x = $x

var l = false
var r = false
var u = false
var d = false
var s = false
var vel = Vector2.ZERO
var lrdir = 0.0
var uddir = 0.0
var inputdir = Vector2.RIGHT
var aimdir = Vector2.RIGHT
var fallspds = [15,0,45]
var fallspd = fallspds[0]
var movspd = 300
var friction = 0.05
var jumpclock = 0
var jumpornot = false
var jumpimpulse = 50
var specialslow = 0.01
var specialtime = 250
var specialtimes = [20,20,20,20,20,20]
var specialpos = Vector2.ZERO
var specialstartclock = 0
var specialendclock = 0
var specialenddir = Vector2.RIGHT
var specialendcharge
var specialendpos = Vector2.ZERO
var specialcooldown = 0
var aimlinealpha = 1.0
var timespd = 1.0
var move = true
var jump = true
var special = true
var mousepos = Vector2.ZERO
var coyoteclock = 0
var d5 = 0

#debug variables
var debug_die_no = 0

func _ready():
	vars.ppos = position
	vars.pspeed = vel.length()
	vars.pvel = vel
	gcheck.enabled = true
	
	

func _process(delta):
	
	if Input.is_action_just_pressed("debug"):
		debug_die_no+=1
		debug_die_no=debug_die_no%6
	
	mousepos = get_global_mouse_position()
	
	vars.player = self
	vars.ppos = position
	vars.pspeed = vel.length()
	vars.pgrounded = is_on_floor()
	vars.pvel = vel
	vars.jumpclock = jumpclock
	vars.specialstartclock = specialstartclock
	vars.specialendclock = specialendclock
	
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
	
	if Input.is_action_just_pressed("left"):
		l = true
	if Input.is_action_just_released("left"):
		l = false
	if Input.is_action_just_pressed("right"):
		r = true
	if Input.is_action_just_released("right"):
		r = false
	if Input.is_action_just_pressed("up"):
		u = true
	if Input.is_action_just_released("up"):
		u = false
	if Input.is_action_just_pressed("down"):
		d = true
	if Input.is_action_just_released("down"):
		d = false
	if Input.is_action_just_pressed("special"):
		s = true
	if Input.is_action_just_released("special"):
		s = false
	
	
	if r:
		lrdir = lerp(lrdir,24.0/19.0,0.2)
		inputdir.x=1.0
	if l:
		lrdir = lerp(lrdir,-24.0/19.0,0.2)
		inputdir.x=-1.0
	if u:
		uddir = lerp(uddir,-24.0/19.0,0.2)
		inputdir.y=-1.0
	if d:
		uddir = lerp(uddir,24.0/19.0,0.2)
		inputdir.y=1.0
	inputdir = inputdir.linear_interpolate(Vector2.ZERO,0.1)
	aimdir = aimdir.slerp(inputdir.normalized(),0.5)
	lrdir = lerp(lrdir,0,friction)
	uddir = lerp(uddir,0,friction)

func move():
	if move:
		vel.x=lerp(vel.x,lrdir*movspd,0.1)
		vel.x=lerp(vel.x,0,0.01)
		vel.y=lerp(vel.y,0,0.01)

func jump():
	coyoteclock -= 1 if coyoteclock>0 else 0
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
			coyoteclock=15
		if coyoteclock>0:
			if jumpclock <90: jumpclock=0
			if coyoteclock>10 and jumpclock==0: vel.y=0
			if Input.is_action_pressed("up"):
				coyoteclock=0
				jumpclock = 100
		if Input.is_action_pressed("down") and specialstartclock==0:
			fallspd = fallspds[2]
		if Input.is_action_just_released("down"):
			fallspd = fallspds[0]
		if specialcooldown==1:dicespr.particle.emitting=false
	vel.y+=fallspd

func start_special():
	specialstartclock -= 1 if specialstartclock>0 else 0
	specialcooldown -= 1 if specialcooldown>0 else 0
	var rng = RandomNumberGenerator.new()
	if gcheck.is_colliding() and specialstartclock>0: vel.y -= 20
	if Input.is_action_just_pressed("special") and specialcooldown==0:
		dicespr.particle.emitting=true
		jump = false
		specialstartclock=specialtime
		inputdir = Vector2.ZERO
		aimline.aimdir = vel.normalized()
		vel = vel.linear_interpolate(Vector2.ZERO,0.1)
	if specialstartclock==specialtime:
		timespd=specialslow
	elif specialstartclock > specialtime-15 and specialstartclock%2==0:
		specialpos = position
		rng.randomize()
		vars.state=rng.randi_range(0,1)
		vars.state=debug_die_no
	if (!s and specialstartclock<specialtime-20 and specialstartclock>0) or specialstartclock==1:
		vel = Vector2.ZERO
		start_end_special()
	if specialstartclock==0:
		timespd=1.0
	if specialstartclock > 0 and specialstartclock < specialtime-15: 
		position = position.linear_interpolate(specialpos,0.05)
		fallspd = 0
	if timespd>0.9:Engine.time_scale=lerp(Engine.time_scale,timespd,0.2)
	else:Engine.time_scale=lerp(Engine.time_scale,timespd,0.02)

func start_end_special():
	specialenddir = aimline.aimdir.normalized()
	specialendcharge = min(specialtime/2,specialtime-specialstartclock)
	specialtimes = [round(specialendcharge/3.0),30,100,20,500,20]
	specialendpos = position
	specialstartclock=0
	specialendclock = specialtimes[vars.state]
	specialcooldown=1000
	d5 = vars.d5x
	
	

func end_special():
	move=false
	specialendclock -= 1.0 if specialendclock>0 else 0.0
	if specialendclock>0:match vars.state:
		0:
			vel = 8*((specialendclock)/specialtimes[0])*specialenddir*specialtime
		1:
			var goto1 = specialenddir*specialtime
			var goto2 = Vector2(goto1.x,-goto1.y)
			if specialendclock>15:
				position=position.linear_interpolate(specialendpos+goto1,0.15)
			else:
				position=position.linear_interpolate(specialendpos+goto1+goto2,0.15)
		2:
			var dir = (mousepos-position).normalized()
			dir = (dir.normalized()).slerp(mousepos-position,0.5)
			vel = dir*300
		3:
			print(4)
		4:
			fallspd=15
			print(specialendclock)
			if x.position.length()>d5: 
				vel+=x.position/10
				global_position= global_position.linear_interpolate(x.global_position+(global_position-x.global_position).clamped(d5),0.5)
			if specialendclock<specialtimes[4]-100:vel+=x.position
			#if u: d5-=1
			#if d: d5+=1
			if l: vel += x.position.rotated(-PI/2)/50
			if r: vel += x.position.rotated(PI/2)/50
			if Input.is_action_just_pressed("special"):
				specialendclock=specialtimes[4]-100
			if x.position.length() <90:
				specialendclock=1
			vel=vel.clamped(1000)
		5:
			print(6)
	if specialendclock==1:
		specialcooldown=30
	if specialendclock==0 and specialstartclock==0:
		move = true
		friction = 0.05
		jump = true
	
func aim_special():
	aimline.modulate = Color(1.0,1.0,1.0,aimlinealpha)
	if !aimline.aimdir.normalized().is_equal_approx(Vector2.RIGHT.rotated(snap_angle(inputdir.angle(),16))):
		aimline.aimdir = (aimline.aimdir.normalized()).linear_interpolate((mousepos-position).normalized(),0.5)
	if specialstartclock>0:
		aimlinealpha = lerp(aimlinealpha,1.0,0.05) 
		match vars.state:
			0:
				var p1 = aimline.aimdir*25
				var mult = max(30,min(specialtime*1.5,(specialtime-specialstartclock)*2))
				var p2 = aimline.aimdir*mult
				aimline.points = [p1,p2]
			1:
				var p1 = aimline.aimdir*25
				var mult = max(30,min(specialtime-60,(specialtime-specialstartclock)*2))
				var p2 = aimline.aimdir*mult
				var p3 = aimline.aimdir*mult+Vector2(aimline.aimdir.x,-aimline.aimdir.y)*mult
				aimline.points = [p1,p2,p3]
			2:
				var p1 = aimline.aimdir*25
				var mult = 60
				var p2 = aimline.aimdir*mult
				aimline.points = [p1,p2]
			4:
				var p1 = aimline.aimdir*25
				var p2 = x.global_position-global_position
				aimline.points = [p1,p2]
	elif specialendclock>0 and vars.state==2:
			var p1 = aimline.aimdir*25
			var mult = 60
			var p2 = aimline.aimdir*mult
			aimline.points = [p1,p2]
	else:
		aimlinealpha = lerp(aimlinealpha,0.0,0.2)
		aimline.points = [aimline.points[0].linear_interpolate(Vector2.ZERO,0.4),aimline.points[1].linear_interpolate(Vector2.ZERO,0.4)]
	aimline.rc.cast_to = (mousepos-position).clamped(min(specialtime/2,(specialtime-specialstartclock)*7)*2)

func snap_angle(angle,div):
	return PI/div * round(angle / (PI/div));
