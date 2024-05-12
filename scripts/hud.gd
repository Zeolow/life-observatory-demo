extends Control

#region LEFT PANEL
@onready var search_bar: LineEdit = $LeftPanel/VBoxContainer/SearchBar
@onready var food_item_container : VBoxContainer = $LeftPanel/VBoxContainer/FoodItems/VBoxContainer
@onready var info_panel: VBoxContainer = $LeftPanel/VBoxContainer/InfoPanel
#endregion

#region RIGHT PANEL
@onready var co2_output: DataBox = $RightPanel/VBoxContainer/CO2
@onready var land_use_output: DataBox = $RightPanel/VBoxContainer/LandUse
@onready var food_item_output: VBoxContainer = $RightPanel/VBoxContainer/FoodItemOutput
#endregion

var food_display_mode := "day"
var food_items: Array[Dictionary] = []

var data_box_scene = preload("res://scenes/data_box.tscn")

signal food_item_selected(item_name: String)
signal food_item_hovered(item_name: String)

func create_food_items(data: Array[BlockData]) -> void:
	for b in data:
		var food_button = ToggleMenuButton.new()
		food_button.text = b.item
		food_button.name = b.item
		food_button.toggle_on.connect(_on_food_button_toggled)
		food_button.toggle_mode = true
		food_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		food_item_container.add_child(food_button)
	food_item_container.connect_children()

func set_output_data(data: Array[BlockData]) -> void:
	print(data)
	var tot_co2: float = 0
	var tot_land: float
	food_items.clear()
	for b in data:
		tot_co2 += b.co2 * b.get_amount()
		tot_land += b.area
		var has_food_item := false
		for i in food_items:
			if i.item == b.item:
				has_food_item = true
				i.amount += b.get_amount()
		if not has_food_item:
			food_items.append({"item": b.item, "amount": b.get_amount()})
	
	var tot_land_percent = tot_land / (Globals.HABITABLE_LAND_M2 / Globals.POPULATION_2030) * 100.0
	
	co2_output.set_data(tot_co2)
	print("set c02 from set_output_data: ", tot_co2)
	land_use_output.set_data(tot_land_percent)
	print("set land from set_output_data: ", tot_land_percent)
	
	set_food_item_data(food_items, food_display_mode)

func set_food_item_data(items: Array[Dictionary], display_mode: String) -> void:
	var div_factor: float = 1
	match display_mode:
		"day":
			div_factor = 365
		"week":
			div_factor = 52
		"month":
			div_factor = 12
		"year":
			div_factor = 1
	
	for i in food_item_output.get_children():
		i.queue_free()
	
	for i in items:
		var data_box_instance = data_box_scene.instantiate()
		data_box_instance.data = round_to_dec(i.amount / div_factor, 3)
		data_box_instance.text = i.item
		food_item_output.add_child(data_box_instance)

func set_info_data(data: BlockData, is_info: bool) -> void:
	info_panel.set_data(data, is_info)

#region UTIL
func round_to_dec(num, digit) -> float:
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
#endregion

func _on_food_button_toggled(button_name: String):
	food_item_selected.emit(button_name)

func _on_food_display_mode_toggle_on(button_name: String):
	button_name = button_name.to_lower()
	food_display_mode = button_name
	set_food_item_data(food_items, button_name)
