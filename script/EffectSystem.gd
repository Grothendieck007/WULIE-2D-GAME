extends Node

var speed_effect
var item
var selected_item: String

# 定义效果名称和对应的方法
var effect_methods = {
	"item1":"apply_speed_effect",
	"item2":""
	# 添加其他效果...
}

func _ready():
	# 获取节点
	speed_effect = $SpeedEffect
	item = $".."
	selected_item = item.selected_item
	
	print("选中的道具：", selected_item)

