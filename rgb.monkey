Strict

Function MakeHSL:RGB(h:Float, sl:Float, l:Float)
	Local c:RGB = New RGB()
	Local v:Float = 0.0
	
	If l <= .5 Then
		v = l * (1.0 + sl)
	Else
		v = l + sl - l * sl
	End
	
	If v <= 0.0 Then
		c.r = 0.0
		c.g = 0.0
		c.b = 0.0
	Else
		Local m:Float = l + l - v
		Local sv:Float = (v - m) / v
		h *= 6.0
		Local sextant:Int = h 
		Local fract:Float = h - sextant
		Local vsf:Float = v * sv * fract
		Local mid1:Float = m + vsf
		Local mid2:Float = m - vsf
	
		Select sextant
			Case 0
				c.r = v
				c.g = mid1
				c.b = m
			Case 1
				c.r = mid2
				c.g = v
				c.b = m
			Case 2
				c.r = m
				c.g = v
				c.b = mid1
			Case 3
				c.r = m
				c.g = mid2
				c.b = v
			Case 4
				c.r = mid1
				c.g = m
				c.b = v
			Case 5
				c.r = v
				c.g = m
				c.b = mid2
		End
	End
	
	Return c
End

Class RGB
	Field r:Float
	Field g:Float
	Field b:Float
	
	Method New (red:Float = 1.0, green:Float = 1.0, blue:Float = 1.0)
		r = red
		g = green
		b = blue
	End
End