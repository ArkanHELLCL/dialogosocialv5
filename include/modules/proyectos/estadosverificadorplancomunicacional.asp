<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	PLC_Id				= Request("PLC_Id")
    PRY_Id              = Request("PRY_Id")
		
	PLC_EstadoRevisado	= Request("PLC_EstadoRevisado")
	PLC_EstadoAprobado 	= Request("PLC_EstadoAprobado")
	PLC_EstadoRechazado = Request("PLC_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	if(PLC_EstadoRevisado<>"" and not IsNULL(PLC_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec [spPlanComunicacional_Revisar] " & PRY_Id & "," & PLC_Id & "," & PLC_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rs = cnn.Execute(sql)
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rs.close
			cnn.close
			response.end()
		End If	
	end if
	if(PLC_EstadoAprobado<>"" and not IsNULL(PLC_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec [spPlanComunicacional_Aprobar] " & PRY_Id & "," & PLC_Id & "," & PLC_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rs = cnn.Execute(sql)
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rs.close
			cnn.close
			response.end()
		End If	
	end if
	if(PLC_EstadoRechazado<>"" and not IsNULL(PLC_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec [spPlanComunicacional_Rechazar] " & PRY_Id & "," & PLC_Id & "," & PLC_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rs = cnn.Execute(sql)
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rs.close
			cnn.close
			response.end()
		End If	
	end if%>	
	{"state": 200, "message": "Cambio de estado correcto","data": null}	