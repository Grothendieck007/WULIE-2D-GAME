extends CanvasLayer

# 通知“Main”节点按钮已被按下
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("游戏失败")
	# 等待消息计时器倒计时。
	await $MessageTimer.timeout

	$Message.text = "躲避怪物"
	$Message.show()
	# 创建一个一次性计时器并等待它完成。
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
