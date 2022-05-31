extends Node

var lives = 7
export var speed = 2
export var left = 100
export var right = 400

var filePath 
var book = []
var word 
var display_quiz = ""
var secret_char = 0
var guess
var wrong = ""

var direction = 1


func _ready():
	$Crocodice.position.x = left

func croc_move():
	$Crocodice.position.x += speed * direction
	if $Crocodice.position.x > right:
		$Crocodice.flip_h = true
		direction = -1
	elif $Crocodice.position.x < left:
		$Crocodice.flip_h = false
		direction = 1
		

func _on_weather_pressed():
	filePath = "res://Category/Weather.txt"
	read_file()
	creat_word()
	$hint.visible = false
	$Category.visible = false
	
func _on_animals_pressed():
	filePath = "res://Category/Animals.txt"
	read_file()
	creat_word()
	$hint.visible = false
	$Category.visible = false
	
func _on_food_pressed():
	filePath = "res://Category/Food.txt"
	read_file()
	creat_word()
	$hint.visible = false
	$Category.visible = false

func _on_travel_pressed():
	filePath = "res://Category/Travel.txt"
	read_file()
	creat_word()
	$hint.visible = false
	$Category.visible = false

func read_file():
	var data = File.new()
	data.open(filePath, File.READ)
	while not data.eof_reached():
		var line = data.get_line()
		book.append(line)
		
	data.close()

func creat_word():
	randomize()
	word = book[randi()% book.size()]
	read_word()
	
func normalize(var line):
	line = line.to_lower()
	line = line.replace(" ","")
	return line

func read_word():
	word = normalize(word)
	for _index in range(word.length()):
		display_quiz += "_ "
		secret_char += 1


func _process(_delta):
	croc_move()
	$RichTextLabel/Word.set_text(display_quiz)



func show_heart():
	if lives == 6:
		$remainLives/Heart1.visible = false
	elif lives == 5:
		$remainLives/Heart2.visible = false
	elif lives == 4:
		$remainLives/Heart3.visible = false
	elif lives == 3:
		$remainLives/Heart4.visible = false
	elif lives == 2:
		$remainLives/Heart5.visible = false
	elif lives == 1:
		$remainLives/Heart6.visible = false
	elif lives == 0:
		$remainLives/Heart7.visible = false	

func _on_Click_pressed():       # WHen submiss guess
	$Princess/Stream.stop()
	guess = $RichTextLabel/Guess.get_text()
	$RichTextLabel/Guess.clear()

	if found_char() == true:
		$Ting.play()
		$RichTextLabel/Word.set_text(display_quiz)
	else:
		die()	

	if lives == 0 :
		if secret_char > 0:
			player_lose()
			
	if secret_char == 0 and lives > 0:
		player_win()




func found_char():
	if guess == "":
		guess = "*"
		return false
	guess = guess.to_lower()
	var hope = 0
	for index in range(word.length()):
		if display_quiz[2 * index] == "_":
			if guess[0] == word[index]:
				display_quiz[2 * index] = guess[0]
				secret_char -= 1
				hope += 1
	if hope > 0:
		return true
	else:
		return false

func die():
	lives -= 1
	show_heart()
	$Princess.position.y += 35
	wrong += guess[0]
	$RichTextLabel/Wrong.set_text(wrong)
	$Princess/Stream.play()

func player_lose():
	display_quiz = word
	$AudioStreamPlayer.stop()
	$EndGame/LoseBackground/LoseSound.play()
	$EndGame/displayResult.set_text("Game Over")
	$Princess.visible = false
	$EndGame.visible = true
	
func player_win():
	$AudioStreamPlayer.stop()
	$EndGame/WinBackground.visible = true
	$EndGame/WinBackground/WinSound.play()
	$EndGame/displayResult.set_text("YOU WIN")
	$Crocodice.visible = false
	$Ladder.visible = false
	$Princess.position.y = 620
	$Princess.position.x = 200
	$EndGame.visible = true

func _on_PlayAgain_pressed():
	get_tree().change_scene("res://Hangman.tscn")

func _on_QuitGame_pressed():
	get_tree().quit()
	pass # Replace with function body.
