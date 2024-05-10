<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	OES_Id				= Request("OES_Id")
		
	OES_EstadoRevisado	= Request("OES_EstadoRevisado")
	OES_EstadoAprobado 	= Request("OES_EstadoAprobado")
	OES_EstadoRechazado = Request("OES_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	if(OES_EstadoRevisado<>"" and not IsNULL(OES_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec [spObjetivoEspecifico_Revisar] " & OES_Id & "," & OES_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(OES_EstadoAprobado<>"" and not IsNULL(OES_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec [spObjetivoEspecifico_Aprobar] " & OES_Id & "," & OES_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(OES_EstadoRechazado<>"" and not IsNULL(OES_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec [spObjetivoEspecifico_Rechazar] " & OES_Id & "," & OES_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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