Strict

Import vec2

Class Hitbox
	Field pos:Vec2
	Field size:Vec2
	
	Method New(width:Float, height:Float, x:Float = 1, y:Float = 1)
		pos = New Vec2(x, y)
		size = New Vec2(width, height)
	End


	Method Move:Void(x:Float, y:Float)
		pos.x = x
		pos.y = y
	End
	
	Method Move:Void(v:Vec2)
		pos.x = x.x
		pos.y = v.y
	End
	
	Method Resize:Void(width:Float, height:Float)
		size.x = width
		size.y = height
	End
	
	Method GetX:Float()
		Return pos.x
	End
	
	Method GetY:Float()
		Return pos.y
	End
	
	Method GetHeight:Float()
		Return size.x
	End
	
	Method GetWidth:Float()
		Return size.y
	End
	
	Method GetHalfWidth:Float()
		Return size.x * .5	
	End
	
	Method GetHalfHeight:Float()
		Return size.y * .5
	End
	
	Method GetLeft:Float()
		Return pos.x - GetHalfWidth()
	End
	
	Method GetRight:Float()
		Return pos.x + GetHalfWidth()
	End
	
	Method GetTop:Float()
		Return pos.y - GetHalfHeight()
	End
	
	Method GetBottom:Float()
		Return pos.y + GetHalfHeight()
	End
	
	Method Collides:Bool(h:Hitbox)
		' Left of other
		If GetRight() < h.GetLeft() Then 
			Return False 
		End
		' Right of other
		If GetLeft() > h.GetRight() Then 
			Return False 
		End
		' Above other
		If GetBottom() < h.GetTop() Then 
			Return False 
		End
		' Below of other
		If GetTop() > h.GetBottom() Then 
			Return False 
		End
		
		Return True
	End
	
	Method PointInside:Bool(x:Int, y:Int)
		If x > GetRight()  Then Return False
		If x < GetLeft()   Then Return False
		If y > GetBottom() Then Return False
		If y < GetTop()    Then Return False
		Return True
	End
End


Class CollisionCircle
	Field radius:Float
	Field pos:Vec2
	
	Method New(x:Float, y:Float, rad:Float)
		pos = New Vec2(x, y)
		radius = rad
	End
	
	Method New(v:Vec2, rad:Float)
		pos = New Vec2(v.x, v.y)
		radius = rad
	End
	
	Method Move:Void(x:Float, y:Float)
		pos.x = x
		pos.y = y
	End
	
	Method Move:Void(v:Vec2)
		pos.x = x.x
		pos.y = v.y
	End
	
	Method GetX:Float()
		Return pos.x
	End
	
	Method GetY:Float()
		Return pos.y
	End
	
	Method Collides:Bool(c:CollisionCircle)
		Local minDist:Float = c.radius + radius
		Local deltaX:Float = c.GetX() - GetX()
		Local deltaY:Float = c.GetY() - GetY()
		
		If (deltaX * deltaX) + (deltaY * deltaY) > minDist * minDist Then
			Return False
		Else
			Return True
		End
		
	End
End

