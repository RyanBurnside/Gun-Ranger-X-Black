Strict
Import cell
Import vec2
Import cellBodyMover
Import objectManager

Class CellBody
	' This is a class that contains cells and abstracts their positions given a direction and position
	Public
	Field cells:ObjectManager<Cell> = New ObjectManager<Cell>
	Field pos:Vec2
	Field rot:Float
	Field dead:Bool = False
	Field mover:CellBodyMover = Null
	Field MaxHP:Float = 1
	
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
		cells.data.PushFirst(cell)
	End
	
	Method New(x:Float, y:Float, cellDeque:Deque<Cell>, direction:Float = 0.0)
		pos = New Vec2(x, y)
		rot = direction
		cells.data = cellDeque
	End
	
	Method GetHP:Int()
		Local HP:Int = 0
		For Local i:Cell = Eachin(cells.data)
			HP += i.HP
		Next
		Return HP
	End
	
	Method GenerateRandomCells:Void(numCells:Int, width:Float, height:Float, maxSides:Int = 8)
		cells.Clear()
		
		'Make a region around pos for the cells to spawn within
		Local genRegion:Hitbox = New Hitbox(width, height, pos.x, pos.y)
		
		'Make first cell and then generate from that
		If cells.Length() = 0
			cells.data.PushFirst(New Cell(pos.x, pos.y, rot, Rnd(3, maxSides), 32, 0))
		End
		
		cells.data = GenerateCluster(cells.data.Get(0), genRegion, numCells, maxSides)
		
		'Now to correct the offsets we need to subtract off pos.x and pos.y from all cells
		For Local c:Cell = Eachin(cells.data)
			c.pos.Sub(pos)
		Next
		MaxHP = GetHP()
	End
	
	Method Update:Void()
		If mover <> Null 
			mover.Move()
		End
		
		'Cull dead cells
		cells.CullDead()
		
		' If all children are dead so is this CellBody
		If cells.data.IsEmpty() Then dead = True
		
		'Update remaining cells
		UpdateCells()
	End
	
	Method UpdateCells:Void()
		'updates each cells x and y postion based on the cell's relative position and this rotation and position
		For Local c:Cell = Eachin(cells.data)
			workingVec = c.pos.Copy()
			workingVec.Rot(rot)
			workingVec.Add(pos)
			c.finalPosition = workingVec
			c.Update()
		Next
	End
	
	Method DamageTouching:Bool(shotPosition:Vec2, shotRadius:Float, damageValue:Float = 1.0)
		'Given a vec2d iterate through all cells and if one is hit, damage it
		Local gaveDamage:Bool = False
		For Local c:Cell = Eachin(cells.data)
			If CirclesCollide(shotPosition.x, shotPosition.y, shotRadius, c.finalPosition.x, c.finalPosition.y, c.insideRadius) Then
				c.Damage(damageValue)
				gaveDamage = True
			End
		Next
		Return gaveDamage
	End
End