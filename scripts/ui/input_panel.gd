class_name InputPanel extends PanelContainer

enum InputPanelState {
	CONSONANT,
	VOCAL,
	FULLWORD
}

@export var consonant_control: Control
@export var consonant_line: LineEdit
@export var vocal_control: Control
@export var vocal_line: LineEdit
@export var fullword_control: Control
@export var fullword_line: LineEdit
@export var color_rect: ColorRect
@export var button: Button

var focus_locked := false

signal on_submit(text: String)

var state : InputPanelState = InputPanelState.CONSONANT
var state_changed : bool = true;

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	consonant_line.focus_exited.connect(_on_line_edit_focus_exited)
	consonant_line.text_changed.connect(_on_consonant_text_changed)
	vocal_line.focus_exited.connect(_on_line_edit_focus_exited)
	vocal_line.text_changed.connect(_on_vocal_text_changed)
	fullword_line.focus_exited.connect(_on_line_edit_focus_exited)

func set_state(_state: InputPanelState):
	if state != _state:
		state_changed = true; 
	state = _state

func show_panel(value: bool):
	if value: 
		_clear_text()
		button.disabled = true
	self.visible = value

func _clear_text():
	if state == InputPanelState.CONSONANT:
		consonant_line.text = ""
	elif state == InputPanelState.VOCAL:
		vocal_line.text = ""
	elif state == InputPanelState.FULLWORD:
		fullword_line.text = ""

func _on_line_edit_focus_exited():
	if focus_locked:
		if state == InputPanelState.CONSONANT:
			consonant_line.grab_focus()
		elif state == InputPanelState.VOCAL:
			vocal_line.grab_focus()
		elif state == InputPanelState.FULLWORD:
			fullword_line.grab_focus()


func _on_button_pressed():
	focus_locked = false
	if state == InputPanelState.CONSONANT:
		if _consonant_is_valid():
			emit_signal("on_submit", consonant_line.text)
	elif state == InputPanelState.VOCAL:
		if _consonant_is_valid():
			emit_signal("on_submit", vocal_line.text)
	elif state == InputPanelState.FULLWORD:
		if _full_word_is_valid():
			emit_signal("on_submit", fullword_line.text)


func _consonant_is_valid()->bool:
	if consonant_line.text.length() == 0:
		return false
	if consonant_line.text[0].to_upper() in GameData.consonants:
		return true
	else:		
		return false

func _vocal_is_valid()->bool:
	if vocal_line.text.length() == 0:
		return false
	if vocal_line.text[0].to_upper() in GameData.vocals:
		return true
	else:		
		return false

func _full_word_is_valid()->bool:
	if vocal_line.text.length() == 0:
		return false
	return true

func _process(_delta: float) -> void:
	if state_changed:
		_update_control()


func _update_control():
	if state == InputPanelState.CONSONANT:
		color_rect.visible = true
		consonant_control.visible = true		
		vocal_control.visible = false
		fullword_control.visible = false

		consonant_line.grab_focus()
		focus_locked = true
	elif state == InputPanelState.VOCAL:
		color_rect.visible = true
		consonant_control.visible = false
		vocal_control.visible = true
		fullword_control.visible = false

		vocal_line.grab_focus()
		focus_locked = true
	elif state == InputPanelState.FULLWORD:
		color_rect.visible = true
		consonant_control.visible = false
		vocal_control.visible = false
		fullword_control.visible = true

		fullword_line.grab_focus()
		focus_locked = true


func _on_consonant_text_changed(value: String):
	if value.length() > 1 and value.length() != 0:
		consonant_line.text = value[-1]
		consonant_line.caret_column = 1
	if _consonant_is_valid():
		button.disabled = false
	else:
		button.disabled = true


func _on_vocal_text_changed(value: String):
	if value.length() > 1 and value.length() != 0:
		vocal_line.text = value[-1]
		vocal_line.caret_set_column(1)
	if _vocal_is_valid():
		button.disabled = false
	else:
		button.disabled = true
