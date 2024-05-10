<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	rut       		     = Request("SIN_rut")
	SIN_Nombre           = LimpiarUrl(Request("SIN_Nombre"))
	SIN_direccion        = LimpiarUrl(Request("SIN_direccion"))
	SIN_telefono         = Request("SIN_telefono")
	SIN_Mail     	     = Request("SIN_Mail")
	ACE_Id        	     = Request("ACE_Id")
	RUB_Id               = request("RUB_Id")
	SIN_DirPaginaWeb     = request("SIN_DirPaginaWeb")
	SIN_NombrePresidente = ""'request("SIN_NombrePresidente")
	SIN_NumAsociados     = 0'request("SIN_NumAsociados")
	SIN_NumMujeres       = 0'request("SIN_NumMujeres")
	SIN_NumHombres       = 0'request("SIN_NumHombres")
	TOR_Id               = request("TOR_Id")

	SIN_rut      	= rut'mid(rut,1,len(rut)-1)
	SIN_dv		   	= ""'mid(rut,len(rut),1)


	datos =   "'" & SIN_Nombre & "'," & ACE_Id & "," & RUB_Id & "," & SIN_rut & ",'" & SIN_dv & "','" & SIN_direccion & "','" & SIN_telefono & "','" & SIN_Mail & "','" & SIN_DirPaginaWeb & "','" & SIN_NombrePresidente & "'," & SIN_NumAsociados & "," & SIN_NumMujeres & "," & SIN_NumHombres & "," & TOR_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	sql="exec spSindicato_Agregar " & datos 
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=data%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	cnn.close
	set cnn = nothing%>
	{"state": 200, "message": "Ejecución exitosa","data": null}