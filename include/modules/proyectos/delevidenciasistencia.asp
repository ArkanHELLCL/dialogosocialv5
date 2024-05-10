<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	PLN_Sesion			= request("PLN_Sesion")		
	PRY_Hito			= 95
	TDO_Id				= 1007			
		
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
		if len(PLN_Sesion)>1 then
			yPLN_Sesion=""
			for i=0 to len(PLN_Sesion)
				if(isnumeric(mid(PLN_Sesion,i,1))) then
					yPLN_Sesion=yPLN_Sesion & mid(PLN_Sesion,i,1)
				end if
			next
		else
			yPLN_Sesion=cint(PLN_Sesion)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\evidencias\s-" & yPLN_Sesion & "\"
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
		
	sql="exec spEvidenciaAsistencia_Consultar " & PRY_Id & ",'" & PRY_Identificador & "',95," & PLN_Sesion
	on error resume next
	set rs = cnn.Execute(sql)
	' response.Write(sql)
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	Else
		if not rs.eof then
			EVI_Nombre=rs("EVI_Nombre")
			EVI_Extension=rs("EVI_Extension")
		else
			response.Write("2||" & ErrMsg & " string= " & sql)
			cnn.close 		
			response.End()
		end if
		rs.close
		set rs=nothing
	end if	
	
	set FSO = server.createObject("Scripting.FileSystemObject") 	
	Set carpeta = FSO.GetFolder(path) 	
	Set archivos = carpeta.Files
	for each nombre_archivo in archivos
		sFichero = path & nombre_archivo.name	
	  	fso.DeleteFile sFichero,true		
	next	
	
	sql="exec spEvidenciaAsistencia_Eliminar " & PRY_Id & ",'" & PRY_Identificador & "'," & PRY_Hito & ",'" & trim(EVI_Nombre) & trim(EVI_Extension) & "'," & PLN_Sesion
 	on error resume next
	set rs = cnn.Execute(sql)
	' response.Write(sql)
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()					
	End If  
	cnn.close
	set cnn = nothing%>	
	{"state": 200, "message": "Eliminacion de archivo correcta","data": null}	