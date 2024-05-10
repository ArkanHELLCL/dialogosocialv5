<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
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
	PRY_Hito			= up.form("PRY_Hito")
	VER_Corr			= up.form("VER_Corr")		
		
	'Obteniendo el nombre del archivo a subir
	fileItems = up.UploadedFiles.Items
	set fileItem = fileItems(0)
	outFileName = fileItem.FileName

	fileName		  						  = outFileName
		
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
	sql="exec spProyecto_Consultar " & PRY_Id
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
		LFO_Id=rs("LFO_Id")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		PRY_Identificador=rs("PRY_Identificador")
		if len(VER_Corr)>1 then
			yVER_Corr=""
			for i=0 to len(VER_Corr)
				if(isnumeric(mid(VER_Corr,i,1))) then
					yVER_Corr=yVER_Corr & mid(VER_Corr,i,1)
				end if
			next
		else
			yVER_Corr=cint(VER_Corr)
		end if		
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
	
	VPR_Descripcion=""
	sql="exec [spVerificadorProyecto_Agregar] " & VER_Corr & "," & PRY_Id & ",'" & PRY_Identificador & "','" & VPR_Descripcion & "'," & PRY_Hito & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	carpeta_informe="no_definido"
	if LFO_Id=10 then
		if PRY_Hito=0 then
			carpeta_informe="informecreacion"
		else
			if PRY_Hito=1 then
				carpeta_informe="informeinicio"
			else
				if PRY_Hito=2 then
					carpeta_informe="informeparcial"
				else
					'if PRY_Hito=3 then
					'	carpeta_informe="informedesarrollo"
					'else
						'if PRY_Hito=4 then
						if PRY_Hito=3 then
							carpeta_informe="informefinal"
						else
							carpeta_informe="no_definido"
						end if
					'end if
				end if
			end if
		end if
	else
		if LFO_Id=11 then
			if PRY_Hito=0 then
				carpeta_informe="informecreacion"
			else
				if PRY_Hito=1 then
					carpeta_informe="informeinicial"
				else
					if PRY_Hito=2 then
						carpeta_informe="informeavances"
					else
						if PRY_Hito=3 then
							carpeta_informe="informefinal"
						else
							if PRY_Hito=999 then
								carpeta_informe="verificadoresmesas"
							else
								carpeta_informe="no_definido"
							end if
						end if
					end if
				end if
			end if
		else
			if LFO_Id=12 then
				if PRY_Hito=0 then
					carpeta_informe="informecreacion"
				else
					if PRY_Hito=1 then
						carpeta_informe="informeinicio"
					else			
						if PRY_Hito=2 then
							carpeta_informe="informefinal"
						else						
							carpeta_informe="no_definido"
						end if 
					end if
				end if
			else
				if LFO_Id=13 then
					if PRY_Hito=0 then
						carpeta_informe="informecreacion"
					else
						if PRY_Hito=1 then
							carpeta_informe="informeinicial"
						else
							if PRY_Hito=2 then
								carpeta_informe="informeavances"
							else
								if PRY_Hito=3 then
									carpeta_informe="informefinal"
								else
									if PRY_Hito=999 then
										carpeta_informe="verificadorerecuperacion"
									else
										carpeta_informe="no_definido"
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end if
	
	path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\" & carpeta_informe & "\documentos\tpo-" & yVER_Corr
		
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
	up.Save(ruta)	'Subiendo archivo%>	
	{"state": 200, "message": "Subida de archivo correcta","data": null}	