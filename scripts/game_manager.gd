extends Node

@onready var wheel = $"../Wheel"
@onready var test_label = $"../test"

func _ready():
	wheel.spin_finished.connect(_on_wheel_finished)

func _on_wheel_finished(index):
	var winner_data = WheelConfig.wedges[index]
	var winner_str = ""
	if winner_data["amount"] == -1:
		winner_str = "Bankrupt!"
	elif winner_data["amount"] == 0:
		winner_str = "Lose Turn"
	else:		
		winner_str = "%s %d" % ["Won $", winner_data["amount"]]
	test_label.text = winner_str


func _input(event):
	# Check if Enter/Return key was pressed
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			wheel.start_spin(360*2)
