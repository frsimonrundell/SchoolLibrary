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
	Private bs As String
End Sub


'Description: Generates a EAN-13 barcode and saves it in the /pictures folder as "EAN13.png" from where it can be loaded into for eg an ImageView
'
'Method of calling:
'success = EAN13.Draw_EAN13(message, back_color, fore_color)
'
'where 'success' = indication of successful encoding (0 = successful, 1 = not successful) - type Int
'successful = all input chars are numbers only
'where 'message' = message to be encoded - type String (enter first 12 characters only. The check digit (13th char) will be calculated and added)
'where 'back_color' = background color of the code - type Int
'where 'fore_color' = foreground color of the code (solid bar color) - type Int
'example of parameters to pass:
'message = "600106035982" - the message excludes the check digit that will be added
'back_color = Colors.Yellow
'fore_color = Colors.Black
Public Sub Draw_EAN13 (message As String) As String

  Dim flag1, flag2 As Int
  su.Initialize()
 
  flag1 = 0
  flag2 = 0
  If su.stringLength(message) <> 12 Then                'not the right number of digits
'    ToastMessageShow ("You have entered the incorrect number of digits", False) 
    flag2 = 1
  End If  
  
  For i = 0 To su.stringLength(message) - 1
      If su.Mid(message,i,1) <> "0" And _
	     su.Mid(message,i,1) <> "1" And _
		 su.Mid(message,i,1) <> "2" And _
		 su.Mid(message,i,1) <> "3" And _
		 su.Mid(message,i,1) <> "4" And _
		 su.Mid(message,i,1) <> "5" And _
		 su.Mid(message,i,1) <> "6" And _
		 su.Mid(message,i,1) <> "7" And _
		 su.Mid(message,i,1) <> "8" And _
		 su.Mid(message,i,1) <> "9"  Then
		 flag1 = 1
		 Exit
	  End If	   
	Next 
 
    If flag1 = 1 Then
'   	  ToastMessageShow ("You are attempting to encode non-numeric characters", False)
    End If

   If flag1 = 0 And flag2 = 0 Then                    'calculate and add a checksum for the 13th digit
     Dim z As Double
	 z = 0

    For i = 0 To su.stringLength(message) - 1
	  If (i+1) Mod 2 = 1 Then
	    z = z + su.Val(su.Mid(message,i,1))
      Else
	    z = z + (su.Val(su.Mid(message,i,1)) * 3)  
	  End If
	Next  
	
     z = ((Floor(z/10) + 1)*10) - z
	 If z = 0 Or z = 10 Then message = message & "0"
	 If z = 1 Then message = message & "1"
	 If z = 2 Then message = message & "2"
	 If z = 3 Then message = message & "3"
	 If z = 4 Then message = message & "4"
	 If z = 5 Then message = message & "5"
	 If z = 6 Then message = message & "6"
	 If z = 7 Then message = message & "7"
	 If z = 8 Then message = message & "8"
	 If z = 9 Then message = message & "9"




'    Log(message)
	message = build_string(message)
   End If
   
   Return message
  
End Sub

Private Sub build_string(message As String) As String

Dim karak As String
bs = ""
start = "101"	
bs = bs & start
Private ver() As String
'First                 Second  M1     M2     M3      M4    M5
ver = Array As String("Odd", "Odd", "Odd", "Odd" ,"Odd", "Odd", _
                      "Odd", "Odd", "Even", "Odd", "Even", "Even", _
                      "Odd", "Odd", "Even", "Even", "Odd", "Even", _
                      "Odd", "Odd", "Even", "Even", "Even", "Odd", _
                      "Odd", "Even", "Odd", "Odd", "Even", "Even", _
                      "Odd", "Even", "Even", "Odd", "Odd", "Even", _
                      "Odd", "Even", "Even", "Even", "Odd", "Odd", _
                      "Odd", "Even", "Odd", "Even", "Odd", "Even", _
                      "Odd", "Even", "Odd", "Even", "Even", "Odd", _
                      "Odd", "Even", "Even", "Odd", "Even", "Odd")


Private str()As String
                       '  ODD     EVEN       ALL
                       '  LEFT    LEFT      RIGHT
str = Array As String("0001101","0100111","1110010", _
                      "0011001","0110011","1100110", _
                      "0010011","0011011","1101100", _
                      "0111101","0100001","1000010", _
                      "0100011","0011101","1011100", _
                      "0110001","0111001","1001110", _ 
                      "0101111","0000101","1010000", _ 
                      "0111011","0010001","1000100", _ 
                      "0110111","0001001","1001000", _ 
                      "0001011","0010111","1110100") 

Dim first_num, karak_val As Int
first_num = su.Val(su.Mid(message,0,1))


'Log("first_num")
'Log(first_num)
   karak = su.Mid(message,1,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3)

   karak = su.Mid(message,2,1)
   karak_val = su.Val(karak)
   If ver(first_num * 6 + 1) = "Odd" Then
     bs = bs & str(karak_val*3)   
   Else
     bs = bs & str(karak_val * 3 + 1 )        
   End If
   
   karak = su.Mid(message,3,1)
   karak_val = su.Val(karak)
   If ver(first_num * 6 + 2) = "Odd" Then
     bs = bs & str(karak_val * 3)   
   Else
     bs = bs & str(karak_val * 3 + 1 )        
   End If  
   
    karak = su.Mid(message,4,1)
   karak_val = su.Val(karak)
   If ver(first_num * 6 + 3) = "Odd" Then
     bs = bs & str(karak_val * 3)   
   Else
     bs = bs & str(karak_val * 3 + 1 )        
   End If    

   karak = su.Mid(message,5,1)
   karak_val = su.Val(karak)
   If ver(first_num * 6 + 4) = "Odd" Then
     bs = bs & str(karak_val * 3)   
   Else
     bs = bs & str(karak_val * 3 + 1 )        
   End If  

   karak = su.Mid(message,6,1)
   karak_val = su.Val(karak)
   If ver(first_num * 6 + 5) = "Odd" Then
     bs = bs & str(karak_val * 3)   
   Else
     bs = bs & str(karak_val * 3 + 1 )        
   End If  

   bs = bs & "01010"

   karak = su.Mid(message,7,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3 + 2)   
 
   karak = su.Mid(message,8,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3 + 2)   
   
   karak = su.Mid(message,9,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3 + 2)   
   
   karak = su.Mid(message,10,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3 + 2)   
   
   karak = su.Mid(message,11,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3 + 2)   
   
   karak = su.Mid(message,12,1)
   karak_val = su.Val(karak)
   bs = bs & str(karak_val * 3 + 2)      

fin = "101"	
bs = bs & fin

Return bs

End Sub

