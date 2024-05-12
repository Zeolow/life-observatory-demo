extends HBoxContainer

class_name DataBox

@export var text: String = "unnamed"
@export var data: float = 0
@export var unit: String = "kg"

func _ready():
	$Text.text = text + " (" + unit + "): "
	$Data.text = str(data)

func set_data(v: float):
	$Data.text = str(v)

func set_text(v: String):
	$Text.text = v + " (" + unit + "): "
