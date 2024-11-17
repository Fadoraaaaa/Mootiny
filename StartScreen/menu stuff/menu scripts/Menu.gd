
extends Control

@onready var options_menu = $Options as Options

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.grab_focus()
	$AnimationPlayer.play("Fade in")
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	print("menu loaded")
	



func _on_start_button_pressed():
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	print("start button pressed")
	


func _on_options_button_pressed():
	print("options menu opened")
	options_menu.visible = true
	options_menu.set_process(false)
	
func on_exit_options_menu() -> void:
	options_menu.visible = false
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		print("quitting")
	
	if $MusicStreamPlayer2D.playing == false:
		$MusicStreamPlayer2D.play()
	pass
