extends Button

class_name ToggleMenuButton

signal toggle_on(button_name: String)

func _ready():
	toggle_mode = true
	toggled.connect(_on_toggled)

func _on_toggled(toggled_on: bool):
	if toggled_on:
		toggle_on.emit(name)
