Strict


Class Vec2

	Field x:Float = 0
	Field y:Float = 0
	
	Method New(xx:Float = 0, yy:Float = 0)
		Self.x = xx
		Self.y = yy
	End
	
	Method Copy:Vec2()
		Return New Vec2(x, y)
	End
	
	Method Set:Void(xx:Float = 1.0, yy:Float = 0)
		x = xx
		y = yy
	End
	
	Method Set:Void(vec:Vec2)
		x = vec2.x
		y = vec2.y
	End
	
	Method SetRndUnit:Void()
		Local dir:Float = Rnd(1.0) * 360.0
		x = Cos(dir)
		y = Sin(dir)
	End
	
	Method SetAngleMag:Void(angle:Float, mag:Float)
		x = Cos(angle) * mag
		y = Sin(angle) * mag
	End
	
	Method GetAngle:Float() Return ATan2(y, x) End
	
	Method SetAngle:Void(angle:Float) 
		Local m:Float = GetMag()
		x = Cos(angle) * m
		y = Sin(angle) * m
	End
	
	Method GetMag:Float() Return Sqrt(x * x + y * y) End
	
	Method SetMag:Void(mag:Float)
		Local a:Float = GetAngle()
		x = Cos(a) * mag
		y = Sin(a) * mag
	End
	
	Method Scale:void(val:Float) SetMag(GetMag * val) End
	
	Method Invert:Void()
		FlipX()
		FlipY()
	End
	
	Method FlipX:Void() x *= -1.0 End
	Method FlipY:Void() y *= -1.0 End
	
	Method Add:Void(v:Vec2)
		x += v.x
		y += v.y
	End
	
	Method Sub:Void(v:Vec2)
		x -= v.x
		y -= v.y
	End
	
	Method Rot:Void(angle:Float)
		SetAngle(GetAngle() + angle)
	End
End