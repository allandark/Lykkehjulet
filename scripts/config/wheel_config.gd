extends Node

# Array of dictionaries representing wedges
@export var wedges: Array = [
    {"amount": 100, "color": Color.RED},
    {"amount": 200, "color": Color.ORANGE},
    {"amount": -1, "color": Color.GRAY},  # Bankrupt
    {"amount": 500, "color": Color.GREEN},
    {"amount": 0, "color": Color.YELLOW}  # Lose turn or free spin
]

@export var radius: float = 200.0
@export var wheel_text_offset: float = 80.0
@export var arc_resolution: int = 12
@export var spin_duration: float = 4.0