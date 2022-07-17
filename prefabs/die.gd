extends Node2D


export (bool) var special = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$dice.special = special


func _process(delta):
	pass
