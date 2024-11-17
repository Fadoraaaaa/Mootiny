extends Node2D

@onready var music = $Music as AudioStreamPlayer2D
var intro = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#setting up beginning
	$Dialog.visible = false
	
	#playing act 0
	$You.pause = true

	$AnimationPlayer.play("act 0")
	print("playing act 0")
	await $Dialog.finished
	print("act 0 is done")

	$AnimationPlayer.play("act 1_1")
	await $Dialog.finished
	print("act 1_1 is done")
	
	$AnimationPlayer.play("act 1_2")
	await $Dialog.finished
	print("act 1_2 is done")
	
	$AnimationPlayer.play("act 1_3")
	await $Dialog.finished
	print("act 1_3 is done")
	
	$AnimationPlayer.play("act 1_4")
	await $Dialog.finished
	print("act 1_4 is done")
	
	$AnimationPlayer.play("act 1_5")
	await $Dialog.finished
	print("act 1_5 is done")
	
	$You.pause = false
	

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
	
func play_anim(animation):
	$AnimationPlayer.play(animation)
	
	await $Dialog.finished
	print(animation + " is done")
