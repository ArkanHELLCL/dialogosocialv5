<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	CIV_Id			= Request("CIV_Id")
	CIV_Nombre		= LimpiarUrl(Request("CIV_Nombre"))
	CIV_Estado 		= 1
	CIV_Direccion	= LimpiarUrl(Request("CIV_Direccion"))
	CIV_Telefono	= Request("CIV_Telefono")
	CIV_Rol			= Request("CIV_Rol")
	RUB_Id			= Request("RUB_Id")
	
 
	datos = CIV_Id & ",'" & CIV_Nombre & "','" & CIV_Direccion & "'," & CIV_Telefono & ",'" & CIV_Rol & "'," & RUB_Id & "," & CIV_Estado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec spCiviles_Modificar " & datos 
	
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