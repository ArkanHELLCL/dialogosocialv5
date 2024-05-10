<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then%>
		{"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	EME_Id=request("EME_Id")	
		
	sql="exec [spEmpresaEjecutora_Consultar] " & EME_Id

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	    response.End()
	End If%>
	{"state": 200, "message": "Listado extraido correctamente","data": "ok", "EME_Rol" : "<%=rs("EME_Rol")%>"}<%
	rs.close
%>
	
