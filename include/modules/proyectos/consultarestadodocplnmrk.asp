<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	VPM_Id				= request("VPM_Id")	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	sql="exec [spVerificadorPlanMarketing_Consultar] " & VPM_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		VPM_EstadoRevisado=rs("VPM_EstadoRevisado")		
		VPM_EstadoAprobado=rs("VPM_EstadoAprobado")			
		VPM_EstadoRechazado=rs("VPM_EstadoRechazado")	
		
		'if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		''	VPR_EstadoSubido="NULL"		
		'end if
		if(VPM_EstadoRevisado="" or IsNull(VPM_EstadoRevisado) or VPM_EstadoRevisado=0) then
			VPM_EstadoRevisado=0		
		end if
		if(VPM_EstadoAprobado="" or IsNull(VPM_EstadoAprobado) or VPM_EstadoAprobado=0) then
			VPM_EstadoAprobado=0		
		end if
		if(VPM_EstadoRechazado="" or IsNull(VPM_EstadoRechazado) or VPM_EstadoRechazado=0) then
			VPM_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","VPM_EstadoRevisado":<%=VPM_EstadoRevisado%>,"VPM_EstadoAprobado":<%=VPM_EstadoAprobado%>,"VPM_EstadoRechazado":<%=VPM_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>