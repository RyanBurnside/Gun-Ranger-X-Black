Strict

Class Ticker
	Field value:Int
	Field max:Int
	Field ready:Bool

	Method New(maxValue:Float, startValue:Float = 0)
		max = maxValue
		value = startValue 
	End
	
	Method Reset:Void()
		value = 0
		ready = False
	End
	
	Method Tick:Void()
		If Not ready
			If value < max Then
		 		value += 1
			Else
				ready = True
			End
		End
	End
End