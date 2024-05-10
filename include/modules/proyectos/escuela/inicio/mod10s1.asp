<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if
	
	'Dim ruta
	'Dim streamFile, fileItem, filePath, up
	'Dim sFileName
	
	Set up = New FreeASPUpload
	up.Upload()			
	
	Response.Flush
	
	PRY_Id							 = up.form("PRY_Id")
	PRY_Identificador				 = up.form("PRY_Identificador")
	
	PRY_EncargadoProyecto			 = LimpiarUrl(up.form("PRY_EncargadoProyecto"))
	PRY_EncargadoProyectoMail		 = up.form("PRY_EncargadoProyectoMail")
	PRY_EncargadoProyectoCelular	 = up.form("PRY_EncargadoProyectoCelular")
	SEX_IdEncargadoProyecto			 = up.form("SEX_IdEncargadoProyecto")

	PRY_EncargadoActividades		 = LimpiarUrl(up.form("PRY_EncargadoActividades"))
	PRY_EncargadoActividadesMail	 = up.form("PRY_EncargadoActividadesMail")
	PRY_EncargadoActividadesCelular	 = up.form("PRY_EncargadoActividadesCelular")
	SEX_IdEncargadoActividades		 = up.form("SEX_IdEncargadoActividades")
	ENC_AdjuntoX					 = up.form("ENC_AdjuntoX")
	COR_AdjuntoX					 = up.form("COR_AdjuntoX")
	
	ENC_AdjuntoY 	  				 = CInt(up.form("ENC_Adjunto"))
	COR_AdjuntoY 					 = CInt(up.form("COR_Adjunto"))
	Step							 = CInt(up.form("Step"))
	
	EDU_IdEncargadoProyecto			 = "Null"
	PRY_EncargadoProyectoCarrera	 = "Null"

	EDU_IdEncargadoActividades		 = "Null"
	PRY_EncargadoActividadesCarrera	 = "Null"

	PRY_Facilitador					 = "Null"
	PRY_FacilitadorMail				 = "Null"
	PRY_FacilitadorCelular			 = "Null"
	SEX_IdFacilitador				 = "Null"
	PRY_FacilitadorCarrera			 = "Null"
	EDU_IdFacilitador				 = "Null"
	PRY_FacilitidorForEsp			 = "Null"
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
	
	xsql = "exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(xsql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión 2:" & ErrMsg & "-" & xsql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step=rs("PRY_Step")
		LFO_Id = rs("LFO_Id")
				
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		LIN_AgregaTematica=rs("LIN_AgregaTematica")
		
		pathENC="D:\DocumentosSistema\dialogosocial\" & carpeta & "\curriculums\encargado\"
		pathCOR="D:\DocumentosSistema\dialogosocial\" & carpeta & "\curriculums\coordinador\"
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_InformeInicioEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if		
		
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f

	folders = Split(pathENC, "\")
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
	
	folders = Split(pathCOR, "\")
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

	fileItems = up.UploadedFiles.Items
	if(ubound(fileItems)>=0) then
		if(COR_AdjuntoY=1) and (ENC_AdjuntoY=1)  then			
			set COR_Adjunto = fileItems(0)
			COR_Adjunto.Path = pathCOR
			COR_AdjuntoX = COR_Adjunto.FileName
						
			set ENC_Adjunto = fileItems(1)
			ENC_Adjunto.Path = pathENC
			ENC_AdjuntoX = ENC_Adjunto.FileName			
		end if
		
		if(COR_AdjuntoY=1) and (ENC_AdjuntoY=0)  then
			set COR_Adjunto = fileItems(0)
			COR_Adjunto.Path = pathCOR
			COR_AdjuntoX = COR_Adjunto.FileName
		end if				
		if(COR_AdjuntoY=0) and (ENC_AdjuntoY=1)  then
			set ENC_Adjunto = fileItems(0)
			ENC_Adjunto.Path = pathENC
			ENC_AdjuntoX = ENC_Adjunto.FileName		
		end if						
		'outFileName = fileItem.FileName	
	end if		
	up.SaveFile()
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_EncargadoProyecto & "','" & PRY_EncargadoProyectoMail & "','" & PRY_EncargadoProyectoCelular & "','" & SEX_IdEncargadoProyecto & "','" & PRY_EncargadoActividades & "','" & PRY_EncargadoActividadesMail & "','" & PRY_EncargadoActividadesCelular & "','" & SEX_IdEncargadoActividades & "'," & PRY_Step & ",'" & ENC_AdjuntoX & "','" & COR_AdjuntoX & "'," & EDU_IdEncargadoProyecto & ",'" & PRY_EncargadoProyectoCarrera & "'," & EDU_IdEncargadoActividades & ",'" & PRY_EncargadoActividadesCarrera & "','" & PRY_Facilitador & "','" & PRY_FacilitadorMail & "','" & PRY_FacilitadorCelular & "'," & SEX_IdFacilitador & ",'" & PRY_FacilitadorCarrera & "'," & EDU_IdFacilitador & "," & PRY_FacilitidorForEsp & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	sql="exec spProyecto_ResponsablesProyectoModificar " & datos 	
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	if not rs.eof then		
		response.write("200\\" & texto)		
	end if			
	
%>