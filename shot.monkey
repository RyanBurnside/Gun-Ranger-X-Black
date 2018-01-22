
Strict

Import vec2
Import rgb
Import hitbox 'Used for offscreen culling

Class Shot
	Field pos:Vec2
	Field velocity:Vec2
	Field radius:Float
	Field dead:Bool
	Field imageColor:Int
	Field imageFrame:Int
	Field imageScale:Float
	Field direction:Float
	
	Method New(x:Float, y:Float, speed:Float, angle:Float, diameter:Float, color:Int = 0, frame:Int = 0)
		pos = New Vec2(x, y)
		velocity = New Vec2(Cos(angle) * speed, Sin(angle) * -speed)
		radius = diameter * .5
		imageColor = color
		imageFrame = frame
		direction = angle
		imageScale = .12
	End
	
	Method Move:Void()
		pos.Add(velocity)
	End
End