extends CharacterBody2D

@export var direction = 1
@export var gravity = 30
@export var character_name = "Cocoa"
@onready var sprite = $AnimatedSprite2D

func _ready():
	$Label.text = character_name
	$Questionmark.visible = false
	$Exclamation.visible = false


func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 200:
			velocity.y = 200
	
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
	print("direction changed to face left")
	
func flip_sprite_right():
	direction = 1
	
func show_emote(emotion):
	if emotion == "curious":
		$Questionmark.visible = true
		await get_tree().create_timer(2).timeout
		$Questionmark.visible = false
	if emotion == "surprise":
		$Exclamation.visible = true
		await get_tree().create_timer(2).timeout
		$Exclamation.visible = false
		
