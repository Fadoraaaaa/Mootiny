extends CharacterBody2D

@export var buzz = false
@export var swirl = false
@export var whoosh = false

signal beam_player()

func _ready():
	$UfoBeam.visible = false
	$Sprite.play()
	
func show_beam():
	$AnimationPlayer.play("show_beam")

func hide_beam():
	$AnimationPlayer.play("stop_beam")

func _process(delta):
	if buzz and !$Buzz.playing:
		$Buzz.play()
	if swirl and !$Swirl.playing:
		$Swirl.play()
	if whoosh and !$Whoosh.playing:
		$Whoosh.play()

func play_sound(sound):
	if sound == "buzz":
		buzz = true
	if sound == "swirl":
		swirl = true
	if sound == "whoosh":
		whoosh = true
	
func stop_sound(sound):
	if sound == "buzz":
		buzz = false
	if sound == "swirl":
		swirl = false
	if sound == "whoosh":
		whoosh = false
	
	
#beam has been entered
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if $UfoBeam.visible:
		emit_signal("beam_player")
	
