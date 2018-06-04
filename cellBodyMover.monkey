Strict

Import misc
Import cellBody
Import hitbox

' An interface for CellBody movement definition since you can't have function pointers
Interface CellBodyMover
	Method Move:Void()
End

' This is the shaking boss behavior class
Class CellBodyMoverBoss Implements CellBodyMover
	Field parent:CellBody = Null	
	Field noiseX:FourOctaveNoiseMover
	Field noiseY:FourOctaveNoiseMover

	Field rotNoise:Float = 0.0 + Rnd()
	
	Method New(CellBodyParent:CellBody, moveBox:Hitbox)
		parent = CellBodyParent
		noiseX = New FourOctaveNoiseMover(moveBox.GetX(), moveBox.GetY(), moveBox.GetWidth(), moveBox.GetHeight(), .03, 0 + Rnd(500), 10000 + Rnd(500))
		noiseY = New FourOctaveNoiseMover(moveBox.GetX(), moveBox.GetY(), moveBox.GetWidth(), moveBox.GetHeight(), .03, 0 + Rnd(500), 10000 + Rnd(500))
	End
	
	Method Move:Void()
		noiseX.Update()
		noiseY.Update()
				
		parent.pos.x = noiseX.GetX()
		parent.pos.y = noiseY.GetY()
		rotNoise += .02
		parent.rot = FourOctaveNoise(rotNoise, 360.0)
	End
End


' A common steering mover that will mark all cells dead when all are offscreen
Class CellBodyMoverPath Implements CellBodyMover
	'Algorithm
	' 1. Find the future position given current heading and veolcity [pt1] 
	' 2. Find a line perpindicular to the path from pt1, the path endpoint is pt2 (dot product, may project behind path, this is fine) https://www.youtube.com/watch?v=_ENEsV_kNx8
	' 3. If length of pt1 to pt2 is greater than path radius steer toward a point a further along the path than pt2
	' 4. move forward



	Public	
	Field pts:List<Vec2> = New List<Vec2>
	Field parent:CellBody = Null
	Field pathRadius:Float = 24.0
	Field currentTargetIndex:Int = 0
	
	Method CalculateFuturePos:Vec2()
	
	End
	
	Method TotalLength:Float()
	Local l:Float = 0.0
	
	'Loop over points summing distance
	
	End
End