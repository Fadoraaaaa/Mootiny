extends "res://level2/Hitbox.gd"

@export var SPEED: int = 100

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	if !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()

func destroy():
	queue_free()

func _on_PlayerDagger_area_entered(area):
	print("AHAHHHHGAHAHHAHHAGH")
	destroy()

func _on_PlayerDagger_body_entered(_body):
	destroy()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
