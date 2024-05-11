extends Node

var main

func apply_effect():
	main = $"../../.."
	print("main = ",main)
	main.score += 10
