<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	ESC_Id				= request("ESC_Id")
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
	sql="exec [spEstrategiaConvocatoria_Consultar] " & PRY_Id & "," & ESC_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		ESC_EstadoRevisado=rs("ESC_EstadoRevisado")		
		ESC_EstadoAprobado=rs("ESC_EstadoAprobado")			
		ESC_EstadoRechazado=rs("ESC_EstadoRechazado")	
				
		if(ESC_EstadoRevisado="" or IsNull(ESC_EstadoRevisado) or ESC_EstadoRevisado=0) then
			ESC_EstadoRevisado=0		
		end if
		if(ESC_EstadoAprobado="" or IsNull(ESC_EstadoAprobado) or ESC_EstadoAprobado=0) then
			ESC_EstadoAprobado=0		
		end if
		if(ESC_EstadoRechazado="" or IsNull(ESC_EstadoRechazado) or ESC_EstadoRechazado=0) then
			ESC_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","ESC_EstadoRevisado":<%=ESC_EstadoRevisado%>,"ESC_EstadoAprobado":<%=ESC_EstadoAprobado%>,"ESC_EstadoRechazado":<%=ESC_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>