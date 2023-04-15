B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Private fx As JFX
	Private PageForm As Form
	Private mData As Map
	Private RowData As List
	Private Fields As Map
	Private ContentPages As List
	Private ColFormats As List
	
	Private pnHeader As Pane
	Private pnContent As Pane	'ignore
	Private pnRow As Pane
	Private pnSubTotal As Pane
	Private pnTotal As Pane
	Private pnFooter As Pane
	Private pnColHeader As Pane
	Type RWSubTotalsType(GroupBy As Int,ShowTotal As Boolean,InsertSubTotal As Boolean,LastGroupByVal As String,TotalsMap As Map,Level As Int)
	Private SubTotals As RWSubTotalsType
		
	Private ShowColHeaderAll,ShowColHeaderFirst As Boolean
	
	Type TotalTag(TotalId As String,TotalFormat As String)
	Type StaticTag(FieldName As String,FormatStr As String)
	Type RWColOrder(Left As Int,N As Node)
	
	Private mScale, mKeepAspect As Boolean
	
	Private RWP As ReportWriterPreview
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Layout As String,Width As Int,Height As Int)
	
	Fields.Initialize
	SubTotals.Initialize
	SubTotals.TotalsMap.Initialize
	ColFormats.Initialize
	
	SubTotals.GroupBy = -1

	PageForm.Initialize("PageForm",Width,Height)
	
	PageForm.RootPane.LoadLayout(Layout)
	
	ShowColHeaderAll = True
	ShowColHeaderFirst = True
	
	pnColHeader.StyleClasses.Add("rw-pncolheader")
	pnContent.StyleClasses.Add("rw-pncontent")
	pnFooter.StyleClasses.Add("rw-pnfooter")
	pnHeader.StyleClasses.Add("rw-pnheader")
	pnRow.StyleClasses.Add("rw-pnrow")
	
	'Ensure the columns for rowfields and headerfields are in the correct order Left to right
	Dim Cols As List
	Cols.Initialize
	
	Dim i As Int
	Dim Children As List = AdHocWrappers.Parent_GetChildren(pnColHeader)
	For i = Children.Size - 1 To 0 Step - 1
		Dim N As Node = Children.Get(i)
		Dim ColOrd As RWColOrder
		ColOrd.Initialize
		ColOrd.Left = N.Left
		ColOrd.N = N
		Cols.Add(ColOrd)
		N.RemoveNodeFromParent
	Next
	Cols.SortType("Left",True)
	For Each ColOrd As RWColOrder In Cols
		Dim N As Node = ColOrd.N
		pnColHeader.AddNode(N,N.Left,N.Top,N.PrefWidth,N.PrefHeight)
	Next
	
	Cols.Clear
	Dim Children As List = AdHocWrappers.Parent_GetChildren(pnRow)
	For i = Children.Size - 1 To 0 Step - 1
		Dim N As Node = Children.Get(i)
		Dim ColOrd As RWColOrder
		ColOrd.Initialize
		ColOrd.Left = N.Left
		ColOrd.N = N
		Cols.Add(ColOrd)
		N.RemoveNodeFromParent
	Next
	
	Cols.SortType("Left",True)
	For Each ColOrd As RWColOrder In Cols
		Dim N As Node = ColOrd.N
		pnRow.AddNode(N,N.Left,N.Top,N.PrefWidth,N.PrefHeight)
	Next
	
	
	'Get the column formats from the column header row tags, these are applied to each column field in the column
	For Each N As Node In AdHocWrappers.Parent_GetChildren(pnColHeader)
		If N Is Label Then
			Dim L As Label = N
			ColFormats.add(L.Tag)
		End If
	Next
	
	
	'Get Content place holders in the header pane and save a reference in the fields map
	For Each O As Object In AdHocWrappers.Parent_GetChildren(pnHeader)
		If O Is Label Then
			Dim L As Label = O
			'If a static field object was used, it's tag will contain a StaticTag object, extract the fieldname
			If L.Tag Is StaticTag Then
				Dim Tag As StaticTag = L.Tag
				Fields.Put(Tag.FieldName,L)
			Else
				'If it's a label, it's Tag should contain field name
				Fields.Put(L.Tag,L)
			End If
		End If

	Next
	
	'Get Content place holders in the footer pane and save a reference in the fields map
	For Each O As Object In AdHocWrappers.Parent_GetChildren(pnFooter)
		Dim L As Label = O
		'If a static field object was used, it's tag will contain a StaticTag object, extract the fieldname
		If L.Tag Is StaticTag Then
			Dim Tag As StaticTag = L.Tag
			Fields.Put(Tag.FieldName,L)
		Else
			'If it's a label, it's Tag should contain field name
			Fields.Put(L.Tag,L)
		End If
	Next
	
End Sub
Private Sub Parse_Data
	
	'Remove temporary and movable panes
	pnColHeader.RemoveNodeFromParent
	pnRow.RemoveNodeFromParent
	
	SubTotals.TotalsMap.Clear
	
	
	'Initialze the report page list
	ContentPages.Initialize
	
	'The current working page
	Dim ThisPage As List
	ThisPage.Initialize
	
	'Set a default list so we don't have to create one if we don't want to use it
	Dim DefaultL As List
	DefaultL.Initialize
	RowData = mData.GetDefault("RowData",DefaultL)
	
'	Dim Row() As String = RowData.Get(0)
	
	
	'Available space in the page
	Dim ContentHeight As Int = pnContent.PrefHeight
	
	'Setup for first page
	Dim CurrentHeight As Int = 0
	Dim DataStartRow As Int = 0
	Dim ST As Pane 			'Holder for SubTotal Pane as and when needed 
	
	If ShowColHeaderAll Or ShowColHeaderFirst Then 
		ThisPage.Add(ClonePane(pnColHeader))
		CurrentHeight = CurrentHeight + pnColHeader.PrefHeight
		DataStartRow = 1
	End If
	
	Dim i As Int = 0
	Dim RowValidLength As Int
	For Each Row() As String In RowData
		If i = 0 Then 
			RowValidLength = Row.Length
		Else
			If Row.Length <> RowValidLength Then
				Utils.ThrowIllegalArgumentException("Invalid data length in row " & i)
				Return
			End If
		End If
		Dim R As Pane = ClonePane(pnRow)
		Dim RowChildren As List = AdHocWrappers.Parent_GetChildren(R)
		Dim j As Int
		For j = 0 To Row.Length - 1
			Dim L As Label = RowChildren.Get(j)
			L.Text = FormatOutput(j,Row(j),"")
'			Log(j & " : " & Row(j))
			'Check if we need to display subtotals
			If SubTotals.GroupBy = j And i >= DataStartRow Then
				'Check If Subtotal is required
				If i = DataStartRow Then
					'Not on first row
					SubTotals.LastGroupByVal = Row(J)
				Else
					If SubTotals.LastGroupByVal <> Row(J) Then
						SubTotals.LastGroupByVal = Row(J)
						'Need to Insert SubTotal
						SubTotals.InsertSubTotal = True
						
					End If
				End If
			End If
			
		Next
		
		'Insert the subtotal before the current row and before the subtotals are updated for the current row
		If SubTotals.InsertSubTotal Then
			SubTotals.InsertSubTotal = False
			ST = ClonePane(pnSubTotal)
			Dim j As Int = 0
			For Each N As Node In AdHocWrappers.Parent_GetChildren(ST)
				If N Is Label Then
					Dim L As Label = N
					If L.Tag Is TotalTag Then
						Dim Tag As TotalTag = L.Tag
'						Log("2 " & Tag.TotalId)
						L.Text = FormatOutput(j, SubTotals.TotalsMap.GetDefault(Tag.TotalId,0),Tag.TotalFormat)
						SubTotals.TotalsMap.Put(Tag.TotalId,0)
					End If
				End If
				j = j + 1
			Next
			'Will the subtotal fit on the page?
'			Log(CurrentHeight & " : " & ST.PrefHeight & " : " & ContentHeight)
			If CurrentHeight + ST.PrefHeight < ContentHeight Then
				'Add the current row
				ThisPage.Add(ST)
				CurrentHeight = CurrentHeight + ST.PrefHeight
			Else
				'Store the current page
				ContentPages.Add(ThisPage)
				
				'Create a new page
				Dim ThisPage As List
				ThisPage.Initialize
				CurrentHeight = 0
				'Display the data header row if requested
				If ShowColHeaderAll Then 
					ThisPage.Add(ClonePane(pnColHeader))
					CurrentHeight = CurrentHeight + pnColHeader.PrefHeight
				End If
				
				'Add the row that caused the page to be thrown to the new page
				ThisPage.Add(ST)
				CurrentHeight = CurrentHeight + ST.PrefHeight
			End If
		End If

		
		'Check if the current row will fit on the page.
		If CurrentHeight + R.PrefHeight < ContentHeight Then
			'Add the current row
			ThisPage.Add(R)
			CurrentHeight = CurrentHeight + R.PrefHeight
		Else
			'Store the current page
			ContentPages.Add(ThisPage)
			
			'Create a new page
			Dim ThisPage As List
			ThisPage.Initialize
			CurrentHeight = 0
			'Display the data header row if requested
			If ShowColHeaderAll Then 
				ThisPage.Add(ClonePane(pnColHeader))
				CurrentHeight = CurrentHeight + pnColHeader.PrefHeight
			End If
			
			'Add the row that caused the page to be thrown to the new page
			ThisPage.Add(R)
			CurrentHeight = CurrentHeight + R.PrefHeight
		End If
		
		If SubTotals.GroupBy > -1 Or SubTotals.ShowTotal Then
			For j = 0 To Row.Length - 1
				Dim L As Label = RowChildren.Get(j)
				'Calculate sub and running totals for columns that need it
				If L.Tag <> "" Then
					SubTotals.TotalsMap.Put(L.Tag,SubTotals.TotalsMap.GetDefault(L.Tag,0) + Row(j))
					SubTotals.TotalsMap.Put("Running" & L.Tag,SubTotals.TotalsMap.GetDefault("Running" & L.Tag,0) + Row(j))
'					Log(i & " :  " & L.Tag & " : " & j & " : " & Row(j) & " : " & SubTotals.TotalsMap.GetDefault("Running" & L.Tag,0))
				End If
			Next
		End If
		i = i + 1
	Next
	

	'Show last SubTotal if required
	If SubTotals.GroupBy > -1 Then
			ST = ClonePane(pnSubTotal)
			Dim j As Int = 0
			For Each N As Node In AdHocWrappers.Parent_GetChildren(ST)
				If N Is Label Then
					Dim L As Label = N
					If L.Tag Is TotalTag Then
						Dim Tag As TotalTag = L.Tag
'						Log("1 " & Tag.TotalId)
						L.Text = FormatOutput(j, SubTotals.TotalsMap.GetDefault(Tag.TotalId,0),Tag.TotalFormat)
						SubTotals.TotalsMap.Put(Tag.TotalId,0)
					End If
				End If
				j = j + 1
			Next
			'Will the subtotal fit on the page?
			If CurrentHeight + ST.PrefHeight < ContentHeight Then
				'Add the current row
				ThisPage.Add(ST)
				CurrentHeight = CurrentHeight + ST.PrefHeight
			Else
				'Store the current page
				ContentPages.Add(ThisPage)
				
				'Create a new page
				Dim ThisPage As List
				ThisPage.Initialize
				CurrentHeight = 0
				'Display the data header row if requested
				If ShowColHeaderAll Then 
					ThisPage.Add(ClonePane(pnColHeader))
					CurrentHeight = CurrentHeight + pnColHeader.PrefHeight
				End If
				
				'Add the row that caused the page to be thrown to the new page
				ThisPage.Add(ST)
				CurrentHeight = CurrentHeight + ST.PrefHeight
			End If
		End If

	'Show Total
	If SubTotals.ShowTotal Then
		Dim j As Int = 0
		For Each N As Node In AdHocWrappers.Parent_GetChildren(pnTotal)
			If N Is Label Then
				Dim L As Label = N
				If L.Tag Is TotalTag Then
					Dim Tag As TotalTag = L.Tag
					L.Text = FormatOutput(j,SubTotals.TotalsMap.Get("Running" & Tag.TotalId),Tag.TotalFormat)
				End If
			End If
			j = j + 1
		Next
		'Will the total fit on the page?
			If CurrentHeight + pnTotal.PrefHeight < ContentHeight Then
				'Add the current row
				ThisPage.Add(pnTotal)
				CurrentHeight = CurrentHeight + pnTotal.PrefHeight
			Else
				'Store the current page
				ContentPages.Add(ThisPage)
				
				'Create a new page
				Dim ThisPage As List
				ThisPage.Initialize
				CurrentHeight = 0
				'Display the data header row if requested
				If ShowColHeaderAll Then 
					ThisPage.Add(ClonePane(pnColHeader))
					CurrentHeight = CurrentHeight + pnColHeader.PrefHeight
				End If
				
				'Add the row that caused the page to be thrown to the new page
				ThisPage.Add(pnTotal)
				CurrentHeight = CurrentHeight + ST.PrefHeight
			End If			
	End If
		'Catch the remaining rows on the last partially filled page
	If ThisPage.Size > 0 Then
		ContentPages.Add(ThisPage)
		Dim ThisPage As List
		ThisPage.Initialize
	End If
End Sub

Private Sub FormatOutput(Col As Int,Val As String,FormatStr As String) As String
	
	If Val = Null Or Val = "null" Or  Val = "" Then Return ""
	If FormatStr = "" Then
		If ColFormats.Size - 1 < Col Then Return Val
		'Check column format
		FormatStr = ColFormats.Get(Col)
	End If
	
	'Not required
	If FormatStr = Null Or FormatStr = "" Or FormatStr = "null" Then Return Val
	
	Dim Group As Boolean
	Dim MinInt As Int = 0
	Dim MaxFrac As Int = 0
	Dim MinFrac As Int = 0
	
	If FormatStr.EndsWith(",") Then 
		Group = True
		FormatStr = FormatStr.SubString2(0,FormatStr.Length-1)
	End If
	
	Dim FormS() As String = Regex.Split("\.",FormatStr)
	Select FormS.Length
		Case 0
			Return Val
		Case 1
			MinInt = FormS(0) + 0
		Case 2
			MinInt = FormS(0) + 0
			MinFrac = FormS(1) + 0
		Case 3
			MinInt = FormS(0) + 0
			MinFrac = FormS(1) + 0
			MaxFrac = FormS(2) + 0
	End Select
		
	Return NumberFormat2(Val,MinInt,MaxFrac,MinFrac,Group)
	
End Sub

Public Sub GroupBy(ColNo As Int)
	SubTotals.GroupBy = ColNo
End Sub

Public Sub setShowTotal(Show As Boolean)
	SubTotals.ShowTotal = Show
End Sub

'Get the page count
Public Sub PageCount As Int
	Return ContentPages.Size
End Sub

Private Sub DisplayPage(PageNo As Int)
	
	pnContent.RemoveAllNodes
	'Read data for static fields
	For Each Key As String In mData.Keys
		
		'Rowdata has already been dealtwith
		If Key = "RowData" Then Continue
		
		'Update the label values with the required data
		'Match the field names defined in the layout with those passed in the data map
		Dim L As Label = Fields.Get(Key)
		
		'If a static field object was used, it's tag will contain a statictag object, extract the format string
		If L.Tag Is StaticTag Then
			Dim Tag As StaticTag = L.Tag
			L.Text = FormatOutput(999,mData.Get(Key),Tag.FormatStr)
		Else
			'If a label was used, cannot format the output
			L.Text = mData.Get(Key)
		End If
	Next

	'Row data	
	Dim i As Int = 0
	'get the rows for this page
	Dim ThisPage As List = ContentPages.Get(PageNo)
	Dim Top As Int = 0
	
	'Display parsed rowdata
	For Each Row As Pane In ThisPage	
		pnContent.AddNode(Row,Row.Left,Top,Row.PrefWidth,Row.PrefHeight)
		Top = Top + Row.PrefHeight
		i = i + 1
	Next
	
End Sub

'Get Content place holders in a Static pane and save a reference in the fields map
Public Sub RegisterStaticPane(TagValue As String)
	For Each N As Node In PageForm.RootPane.GetAllViewsRecursive
		If N.Tag = TagValue Then
			Dim P As Pane = N
			For Each O As Object In P.GetAllViewsRecursive
				If O Is Label Then
					Dim L As Label = O
					'If a static field object was used, it's tag will contain a StaticTag object, extract the fieldname
					If L.Tag Is StaticTag Then
						Dim Tag As StaticTag = L.Tag
						Fields.Put(Tag.FieldName,L)
					Else
						'If it's a label, it's Tag should contain field name
						Fields.Put(L.Tag,L)
					End If
				End If
			Next
			Exit
		End If
	Next
End Sub

'Get / Set current mData map
Public Sub setData(M As Map)
	mData = Utils.MapClone(M)
	Parse_Data
	
End Sub
Public Sub getData As Map
	Return mData
End Sub

Public Sub ShowColHeader(FirstPage As Boolean,AllPages As Boolean)
	ShowColHeaderFirst = FirstPage	
	ShowColHeaderAll = AllPages
End Sub

Public Sub PositionForm(Left As Int,Top As Int)
	PageForm.WindowLeft = Left
	PageForm.WindowTop = Top
End Sub


Public Sub Print(Scale As Boolean,KeepAspect As Boolean)
	mScale = Scale
	mKeepAspect = KeepAspect
	Dim PJ As PrinterJob = PrinterJob_Static.CreatePrinterJob
	PJ.ShowPageSetupDialog(Null)
	If Not(PJ.ShowPrintDialog(Null)) Then Return

	'Resize the	page to that selected in the printer dialog, and afterwards call the print pages sub.
	Resize(PJ.GetJobSettings.GetPageLayout.GetPrintableWidth,PJ.GetJobSettings.GetPageLayout.GetPrintableHeight,"Print_Pages",PJ)
	
End Sub

Private Sub Resize(Width As Int,Height As Int,Callback As String,Arg As Object)
	'Show the page so new sizes are calculated
	PageForm.Show
	
	PageForm.WindowWidth = Width
	PageForm.WindowHeight = Height

	'Call after a delay to allow the page to be redrawn at it's new size
	Utils.CallSubTime(Me,"Parse_Data",Null,100)
	Utils.CallSubTime(Me,Callback,Array(Arg),110)
End Sub

Private Sub Print_Pages(PJ As PrinterJob)	'ignore
	'Print the pages
	For i = 0 To ContentPages.Size - 1
		DisplayPage(i)
		If mScale Then
			If mKeepAspect Then
				PJ.PrintPage(Utils.ScaleOutputKeepAspect(PJ.GetJobSettings.GetPageLayout, PageForm.RootPane))
			Else
				PJ.PrintPage(Utils.ScaleOutput(PJ.GetJobSettings.GetPageLayout, PageForm.RootPane))
			End If
		Else
			PJ.PrintPage(PageForm.RootPane)
		End If
	Next
    
    PJ.EndJob
	PageForm.close
End Sub

Public Sub PreviewSetup(LeftMargin As Int,TopMargin As Int,RightMargin As Int,BottomMargin As Int,Scale As Boolean,KeepAspect As Boolean)
	RWP.Initialize(Me,LeftMargin,TopMargin,RightMargin,BottomMargin,Scale,KeepAspect)
End Sub

Public Sub PreviewShow(PageNo As Int)
'	PageForm.Close
	PageForm.Show
	DisplayPage(PageNo)
	RWP.ShowPage(PageNo,PageForm.RootPane)
	PageForm.Close
End Sub

Public Sub AsNode As Node
	Return PageForm.RootPane
End Sub

Private Sub ClonePane(P As Pane) As Pane
	
	Dim NewP As Pane
	NewP.Initialize("")
	For Each N As Node In AdHocWrappers.Parent_GetChildren(P)
		If N Is Label Then
			Dim L As Label = N
			Dim NewL As Label
			NewL.Initialize("")
			NewL.Font = L.font
			NewL.Tag = L.Tag
			NewL.Style = L.Style
			NewL.Alignment = L.Alignment
			NewL.TextColor = L.TextColor
			NewL.TextSize = L.TextSize
			NewL.Text = L.Text
			NewL.Tag = L.Tag
			NewP.AddNode(NewL,L.Left,L.Top,L.PrefWidth,L.PrefHeight)
		End If
	Next
	NewP.Style = P.Style
	NewP.PrefHeight = P.PrefHeight
	NewP.PrefWidth = P.PrefWidth
	Return NewP
End Sub

