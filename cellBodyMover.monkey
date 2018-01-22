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
	Field noise:FourOctaveNoiseMover
	Field rotNoise:Float = 0.0
	
	Method New(CellBodyParent:CellBody, moveBox:Hitbox)
		parent = CellBodyParent
		noise = New FourOctaveNoiseMover(moveBox.GetX(), moveBox.GetY(), moveBox.GetWidth(), moveBox.GetHeight(), .03, 0, 10000)
	End
	
	Method Move:Void()
		noise.Update()		
		parent.pos.x = noise.GetX()
		parent.pos.y = noise.GetY()
		rotNoise += .008
		parent.rot = FourOctaveNoise(rotNoise, 360.0)
	End
End


' A common steering mover that will mark all cells dead when all are offscreen
Class CellBodyMoverPath Implements CellBodyMover

End