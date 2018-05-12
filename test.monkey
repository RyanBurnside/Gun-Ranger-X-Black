Strict

' Ideas section-----------------------------------------------------------------
' Add aimed shots in the bursts and also reverse firing like ikaruga lasers
' Animated diagonal warning scroller prior to bosses
' Before boss stats show how many of each polygon/weapon was created (created before the stats show) seems more interesting as a gamble (slots or flipping cards)
' popcorn enemies between bosses
' Maybe each cell gets to choose their own shot shape for their bursts
' Maybe X shaped 1970's style lens flair that shimmers using perlin noise

' 1D perlin noise based line shimmer (1 generator for all)

' Card base boss choice (you shoot a card to reviel a boss, you get shown what you didn't pick
' "Daily Boss" a boss that uses the current month and day as a seed to encourage daily play
' Multiple enemy shot types like homing missle and cluster laser
' Droning boss background hum that changes frequency on movement speed
' Honeycomb scrolling background (very faint gray possibly the same texture as the cells)
' Calculate and use lightest color for the bullets when colors are generated
' Overdrive mode when boss is nearly dead (ensure it's fair though, faster shots aimed reverse ikaruga chassers, missles etc)
' Sparks from bullet hitting enemy
' Explosions

Import math
Import hitbox
Import shot
Import player
Import cell
Import cellBody
Import vec2
Import ticker
Import objectManager
Import strokeFont
Import mojo.keycodes
Import misc
Import mojo2


Function Main:Int()
	New Game
	Return 0
End

Class Game Extends App
	Field lineTexture:Image[3]
	Field shotTexture:Image[4]
	Const maxCellSides:Float = 8
	Const cellSideLength:Float = 32
	Field cellImages:Image[maxCellSides - 2]
	
	Field windowCanvas:Canvas 'The window's canvas
	Field canvas:Canvas       'The game world's canvas
	Field canvasImage:Image   'A special image bound to game world's canvas
	
	Field numPlaying:Int = 1
	Field players:Player[4]
	
	Field mainFont:GlowStrokeFont = New GlowStrokeFont()
	
	'Field cells:ObjectManager<Cell>
	Field cellBodies:ObjectManager<CellBody>
	
	Field playerShots:ObjectManager<Shot>
	Field enemyShots:ObjectManager<Shot>
	
	Field screenRot:Float = 0.0
	Field colors:RGB[6]
	
	Field level:Int = 12
	
	Method OnCreate:Int()			
		SetUpdateRate(60)
		Seed = Millisecs()
		lineTexture = Image.LoadFrames("glow.png", 3.0, False, 0.5, 0.5, Image.Filter)
		shotTexture = Image.LoadFrames("bullet_textures.png", 4, False, .5, .5, Image.Filter)
		numPlaying = 1
		players = [New Player(), New Player(), New Player(), New Player()]


		mainFont = New GlowStrokeFont() 'TESTING ONLY REMOVE ME LATER AND INITIALIZE IN THE MEMBERS SECTION

		playerShots = New ObjectManager<Shot>
		enemyShots = New ObjectManager<Shot>
		'cells = New ObjectManager<Cell>
		cellBodies = New ObjectManager<CellBody>
		
		canvasImage = New Image(600, 800)	
		canvas = New Canvas(canvasImage)
		SetDeviceWindow(6000, 6000, 2|4) ' A bug prevents the clipping area from resizing once set, so set it HUGE initially
		windowCanvas = New Canvas()
		SetDeviceWindow(1024, 768, 2|4)  ' Now, set it to a reasonable default
		
		GenerateColors()
		GenerateTextures()
		
		StartLevel(level)
		Return 0
	End
	
	Method StartLevel:Void(num:Int)
		playerShots.data.Clear()
		enemyShots.data.Clear()
		cellBodies.Clear()
		
		GenerateColors()
		GenerateTextures()
		Local temp:Hitbox = New Hitbox(canvasImage.Width(), canvasImage.Height() *.5, canvasImage.Width() * .5, canvasImage.Height() * .25)
		Local bossMoveBox:Hitbox = New Hitbox(canvasImage.Width() * .25, 
		                               canvasImage.Height() * .25, 
		                               canvasImage.Width() * .5, 
		                               canvasImage.Height() * .25)
		Local c:Cell = New Cell(canvasImage.Width() * .5, canvasImage.Height() * .5, Rnd(0, 360), maxCellSides, cellSideLength, RndColor())
		
		
		For Local i:Int = 0 To 1
		Local boss:CellBody = New CellBody(temp.GetX(), temp.GetY(), c)
		boss.GenerateRandomCells(num, temp.GetWidth(), temp.GetHeight())
		boss.mover = New CellBodyMoverBoss(boss, bossMoveBox)
		cellBodies.data.PushLast(boss)
		Next
		
		PositionPlayers()
	End
	
	Method PositionPlayers:Void()
		Local sub:Float = canvas.Width() / numPlaying + 1
		For Local i:Int = 0 To numPlaying -1
			players[i].pos.x = (sub * .5) + i * sub
			players[i].pos.y = canvas.Height() * .75
		End
	End

	Method GenerateColors:Void()
		'Makes the colors for the cells, should be called per boss
		colors[0] = MakeHSL(Rnd(), .65, Rnd(.55, .75))
		colors[1] = MakeHSL(Rnd(), .65, Rnd(.55, .75))
		colors[2] = MakeHSL(Rnd(), .65, Rnd(.55, .75))
		colors[3] = MakeHSL(Rnd(), .65, Rnd(.55, .75))
		colors[4] = MakeHSL(Rnd(), .65, Rnd(.55, .75))
		colors[5] = MakeHSL(Rnd(), .65, Rnd(.55, .75))
	End
	
	Method GenerateTextures:Void()
		'Ensure colors are generated prior to calling this
		cellImages = New Image[maxCellSides - 2] ' 0 - 8 needs 6 slots for 3 - 8
		For Local i:Int = 0 To cellImages.Length() - 1
			Local numSides:Int = i + 3
			Local width:Int = Ceil((NgonCircumscribedRadius(numSides, cellSideLength) * 2.0) + lineTexture[0].Height())
			cellImages[i] = New Image(width, width)
			Local c:Canvas = New Canvas(cellImages[i])
			c.SetBlendMode(BlendMode.Additive)
			Local colorIndex:Int = numSides Mod colors.Length()
			c.SetColor(colors[colorIndex].r, colors[colorIndex].g, colors[colorIndex].b, 1.0)
			c.Clear(0, 0, 0, 1)
			Local cell:Cell = New Cell(width * .5, width * .5, 0.0, numSides, cellSideLength, colorIndex)
			DrawCell(cell, c)
			c.Flush()
		Next
	End
	
	Method RndColor:Int()
		Return Rnd(colors.Length())
	End
	
	Method OnRender:Int()
		DrawGame()
		Return 0
	End
	
	Method HandleHotKeys:Void()
		If KeyHit(KEY_R) Then screenRot += 90.0
		If screenRot > 270 Then screenRot = 0.0
	End
	
	Method OnUpdate:Int()	
		UpdateEnemyShots()
		UpdatePlayerShots()
		HandleHotKeys()
		UpdatePlayers()

		UpdateCellBodies()
		
		PlayerShotCellCheck()
		EnemyShotPlayerCheck()

		MarkOffscreenShots(playerShots)
		MarkOffscreenShots(enemyShots)
		playerShots.CullDead()
		enemyShots.CullDead()
		cellBodies.CullDead()
		
		If cellBodies.Length() < 1 Then
			level = level + 1
			StartLevel(level * 3)
		Endif
		
		Return 0
	End
	
	Method UpdateEnemyShots:Void()
		For Local s:Shot = Eachin(enemyShots.data)
			s.Move()
		Next
	End
	
	Method UpdatePlayerShots:Void()
		For Local s:Shot = Eachin playerShots.data
			s.Move()
		Next
	End
	
	Method EnemyShotPlayerCheck:Void()

	End
	
	Method PlayerShotCellCheck:Void()
		For Local s:Shot = Eachin(playerShots.data)
			For Local c:CellBody = Eachin(cellBodies.data)
				s.dead = c.DamageTouching(s.pos, s.radius)
			Next
		Next
	End
	
	Method UpdatePlayers:Void()
		For Local i:Int = 0 To numPlaying - 1
			players[i].Update()
			ContainPlayer(players[i])
			If players[i].shotTicker.ready Then
				
				playerShots.data.PushLast(New Shot(players[i].pos.x, players[i].pos.y, 24.0, 90, 16, 0, 1))
				players[i].shotTicker.Reset()
			End
		End
	End
	
	Method UpdateCellBodies:Void()
		For Local cb:CellBody = Eachin(cellBodies.data)
			cb.Update()
			
			'update cells
			For Local c:Cell = Eachin(cb.cells.data)
				
				'We need to check which Cells are ready to fire and let them fire
				If c.shotTicker.ready Then
					Local temp:Shot = New Shot(0, 0, 8.0, 0.0, 8, c.color, Rnd(0, 4))
					BurstFire(enemyShots.data, c.finalPosition.x, c.finalPosition.y, c.aimDirection, c.GetSides(), temp)
					c.shotTicker.Reset()
				End
			Next
		Next
		'update cells
	End
	
	Method ContainPlayer:Void(p:Player)
		'Function to make sure players stay inside border
		If p.pos.x - p.radius < 0.0 Then p.pos.x = p.radius
		If p.pos.y - p.radius < 0.0 Then p.pos.y = p.radius
		If p.pos.x + p.radius > canvas.Width() Then p.pos.x = canvas.Width() - p.radius
		If p.pos.y + p.radius > canvas.Height() Then p.pos.y = canvas.Height() - p.radius
	End
	
	Method OnResize:Int()		
		canvas.Flush()
		windowCanvas.Flush()
		Return 0
	End
	
	Method MarkOffscreenShots:Void(o:ObjectManager<Shot>)
		'Mark offscreen shots for player and enemy for death (does not kill just sets flag)
		Local shotBottom:Float
		Local shotTop:Float 
		Local shotRight:Float
		Local shotLeft:Float
		For Local s:Shot = Eachin(o.data)
			shotBottom = s.pos.y + shotTexture[0].Height() * s.imageScale
			shotTop = s.pos.y - shotTexture[0].Height() * s.imageScale
			shotRight = s.pos.x + shotTexture[0].Height() * s.imageScale
			shotLeft = s.pos.x - shotTexture[0].Height() * s.imageScale
			' Above
			If shotBottom < 0 Then s.dead = True
			' Left
			If shotLeft > canvasImage.Width() Then s.dead = True
			' Right
			If shotRight < 0 Then s.dead = True 
			' Below
			If shotTop > canvasImage.Height() Then s.dead = True
		Next
	End
	
	Method DrawGame:Void()
		canvas.Clear(0, 0, 0, 1.0)
		canvas.SetBlendMode(BlendMode.Additive)
		canvas.SetAlpha(1.0)
		
		DrawPlayers()
		
		For Local cb:CellBody = Eachin(cellBodies.data)
			DrawCellBody(cb)
			'canvas.DrawCircle(cb.pos.x, cb.pos.y, 16)
		Next
		
		For Local s:Shot = Eachin(enemyShots.data)
			DrawShot(s)
		Next
		
		For Local s:Shot = Eachin(playerShots.data)
			DrawShot(s)
		Next

		DrawGlowStrokeFont(32, 32, "ABCDEFGHIJKLMNO", 24.0, mainFont, canvas)
		DrawGlowStrokeFont(32, 64, "PQRSTUVWXYZ", 24.0, mainFont, canvas)
		canvas.Flush()
		windowCanvas.Clear(.1, .1, .1, 1.0)

		Local scale:Float = DeviceHeight() / Float(canvasImage.Height())

		ShapeAndDrawCanvas()	
		windowCanvas.Flush()
	End

	Method ShapeAndDrawCanvas:Void()
		Local deltaX:Float = windowCanvas.Width() / Float(canvasImage.Width())
		Local deltaY:Float = windowCanvas.Height() / Float(canvasImage.Height())
		
		' Adjustment for rotated canvas
		If screenRot = 90.0 Or screenRot = 270.0
			deltaX = windowCanvas.Height() / Float(canvasImage.Width())
			deltaY = windowCanvas.Width() / Float(canvasImage.Height())
		End
		
		Local scale:Float = Min(deltaX, deltaY)
		windowCanvas.DrawImage(canvasImage, DeviceWidth() * .5, DeviceHeight() * .5, screenRot, scale, scale)
	End
	
	Method DrawLine:Void(x:Float, y:Float, x2:Float, y2:Float, can:Canvas = canvas)		
		Local dist:Float = Sqrt(((x2-x) * (x2-x)) + ((y2-y) * (y2-y)))
		Local dir:Float = ATan2(y2-y, x-x2)
		Local midX:Float = (x+x2) * .5
		Local midY:Float = (y+y2) * .5
		Local midScale:Float = dist  / Float(lineTexture[1].Height())
		'Endcap
			can.DrawImage(lineTexture[2], x, y, dir)
		'Middle
			can.DrawImage(lineTexture[1], midX, midY, dir, midScale, 1.0)
		'Endcap
			can.DrawImage(lineTexture[0], x2, y2, dir)
	End
	
	Method DrawPlayers:Void()
		For Local i:Int = 0 To numPlaying -1
			canvas.SetColor(players[i].color.r, players[i].color.g, players[i].color.b)
			DrawPlayer(players[i])
		Next
	End
	
	Method DrawChar:Void(x:Float, y:Float, c:Int, scale:Float, f:GlowStrokeFont = mainFont, can:Canvas)
		For Local s:Stroke = Eachin f.GetChar(c)
			DrawLine(x + s.pt1.x * scale, y + s.pt1.y * scale, x + s.pt2.x * scale, y + s.pt2.y * scale, can)
		Next
	End
	
	Method DrawGlowStrokeFont:Void(x:Float, y:Float, s:String, scale:Float = 24.0, f:GlowStrokeFont = mainFont, can:Canvas)
		Local counter:Float = 0.0
		Local nextX:Float = x
		For Local c:Int = Eachin s.ToChars()
			nextX += scale + (scale / 2.0)
			DrawChar(nextX, y, c, scale, f, can)
		Next
	End
	
	Method DrawPlayer:Void(p:Player)
		Local tipX:Float = p.pos.x
		Local tipY:Float = p.pos.y - 16.0
		Local rWingX:Float = p.pos.x + 16.0
		Local rWingY:Float = p.pos.y + 16.0
		Local lWingX:Float = p.pos.x - 16.0
		Local lWingY:Float = p.pos.y + 16.0
		Local bottomX:Float = p.pos.x
		Local bottomY:Float = p.pos.y + 10.0
		
		DrawLine(tipX, tipY, rWingX, rWingY)
		DrawLine(tipX, tipY, lWingX, lWingY)
		DrawLine(rWingX, rWingY, bottomX, bottomY)
		DrawLine(lWingX, lWingY, bottomX, bottomY)
		DrawLine(p.pos.x, p.pos.y, p.pos.x, p.pos.y)
	End
		
	Method DrawCell:Void(cell:Cell, can:Canvas = canvas)
		' Draws a cell in the mass provides optional canvas for prerendering to a different target
		' This function is used to generate the sprites for the cell images

		Local cx:Float = cell.pos.x
		Local cy:Float = cell.pos.y
		Local sub:Float = 360.0 / cell.GetSides()
		Local angle:Float = 0.0
		For Local i:Int = 0 To cell.GetSides() - 1
			Local angle:Float = cell.GetRotDirection() + i * sub
			DrawLine(cx + Cos(angle) * cell.radius,
					 cy + Sin(angle) * cell.radius,
					 cx + Cos(angle + sub) * cell.radius,
					 cy + Sin(angle + sub) * cell.radius,
					 can)
			DrawLine(cx + Cos(angle) * cell.radius,
					 cy + Sin(angle) * cell.radius,
					 cx,
					 cy,
					 can)
		Next
		
	End
	
	Method DrawCellSprite:Void(cell:Cell, can:Canvas = canvas)
		'This draws the cell from the cell images master list
		can.DrawImage(cellImages[cell.GetSides() - 3], cell.pos.x, cell.pos.y, -cell.GetRotDirection())
	End
	
	Method DrawCellBody:Void(cb:CellBody, can:Canvas = canvas)
		' This draws the CellBody using the CellBodies's direction and postiion
		can.PushMatrix()
		can.TranslateRotate(cb.pos.x, cb.pos.y, -cb.rot)
		'can.DrawCircle(0, 0, 2)
		For Local c:Cell = Eachin(cb.cells.data)
			If c.lifeFlasher.Ready()
				can.SetAlpha(1.0)
			Else
				Local transparency:Float = .5 + (c.lifeFlasher.PercentReady()) * .5
				can.SetAlpha(transparency)				
			End
			DrawCellSprite(c, can)
		Next
		can.SetAlpha(1.0)
		can.PopMatrix()		
	End
	
	Method DrawShot:Void(shot:Shot)
		canvas.SetColor(colors[shot.imageColor].r, colors[shot.imageColor].g, colors[shot.imageColor].b)
		canvas.DrawImage(shotTexture[shot.imageFrame], shot.pos.x, shot.pos.y, ATan2(-shot.velocity.y, shot.velocity.x), shot.imageScale, shot.imageScale)
		'canvas.DrawRect(shot.pos.x - shot.radius, shot.pos.y - shot.radius, shot.radius * 2.0, shot.radius * 2.0)
	End
	
	Method BurstFire:Void(bulletList:Deque<Shot>, x:Float, y:Float, aim:Float, numShots:Float, shotTemplate:Shot)
		Local subAngle:Float = 360.0 / numShots
		For Local i:Float = 0 To numShots -1
			bulletList.PushLast(New Shot(x, y, shotTemplate.velocity.GetMag(), aim + i * subAngle, shotTemplate.radius, shotTemplate.imageColor, shotTemplate.imageFrame))
		Next
	End
End





