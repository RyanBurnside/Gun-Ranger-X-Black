Strict 

Import vec2


Class Stroke
	Field pt1:Vec2 = New Vec2()
	Field pt2:Vec2 = New Vec2()

	Method New(p1:Vec2, p2:Vec2)
		pt1 = p1
		pt2 = p2
	End
End

Class StrokeFont
	Public
	Field strokes:IntMap<List<Stroke>> = New IntMap<List<Stroke>>
End

Class GlowStrokeFont Extends StrokeFont
	Public
	Method New()
	'0-------1--------2
	'|                |
	'3                4s
	'|                |
	'5  	     6        7s
	'|                |
	'8                9
	'|                |
	'10------11-------12
	'+-------+-----+-------+
	'| index |   x |     y |
	'|-------+-----+-------|
	'|     0 | 0.0 |   0.0 |
	'|     1 | 0.5 |   0.0 |
	'|     2 | 1.0 |   0.0 |
	'|     3 | 0.0 |  0.25 |
	'|     4 | 1.0 |  0.25 |
	'|     5 | 0.0 |   0.5 |
	'|     6 | 0.5 |   0.5 |
	'|     7 | 1.0 |   0.5 |
	'|     8 | 0.0 |  0.75 |
	'|     9 | 1.0 |  0.75 |
	'|    10 | 0.0 |   1.0 |
	'|    11 | 0.5 |   1.0 |
	'|    12 | 1.0 |   1.0 |
	'+-------+-----+-------+
	Local vertexBuffer:Vec2[] = New Vec2[13]
	
	vertexBuffer[0]  = New Vec2( 0.0 , 0.0)
	vertexBuffer[1]  = New Vec2( 0.5 , 0.0)
	vertexBuffer[2]  = New Vec2( 1.0 , 0.0)
	vertexBuffer[3]  = New Vec2( 0.0 , 0.25)
	vertexBuffer[4]  = New Vec2( 1.0 , 0.25)
	vertexBuffer[5]  = New Vec2( 0.0 , 0.5)
	vertexBuffer[6]  = New Vec2( 0.5 , 0.5)
	vertexBuffer[7]  = New Vec2( 1.0 , 0.5)
	vertexBuffer[8]  = New Vec2( 0.0 , 0.75)
	vertexBuffer[9]  = New Vec2( 1.0 , 0.75)
	vertexBuffer[10] = New Vec2( 0.0 , 1.0)
	vertexBuffer[11] = New Vec2( 0.5 , 1.0)
	vertexBuffer[12] = New Vec2( 1.0 , 1.0)
	
	'Some premade strokes (we use smaller index then bigger index for naming)
	Local st0_1:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[1])
	Local st0_2:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[2])
	Local st0_5:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[5])
	Local st0_6:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[6])
	Local st0_8:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[8])
	Local st0_10:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[10])
	Local st0_11:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[11])
	Local st0_12:Stroke = New Stroke(vertexBuffer[0], vertexBuffer[12])
	Local st1_2:Stroke = New Stroke(vertexBuffer[1], vertexBuffer[2])
	Local st1_3:Stroke = New Stroke(vertexBuffer[1], vertexBuffer[3])
	Local st1_4:Stroke = New Stroke(vertexBuffer[1], vertexBuffer[4])
	Local st1_5:Stroke = New Stroke(vertexBuffer[1], vertexBuffer[5])
	Local st1_11:Stroke = New Stroke(vertexBuffer[1], vertexBuffer[11])
	Local st2_6:Stroke = New Stroke(vertexBuffer[2],vertexBuffer[6])
	Local st2_7:Stroke = New Stroke(vertexBuffer[2],vertexBuffer[7])
	Local st2_9:Stroke = New Stroke(vertexBuffer[2],vertexBuffer[9])
	Local st2_10:Stroke = New Stroke(vertexBuffer[2],vertexBuffer[10])
	Local st2_11:Stroke = New Stroke(vertexBuffer[2],vertexBuffer[11])
	Local st2_12:Stroke = New Stroke(vertexBuffer[2],vertexBuffer[12])
	Local st3_5:Stroke = New Stroke(vertexBuffer[3],vertexBuffer[5])	
	Local st3_6:Stroke = New Stroke(vertexBuffer[3],vertexBuffer[6])	
	Local st3_8:Stroke = New Stroke(vertexBuffer[3],vertexBuffer[8])	
	Local st3_9:Stroke = New Stroke(vertexBuffer[3],vertexBuffer[9])
	Local st4_6:Stroke = New Stroke(vertexBuffer[4], vertexBuffer[6])
	Local st4_8:Stroke = New Stroke(vertexBuffer[4], vertexBuffer[8])
	Local st4_9:Stroke = New Stroke(vertexBuffer[4], vertexBuffer[9])
	Local st5_6:Stroke = New Stroke(vertexBuffer[5], vertexBuffer[6])
	Local st5_7:Stroke = New Stroke(vertexBuffer[5], vertexBuffer[7])
	Local st5_8:Stroke = New Stroke(vertexBuffer[5], vertexBuffer[8])
	Local st5_10:Stroke = New Stroke(vertexBuffer[5], vertexBuffer[10])
	Local st5_11:Stroke = New Stroke(vertexBuffer[5], vertexBuffer[11])
	Local st6_5:Stroke = New Stroke(vertexBuffer[6],vertexBuffer[5])
	Local st6_7:Stroke = New Stroke(vertexBuffer[6],vertexBuffer[7])
	Local st6_9:Stroke = New Stroke(vertexBuffer[6],vertexBuffer[9])
	Local st6_10:Stroke = New Stroke(vertexBuffer[6],vertexBuffer[10])
	Local st6_11:Stroke = New Stroke(vertexBuffer[6],vertexBuffer[11])
	Local st6_12:Stroke = New Stroke(vertexBuffer[6],vertexBuffer[12])
	Local st7_9:Stroke = New Stroke(vertexBuffer[7],vertexBuffer[9])
	Local st7_10:Stroke = New Stroke(vertexBuffer[7],vertexBuffer[10])
	Local st7_11:Stroke = New Stroke(vertexBuffer[7],vertexBuffer[11])
	Local st7_12:Stroke = New Stroke(vertexBuffer[7],vertexBuffer[12])
	Local st8_10:Stroke = New Stroke(vertexBuffer[8],vertexBuffer[10])
	Local st8_11:Stroke = New Stroke(vertexBuffer[8],vertexBuffer[11])
	Local st9_11:Stroke = New Stroke(vertexBuffer[9],vertexBuffer[11])
	Local st9_12:Stroke = New Stroke(vertexBuffer[9],vertexBuffer[12])
	Local st10_11:Stroke = New Stroke(vertexBuffer[10],vertexBuffer[11])
	Local st10_12:Stroke = New Stroke(vertexBuffer[10],vertexBuffer[12])
	Local st11_12:Stroke = New Stroke(vertexBuffer[11],vertexBuffer[12])

	strokes = New IntMap<List<Stroke>>
	strokes.Set(" ".ToChars()[0], New List<Stroke>)
	strokes.Set("A".ToChars()[0], New List<Stroke>([st2_10, st2_12, st6_7]))
	strokes.Set("B".ToChars()[0], New List<Stroke>([st0_1, st1_4, st4_6,st6_5, st6_9, st9_12, st10_12, st0_10]))
	strokes.Set("C".ToChars()[0], New List<Stroke>([st1_2, st1_5, st5_11, st11_12]))
	strokes.Set("D".ToChars()[0], New List<Stroke>([st0_1, st1_4, st4_9, st9_11, st10_11, st0_10]))
	strokes.Set("E".ToChars()[0], New List<Stroke>([st0_2, st0_10, st5_6, st10_12]))
	strokes.Set("F".ToChars()[0], New List<Stroke>([st0_2, st0_10, st5_6]))
	strokes.Set("G".ToChars()[0], New List<Stroke>([st1_2, st1_3, st3_8, st8_11, st11_12, st7_12, st6_7]))
	strokes.Set("H".ToChars()[0], New List<Stroke>([st0_10, st5_7, st2_12]))
	strokes.Set("I".ToChars()[0], New List<Stroke>([st0_2, st1_11, st10_12]))
	strokes.Set("J".ToChars()[0], New List<Stroke>([st0_2, st1_11, st8_11, st5_8]))
	strokes.Set("K".ToChars()[0], New List<Stroke>([st0_10, st5_6, st2_6, st6_12]))
	strokes.Set("L".ToChars()[0], New List<Stroke>([st0_10, st10_12]))
	strokes.Set("M".ToChars()[0], New List<Stroke>([st0_10, st0_6, st2_6, st2_12]))
	strokes.Set("N".ToChars()[0], New List<Stroke>([st0_10, st0_12, st2_12]))
	strokes.Set("O".ToChars()[0], New List<Stroke>([st1_3, st3_8, st8_11, st9_11, st4_9, st1_4]))
	strokes.Set("P".ToChars()[0], New List<Stroke>([st0_1, st1_4, st4_6,st6_5, st0_10]))
	strokes.Set("Q".ToChars()[0], New List<Stroke>([st1_3, st3_8, st8_11, st9_11, st4_9, st1_4, st6_12]))
	strokes.Set("R".ToChars()[0], New List<Stroke>([st0_1, st1_4, st4_6,st6_5, st0_10, st6_12]))
	strokes.Set("S".ToChars()[0], New List<Stroke>([st1_3, st8_11, st9_11, st1_4, st3_9]))
	strokes.Set("T".ToChars()[0], New List<Stroke>([st0_2, st1_11]))
	strokes.Set("U".ToChars()[0], New List<Stroke>([st0_8, st8_11, st9_11, st2_9]))
	strokes.Set("V".ToChars()[0], New List<Stroke>([st0_12, st2_12]))
	strokes.Set("W".ToChars()[0], New List<Stroke>([st0_10, st6_10, st6_12, st2_12]))
	strokes.Set("X".ToChars()[0], New List<Stroke>([st0_12, st2_10]))
	strokes.Set("Y".ToChars()[0], New List<Stroke>([st0_6, st2_10]))
	strokes.Set("Z".ToChars()[0], New List<Stroke>([st0_2, st2_10, st10_12]))
	strokes.Set("0".ToChars()[0], New List<Stroke>([st1_3, st3_8, st8_11, st9_11, st4_9, st1_4, st3_9]))
	strokes.Set("1".ToChars()[0], New List<Stroke>([st1_3, st1_11, st10_12]))
	strokes.Set("2".ToChars()[0], New List<Stroke>([st1_3,st1_4, st4_8, st8_10, st10_12]))
	strokes.Set("3".ToChars()[0], New List<Stroke>([st1_3, st1_4, st4_6, st6_9, st9_11, st10_11]))
	strokes.Set("4".ToChars()[0], New List<Stroke>([st1_5, st1_11, st5_7]))
	strokes.Set("5".ToChars()[0], New List<Stroke>([st0_2, st0_5, st5_6, st6_9, st9_11, st10_11]))
	strokes.Set("6".ToChars()[0], New List<Stroke>([st1_2, st1_5, st5_6, st6_9, st9_11, st10_11, st5_10]))
	strokes.Set("7".ToChars()[0], New List<Stroke>([st0_2, st2_10]))
	strokes.Set("8".ToChars()[0], New List<Stroke>([st1_3, st1_4, st3_9, st4_8, st8_11, st9_11]))
	strokes.Set("9".ToChars()[0], New List<Stroke>([st1_2, st1_3, st2_7, st3_6, st6_7, st7_11]))
	strokes.Set(".".ToChars()[0], New List<Stroke>)
	strokes.Set("!".ToChars()[0], New List<Stroke>)
	strokes.Set(":".ToChars()[0], New List<Stroke>)
		
	End
		
	Method GetChar:List<Stroke>(c:Int)
		'Returns a list of strokes given a character code
		If strokes.Get(c) <> Null Then
			Return strokes.Get(c)
		Else
			'Return a blank character (no strokes) if not found
			Return strokes.Get(" ".ToChars()[0])
		Endif
	End
End