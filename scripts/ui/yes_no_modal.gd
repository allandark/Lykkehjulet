class_name YesNoModal extends Panel

@export var panel: Panel
@export var yes_button : Button
@export var no_button : Button
@export var joker_label: Label

enum ButtonID{
	YES,
	NO
}

signal on_button(button: ButtonID)

func _ready() -> void:
	yes_button.pressed.connect(_on_yes)
	no_button.pressed.connect(_on_no)

func _on_yes():	
	emit_signal("on_button", ButtonID.YES)

func _on_no():	
	emit_signal("on_button", ButtonID.NO)

func set_joker(value: int):
	joker_label.text = "Antal jokere: " + str(value)


func show_modal(value: bool):
	panel.visible = value