<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
		
	PAT_Id				= Request("PAT_Id")
	PAT_Tipo			= Request("PAT_Tipo")
	PRY_Id				= Request("PRY_Id")
		
	PAT_EstadoRevisado	= Request("PAT_EstadoRevisado")
	PAT_EstadoAprobado 	= Request("PAT_EstadoAprobado")
	PAT_EstadoRechazado = Request("PAT_EstadoRechazado")
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if

	if(PAT_Tipo="SIN") then		
		spRevisado="spPatrocinio_Revisar"
		spAprobado="spPatrocinio_Aprobar"
		spRechazado="spPatrocinio_Rechazar"
	else
		if(PAT_Tipo="EMP") then
			spRevisado="spPatrocinioEmpresa_Revisar"
			spAprobado="spPatrocinioEmpresa_Aprobar"
			spRechazado="spPatrocinioEmpresa_Rechazar"
		else
			if(PAT_Tipo="CIV") then
				spRevisado="spPatrocinioCiviles_Revisar"
				spAprobado="spPatrocinioCiviles_Aprobar"
				spRechazado="spPatrocinioCiviles_Rechazar"
			else
				if(PAT_Tipo="GOB") then
					spRevisado="spPatrocinioGobierno_Revisar"
					spAprobado="spPatrocinioGobierno_Aprobar"
					spRechazado="spPatrocinioGobierno_Rechazar"
				end if
			end if
		end if
	end if	
	
	if(PAT_EstadoRevisado<>"" and not IsNULL(PAT_EstadoRevisado)) then
		'Cambiando a estado revisado
		sql="exec " & spRevisado & " " & PRY_Id & "," & PAT_Id & "," & PAT_EstadoRevisado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(PAT_EstadoAprobado<>"" and not IsNULL(PAT_EstadoAprobado)) then
		'Cambiando a estado aprobado
		sql="exec " & spAprobado & " " & PRY_Id & "," & PAT_Id & "," & PAT_EstadoAprobado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	if(PAT_EstadoRechazado<>"" and not IsNULL(PAT_EstadoRechazado)) then
		'Cambiando a estado rechazado
		sql="exec " & spRechazado & " " & PRY_Id & "," & PAT_Id & "," & PAT_EstadoRechazado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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