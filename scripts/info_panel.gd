extends VBoxContainer

func set_data(data: BlockData, is_info: bool) -> void:
	if is_info:
		$Info.text = "Info"
	else:
		$Info.text = "Selected"
	$Item.text = data.item
	$Co2.set_data(data.co2)
	$Amount.set_data(data.kg_per_m2 * 100.0)
