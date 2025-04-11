extends Node2D

@onready var music = $Music as AudioStreamPlayer2D

signal anim_done()
var dead
var ready_over
var leaving_scene = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_location = 4
	new_game()
	await $ExitScene.exiting_level
	$AnimationPlayer.play("leaving_scene")
	leaving_scene = true
	$You.pause = true
	await anim_done
	get_tree().change_scene_to_file("res://level1/scenes/main.tscn")

func new_game():
	dead = false
	ready_over = false
	$GameOver.hide()
	$GameOver.get_node("Button").pressed.connect(new_game)
	#setting up beginning
	$Dialog.visible = false
	$You.position = Vector2i(577, 763)
	$UFO.position = Vector2i(-788, -800)
	$Honey.position = Vector2i(294, 760)
	$Honey.modulate = Color8(255, 255, 255, 255)
	$Honey.visible = true
	$Cocoa.position = Vector2i(145, 760)
	$Cocoa.modulate = Color8(255, 255, 255, 255)
	$Cocoa.visible = true
	$ColorRect2.visible = false
	
	$Deathscreen.hide()
	$UFO.hide_beam()
	
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
	$UFO.show_beam()
	await $Dialog.finished
	print("act 1_3 is done")
	
	
	#UFO swipes ur friends--they're gone now. Reduced to atoms
	$AnimationPlayer.play("act 1_4")
	await anim_done
	$AnimationPlayer.play("act 1_4.5")
	await $Dialog.finished
	print("act 1_4 is done")
	
	
	#OH NO!!!! Now run away like the coward you are!
	$AnimationPlayer.play("act 1_5")
	#await $Dialog.finished
	print("act 1_5 is done")
	
	$You.pause = false
	#movement instructions
	$AnimationPlayer.play("move_using_wasd")
	
	
	
	ready_over = true
	#OH MY THE UFO IS GONNA CHASE YOU!!! :O
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !music.playing and !dead:
		music.play()
	if dead:
		music.stop()
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
	if !dead and ready_over and !leaving_scene:
		var tween = create_tween()
		var target_pos = $UFO.position
		$UFO.play_sound("swirl")
		tween.tween_property($You, "position", target_pos, 4)
		await tween.finished
		$Deathscreen.death()
		dead = true
		$You.position = Vector2i(-1000, 1000)
		$UFO.stop_sound("swirl")
		$UFO.stop_sound("buzz")
	else:
		pass
