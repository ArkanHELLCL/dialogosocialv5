<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	COO_Id				= Request("COO_Id")
	COO_Tipo			= Request("COO_Tipo")
	PRY_Id				= Request("PRY_Id")
		
	COO_EstadoRevisado	= Request("COO_EstadoRevisado")
	COO_EstadoAprobado 	= Request("COO_EstadoAprobado")
	COO_EstadoRechazado = Request("COO_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if

	if(COO_Tipo="TRA") then		
		spRevisado="spCoordinacionTrabajadores_Revisar"
		spAprobado="spCoordinacionTrabajadores_Aprobar"
		spRechazado="spCoordinacionTrabajadores_Rechazar"
	else
		if(COO_Tipo="EMP") then
			spRevisado="spCoordinacionEmpleadores_Revisar"
			spAprobado="spCoordinacionEmpleadores_Aprobar"
			spRechazado="spCoordinacionEmpleadores_Rechazar"
		else			
            if(COO_Tipo="GOB") then
                spRevisado="spCoordinacionGobierno_Revisar"
                spAprobado="spCoordinacionGobierno_Aprobar"
                spRechazado="spCoordinacionGobierno_Rechazar"
            end if			
		end if
	end if	
	
	if(COO_EstadoRevisado<>"" and not IsNULL(COO_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec " & spRevisado & " " & PRY_Id & "," & COO_Id & "," & COO_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(COO_EstadoAprobado<>"" and not IsNULL(COO_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec " & spAprobado & " " & PRY_Id & "," & COO_Id & "," & COO_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(COO_EstadoRechazado<>"" and not IsNULL(COO_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec " & spRechazado & " " & PRY_Id & "," & COO_Id & "," & COO_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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