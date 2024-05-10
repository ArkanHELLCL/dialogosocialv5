<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	ENP_Id				= Request("ENP_Id")
    PRY_Id              = Request("PRY_Id")
		
	ENP_EstadoRevisado	= Request("ENP_EstadoRevisado")
	ENP_EstadoAprobado 	= Request("ENP_EstadoAprobado")
	ENP_EstadoRechazado = Request("ENP_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	if(ENP_EstadoRevisado<>"" and not IsNULL(ENP_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec [spEnfoquesPedagogicos_Revisar] " & PRY_Id & "," & ENP_Id & "," & ENP_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(ENP_EstadoAprobado<>"" and not IsNULL(ENP_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec [spEnfoquesPedagogicas_Aprobar] " & PRY_Id & "," & ENP_Id & "," & ENP_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(ENP_EstadoRechazado<>"" and not IsNULL(ENP_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec [spEnfoquesPedagogicos_Rechazar] " & PRY_Id & "," & ENP_Id & "," & ENP_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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