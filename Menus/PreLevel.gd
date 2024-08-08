extends Control

func _ready():
	# Set the lives and level name labels
	$Lives.text = str(Global.total_lives)
	$LevelName.text = Global.get_level_name(Global.level_count)
	
	# Start a timer or wait for player input to proceed to the next level
	$Timer.start()
	
	# Display the price counter for each powerup
	set_powerup_price_display(get_powerup_prices())
	
	# Show powerups if level 2+
	if Global.level_count > 1:
		$HBoxContainer.show()

func _on_timer_timeout():
	Global.start_next_level()

func get_powerup_prices():
	var hamburger: int = Global.hamburger_price
	var icecream: int = Global.icecream_price
	var wings: int = Global.wings_price
	var powerup_prices = [hamburger, icecream, wings]
	return powerup_prices

func set_powerup_price_display(prices: Array):
	$HBoxContainer/Hamburger/HamburgerPrice.text = str(prices[0])
	$HBoxContainer/Icecream/IcecreamPrice.text = str(prices[1])
	$HBoxContainer/Wings/WingsPrice.text = str(prices[2])
