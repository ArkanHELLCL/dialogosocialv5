<%
	informe=request("informe")
	INF_Path=request("INF_Path")
	INF_Archivo=request("INF_Archivo")	
	
	on error resume next
	set fso = createobject("scripting.filesystemobject")
	'if (Not fso.FolderExists(INF_Path)) then
	
	'	Set fol = fso.CreateFolder(INF_Path)
	'end if
					
	BuildFullPath INF_Path

	Sub BuildFullPath(ByVal FullPath)
		If Not fso.FolderExists(FullPath) Then
			BuildFullPath fso.GetParentFolderName(FullPath)
			fso.CreateFolder FullPath
		End If
	End Sub
	
	
	Set act = fso.CreateTextFile(INF_Path & INF_Archivo & ".htm", true)
	
	
	act.Write informe
	act.Close
%>