extends Node2D

export (String) var txt = "add text"
onready var text = $text


# Called when the node enters the scene tree for the first time.
func _ready():
	text.text = txt


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
