extends ColorRect

@export var labels : Array[RichTextLabel]
@export var buttons: Array[Button]

var queue: Array = []        # queue of texts to type
var full_text: String = ""   # current BBCode text being typed
var label_index: int = 0
var char_index: int = 0
var char_delay: float = 0.05
var typing_timer: Timer
var open_tags: Array = []    # keeps track of currently open BBCode tags

signal line_done(label_index)  # emitted when a line finishes typing
signal all_done()              # emitted when the queue is empty
signal on_spin()
signal on_vokal()
signal on_guess()

func _ready():
	for label in labels:
		label.bbcode_enabled = true
		label.text = ""
		
	typing_timer = Timer.new()
	typing_timer.wait_time = char_delay
	typing_timer.one_shot = false
	typing_timer.autostart = false
	add_child(typing_timer)
	typing_timer.timeout.connect(_on_typing_tick)

	buttons[0].pressed.connect(func(): emit_signal("on_spin"))
	buttons[1].pressed.connect(func(): emit_signal("on_vokal"))
	buttons[2].pressed.connect(func(): emit_signal("on_guess"))


func set_button_state(value: bool):
	buttons[0].disabled = !value
	buttons[1].disabled = !value
	buttons[2].disabled = !value


# Add a new text to the queue
func show_text(text: String, line: int):
	var idx = clamp(line-1, 0, labels.size()-1)
	queue.append({"text": text, "line": idx})
	
	# Start typing immediately if nothing is typing
	if typing_timer.is_stopped():
		_start_next()

func clear_text():
	for label in labels:
		label.text = ""

func clear_line(line: int):
	var idx = clamp(line-1, 0, labels.size()-1)
	labels[idx].text = ""

# Start next queued text
func _start_next():
		if queue.size() == 0:
				emit_signal("all_done")
				return

		var next_item = queue.pop_front()
		full_text = next_item["text"]
		label_index = next_item["line"]
		char_index = 0
		open_tags.clear()
		labels[label_index].text = ""
		typing_timer.start()


func _on_typing_tick():
		if char_index >= full_text.length():
				typing_timer.stop()
				emit_signal("line_done", label_index)
				_start_next()
				return

		var c = full_text[char_index]
		char_index += 1

		# Check for BBCode tag start
		if c == "[":
				var end = full_text.find("]", char_index)
				if end != -1:
						var tag = full_text.substr(char_index - 1, end - char_index + 2) # include []
						
						if tag.begins_with("[/"):
								# closing tag, remove matching opening tag
								if open_tags.size() > 0:
										# pop the most recent tag that matches
										for i in range(open_tags.size()-1, -1, -1):
												if open_tags[i].substr(1, open_tags[i].find("=")-1 if open_tags[i].find("=")!=-1 else open_tags[i].find("]")-1) in tag:
														open_tags.remove_at(i)
														break
						else:
								# opening tag
								open_tags.append(tag)

						labels[label_index].text += tag
						char_index = end + 1
						return

		# Append character with temporary closing tags
		var display_text = c
		for tag in open_tags:
				var tag_name = tag.substr(1, tag.find("=")-1) if tag.find("=") != -1 else tag.substr(1, tag.find("]")-1)
				display_text += "[/" + tag_name + "]"

		# Reopen tags for next character
		for tag in open_tags:
				display_text += tag

		labels[label_index].text += display_text
