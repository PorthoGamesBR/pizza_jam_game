extends Button
# Types of upgrades
#	"damage"
#	"atk_speed"
#	"ammo"
#	"armor" (logic on other class)
#	"penetrating" special
#	"double_atk" special
#	"ak47" special

var ne_cash_clr = Color(1,0,0,1)
var he_cash_clr = Color(0,1,0,1)

var upgrade_function : Callable = func(_upgrade_type): pass
@export var upgrade_type : String = "damage"
@export var price : int = 0
@export var price_increase : int = 0
@export var special_upgrade : bool = false
var special_upgrade_unlocked : bool = false

var _enought_cash : bool = true
signal bought_upgrade

func _ready():
	pressed.connect(upgrade)

func _process(delta):
	if special_upgrade:
		set_special_upgrade()
	if not disabled:
		set_enought_cash(Global.money)
		

func upgrade():
	if _enought_cash:
		Global.upgrade_function.call(upgrade_type)
		Global.money -= price
		price += price_increase
		if upgrade_type in Global.max_upgraded:
			max_upgrade_reached()
	
func set_special_upgrade():
	if not special_upgrade_unlocked:
		if upgrade_type in Global.special_upgrades:
			special_upgrade_unlocked = true
			disabled = false
			text = upgrade_type
			text.capitalize()
		else:
			disabled = true
			modulate = Color(0.5,0.5,0.5,1)
	
func set_enought_cash(cash:int):
	if cash >= price:
		_enought_cash = true
		modulate = he_cash_clr
	else:
		_enought_cash = false
		modulate = ne_cash_clr
	
func max_upgrade_reached():
	modulate = Color(0.5,0.5,0.5,1)
	disabled = true
