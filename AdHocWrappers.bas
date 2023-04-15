B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=4.2
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub

'Parent Subs

Public Sub Parent_GetChildren(Parent As JavaObject) As List
	Return Parent.RunMethod("getChildrenUnmodifiable",Null)
End Sub

Public Sub Parent_GetChildAt(Parent As JavaObject,Index As Int) As JavaObject
	Dim L As List = Parent_GetChildren(Parent)
	Return L.Get(Index)
End Sub
