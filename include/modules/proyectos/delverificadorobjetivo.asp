<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if	
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	OES_Id				= request("OES_Id")		
			
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
		if len(OES_Id)>1 then
			yOES_Id=""
			for i=0 to len(OES_Id)
				if(isnumeric(mid(OES_Id,i,1))) then
					yOES_Id=yOES_Id & mid(OES_Id,i,1)
				end if
			next
		else
			yOES_Id=cint(OES_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\verificadoresproyecto\p-" & yOES_Id
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
	
	'Cambiando a estado eliminado
	sql="exec spObjetivoEspecifico_Borrar " & OES_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f
	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	fs.DeleteFolder path

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe
	'response.end()%>	
	{"state": 200, "message": "Eliminación de carpeta correcta","data": null}	