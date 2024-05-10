<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	EME_Id				= Request("EME_Id")
	EME_Nombre			= LimpiarUrl(Request("EME_Nombre"))	
	EME_Rol				= LimpiarUrl(Request("EME_ROL"))
	EME_Nombre			= LimpiarUrl(Request("EME_Nombre"))
	EME_Direccion		= LimpiarUrl(Request("EME_Direccion"))
	COM_Id				= Request("COM_Id")
	EME_Telefono		= Request("EME_Telefono")
	EME_NombreContacto	= LimpiarUrl(Request("EME_NombreContacto"))
	EME_CargoContacto	= LimpiarUrl(Request("EME_CargoContacto"))
	EME_Mail			= Request("EME_Mail")
	EME_PaginaWeb		= Request("EME_PaginaWeb")
	EME_Estado 			= 1 
	TEJ_Id				= Request("TEJ_Id")
 
	datos = EME_Id & ",'" & EME_Rol & "','" & EME_Nombre & "','" & EME_Direccion & "'," & COM_Id & ",'" & EME_Telefono & "','" & EME_NombreContacto & "','" & EME_CargoContacto & "','" & EME_Mail & "','" & EME_PaginaWeb & "'," & EME_Estado & "," & TEJ_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec [spEmpresaEjecutora_Modificar] " & datos 
	
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