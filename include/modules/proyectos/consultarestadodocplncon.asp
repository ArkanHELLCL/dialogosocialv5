<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PCO_Id				= request("PCO_Id")
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
	sql="exec [spPlanContingencia_Consultar] " & PRY_Id & "," & PCO_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		PCO_EstadoRevisado=rs("PCO_EstadoRevisado")		
		PCO_EstadoAprobado=rs("PCO_EstadoAprobado")			
		PCO_EstadoRechazado=rs("PCO_EstadoRechazado")	
				
		if(PCO_EstadoRevisado="" or IsNull(PCO_EstadoRevisado) or PCO_EstadoRevisado=0) then
			PCO_EstadoRevisado=0		
		end if
		if(PCO_EstadoAprobado="" or IsNull(PCO_EstadoAprobado) or PCO_EstadoAprobado=0) then
			PCO_EstadoAprobado=0		
		end if
		if(PCO_EstadoRechazado="" or IsNull(PCO_EstadoRechazado) or PCO_EstadoRechazado=0) then
			PCO_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","PCO_EstadoRevisado":<%=PCO_EstadoRevisado%>,"PCO_EstadoAprobado":<%=PCO_EstadoAprobado%>,"PCO_EstadoRechazado":<%=PCO_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>