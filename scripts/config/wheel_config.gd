extends Node


enum wedge_type {
	NORMAL,
	LOSE_TURN,
	BANKRUPT,
	JOKER
}

func wedge_element_to_str(element: Dictionary):
	if element["type"] == wedge_type.NORMAL:
		return str(element["amount"]) + " Kr"
	elif element["type"] == wedge_type.LOSE_TURN:
		return "Tabt tur"
	elif element["type"] == wedge_type.JOKER:
		return "Joker: ekstra tur"
	elif element["type"] == wedge_type.BANKRUPT:
		return "Fallit"


@export var wedges: Array = [
	{"type": wedge_type.BANKRUPT, "amount": 0, "color": Color.BLACK},
	{"type": wedge_type.NORMAL, "amount": 1500, "color": Color.FOREST_GREEN},
	{"type": wedge_type.NORMAL, "amount": 800, "color": Color.ORANGE},
	{"type": wedge_type.NORMAL, "amount": 100, "color": Color.BLUE},
	{"type": wedge_type.NORMAL, "amount": 500, "color": Color.GREEN},
	{"type": wedge_type.NORMAL, "amount": 600, "color": Color.ORANGE_RED},
	{"type": wedge_type.NORMAL, "amount": 500, "color": Color.YELLOW},
	{"type": wedge_type.JOKER, "amount": 0, "color": Color.PURPLE},
	{"type": wedge_type.NORMAL, "amount": 800, "color": Color.LIGHT_BLUE},
	{"type": wedge_type.NORMAL, "amount": 500, "color": Color.YELLOW},
	{"type": wedge_type.NORMAL, "amount": 800, "color": Color.RED},
	{"type": wedge_type.NORMAL, "amount": 1000, "color": Color.ORANGE},
	{"type": wedge_type.NORMAL, "amount": 100, "color": Color.LIGHT_GREEN},
	{"type": wedge_type.NORMAL, "amount": 300, "color": Color.LIGHT_GOLDENROD},
	{"type": wedge_type.NORMAL, "amount": 800, "color": Color.LIGHT_BLUE},
	{"type": wedge_type.NORMAL, "amount": 1000, "color": Color.ORANGE},
	{"type": wedge_type.NORMAL, "amount": 500, "color": Color.YELLOW},
	{"type": wedge_type.LOSE_TURN, "amount": 0, "color": Color.PURPLE},
	{"type": wedge_type.NORMAL, "amount": 600, "color": Color.ORANGE_RED},
	{"type": wedge_type.NORMAL, "amount": 500, "color": Color.LIGHT_GREEN},
	{"type": wedge_type.NORMAL, "amount": 800, "color": Color.LIGHT_SALMON},
	{"type": wedge_type.NORMAL, "amount": 500, "color": Color.YELLOW},
]

@export var radius: float = 250.0
@export var wheel_text_offset: float = 80.0
@export var arc_resolution: int = 12
@export var spin_duration: float = 4.0
@export var inner_circle_radius: float = radius*0.15
@export var outer_circle_radius: float = radius*0.35
@export var min_spin: float = 270.0 # 3/4 of a circle
@export var max_spin: float = 1710.0 # 4 3/4 of a circle
