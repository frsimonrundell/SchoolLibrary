B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
'Custom View class
#DesignerProperty: Key: TotalId, DisplayName: Total For Id, DefaultValue: ,FieldType: String, Description: Id of total for this column
#DesignerProperty: Key: FormatStr, DisplayName: Format String, DefaultValue: ,FieldType: String, Description: Format string for this total MinInt.MinFrac.MaxFrac
#DesignerProperty: Key: StyleClass, DisplayName: StyleClass, DefaultValue: rw-staticfield,FieldType: String, Description: Styleclasses for this field enclose multiple styleclasses in [] as a comma seperated list 

Sub Class_Globals
	Private fx As JFX
	Private EventName As String 'ignore
	Private CallBack As Object 'ignore
	Private mLbl As Label
End Sub

Public Sub Initialize (vCallback As Object, vEventName As String)
	EventName = vEventName
	CallBack = vCallback
End Sub

Public Sub DesignerCreateView (Base As Pane, Lbl As Label, Props As Map)
	mLbl = Lbl
	Dim Parent As Pane = Base.Parent
	Parent.AddNode(Lbl,Base.Left,Base.Top,Base.PrefWidth,Base.PrefHeight)
	Base.RemoveNodeFromParent
	Dim Tag As TotalTag
	Tag.TotalId = Props.GetDefault("TotalId","")
	Tag.TotalFormat = Props.GetDefault("FormatStr","")
	Lbl.Tag = Tag
	Dim SC As String = Props.GetDefault("StyleClass","")
	If SC <> "" Then 
		If SC.StartsWith("[") Then
			SC =SC.Replace("[","").Replace("]","")
			For Each SSC As String In Regex.Split(",",SC)
				If SSC <> "" Then Lbl.StyleClasses.Add(SSC)
			Next
		Else
			Lbl.StyleClasses.Add(SC)
		End If
	End If
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	
End Sub

Public Sub GetLbl As Label
	Return mLbl
End Sub
