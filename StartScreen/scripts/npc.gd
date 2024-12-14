extends CharacterBody2D

@export var direction = 1
@export var gravity = 30
@export var character_name = "Cocoa"
@onready var sprite = $AnimatedSprite2D
@export var jump_force = 300

func _ready():
	$Label.text = character_name
	$Questionmark.visible = false
	$Exclamation.visible = false
	visible = true


func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
		if position.y > 1800:
			position.y = 1800
	
	if direction != 0:
		sprite.flip_h = (direction == -1)
		
	if character_name == "Cocoa":
		sprite.play("cocoa_idle")
	elif character_name == "Honey":
		sprite.play("honey_idle")
	elif character_name == "HolyCow":
		sprite.play("holy_cow_idle")
	move_and_slide()
	
func flip_sprite_left():
	direction = -1
	
func flip_sprite_right():
	direction = 1
	
func show_emote(emotion):
	if emotion == "curious":
		$Questionmark.visible = true
		await get_tree().create_timer(2).timeout
		$Questionmark.visible = false
	if emotion == "surprise":
		$Exclamation.visible = true
		if db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"))) < 0.0002:
			$EmotionIndicator.play()
		else:
			$JENNAEmotionIndicator.play()
		await get_tree().create_timer(2).timeout
		$Exclamation.visible = false
	
		
func is_speaking(direction, emotion):
	if direction == "right":
		flip_sprite_right()
	if direction == "left":
		flip_sprite_left()
	if emotion != "":
		show_emote(emotion)
	velocity.y = -200
