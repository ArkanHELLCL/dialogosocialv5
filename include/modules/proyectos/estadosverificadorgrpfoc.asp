<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	GRP_Id				= Request("GRP_Id")
	GRP_Tipo			= Request("GRP_Tipo")
	PRY_Id				= Request("PRY_Id")
		
	GRP_EstadoRevisado	= Request("GRP_EstadoRevisado")
	GRP_EstadoAprobado 	= Request("GRP_EstadoAprobado")
	GRP_EstadoRechazado = Request("GRP_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if

	if(GRP_Tipo="SIN") then		
		spRevisado="spPrioridadSindicato_Revisar"
		spAprobado="spPrioridadSindicato_Aprobar"
		spRechazado="spPrioridadSindicato_Rechazar"
	else
		if(GRP_Tipo="EMP") then
			spRevisado="spPrioridadEmpresa_Revisar"
			spAprobado="spPrioridadEmpresa_Aprobar"
			spRechazado="spPrioridadEmpresa_Rechazar"
		else			
            if(GRP_Tipo="GOB") then
                spRevisado="spPrioridadGobierno_Revisar"
                spAprobado="spPrioridadGobierno_Aprobar"
                spRechazado="spPrioridadGobierno_Rechazar"
            end if			
		end if
	end if	
	
	if(GRP_EstadoRevisado<>"" and not IsNULL(GRP_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec " & spRevisado & " " & PRY_Id & "," & GRP_Id & "," & GRP_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(GRP_EstadoAprobado<>"" and not IsNULL(GRP_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec " & spAprobado & " " & PRY_Id & "," & GRP_Id & "," & GRP_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(GRP_EstadoRechazado<>"" and not IsNULL(GRP_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec " & spRechazado & " " & PRY_Id & "," & GRP_Id & "," & GRP_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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