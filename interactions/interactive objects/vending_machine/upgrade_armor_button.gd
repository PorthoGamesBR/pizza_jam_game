extends Button

var ne_cash_clr = Color(1,0,0,1)
var he_cash_clr = Color(0,1,0,1)

var upgrade_type : String = "armor"
@export var price : int = 300
var has_armor : bool = false
var ind_brk_armor : int = -1

var _enought_cash : bool = true
signal bought_upgrade

func _ready():
	pressed.connect(upgrade)

func _process(delta):
	set_armor_icon()
	if not disabled and has_armor:
		set_enought_cash(Global.money)
		
func upgrade():
	if _enought_cash and has_armor:
		Global.money -= price
		Global.remove_from_inventory(ind_brk_armor)
		Global.upgrade_function.call(upgrade_type)
		bought_upgrade.emit()
	
func has_broken_armor() -> int:
	var index = 0
	for i in Global.inventory:
		if i.name == Global.colete_upgrade.name:
			return index
		index += 1
	return -1
	
func set_armor_icon():
	ind_brk_armor = has_broken_armor()
	if ind_brk_armor >= 0:
		has_armor = true
	else:
		has_armor = false
		modulate = Color(0,0,0,0)
		
func set_enought_cash(cash:int):
	if cash >= price:
		_enought_cash = true
		modulate = he_cash_clr
	else:
		_enought_cash = false
		modulate = ne_cash_clr

