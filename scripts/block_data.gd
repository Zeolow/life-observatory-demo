extends Resource

class_name BlockData

@export var item: String
@export var visual_object: PackedScene
@export var co2: float
@export var kg_per_m2: float
@export var possible_origins: Array[String]
@export var color: Color
@export_enum("food", "forest") var type: int

var area: float = 100
var amount: float

func get_amount() -> float:
	return kg_per_m2 * area
