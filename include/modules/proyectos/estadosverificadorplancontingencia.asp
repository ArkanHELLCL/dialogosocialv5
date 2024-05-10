<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	PCO_Id				= Request("PCO_Id")
    PRY_Id              = Request("PRY_Id")
		
	PCO_EstadoRevisado	= Request("PCO_EstadoRevisado")
	PCO_EstadoAprobado 	= Request("PCO_EstadoAprobado")
	PCO_EstadoRechazado = Request("PCO_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	if(PCO_EstadoRevisado<>"" and not IsNULL(PCO_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec [spPlanContingencia_Revisar] " & PRY_Id & "," & PCO_Id & "," & PCO_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(PCO_EstadoAprobado<>"" and not IsNULL(PCO_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec [spPlanContingencia_Aprobar] " & PRY_Id & "," & PCO_Id & "," & PCO_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(PCO_EstadoRechazado<>"" and not IsNULL(PCO_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec [spPlanContingencia_Rechazar] " & PRY_Id & "," & PCO_Id & "," & PCO_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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