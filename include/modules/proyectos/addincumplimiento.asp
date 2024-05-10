<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Ejecutor, Auditor, Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
	
	Dim ruta
	Dim streamFile, fileItem, filePath, up
	Dim sFileName

	Set up = New FreeASPUpload
	up.Upload()

	Response.Flush	
	
	PRY_Id				= up.form("PRY_Id")	
	PRY_Identificador	= up.form("PRY_Identificador")
	
	INC_Id				= up.form("INC_Id")				
	IPR_MontoAplicado	= up.form("IPR_MontoAplicado")
	IPR_HechosFundantes	= up.form("IPR_HechosFundantes")	
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
		
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		response.End() 	
	End If
	if not rs.eof then
		LFO_Id=rs("LFO_Id")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		LIN_AgregaTematica=rs("LIN_AgregaTematica")				
	end if
							
							
	datos = PRY_Id & "," & INC_Id & ",'" & IPR_MontoAplicado & "','" & IPR_HechosFundantes & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	sqz = "exec [spIncumplimientosProyecto_Agregar] " & datos
	set rz = cnn.Execute(sqz)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
		rz.close
		cnn.close
		response.end()
	End If	
	if not rz.eof then
		IPR_Id = trim(rz("IPR_Id"))
	end if
	
	path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\incumplimientos\inc-" & IPR_Id & "\"
		
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f

	folders = Split(path, "\")
	currentFolder = ""
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	For i = 0 To UBound(folders)
		currentFolder = currentFolder & folders(i)
		'response.write("</br>" & currentFolder & "</br>")
		If fs.FolderExists(currentFolder) <> true Then
			Set f=fs.CreateFolder(currentFolder)
			Set f=nothing       
		End If      
		currentFolder = currentFolder & "\"
	Next

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe
	'response.end()	

	ruta=path		
	up.Save(ruta)	'Subiendo archivo	
	
	%>	
	{"state": 200, "message": "Grabación de incumplimiento correcta","data": "<%=IPR_Id%>"}