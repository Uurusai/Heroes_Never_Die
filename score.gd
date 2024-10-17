extends Label


var default_text = "/30"

func _process(delta):
	var text = str(str(Global.player_health),default_text)
	self.text = (text)
