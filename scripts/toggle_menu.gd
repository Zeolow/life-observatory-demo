extends BoxContainer

@onready var selected_node: ToggleMenuButton
@onready var hovered_node: ToggleMenuButton

func _ready():
	connect_children()

func _on_button_toggled(button_name: String) -> void:
	for child in get_children():
		if child.name == button_name:
			selected_node = child
		else:
			child.button_pressed = false

func connect_children() -> void:
	for child in get_children():
		if child is ToggleMenuButton:
			child.toggle_on.connect(_on_button_toggled)
		else:
			print("This box should only have ToggleMenuButtons as children")
