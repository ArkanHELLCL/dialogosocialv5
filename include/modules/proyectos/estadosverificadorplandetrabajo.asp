<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	TED_Id				= Request("TED_Id")
    PRY_Id              = Request("PRY_Id")
		
	TED_EstadoRevisado	= Request("TED_EstadoRevisado")
	TED_EstadoAprobado 	= Request("TED_EstadoAprobado")
	TED_EstadoRechazado = Request("TED_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	if(TED_EstadoRevisado<>"" and not IsNULL(TED_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec [spTematicaDialogo_Revisar] " & PRY_Id & "," & TED_Id & "," & TED_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(TED_EstadoAprobado<>"" and not IsNULL(TED_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec [spTematicaDialogo_Aprobar] " & PRY_Id & "," & TED_Id & "," & TED_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(TED_EstadoRechazado<>"" and not IsNULL(TED_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec [spTematicaDialogo_Rechazar] " & PRY_Id & "," & TED_Id & "," & TED_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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