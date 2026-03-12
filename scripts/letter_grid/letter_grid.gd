class_name LetterGrid extends Control
@export var letter_rows : Array[HBoxContainer] = []
@export var letter_scene : PackedScene  
@export var vbox : VBoxContainer
var letter_nodes : Array = []

var category_value_index : int
var category : Category

var row_counts: Array[int] = [11, 14, 14, 11]
var letter_size = Vector2(32, 32) # TODO: make configurable

var used_vocals = []


func _ready() -> void:
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	for i in range(letter_rows.size()):
		var row = letter_rows[i]
			
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		var row_letters : Array = []

		for j in range(row_counts[i]):
			var letter_instance = letter_scene.instantiate() as Control 
			
			letter_instance.set_letter(" ")		
			letter_instance.set_hidden(false)	
			letter_instance.set_unused(true)	

			letter_instance.custom_minimum_size  = letter_size			
			letter_instance.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			letter_instance.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			
			row.add_child(letter_instance)
			row_letters.append(letter_instance)
			# letter_instance.pressed.connect(_on_letter_pressed.bind(j, i))
		
		letter_nodes.append(row_letters)
	

func setup_category(cat : Category):					
	GameData.used_vocals.clear()
	_clear_grid()
	category = cat
	category_value_index = randi_range(0, category.values.size()-1)	
	_assign_text_to_grid(category.values[category_value_index])
	


func guess_consonant(consonant: String):
	var found: bool = false
	for row_index in range(letter_rows.size()):
		var row = letter_rows[row_index]
		if found:
			break

		for col in row.get_children():
			if col.is_hidden():
				if col.label.text.to_upper() == consonant.to_upper():
					col.set_hidden(false)
					found = true
					break
	return found


func guess_vocal(vocal: String):
	var found: bool = false
	for row_index in range(letter_rows.size()):
		var row = letter_rows[row_index]
		for col in row.get_children():
			if col.is_hidden():
				if col.label.text.to_upper() == vocal.to_upper():
					col.set_hidden(false)
					found = true
					GameData.used_vocals.append(vocal)					
	return found

func guess_fullword(word: String):
	var result: bool = false
	if word.to_upper() == category.values[category_value_index].to_upper():
		result = true
	else:
		result = false
	
	if result:
		for row_index in range(letter_rows.size()):
			var row = letter_rows[row_index]
			for col in row.get_children():
				col.set_hidden(false)

	return result

func is_solved():	
	for row_index in range(letter_rows.size()):
		var row = letter_rows[row_index]
		for col in row.get_children():
			if col.is_hidden():
				return false
	return true

func _clear_grid():
	for row_index in range(letter_rows.size()):
		var row = letter_rows[row_index]
		for col in row.get_children():
			col.set_hidden(false)
			col.set_unused(true)
			col.set_letter(" ")

func _assign_text_to_grid(text: String):
	text = text.replace("-", " - ")
	var words = text.split(" ",false) 
	var grid_rows = letter_nodes

	var default_rows = [1,2,3]
	var default_capacity = 0
	for r in default_rows:
			default_capacity += row_counts[r]

	var total_letters = 0
	for w in words:
			total_letters += w.length()
			total_letters += 1  

	total_letters = max(0, total_letters - 1) 

	var row_order = []
	if total_letters <= default_capacity:			
			row_order = [1,2,3]
	else:			
			row_order = [0,1,2,3]

	var word_idx = 0
	for r in row_order:
			var capacity = row_counts[r]
			var row_letters = []
			var remaining_space = capacity
			var prev_word: String = ""

			while word_idx < words.size():
					var word = words[word_idx]
					var add_space = row_letters.size() > 0 and _should_add_space(prev_word, word)
					var needed_space = word.length() + (1 if add_space else 0)
					if needed_space <= remaining_space:
							if add_space:	
									row_letters.append(" ")  
									remaining_space -= 1

							for c in word:
									row_letters.append(c)
									remaining_space -= 1
							prev_word = word
							word_idx += 1
					else:
							break  

			var padding = int((capacity - row_letters.size()) / 2)
			for i in range(capacity):
					var node = grid_rows[r][i]
					if i >= padding and i < padding + row_letters.size():
							node.set_letter(row_letters[i - padding])
							if node.label.text == " " or node.label.text == "-":
								node.set_hidden(false)
							else:
								node.set_hidden(true)
							node.set_unused(false)
					else:
							node.set_letter(" ")
							node.set_hidden(true)
							node.set_unused(true)

			if word_idx >= words.size():
					break


func _should_add_space(prev_word: String, next_word: String) -> bool:		 
		return prev_word != "-" and next_word != "-"
