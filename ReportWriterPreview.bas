B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Private fx As JFX
	Private PreviewForm As Form
	Private mLeft,mTop,mRight,mBottom As Int
	Private pnControls As Pane
	Private pnPreview As Pane
	Private mRW As ReportWriter
	Private mDisplayPane As Pane
	Private lblPageCount As Label
	Private pnNSpinner As Pane
	Dim NS As NumberSpinner
	Private mScale, mKeepAspect As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(RW As ReportWriter, MarginLeft As Int,MarginTop As Int,MarginRight As Int,MarginBottom As Int,Scale As Boolean,KeepAspect As Boolean)
	mScale = Scale
	mKeepAspect =KeepAspect
	mRW = RW
	mLeft = MarginLeft
	mTop = MarginTop
	mRight = MarginRight
	mBottom = MarginBottom

	PreviewForm.Initialize("PreviewForm",400,600)
	PreviewForm.RootPane.LoadLayout("ReportWriterPreview")
	PreviewForm.Title = "Report Writer Preview"
	lblPageCount.Text = "of " & RW.PageCount
	NS.Initialize(Me,"NS",1,0,1)
	pnControls.AddNode(NS.AsNode,pnNSpinner.Left,pnNSpinner.Top,pnNSpinner.PrefWidth,pnNSpinner.PrefHeight)
	pnNSpinner.RemoveNodeFromParent
	
End Sub

Public Sub ShowPage(PageNo As Int, DisplayPane As Pane)
	
	mDisplayPane = ClonePane(DisplayPane)
	'NS.Value = PageNo + 1
	
	If PreviewForm.Visible = False Then
		PreviewForm.WindowWidth = DisplayPane.Width + mLeft + mRight + 15
		PreviewForm.WindowHeight = DisplayPane.Height + mTop + mBottom + pnControls.PrefHeight + 30
		PreviewForm.RootPane.PrefWidth = DisplayPane.Width + mLeft + mRight
		PreviewForm.RootPane.PrefHeight = DisplayPane.Height + mTop + mBottom + pnControls.PrefHeight
		pnPreview.RemoveAllNodes
		pnPreview.Style = DisplayPane.Style
		pnPreview.StyleClasses.AddAll(DisplayPane.StyleClasses)
		pnPreview.PrefWidth = DisplayPane.Width + mLeft + mRight
		pnPreview.PrefHeight = DisplayPane.Height + mTop + mBottom
		pnPreview.AddNode(mDisplayPane,mLeft,mTop,DisplayPane.Width,DisplayPane.Height)
		PreviewForm.Show
	Else
		pnPreview.RemoveAllNodes
		pnPreview.AddNode(mDisplayPane,mLeft,mTop,DisplayPane.Width,DisplayPane.Height)
	End If
End Sub

Private Sub ClonePane(P As Pane) As Pane
	Dim NewP As Pane
	NewP.Initialize("")
	NewP.Style = P.Style
	NewP.Style = P.Style
	NewP.StyleClasses.AddAll(P.StyleClasses)
	
	For Each N As Node In AdHocWrappers.Parent_GetChildren(P)
		If N Is Pane Then 
			NewP.AddNode(ClonePane(N),N.Left,N.Top,N.PrefWidth,N.PrefHeight)
		Else
			If N Is Label Then
				Dim L As Label = N
				Dim NewL As Label
				NewL.Initialize("")
				NewL.Font = L.font
				NewL.Tag = L.Tag
				NewL.Style = L.Style
				NewL.StyleClasses.AddAll(L.StyleClasses)
				NewL.Alignment = L.Alignment
				NewL.TextColor = L.TextColor
				NewL.TextSize = L.TextSize
				NewL.WrapText = L.WrapText
				NewL.Text = L.Text
				NewL.Tag = L.Tag
				NewP.AddNode(NewL,L.Left,L.Top,L.PrefWidth,L.PrefHeight)
			Else
				If N Is ImageView Then
					Dim IV As ImageView = N
					Dim NewIV As ImageView
					NewIV.Initialize("")
					NewIV.PreserveRatio = IV.PreserveRatio
					NewIV.SetImage(IV.GetImage)
					NewIV.Alpha = IV.Alpha
					NewIV.Style = IV.Style
					NewIV.StyleClasses.AddAll(IV.StyleClasses)
					NewP.AddNode(NewIV,IV.Left,IV.Top,IV.PrefWidth,IV.PrefHeight)
				End If
			End If
		End If
	Next
	Return NewP
End Sub

Public Sub ClosePage
	PreviewForm.Close
End Sub

'Private Sub CenterDispPane
'	mDisplayPane.Left = (pnPreview.Width - mDisplayPane.Width) / 2
'	mDisplayPane.Top = (pnPreview.Height - mDisplayPane.Height) / 2
'	Log(mDisplayPane.Left & " : " & mDisplayPane.Top)
'End Sub

Private Sub NS_EntryReleased(Val As Double)
	If Val < 1 Then Val = 1
	If Val > mRW.PageCount Then Val = mRW.PageCount
	mRW.PreviewShow(Val - 1)
End Sub

Sub btnDone_Action
	ClosePage
End Sub

Sub btnPrint_Action
	mRW.Print(mScale,mKeepAspect)
	ClosePage
End Sub