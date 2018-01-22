Strict


Import vec2
Import rgb
Import ticker
Import hitbox
Import misc
Import cellBodyMover

Class Cell
	Public	
	Field pos:Vec2 'Position relative to the cell cluster's center
	Field finalPosition:Vec2 ' This is a position that is used for the CellBody to make the final relative transforms to
	Field velocity:Vec2 = New Vec2()
	Field sideLength:Float

	Field radius:Float
	Field insideRadius:Float
	Field color:Int
	Field dead:Bool
	Field HP:Int = 15
	Field pointValue:Int = 300
	
	Field shotTicker:Ticker
	Field aimDirection:Float = 0.0
	
	
	Private 
	Field rotDirection:Float = 0
	Field numSides:Int = 0
	
	Public
	
	Method GetRotDirection:Float()
		Return rotDirection
	End
	
	Method GetSides:Int()
		Return numSides
	End
	
	Method rot:Void(angle:Float) Property
		rotDirection = angle
		'Transforms the points given angle
		Local stepAngle:Float = 360.0 / GetSides()
		radius = NgonCircumscribedRadius(GetSides(), sideLength)
	End
	
	Method GetDirection:Float()
		Return rotDirection
	End
	
	Method New(x:Float, y:Float, dir:Float, numSides:Int = 3, side:Float = 64, col:Int = 0)
		color = col
	
		pos = New Vec2(x, y)
		finalPosition = pos
		Self.numSides = numSides
		sideLength = side
		radius = NgonCircumscribedRadius(numSides, side)
		insideRadius = NgonInscribedRadius(numSides, side)
		
		velocity = New Vec2(0, 0)
		rot(dir)
		aimDirection = 0.0
		shotTicker = New Ticker(60, Rnd(0, 30))
		dead = False
	End
	
	Method Update:Void()
		If (Not shotTicker.ready) Then
			shotTicker.Tick()
			aimDirection += 5.0
		End
		Move()

	End
	
	Method Move:Void()
		pos.Add(velocity)
	End
End

Function SpawnValidOffspring:Deque<Cell>(starter:Cell, screenArea:Hitbox, cells:Deque<Cell>, maxSides:Int = 8)
	' Generate a deque full of possible cells for each side
	Local results:Deque<Cell> = New Deque<Cell>
	Local newRadius:Float = 0
	Local newX:Float = 0
	Local newY:Float = 0
	Local stepAngle:Float = 360.0 / starter.GetSides()
	Local combinedRadius:Float
	Local newDirection:Float = 0
	Local collides:Bool = False
	Local newStepAngle:Float = 0
	If maxSides < 2 maxSides = 3
	For Local i:Int = 0 To starter.GetSides() - 1
		For Local j:Int = 3 To maxSides
			newRadius = NgonInscribedRadius(j, starter.sideLength)
			combinedRadius = starter.insideRadius + newRadius
			newDirection = starter.GetDirection() + ((i * stepAngle) + (stepAngle * .5))
			newX = starter.pos.x + Cos(newDirection) * combinedRadius
			newY = starter.pos.y + Sin(newDirection) * combinedRadius
			newStepAngle = 360.0 / Float(j)
			
			'If the new point is not inside bail on this
			If Not screenArea.PointInside(newX, newY) Then 
				Exit
			End
			
			'Break from this loop if it collides (higher order cells will collide too) else add it
			collides = False
			For Local c:Cell = Eachin(cells)
				If c <> starter Then
					If CirclesCollide(newX, newY, newRadius, c.pos.x, c.pos.y, c.insideRadius) Then
						collides = True
						Exit
					End
				End
			Next
			
			If collides Then 'Bail on the higher order shapes, they'll collide too
				Exit
			Else
				If j Mod 2 = 0 Then newDirection += (newStepAngle * .5)
				Local c:Cell = New Cell(newX, newY, newDirection, j, starter.sideLength)
				results.PushLast(c)
			End
		Next
	Next
	Return results
End

Function GenerateCluster:Deque<Cell>(starter:Cell, screenArea:Hitbox, numCells:Int, maxSides:Int = 8)
	Local cells:Deque<Cell>  = New Deque<Cell>
	cells.PushLast(starter)
	Local c:CollectionHandler<Cell> = New CollectionHandler<Cell>

	For Local i:Int = 0 To numCells - 1
		' Shuffle the whole list so we don't traverse it the same each time
		c.DequeShuffle(cells)
		Local choices:Deque<Cell> = New Deque<Cell>
		For Local c:Cell = Eachin(cells)
			' Generate 1 random offspring that is inside the hitbox and doesn't collide
			Local results:Deque<Cell> = SpawnValidOffspring(c, screenArea, cells, maxSides)
			' add to choices
			If results.Length() > 0 Then
				choices.PushLast(results.Get(Rnd(results.Length())))
				Exit
			End
		Next
		For Local c:Cell = Eachin(choices)
			cells.PushLast(c)
		Next
	Next
	Return cells
End
