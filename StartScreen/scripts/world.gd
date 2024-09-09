extends Node2D

@onready var music = $MusicStreamPlayer2D as AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$DialogueBox.visible = false
	$AnimationPlayer.play("fade in")
	await get_tree().create_timer(5).timeout
	level0cutscene()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !music.playing:
		music.play()
	pass

func level0cutscene():
	$AnimationPlayer.play("act 0_1")
	print("playing act 0_1")
	$DialogueBox.visible = true
	await get_tree().create_timer(92).timeout
	
	$AnimationPlayer.play("fade out")
	print ("fading out")
	await get_tree().create_timer(5).timeout
	$AnimationPlayer.play("fade in")
	print("fading back in")
	await get_tree().create_timer(5).timeout
	
	$AnimationPlayer.play("act 0_2")
	print("playing act 0_2")
