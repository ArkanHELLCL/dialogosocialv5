<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	EMP_Id              = request("EMP_Id")  
	EMP_Rol      		= Request("EMP_Rol")
	EMP_Nombre          = LimpiarUrl(Request("EMP_Nombre"))
	EMP_Direccion       = LimpiarUrl(Request("EMP_Direccion"))
	EMP_telefono        = Request("EMP_telefono")
	EMP_NumTrabajadores = Request("EMP_NumTrabajadores")
	EMP_NumMujeres      = Request("EMP_NumMujeres")
	EMP_NumHombres      = Request("EMP_NumHombres")
	RUB_Id              = request("RUB_Id")
	EMP_Estado     		= 1
 
 
	datos = EMP_Id & ",'" & EMP_Nombre & "','" & EMP_Direccion & "','" & EMP_telefono & "','" & EMP_Rol & "'," & RUB_Id & ",'" & EMP_NumTrabajadores & "','" & EMP_NumMujeres & "'," & EMP_NumHombres & "," & EMP_Estado & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"


	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec spEmpresa_Modificar " & datos 
	
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