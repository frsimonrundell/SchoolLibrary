B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=3.5
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private start As String
	Private fin As String
	Private su As StringUtilities
	Private bs, bs1 As String
	'Private bcolor As Int
	'Private fcolor As Int	
End Sub


'Description: Generates Code39 barcode and saves it in the /pictures folder as "Code39.png" from where it can be loaded into for eg an ImageView
'
'Method of calling:
'success = Code39.Draw_Code39(message, back_color, front_color)
'
'where 'success' = indication of successful encoding (0 = successful, 1 = not successful) - type Int
'successful = all input chars are valid input chars (lower case will automatically be converted to upper case)
'where 'message' = message to be encoded - type String
'where 'back_color' = background color of the code - type Int
'where 'front_color' = foreground color of the code (solid bar color) - type Int
'example of parameters to pass:
'message = "Test Code39" 
'back_color = Colors.Yellow
'fore_color = Colors.Black
Public Sub Draw_Code39 (message As String) As String

Dim flag As Int
su.Initialize()

Dim karak, new_mes As String

new_mes = ""
flag = 0
For i = 0 To su.stringLength(message) -1
    karak = su.Mid(message,i,1)
	If karak = "a" Then karak = "A"
	If karak = "b" Then karak = "B"
    If karak = "c" Then karak = "C"
	If karak = "d" Then karak = "D"
	If karak = "e" Then karak = "E"
	If karak = "f" Then karak = "F"
	If karak = "g" Then karak = "G"
	If karak = "h" Then karak = "H"
	If karak = "i" Then karak = "I"
	If karak = "j" Then karak = "J"
	If karak = "k" Then karak = "K"
	If karak = "l" Then karak = "L"
	If karak = "m" Then karak = "M"
	If karak = "n" Then karak = "N"
	If karak = "o" Then karak = "O"
	If karak = "p" Then karak = "P"
	If karak = "q" Then karak = "Q"
	If karak = "r" Then karak = "R"
	If karak = "s" Then karak = "S"
	If karak = "t" Then karak = "T"
	If karak = "u" Then karak = "U"
	If karak = "v" Then karak = "V"
	If karak = "w" Then karak = "W"
	If karak = "x" Then karak = "X"
	If karak = "y" Then karak = "Y"
	If karak = "z" Then karak = "Z"
	If karak <> "0" And karak <> "1" And karak <> "2" And _
	   karak <> "3" And karak <> "4" And karak <> "5" And _
	   karak <> "6" And karak <> "7" And karak <> "8" And _
	   karak <> "9" And karak <> "A" And karak <> "B" And _
	   karak <> "C" And karak <> "D" And karak <> "E" And _
	   karak <> "F" And karak <> "G" And karak <> "H" And _
	   karak <> "I" And karak <> "J" And karak <> "K" And _
	   karak <> "L" And karak <> "M" And karak <> "N" And _
	   karak <> "O" And karak <> "P" And karak <> "Q" And _
	   karak <> "R" And karak <> "S" And karak <> "T" And _
	   karak <> "U" And karak <> "V" And karak <> "W" And _
	   karak <> "X" And karak <> "Y" And karak <> "Z" And _
	   karak <> "-" And karak <> "." And karak <> " " And _
	   karak <> "$" And karak <> "/" And karak <> "+" And _
	   karak <> "%" Then
	   flag = 1
	   Exit
    End If
	new_mes = new_mes & karak
Next	

message = new_mes

'Log(message)
If flag = 0 Then
  message = build_string(message)
End If

If flag = 1 Then
'  ToastMessageShow ("You are attempting to encode invalid Code39 characters", False)
End If
   
Return message
 
End Sub


Private Sub build_string(mes1 As String) As String

Dim karak As String
bs = ""
start = "NWNNWNWNN"	
bs = bs & start
bs = bs & "N"

For i = 0 To su.stringLength(mes1) - 1
    karak = su.Mid(mes1,i,1)
	
'	Log(karak)
	If karak = "0" Then bs = bs & "NNNWWNWNN"
	If karak = "1" Then bs = bs & "WNNWNNNNW"
	If karak = "2" Then bs = bs & "NNWWNNNNW"
	If karak = "3" Then bs = bs & "WNWWNNNNN"
	If karak = "4" Then bs = bs & "NNNWWNNNW"
	If karak = "5" Then bs = bs & "WNNWWNNNN"
	If karak = "6" Then bs = bs & "NNWWWNNNN"
	If karak = "7" Then bs = bs & "NNNWNNWNW"
	If karak = "8" Then bs = bs & "WNNWNNWNN"
	If karak = "9" Then bs = bs & "NNWWNNWNN"
	If karak = "A" Then bs = bs & "WNNNNWNNW"
	If karak = "B" Then bs = bs & "NNWNNWNNW"
	If karak = "C" Then bs = bs & "WNWNNWNNN"
	If karak = "D" Then bs = bs & "NNNNWWNNW"
	If karak = "E" Then bs = bs & "WNNNWWNNN"
	If karak = "F" Then bs = bs & "NNWNWWNNN"
	If karak = "G" Then bs = bs & "NNNNNWWNW"
	If karak = "H" Then bs = bs & "WNNNNWWNN"
	If karak = "I" Then bs = bs & "NNWNNWWNN"
	If karak = "J" Then bs = bs & "NNNNWWWNN"
	If karak = "K" Then bs = bs & "WNNNNNNWW"
	If karak = "L" Then bs = bs & "NNWNNNNWW"
	If karak = "M" Then bs = bs & "WNWNNNNWN"
	If karak = "N" Then bs = bs & "NNNNWNNWW"
	If karak = "O" Then bs = bs & "WNNNWNNWN"
	If karak = "P" Then bs = bs & "NNWNWNNWN"
	If karak = "Q" Then bs = bs & "NNNNNNWWW"
	If karak = "R" Then bs = bs & "WNNNNNWWN"
	If karak = "S" Then bs = bs & "NNWNNNWWN"
	If karak = "T" Then bs = bs & "NNNNWNWWN"
	If karak = "U" Then bs = bs & "WWNNNNNNW"
	If karak = "V" Then bs = bs & "NWWNNNNNW"
	If karak = "W" Then bs = bs & "WWWNNNNNN"
	If karak = "X" Then bs = bs & "NWNNWNNNW"
	If karak = "Y" Then bs = bs & "WWNNWNNNN"
	If karak = "Z" Then bs = bs & "NWWNWNNNN"
	If karak = "-" Then bs = bs & "NWNNNNWNW"
	If karak = "." Then bs = bs & "WWNNNNWNN"
	If karak = " " Then bs = bs & "NWWNNNWNN"
	If karak = "$" Then bs = bs & "NWNWNWNNN"
	If karak = "/" Then bs = bs & "NWNWNNNWN"
	If karak = "+" Then bs = bs & "NWNNNWNWN"
	If karak = "%" Then bs = bs & "NNNWNWNWN"
	bs = bs & "N" 
Next	

fin = "NWNNWNWNN"	
bs = bs & fin

'Log(bs)
'Log(su.stringLength(bs))
'Return bs
bs1 = ""




Dim siz1 As Int
Dim qr_size As Int
siz1 = 4dip

qr_size = 0
For i = 0 To su.stringLength(bs) - 1
  If su.Mid(bs,i,1) = "N" Then qr_size = qr_size + siz1
  If su.Mid(bs,i,1) = "W" Then qr_size = qr_size + (2*siz1) 
Next


		
For i = 0 To su.stringLength(bs) - 1
'  Log("i = " & i & " " & su.Mid(bs,i,1))
  If (i+1) Mod 2 = 1  And su.Mid(bs,i,1) = "N" Then
'        Log("Gotcha 1 " & i)
'''''	rect1.Left = x       
'''''	rect1.Right = x + siz1            
'''''	rect1.Top = y            
'''''	rect1.Bottom = Floor(qr_size / 3) + 50dip           	 
'''''    c.DrawRect(rect1, fcolor, True, 5dip)  
'''''    x = x + siz1
     bs1 = bs1 & "1"
  Else If (i+1) Mod 2 = 1  And su.Mid(bs,i,1) = "W" Then
'        Log("Gotcha 2")
'''''	rect1.Left = x       
'''''	rect1.Right = x + (2*siz1)            
'''''	rect1.Top = y            
'''''	rect1.Bottom = Floor(qr_size / 3) + 50dip         	 
'''''    c.DrawRect(rect1, fcolor, True, 5dip)  
'''''    x = x + (2 * siz1)
     bs1 = bs1 & "11"
  Else If (i+1) Mod 2 = 0  And su.Mid(bs,i,1) = "N" Then
'        Log("Gotcha 3")
'''''	rect1.Left = x       
'''''	rect1.Right = x + siz1            
'''''	rect1.Top = y            
'''''	rect1.Bottom = Floor(qr_size / 3) + 50dip          	 
'''''    c.DrawRect(rect1, bcolor, True, 5dip)  
'''''    x = x + siz1
     bs1 = bs1 & "0"
   Else If (i+1) Mod 2 = 0  And su.Mid(bs,i,1) = "W" Then
'        Log("Gotcha 4")
'''''	rect1.Left = x       
'''''	rect1.Right = x + (2*siz1)            
'''''	rect1.Top = y            
'''''	rect1.Bottom = Floor(qr_size / 3) + 50dip           	 
'''''    c.DrawRect(rect1, bcolor, True, 5dip) 
'''''	x = x + (2 * siz1)
     bs1 = bs1 & "00"
   End If
Next

'Log(bs1)

Return bs1

'''''message = "*" & message & "*"
'''''Dim stretch_mess As String
'''''stretch_mess = "     "
'''''
'''''For i=0 To su.stringLength(message) - 1
'''''  stretch_mess = stretch_mess & su.Mid(message,i,1)
'''''  If i < su.stringLength(message) - 1 Then
'''''    stretch_mess = stretch_mess & "        "
'''''  End If	
'''''Next  

'''''c.DrawText(stretch_mess,Floor(qr_size+150)/2, Floor(qr_size / 3) + 130dip,Typeface.DEFAULT_BOLD,45,Colors.Black,"CENTER")
''''''See Erel's posting at http://www.basic4ppc.com/android/forum/threads/saving-a-picture.10200/#post-56686 for detail of the code below
''''''Marginally changed to suite my requirements


  
End Sub


