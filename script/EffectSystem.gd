extends Node
signal effect_on(effect_type: String)
signal effect_signal_finish

var item
var selected_item: String
var node_names = []
var effect: NodePath
var EffectTimerManager
var _on_effect_on_signal_received
var effect_timer_manager_callable

var effects_map = {
	"item1": "SpeedEffect",
	"item2":"ExplosionEffect",
	"item3":"GoldEffect",
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
	

func _on_item_itemhit():
	# 获取item节点
	item = $".."
	
	
	# 获取EffectTimerManger节点，设置_on_effect_on_signal_received方法
	EffectTimerManager = $"../../EffectTimerManager"
	_on_effect_on_signal_received = EffectTimerManager._on_effect_on_signal_received
	effect_timer_manager_callable = Callable(_on_effect_on_signal_received)
	print("获取的节点为：",EffectTimerManager)
	
	# 获取selected_item
	selected_item = item.selected_item
	
	# 从字典中获取对应的effect名称
	effect = effects_map[selected_item]
	print("effect = ", effect)
	print("get_children = ", get_children())
	
	# 等待对应的apply_effect方法执行完毕
	await get_node(effect).apply_effect()
	
	# 信号effect_on连接方法effect_timer_manager_callable，一次性连接，会在触发后自行断开
	effect_on.connect(effect_timer_manager_callable,4)
	
	# 发射effect_on信号,携带effect参数
	emit_signal("effect_on",effect)
	
	#发射effect_signal_finish信号给item节点的方法delete_item，删除物品实例
	effect_signal_finish.emit()
	
	
	
	
