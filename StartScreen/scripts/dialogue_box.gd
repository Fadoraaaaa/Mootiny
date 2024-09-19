extends Node2D

@export var character_name = "MC"

@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func show_sprite(sprite_name):
	sprite.stop()
	sprite.play(sprite_name)
	$Label.text = sprite_name
