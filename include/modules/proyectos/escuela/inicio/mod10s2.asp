<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if
	
	Set up = New FreeASPUpload
	up.Upload()			
	
	Response.Flush
	
	PRY_Id							= up.form("PRY_Id")
	PRY_Identificador				= up.form("PRY_Identificador")
	
	PRY_Responsable1			 	= LimpiarUrl(up.form("PRY_Responsable1"))
	PRY_Responsable1Mail		 	= up.form("PRY_Responsable1Mail")
	PRY_Responsable1Celular	 		= up.form("PRY_Responsable1Celular")
	SEX_IdResponsable1			 	= up.form("SEX_IdResponsable1")

	PRY_Responsable2				= LimpiarUrl(up.form("PRY_Responsable2"))
	PRY_Responsable2Mail			= up.form("PRY_Responsable2Mail")
	PRY_Responsable2Celular			= up.form("PRY_Responsable2Celular")
	SEX_IdResponsable2				= up.form("SEX_IdResponsable2")
	RES1_AdjuntoX					= up.form("RES1_AdjuntoX")
	RES2_AdjuntoX					= up.form("RES2_AdjuntoX")
	
	RES1_AdjuntoY 	  				= CInt(up.form("RES1_Adjunto"))
	RES2_AdjuntoY 					= CInt(up.form("RES2_Adjunto"))


	Step							 = CInt(up.form("Step"))
	
	if(EDU_IdResponsable1="") then
		EDU_IdResponsable1 = "NULL"
	end if

	if(EDU_IdResponsable2="") then
		EDU_IdResponsable2 = "NULL"
	end if
	
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
		
		pathRES2="D:\DocumentosSistema\dialogosocial\" & carpeta & "\curriculums\responsable2\"
		pathRES1="D:\DocumentosSistema\dialogosocial\" & carpeta & "\curriculums\responsable1\"
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

	folders = Split(pathRES2, "\")
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
	
	folders = Split(pathRES1, "\")
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
		if(RES1_AdjuntoY=1) and (RES2_AdjuntoY=1)  then			
			set RES1_Adjunto = fileItems(0)
			RES1_Adjunto.Path = pathRES1
			RES1_AdjuntoX = RES1_Adjunto.FileName
						
			set RES2_Adjunto = fileItems(1)
			RES2_Adjunto.Path = pathRES2
			RES2_AdjuntoX = RES2_Adjunto.FileName			
		end if
		
		if(RES1_AdjuntoY=1) and (RES2_AdjuntoY=0)  then
			set RES1_Adjunto = fileItems(0)
			RES1_Adjunto.Path = pathRES1
			RES1_AdjuntoX = RES1_Adjunto.FileName
		end if				
		if(RES1_AdjuntoY=0) and (RES2_AdjuntoY=1)  then
			set RES2_Adjunto = fileItems(0)
			RES2_Adjunto.Path = pathRES2
			RES2_AdjuntoX = RES2_Adjunto.FileName		
		end if						
		'outFileName = fileItem.FileName	
	end if		
	up.SaveFile()
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_Responsable1 & "','" & PRY_Responsable1Mail & "','" & PRY_Responsable1Celular & "','" & SEX_IdResponsable1 & "','" & PRY_Responsable2 & "','" & PRY_Responsable2Mail & "','" & PRY_Responsable2Celular & "','" & SEX_IdResponsable2 & "'," & PRY_Step & ",'" & RES1_AdjuntoX & "','" & RES2_AdjuntoX & "'," & EDU_IdResponsable1 & ",'" & PRY_Responsable1Carrera & "'," & EDU_IdResponsable2 & ",'" & PRY_Responsable2Carrera & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	sql="exec spProyecto_ResponsablesRendicionModificar " & datos 	
	
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