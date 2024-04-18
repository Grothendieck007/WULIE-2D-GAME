extends Node2D
signal itemhit

# 道具数组
var items: Array = [
	"item1",
	"item2"
	# 添加更多道具...
]

var effect_system: Node
var selected_item: String

# 获取Sprite2D节点
@onready var item_sprite: Sprite2D = $Sprite2D

func _ready():
	randomize()  # 初始化随机数种子
	
	# 随机选择一个道具
	var random_item_index: int = randi() % items.size()
	selected_item = items[random_item_index]
	
	# 加载对应的纹理
	var texture_path: String = "res://art/img/item/" + selected_item + "_texture.png"
	var texture: Texture = load(texture_path)
	
	# 设置纹理
	item_sprite.texture = texture
	
	#获取EffctSystem节点
	effect_system = $EffectSystem
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	hide()

