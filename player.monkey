Strict

Import ticker
Import vec2
Import rgb
Import mojo.input
Class Player
	Field leftKey:Int  = KEY_LEFT
	Field rightKey:Int = KEY_RIGHT
	Field upKey:Int    = KEY_UP
	Field downKey:Int  = KEY_DOWN
	Field button1:Int  = KEY_Z
	Field button2:Int  = KEY_X
	Field button3:Int  = KEY_C
	
	Field pos:Vec2
	Field speed:Float = 3
	Field lives:Int = 3
	Field shotTicker:Ticker
	Field invincibleTicker:Ticker 'Invincible unless ticker is in Ready state
	Field color:RGB
	Field score:Int
	Field radius:Float
	
	Method New(position:Vec2 = New Vec2(0, 0), col:RGB = New RGB())
		pos = position
		lives = 3
		radius = 4
		shotTicker = New Ticker(3)
		invincibleTicker = New Ticker(60, 30)
		color = col
		score = 0
	End
	
	Method Update:Void()
		If KeyDown(button1)
			If Not shotTicker.ready Then shotTicker.Tick()
			speed = 3
		Else 
			speed = 4
		End
		invincibleTicker.Tick()
		Move()
	End
	
	Method GetInvincible:Bool()
		Return Not invincibleTicker.Ready()
	End
	
	Method SetInvincible:Void()
		invincibleTicker.Reset()
	End
	
	Method IsDead:Bool()
		Return lives <= 0
	End
	
	Method TakeLife:Void()
		If (Not GetInvincible()) Then 
			lives -= 1
			If lives < 0 Then lives = 0
			invincibleTicker.Reset()
		End
	End
	
	Method Move:Void()
		pos.x += (KeyDown(rightKey) - KeyDown(leftKey)) * speed
		pos.y += (KeyDown(downKey) - KeyDown(upKey)) * speed
	End
End