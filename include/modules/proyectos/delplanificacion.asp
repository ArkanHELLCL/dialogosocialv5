<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")
	PLN_Sesion			= request("PLN_Sesion")		
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	sqx="exec spProyecto_Consultar " & PRY_Id
	set rx = cnn.Execute(sqx)
	if not rx.eof then
		PRY_Nombre				= rx("PRY_Nombre")
		PRY_InformeInicioEstado	= rx("PRY_InformeInicioEstado")
		PRY_Estado				= rx("PRY_Estado")
	end if
	if (PRY_InformeInicioEstado<>0 or PRY_Estado<>1) then%>
		{"state": 1, "message": "Error estado del proyecto no válido","data": "<%=PRY_Estado%>"}<%
		response.end()
	end if	
					
	datos =  PLN_Sesion & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	sql="exec spPlanificacion_Eliminar " & datos 
	
	set rs = cnn.Execute(sql)	
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=datos%>"}<%
		response.End()
	end if
	if not rs.eof then
		if rs("Result")=1 then%>
			{"state": 2, "message": "Eliminación imposible. Planificación tiene asistencia","data": null}<%
			response.End()
		else%>
			{"state": 200, "message": "Eliminación de planificación correcta","data": null}<%
			response.End()
		end if	
	end if%>	
	{"state": 200, "message": "Eliminación de planificación correcta","data": null}