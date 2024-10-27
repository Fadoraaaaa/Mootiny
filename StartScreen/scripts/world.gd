extends Node2D

@onready var music = $Music as AudioStreamPlayer2D
@onready var current_anim = 0
@onready var do_special_thing

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#setting up beginning
	$Dialog.visible = false
	$AnimationPlayer.play("fade in")
	
	#playing act 0
	$You.pause = true
	await get_tree().create_timer(5).timeout
	$AnimationPlayer.play("act 0")
	print("playing act 0")
	await $Dialog.finished
	print("act 0 is done")
	
	#playing act 1 (friends get kidnapped)
	fade_out_and_in()
	
	
	#segment it into UFO appearing *cuts through some dialog*
	
	#allowing you to move again:
	#$You.pause = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !music.playing:
		music.play()
	pass
	
func fade_out_and_in():
	$AnimationPlayer.play("fade out")
	print ("fading out")
	await get_tree().create_timer(5).timeout
	$AnimationPlayer.play("fade in")
	print("fading back in")
	await get_tree().create_timer(3).timeout
