extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("menu"):
			print("menu button pressed")
			get_tree().change_scene_to_file("res://menu stuff/menu scenes/Menu.tscn")
			
	if Input.is_action_just_pressed("escape_scene"):
			print("escape scene button pressed")
			get_tree().change_scene_to_file("res://level1/scenes/main.tscn")
			
	if Input.is_action_just_pressed("action_tutorial"):
			print("escape scene button pressed")
			get_tree().change_scene_to_file("res://level2/level_2_practice.tscn")
	
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			$RunCol.disabled = false
			if Input.is_action_pressed("jump"):
				velocity.y = JUMP_SPEED
				#$JumpSound.play()
			elif Input.is_action_pressed("ui_down"):
				#$AnimatedSprite2D.play("duck")
				$RunCol.disabled = true
			else:
				$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	move_and_slide()
	
