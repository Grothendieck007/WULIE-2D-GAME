extends Node
signal signal_speed_effect
signal effect_off

var item
var selected_item: String
var node_names = []
var effect: NodePath

var effects_map = {
	"item1": "SpeedEffect",
}

func _ready():
	# 遍历父节点的子节点
	for child_node in get_children():
		# 获取子节点的名称并添加到数组中
		node_names.append(child_node.get_name())
		print("子节点的名称：", node_names)
		
func _on_item_test():
	item = $".."
	selected_item = item.selected_item
	print("选中的道具：", selected_item)
	print(item)

func _effect_off():
	effect_off.emit()

func _on_item_itemhit():
	item = $".."
	# 获取selected_item
	selected_item = item.selected_item
	# 从字典中获取对应的effect名称
	effect = effects_map[selected_item]
	print("effect = ", effect)
	print("get_children = ", get_children())
	# 根据effect查找节点并调用对应的效果方法
	get_node(effect).has_method("apply_effect")
	get_node(effect).apply_effect()
