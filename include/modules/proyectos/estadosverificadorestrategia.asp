<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	ESC_Id				= Request("ESC_Id")
    PRY_Id              = Request("PRY_Id")
		
	ESC_EstadoRevisado	= Request("ESC_EstadoRevisado")
	ESC_EstadoAprobado 	= Request("ESC_EstadoAprobado")
	ESC_EstadoRechazado = Request("ESC_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	if(ESC_EstadoRevisado<>"" and not IsNULL(ESC_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec [spEstrategiaConvocatoria_Revisar] " & PRY_Id & "," & ESC_Id & "," & ESC_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(ESC_EstadoAprobado<>"" and not IsNULL(ESC_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec [spEstrategiaConvocatoria_Aprobar] " & PRY_Id & "," & ESC_Id & "," & ESC_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(ESC_EstadoRechazado<>"" and not IsNULL(ESC_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec [spEstrategiaConvocatoria_Rechazar] " & PRY_Id & "," & ESC_Id & "," & ESC_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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