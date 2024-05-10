<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	ENP_Id				= request("ENP_Id")
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
	sql="exec [spEnfoquePedagogico_Consultar] " & PRY_Id & "," & ENP_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		ENP_EstadoRevisado=rs("ENP_EstadoRevisado")		
		ENP_EstadoAprobado=rs("ENP_EstadoAprobado")			
		ENP_EstadoRechazado=rs("ENP_EstadoRechazado")	
				
		if(ENP_EstadoRevisado="" or IsNull(ENP_EstadoRevisado) or ENP_EstadoRevisado=0) then
			ENP_EstadoRevisado=0		
		end if
		if(ENP_EstadoAprobado="" or IsNull(ENP_EstadoAprobado) or ENP_EstadoAprobado=0) then
			ENP_EstadoAprobado=0		
		end if
		if(ENP_EstadoRechazado="" or IsNull(ENP_EstadoRechazado) or ENP_EstadoRechazado=0) then
			ENP_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","ENP_EstadoRevisado":<%=ENP_EstadoRevisado%>,"ENP_EstadoAprobado":<%=ENP_EstadoAprobado%>,"ENP_EstadoRechazado":<%=ENP_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>