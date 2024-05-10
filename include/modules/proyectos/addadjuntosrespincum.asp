<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, administrativo%>
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
	RIN_Id				= up.form("RIN_Id")
	IPR_Id				= up.form("IPR_Id")
	
		
	'Obteniendo el nombre del archivo a subir
	'fileItems = up.UploadedFiles.Items
	'set fileItem = fileItems(0)
	'set fileItem = fileItems
	'outFileName = fileItem.FileName

	'fileName		  						  = outFileName
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	'Rescatando carpeta del proyecto
	sql="exec spProyectoCarpeta_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if len(RIN_Id)>1 then
			yRIN_Id=""
			for i=0 to len(RIN_Id)
				if(isnumeric(mid(RIN_Id,i,1))) then
					yRIN_Id=yRIN_Id & mid(RIN_Id,i,1)
				end if
			next
		else
			yRIN_Id=cint(RIN_Id)
		end if
		IPR_Id=rs2("IPR_Id")
		if len(IPR_Id)>1 then
			yIPR_Id=""
			for i=0 to len(IPR_Id)
				if(isnumeric(mid(IPR_Id,i,1))) then
					yIPR_Id=yIPR_Id & mid(IPR_Id,i,1)
				end if
			next
		else
			yIPR_Id=cint(IPR_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\incumplimientos\res-" & yIPR_Id & "\"
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
		
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
	{"state": 200, "message": "Subida de archivo correcta","data": null}	