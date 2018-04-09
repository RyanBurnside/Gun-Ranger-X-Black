Strict

Class ObjectManager<T>
	Field data:Deque<T>
	
	Method New()
		data = New Deque<T>
	End
	
	Method New(newData:Deque<T>)
		data = newData
	End
	
	Method Length:Int()
		Return data.Length()
	End
	
	Method Clear:Void()
		data.Clear()
	End
	
	Method CullDead:Void()
		Local l:Int = data.Length()
		Local deadFound:Bool = False
		
		' Sweep through and see if dead exist before hammering memory
		For Local i:T = Eachin(data)
			If i.dead Then
				deadFound = True
				Exit
			End
		Next
		
		If Not deadFound Then
			Return
		End
		
		' TODO make sure Push(Pop()) is safe...
		For Local i:Int = 0 To l - 1
			If data.Get(0).dead Then
				data.PopFirst()
			Else
				data.PushLast(data.PopFirst())
			End
		Next
	End
End