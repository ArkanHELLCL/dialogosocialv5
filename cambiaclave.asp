<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\Dsn.inc" -->
<!-- #INCLUDE FILE="appl\class_md5.asp" -->
<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%
	usr_cod=session("ds5_usuario")
	usr_pass=request("usr_pass2")
	inputPassword=request("inputPassword")		

	'Verificando politicas de contraseña
	Set arrResults = RegExResults(inputPassword, "^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$")

	'In your pattern the answer is the first group, so all you need is'
	ok=false
	For each result in arrResults
		'Response.Write(result.Submatches(0))
		if(result.SubMatches.Count=0) then
			ok=true	
		end if
	Next
	'Response.Write(ok)
	Set arrResults = Nothing
	if(not ok) then			
		response.write("11//ERROR Clave fuera de las politicas de creacion de contraseñas")
		response.end()
	end if
		
	'on error resume next
	set cnn = Server.CreateObject("ADODB.Connection")
    cnn.open session("DSN_DialogoSocialv5")			
	
	'Encriptar Clave	
	Dim objMD5
	Set objMD5 = New MD5
	objMD5.Text = trim(usr_pass)		
	passwenc = objMD5.HEXMD5
	
	objMD5.Text = trim(inputPassword)		
	passwencnew = objMD5.HEXMD5
	
	'Encriptar Clave		  
	sw=1
	titulo=""
	texto=""
	sql="exec spUsuario_Login '" + usr_cod + "','" + passwenc + "'"
	'response.Write(sql)
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   'response.write ErrMsg & " string = " & sql	   	   
	   'response.Write("1")	  
	   sw=6
	   response.Write(sw & "/@/ERROR SQL")
	   rs.close
	   cnn.close 		
	   response.end()
	Else
	'response.Write("Grabación Exitosa")	  
		'do While Not rs.EOF
		if not rs.eof then
			if rs("USR_Estado")=1 then		
				set rs2 = cnn.Execute("exec spUsuario_PassCambiar '" & passwenc & "','" & passwencnew & "'," & rs("USR_Id") & ",'" & rs("USR_Identificador") & "'")
				on error resume next
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description
				   'response.write ErrMsg & " string = " & sql	   	   
				   'response.Write("1")	  
				   rs.close
				   rs2.close
				   cnn.close
				   sw=9	'Error al grabar el cambio de clave
				   response.Write(sw & "/@/Error al grabar el cambio de clave")
				   response.end()
				else				
					sw=200	'ok
					titulo="Grabación exitosa."
					texto="Cambio de clave realizado."
				end if
			else
				sw=2	'usuario no activo
				response.Write(sw & "/@/Usuario no activo")
				response.end()
			end if
				
		else
			sw=1	'credenciales incorrectas
			response.Write(sw & "/@/Credenciales incorrectas")
			response.end()
		end if
	End If  	
	rs.close
    cnn.close
		
	response.Write(sw & "/@/" & titulo & "/@/" & texto)		
    
%>


