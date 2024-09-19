extends CharacterBody2D


func _ready():
	$UfoBeam.visible = false
	
func show_beam():
	$UfoBeam.visible = true

func hide_beam():
	$UfoBeam.visible = false
