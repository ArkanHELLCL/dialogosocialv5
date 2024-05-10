<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\dsn.inc" -->

<%	
USR_Mail = Request("USR_Mail")

sql="exec spUsuario_PassOlvido  '" & USR_Mail & "'"

on error resume next
set cnn = createobject("adodb.connection")
cnn.open session("DSN_DialogoSocialv5")

set rs = cnn.Execute(sql)
if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   'response.write ErrMsg & " strig= " & sql
	   response.Write("1//Hubo un error al acceder al sistema.." & sql )
	   rs.close
	   cnn.close 			   
	   response.End()
End If
if not rs.eof then
	if int(rs("Result"))=1 then
		response.Write("-1//Se ha enviado a tu correo una nueva clave.")
	else
		if int(rs("Result"))=2 then
			response.Write("8//Usuario interno debe cambiar su clave en computador local conectado a la red interna.")
		else
			response.Write("6//Usuario o Email no registrados en el sistema.")
		end if
	end if
else
	response.Write("7//Usuario o Email no registrados en el sistema.")
end if

rs.close
cnn.close
set cnn = nothing


'response.write ErrMsg & " strig= " & sql
%>


