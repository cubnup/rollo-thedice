extends Button

export(String) var scene
var clock = 0

func _ready():
	pass

func _process(delta):
	if pressed:
		clock = 2
	if clock > 0: clock-= .9
	if scene == "quit":
		if clock <= 1 and clock != 0:
			get_tree().quit()
	else:
		if clock <= 1 and clock != 0:
			get_tree().change_scene(scene)
