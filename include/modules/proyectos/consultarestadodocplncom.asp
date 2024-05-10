<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PLC_Id				= request("PLC_Id")
    PRY_Id              = request("PRY_Id")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	sql="exec [spPlanComunicacional_Consultar] " & PRY_Id & "," & PLC_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		PLC_EstadoRevisado=rs("PLC_EstadoRevisado")		
		PLC_EstadoAprobado=rs("PLC_EstadoAprobado")			
		PLC_EstadoRechazado=rs("PLC_EstadoRechazado")	
				
		if(PLC_EstadoRevisado="" or IsNull(PLC_EstadoRevisado) or PLC_EstadoRevisado=0) then
			PLC_EstadoRevisado=0		
		end if
		if(PLC_EstadoAprobado="" or IsNull(PLC_EstadoAprobado) or PLC_EstadoAprobado=0) then
			PLC_EstadoAprobado=0		
		end if
		if(PLC_EstadoRechazado="" or IsNull(PLC_EstadoRechazado) or PLC_EstadoRechazado=0) then
			PLC_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","PLC_EstadoRevisado":<%=PLC_EstadoRevisado%>,"PLC_EstadoAprobado":<%=PLC_EstadoAprobado%>,"PLC_EstadoRechazado":<%=PLC_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>