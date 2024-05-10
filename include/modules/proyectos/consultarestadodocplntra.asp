<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	TED_Id				= request("TED_Id")
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
	sql="exec [spTematicaDialogo_Consultar] " & TED_Id & "," & PRY_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		TED_EstadoRevisado=rs("TED_EstadoRevisado")		
		TED_EstadoAprobado=rs("TED_EstadoAprobado")			
		TED_EstadoRechazado=rs("TED_EstadoRechazado")	
				
		if(TED_EstadoRevisado="" or IsNull(TED_EstadoRevisado) or TED_EstadoRevisado=0) then
			TED_EstadoRevisado=0		
		end if
		if(TED_EstadoAprobado="" or IsNull(TED_EstadoAprobado) or TED_EstadoAprobado=0) then
			TED_EstadoAprobado=0		
		end if
		if(TED_EstadoRechazado="" or IsNull(TED_EstadoRechazado) or TED_EstadoRechazado=0) then
			TED_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","TED_EstadoRevisado":<%=TED_EstadoRevisado%>,"TED_EstadoAprobado":<%=TED_EstadoAprobado%>,"TED_EstadoRechazado":<%=TED_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>