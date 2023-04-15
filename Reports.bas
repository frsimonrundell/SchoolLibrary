B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub


'==========================================================
' PRINT SUBROUTINES
'==========================================================
Sub ReportPrint(frmName As Form)
	
	Dim PP As Paper
	PP.Initialize()
	Dim PC As Printer
	PC.Initialize()
	Dim PL As PageLayout
	PL.Initialize()
	PP = Paper_static.A4
	PC = Printer_Static.GetDefaultPrinter

	PL = PC.CreatePageLayout2(PP, PageOrientation_Static.PORTRAIT, "HARDWARE_MINIMUM")
	Dim PJ As PrinterJob = PrinterJob_Static.CreatePrinterJob
	'PJ.ShowPageSetupDialog(Null)
	PJ.ShowPrintDialog(Null)
	PJ.PrintPage2(PL, frmName.Rootpane)
	PJ.EndJob
	
End Sub

'Print and Close Report Page
Sub btnPrint_Click
	ReportPrint(Report)
End Sub

Sub btnRptClose_Click
	Report.Close
End Sub

' REPORTS MENU

Sub btnReport1_Click
	BorrowedByClassReport
End Sub

Sub BorrowedByClassReport
	Private RW As ReportWriter
	Private dtCurrent As String
	
	RW.Initialize("rptBorrowedBooksByClass",487,733)
	
	'Position the working form off the screen
	RW.PositionForm(-800,0)
	'If we want to see the working form
'	RW.PositionForm(100,100)

	'Set subtotals to display on change of data in column 0
	RW.GroupBy(0)
	
	'Set totals
	RW.ShowTotal = False
	
	'Setup some test data
	Dim Data As Map
	Data.Initialize
	
	'Static field header
	Data.Put("Header","List by Class of Books Borrowed")
	
	'Set up the row data (List of arrays)
	Dim L As List
	L.Initialize
	
	'This is where the query goes
	
	Private sQuery As String
	Private RS As ResultSet
	
	sQuery=" SELECT tblBorrow.ID, tblBorrow.`User`, tblBorrow.Book, 	tblBorrow.DateOut, 	tblBorrow.`Status`, "  & _
			"tblUser.FirstName, tblUser.Surname, tblUser.ID, tblUser.Class, "  & _
			"tblBook.Title, tblBook.Author, tblBook.BabcockCode, datediff( CURDATE( ), tblBorrow.DateOut) As DaysBorrowed " & _
			"FROM tblBorrow INNER JOIN tblUser ON tblBorrow.`User` = tblUser.ID " & _
			"INNER JOIN tblBook ON tblBorrow.Book = tblBook.BabcockCode " & _
			"WHERE 	tblBorrow.`Status` = 1 " &  _
			"ORDER BY tblUser.Class Asc, tblUser.Surname Asc"
			
	
	
	
'	For j = 0 To 10
'		For i = 0 To 4
'			Dim R() As String = Array As String("Group1 ","Item " & (j * 10 + i),10)
'			L.Add(R)
'		Next
'		For i = 5 To 9
'			Dim R() As String = Array As String("Group2 ","Item " & (j * 10 + i),20)
'			L.Add(R)
'		Next
'	Next

	RS = SQL.ExecQuery(sQuery)
	Do While RS.NextRow
		Dim rData() As String = Array As String(RS.GetString("Class"),  RS.GetString("FirstName"),  RS.GetString("Surname"),  RS.GetString("Title"),  RS.GetString("Author"),  RS.GetString("DaysBorrowed"))
		
		L.Add(rData)
	Loop
	RS.Close
	
	Data.Put("RowData",L)
	
	DateTime.DateFormat="dd/MM/yyyy HH:mm:ss"
	dtCurrent=DateTime.Date(DateTime.Now)
	
	'Static field footer
	Data.Put("Footer",cSchool & " " & dtCurrent)
	
	'Assign the data
	RW.Data = Data
	
	RW.PreviewSetup(30,30,30,30,False,False)
	RW.PreviewShow(0)
	

End Sub
