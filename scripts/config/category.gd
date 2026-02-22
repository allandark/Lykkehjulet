class_name Category

var name: String
var values: Array = []

func _init(_name: String, _values: Array) -> void:
    name = _name
    values = _values

func get_random_value() -> String:
    if values.size() == 0:
        return ""
    return values[randi() % values.size()]