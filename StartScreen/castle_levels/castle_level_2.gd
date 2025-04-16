extends Node2D

var beams_out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beams_out = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if beams_out == 1:
		$UFO1.show_beam()
		$UFO2.hide_beam()
	if beams_out == -1:
		$UFO1.hide_beam()
		$UFO2.show_beam()
	beams_out *= -1
	pass # Replace with function body.
