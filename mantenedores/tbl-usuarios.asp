<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec spUsuario_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spUsuario_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataLineas = "{""data"":["
	do While Not rs.EOF
		if rs("USR_Estado")=1 then
			estado="Activado"
		else
			estado="Desactivado"
		end if		
		if rs("USR_LDAP")=1 then
			LDAP="Si"
		else
			LDAP="No"
		end if		
		
		if(rs("PER_Id")=3) then
			nombreinstitucion = rs("EME_Nombre")
		else
			nombreinstitucion = rs("USR_NombreInstitucion")
		end if
		
		dataLineas = dataLineas & "[""" & rs("USR_Id") & """,""" & rs("USR_Identificador") & """,""" & rs("PER_Nombre") & """,""" & UCASE(rs("USR_Usuario")) & """,""" & rs("USR_Nombre") & " " & rs("USR_Apellido") & """,""" & nombreinstitucion & """,""" & estado & """,""" & rs("USR_Telefono") & """,""" & rs("USR_Direccion") & """,""" & rs("USR_Mail") & """,""" & rs("USR_Nombre") & """,""" & rs("USR_Apellido") & """,""" & rs("USR_Rut") & """,""" & rs("USR_Dv") & """,""" & rs("SEX_Descripcion") & """,""" & rs("COM_Nombre") & """,""" & rs("REG_Nombre") & """,""" & rs("DEP_Descripcion") & """,""" & LDAP & """]"
		
		rs.movenext
		if not rs.eof then
			dataLineas = dataLineas & ","
		end if
	loop
	dataLineas=dataLineas & "]}"
	
	response.write(dataLineas)
%>