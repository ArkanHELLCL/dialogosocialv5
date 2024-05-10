<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	GOB_Id                 = request("GOB_Id")  
	GOB_Rut      		   = Request("GOB_Rut")
	GOB_NombreInstitucion  = LimpiarUrl(Request("GOB_NombreInstitucion"))
	GOB_DirPaginaWeb       = Request("GOB_DirPaginaWeb")
	GOB_Estado             = 1

 
 
	datos = GOB_Id & ",'" & GOB_NombreInstitucion & "','" & GOB_Rut & "','" & GOB_DirPaginaWeb & "'," & GOB_Estado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"


	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec spGobierno_Modificar " & datos 
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If					
	
	cnn.close
	set cnn = nothing%>
	{"state": 200, "message": "Ejecución exitosa","data": null}