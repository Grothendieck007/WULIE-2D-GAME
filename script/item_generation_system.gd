extends Node

var item
var item_position

# Called when the node enters the scene tree for the first time.
func generation_item():
	
	# 实例化 Item 场景
	var item = preload("res://scene/item.tscn").instantiate() 
	
	# 设置 Item 的位置为随机坐标
	item.positon = item_position
	
	# 添加生成的道具到组"item"
	item.add_to_group("item")

