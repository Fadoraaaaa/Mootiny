extends Node2D

@onready var music = $Music as AudioStreamPlayer2D

signal anim_done()
var dead

# Called when the node enters the scene tree for the first time.
func _ready():
	dead = false
	#setting up beginning
	$Dialog.visible = false
	$UFO.position.y = -800
	$UFO.position.x = -788
	
	#playing act 0
	$You.pause = true

	#Yapping--the cows are safe...for now
	$AnimationPlayer.play("act 0")
	print("playing act 0")
	await $Dialog.finished
	print("act 0 is done")

	#MY GOD! ITS A BIRD! ITS A PLAN! NO! IT'S-IT's---- (ur mom lol jk)
	$AnimationPlayer.play("act 1_1")
	await $Dialog.finished
	print("act 1_1 is done")
	
	#UFO flies in (GASP)
	$AnimationPlayer.play("act 1_2")
	await anim_done
	$AnimationPlayer.play("act 1_25")
	await $Dialog.finished
	print("act 1_2 is done")
	
	#UFO envelops friends
	$AnimationPlayer.play("act 1_3")
	await $Dialog.finished
	print("act 1_3 is done")
	
	#UFO swipes ur friends--they're gone now. Reduced to atoms
	$AnimationPlayer.play("act 1_4")
	await $Dialog.finished
	await anim_done
	print("act 1_4 is done")
	
	#OH NO!!!! Now run away like the coward you are!
	$AnimationPlayer.play("act 1_5")
	await $Dialog.finished
	print("act 1_5 is done")
	
	$You.pause = false
	
	#OH MY THE UFO IS GONNA CHASE YOU!!! :O
	await $ExitScene.exiting_level
	$AnimationPlayer.play("leaving_scene")
	$You.pause = true
	await anim_done
	get_tree().change_scene_to_file("res://level1/scenes/main.tscn")


	#play some frantic beep beep burp! Burburbaba
	#player chases after MC to the right
	

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
	
func animation_over():
	emit_signal("anim_done")

func _on_ufo_beam_player() -> void:
	if !dead:
		var tween = create_tween()
		var target_pos = $UFO.position
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$Deathscreen.death()
		dead = true
	else:
		pass
