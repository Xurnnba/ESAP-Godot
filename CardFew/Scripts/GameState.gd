extends Node
class_name GameState

signal Transitioned

var phaseName = "Game"

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func Card_Selected(cardNode):
	pass

func Slot_Chosen(slotNode):
	pass

func Continue():
	pass
