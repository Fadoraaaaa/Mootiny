extends Control

@onready var check_button = $HBoxContainer/CheckButton as CheckButton

var SFX_index = AudioServer.get_bus_index("Sfx")
var OGSFXVol = AudioServer.get_bus_volume_db(SFX_index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_button.pressed.connect(on_value_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_value_changed() -> void:
	#button is on
	if check_button.button_pressed:
		#sets jenna to the volume of the SFX
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"), linear_to_db(0.5))
		#turns original SFX silent
		AudioServer.set_bus_volume_db(SFX_index, linear_to_db(0))
		print("jenna mode is ON")

	#button is off
	else:
		#sets sounds back to how they originally were
		AudioServer.set_bus_volume_db(SFX_index, OGSFXVol)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("JENNA MODE"), linear_to_db(0))
