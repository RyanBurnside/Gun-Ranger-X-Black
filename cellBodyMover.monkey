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

End