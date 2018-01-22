Strict
Import cell
Import vec2
Import cellBodyMover

Class CellBody
	' This is a class that contains cells and abstracts their positions given a direction and position
	Public
	Field cells:Deque<Cell> = New Deque<Cell>
	Field pos:Vec2
	Field rot:Float
	Field dead:Boolean = False
	Field mover:CellBodyMover = Null
	
	Private
	' Used internally to keep from making a lot of garbage
	Field workingVec:Vec2 = New Vec2(1.0, 0.0)
	
	
	Public
	
	Method New(x:Float, y:Float, direction:Float = 0.0)
		pos = New Vec2(x, y)
		rot = direction
	End
	
	Method New(x:Float, y:Float, cell:Cell, direction:Float = 0.0)
		pos = New Vec2(x, y)
		rot = direction
		cells.PushFirst(cell)
	End
	
	Method New(x:Float, y:Float, cellDeque:Deque<Cell>, direction:Float = 0.0)
		pos = New Vec2(x, y)
		rot = direction
		cells = cellDeque
	End
	
	Method GenerateRandomCells:Void(numCells:Int, width:Float, height:Float, maxSides:Int = 8)
		cells.Clear()
		
		'Make a region around pos for the cells to spawn within
		Local genRegion:Hitbox = New Hitbox(width, height, pos.x, pos.y)
		
		'Make first cell and then generate from that
		If cells.Length() = 0
			cells.PushFirst(New Cell(pos.x, pos.y, rot, Rnd(3, maxSides), 32, 0))
		End
		
		cells = GenerateCluster(cells.Get(0), genRegion, numCells, maxSides)
		
		'Now to correct the offsets we need to subtract off pos.x and pos.y from all cells
		For Local c:Cell = Eachin(cells)
			c.pos.Sub(pos)
		Next
	End
	
	Method Update:Void()
		If mover <> Null 
			mover.Move()
		End
		
		UpdatePositions()
	End
	
	Method UpdatePositions:Void()
		'updates each cells x and y postion based on the cell's relative position and this rotation and position
		For Local c:Cell = Eachin(cells)
			workingVec = c.pos.Copy()
			workingVec.Rot(rot)
			workingVec.Add(pos)
			c.finalPosition = workingVec
		Next
	End
	
End