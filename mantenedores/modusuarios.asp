<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	USR_Id          			    = Request("USR_Id")
	PER_Id		    			    = Request("PER_Id")
	USR_Estado      			    = Request("USR_Estado")
	USR_Usuario     			  	= LimpiarUrl(Request("USR_Usuario"))
	USR_Telefono     				= Request("USR_Telefono")
	USR_Direccion    				= LimpiarUrl(Request("USR_Direccion"))
	USR_Mail        				= Request("USR_Mail")
	USR_Nombre      				= LimpiarUrl(Request("USR_Nombre"))
	USR_Apellido       				= LimpiarUrl(Request("USR_Apellido"))
	SEX_Id                          = Request("SEX_Id")
	USR_Reset						= Request("USR_Reset")
	Rut								= Request("USR_Rut")
	USR_NombreInstitucion			= LimpiarUrl(Request("USR_NombreInstitucion"))
	COM_Id                          = Request("COM_Id")
	COM_Nombre                      = Request("COM_Nombre")
	REG_Nombre                      = Request("REG_Nombre")
	DEP_Id							= Request("DEP_Id")
	USR_LDAP						= Request("USR_LDAP")
	EME_Id							= Request("EME_Id")

	if(PER_Id<>3) then
		EME_Id="NULL"
	else
		DEP_Id="NULL"
	end if
	USR_Rut=replace(mid(Rut,1,len(Rut)-2),".","")
	USR_Dv=mid(Rut,len(Rut),1)


	datos = USR_Id & "," & PER_Id & "," & USR_Rut & ",'" & USR_Dv & "','" & USR_NombreInstitucion & "'," & USR_Estado & ",'" & USR_Usuario & "','" & USR_Telefono & "','" & USR_Direccion & "'," & COM_Id & ",'" & USR_Mail & "','" & USR_Nombre & "','" & USR_Apellido & "'," & SEX_Id & "," & DEP_Id & "," & USR_LDAP & "," & EME_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 


	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec spUsuario_Modificar " & datos 
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
				
	if USR_Reset=1 then
		sql="exec spUsuario_Consultar " & USR_Id
		set rs = cnn.Execute(sql)
		on error resume next
		if cnn.Errors.Count > 0 then%>
		   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rs.close
			cnn.close
			response.end()
		End If
		if not rs.eof then
			USR_Identificador=rs("USR_Identificador")
		else%>
		   {"state": 5, "message": "Error no pude resetear la clave : <%=ErrMsg%>","data": "<%=sql%>"}<%
		end if
		
		sql="exec spUsuario_PassReset " & USR_Id & ",'" & USR_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rs = cnn.Execute(sql)
		on error resume next
		if cnn.Errors.Count > 0 then%>
		   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rs.close
			cnn.close
			response.end()
		End If
	end if
	
	
	cnn.close
	set cnn = nothing%>
	{"state": 200, "message": "Ejecución exitosa","data": null}