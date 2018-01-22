Strict
Import math
Import vec2

Class CollectionHandler<T>
	' Stupid class to handle collection manipulations only methods can be generic

	Method DequeShuffle:Void(d:Deque<T>)
		If d.Length() = 0 Then Return 
		Local temp:T = d.Get(0)
		Local pos:Int = 0
		For Local i:Int = 0 To d.Length() - 1
			temp = d.Get(i)
			pos = Rnd(d.Length())
			d.Set(i, d.Get(pos))
			d.Set(pos, temp)
		Next
		Return 
    End
    
    Method DequePick:T (d:Deque<T>)
		Return d.Get(Rnd(d.Length()))
	End
End

Function NgonInscribedRadius:Float(numSides:Int, sideLength:Float)
	Return (sideLength * .5) * Tan((180.0 * (numSides - 2.0)) / (2.0 * numSides))
End

Function NgonCircumscribedRadius:Float(numSides:Int, sideLength:Float)
	Return sideLength / (2.0 * Sin(180.0 / numSides))
End

Function CirclesCollide:Bool(x:Float, y:Float, radius:Float, x2:Float, y2:Float, radius2:Float)
	Return (((x2 - x) * (x2 - x) + (y2 - y) * (y2 - y)) < ((radius + radius2) * (radius + radius2)))
End

Function PointDistance:Float(x:Float, y:Float, x2:Float, y2:Float)
	Return Sqrt((x2 - x) * (x2 - x) + (y2 - y) * (y2 - y))
End

Function PointDirection:Float(x:Float, y:Float, x2:Float, y2:Float)
	return ATan2((y2 - y), (x2 - x))
End

Function Lerp:Float(a:Float, b:Float, w:Float)
	Return a * (1.0 - w) + b * w
End

' Perlin noise stuff
Function SCurve:Float(x:Float)
	Return 6 * Pow(x, 5) - 15 * Pow(x, 4) + 10 * Pow(x, 3)
End

Function IntegerNoise:Float(seed:Int)
	'Returns a value between -1 and 1
	Local n:Int = (seed Shr 13) ~ seed
	Local nn:Int = (n * (n * n * 60493 + 19990303) + 1376312589) & $7fffffff
	Return 1.0 - (Float(nn) / 1073741824.0)
End

Function CoherentNoise:Float(x:Float)
	'Returns a value between -1 and 1
	
	Local intX:Int = Int(Floor(x))
	Local n0:Float = IntegerNoise(intX)
	Local n1:Float = IntegerNoise(intX + 1.0)
	Local weight:Float = x - Floor(x)
	Local noise:Float = Lerp(n0, n1, SCurve(weight))
	Return noise
End

Function FourOctaveNoise:Float(time:Float, amplitude:Float = 1.0)
	'Seed can be any number progression, height is the returned max height
	Local o1:Float = CoherentNoise(time) * .5
	Local o2:Float = CoherentNoise(time + 2) * .25
	Local o3:Float = CoherentNoise(time + 4) * .125
	Local o4:Float = CoherentNoise(time + 8) * .0625
	
	Return (o1 + o2 + o3 + o4) / 0.9375 * amplitude
End

Class FourOctaveNoiseMover
	Field center:Vec2 = New Vec2() 'This is the x and y coordinate on the screen
	Field dim:Vec2 = New Vec2() 'This is the width and height
	'Field times:Vec2 = New Vec2() 'X and Y Seeds for random number generator
	Field offsets:Vec2 = New Vec2() 'This is the progression along each generator
	
	Field stepSize:Float = 0.1

	Method New(centerX:Float, centerY:Float, w:Float, h:Float, incVal:Float, xtime:Float, ytime:Float)
		center = New Vec2(centerX, centerY)
		dim = New Vec2(w, h)
		stepSize = incVal
		offsets = New Vec2(xtime, ytime)
	End
	
	Method Update:Void()
		offsets.x += stepSize
		offsets.y += stepSize
	End
	
	Method GetX:Float()
		Return center.x + FourOctaveNoise(offsets.x, dim.x)
	End
	
	Method GetY:Float()
		Return center.y + FourOctaveNoise(offsets.y, dim.y)
	End
End