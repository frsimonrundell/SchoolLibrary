B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=4.2
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Type CallSubDelayedType (Module As Object,SubName As String,Args() As Object, Timer As Timer)
	Dim CSDTMap As Map  
End Sub

'Make a copy of a map
Public Sub MapClone(M1 As Map) As Map
	Dim M2 As Map
	M2.Initialize
	For Each K As Object In M1.Keys
		M2.Put(K,M1.Get(K))
	Next
	Return M2
End Sub

Public Sub ScaleOutput(PL As PageLayout,N As Node) As Node
	Dim ScaleX,ScaleY As Double
	Dim NJO As JavaObject = N
	Dim JO As JavaObject = N
	ScaleX = PL.GetPrintableWidth / JO.RunMethodJO("getBoundsInParent",Null).RunMethod("getWidth",Null)
	ScaleY = PL.GetPrintableHeight / JO.RunMethodJO("getBoundsInParent",Null).RunMethod("getHeight",Null)
	Dim SJO As JavaObject
	SJO.InitializeNewInstance("javafx.scene.transform.Scale",Array(ScaleX,ScaleY))
	NJO.RunMethodJO("getTransforms",Null).RunMethod("add",Array(SJO))
	Return NJO
End Sub

Public Sub ScaleOutputKeepAspect(PL As PageLayout,N As Node) As Node
	Dim ScaleX,ScaleY As Double
	Dim NJO As JavaObject = N
	Dim JO As JavaObject = N
	ScaleX = PL.GetPrintableWidth / JO.RunMethodJO("getBoundsInParent",Null).RunMethod("getWidth",Null)
	ScaleY = PL.GetPrintableHeight / JO.RunMethodJO("getBoundsInParent",Null).RunMethod("getHeight",Null)
	Dim Scale As Double = Max(ScaleX,ScaleY)
	Dim SJO As JavaObject
	SJO.InitializeNewInstance("javafx.scene.transform.Scale",Array(Scale,Scale))
	NJO.RunMethodJO("getTransforms",Null).RunMethod("add",Array(SJO))
	Return NJO
End Sub

Public Sub CallSubTime(Module As Object,SubName As String,Args() As Object, Delay As Long)
	If Not(CSDTMap.IsInitialized) Then CSDTMap.Initialize
	Dim CSDT As CallSubDelayedType
	CSDT.Initialize
	CSDT.Timer.Initialize("CSDT",Delay)
	CSDT.Module = Module
	CSDT.SubName = SubName
	CSDT.Args = Args
	CSDTMap.Put(CSDT.Timer,CSDT)
	CSDT.Timer.Enabled = True
End Sub
Sub CSDT_Tick

	Dim CSDT As CallSubDelayedType = CSDTMap.Get(Sender)
	CSDT.Timer.Enabled = False
	If CSDT.Args = Null Then CSDT.Args = Array As Object()
	CSDTMap.Remove(Sender)
	Select CSDT.Args.Length
		Case 0
			CallSub(CSDT.Module,CSDT.SubName)		
		Case 1
			CallSub2(CSDT.Module,CSDT.SubName,CSDT.Args(0))
		Case 2
			CallSub3(CSDT.Module,CSDT.SubName,CSDT.Args(0),CSDT.Args(1))
		Case Else
			CallSub2(CSDT.Module,CSDT.SubName,CSDT.Args)		
	End Select
	CSDT.Timer = Null
End Sub

Public Sub ThrowIllegalArgumentException(Msg As String)
	'Initialize a new throwable from which to get the stacktrace
	Dim MEJO As JavaObject
	#if b4a
		MEJO.InitializeStatic(Application.PackageName & "." & ClassName) 
	#end if
	#if b4j
		MEJO = Me
	#end if
	MEJO.RunMethod("ThrowIllegalArgumentException",Array(Msg))
End Sub

#if java
public static void ThrowIllegalArgumentException(String msg){
	throw new IllegalArgumentException(msg);
}
#end if