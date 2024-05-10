<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id          			    = Request("PRY_Id")
	PRY_Identificador		    	= Request("PRY_Identificador")	

	datos =  ALU_Rut & "," & PRY_Id  & ",'" & PRY_Identificador & "'," & Nota & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	sql="exec spProyecto_Consultar " & PRY_Id
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
		PRY_NotaActual = rs("PRY_NotaActual")		'Nota en la que va el proyecto		
		if (IsNull(rs("PRY_NotaActual")) or rs("PRY_NotaActual")="") then
			PRY_NotaActual=0
		end if
		PRY_NotaActual = PRY_NotaActual + 1	'Nueva posicion
		sql="exec spProyectoNotaActual_Modificar " & PRY_Id & ",'" & PRY_Identificador & "'," & PRY_NotaActual & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		
		set rs = cnn.Execute(sql)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rs.close
			cnn.close
			response.end()
		End If
	else%>
		{"state": 1, "message": "Error : Consulta en tabla proyecto","data": null}<%	
	end if%>	
	{"state": 200, "message": "Grabación de asistencia correcta","data": null}	