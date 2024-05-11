extends Node2D

# 信号
signal itemhit

# 场景位置
var item_position

# 效果系统
var effect_system: Node

# 被选择道具名称
var selected_item: String

# 道具数组
var items: Array = [
	"item1",
	"item2",
	"item3"
	# 添加更多道具...
]




# 获取Sprite2D节点
@onready var item_sprite: Sprite2D = $Sprite2D

func _ready():
	randomize()  # 初始化随机数种子
	
	# 随机选择一个道具
	var random_item_index: int = randi() % items.size()
	selected_item = items[random_item_index]
	print("test", selected_item)
	
	# 加载对应的纹理
	var texture_path: String = "res://art/img/item/" + selected_item + "_texture.png"
	var texture: Texture = load(texture_path)
	
	# 设置纹理
	item_sprite.texture = texture
	
	# 获取道具所在坐标
	item_position = $".".position
	
func _on_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	itemhit.emit()
	$Sprite2D.queue_free()
	$Area2D.queue_free()
	
func delete_item():
	queue_free()
	print("物品删除")
