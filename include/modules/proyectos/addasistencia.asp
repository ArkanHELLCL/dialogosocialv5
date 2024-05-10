<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id          			    = Request("PRY_Id")
	PRY_Identificador		    	= Request("PRY_Identificador")
	ALU_Rut      			    	= Request("ALU_Rut")
	Asistio     			  		= Request("Asistio")
	PLN_Sesion     					= Request("PLN_Sesion")

	datos = PRY_Id & ",'" & PRY_Identificador & "'," & ALU_Rut & "," & Asistio & "," & PLN_Sesion & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 	
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	sql="exec spAsistencia_Modificar " & datos 
	set rs = cnn.Execute(sql)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	if not rs.eof then
		if rs("Result")<>0 then
		   cnn.close%>
		   {"state": <%=rs("Result")%>, "message": "Error ","data": null}<%
		   response.End() 
		end if
	else%>
		{"state": 9, "message": "Error ","data": null}<%		
		rs.close
		cnn.close
		response.End()
	end if%>	
	{"state": 200, "message": "Grabación de asistencia correcta","data": null}	