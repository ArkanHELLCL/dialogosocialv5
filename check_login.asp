<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\dsn.inc" -->
<!-- #INCLUDE FILE="appl\class_md5.asp" -->
<%	
	usr_cod=request("usr_cod")
	usr_pass=request("usr_pass")
	
	if isEmpty(usr_cod) or isNull(usr_cod) then
		response.Write("5//Error Par&oacute;metros no v&aacute;lidos")
		response.end()
	end if		
	
	'Encriptar Clave	
	Dim objMD5
	Set objMD5 = New MD5
	objMD5.Text = trim(usr_pass)	
	
	passwenc = objMD5.HEXMD5
	'Encriptar Clave	
 		
	session("ds5_usrperfil")	= 0
	session("ds5_usrpernom")	= ""
	session("ds5_usuario") 		= ""
	session("ds5_usrnom")		= ""
	session("ds5_usrid")		= 0
	session("ds5_usrtoken")		= ""
	session("ds5_usrdep")		= ""
	session("ds5_usrdepid")		= 0
	session("ds5_usrldap")		= 0
	session("dialogosocialv5")	= ""		
	
	'SQL
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
    cnn.open session("DSN_DialogoSocialv5")	
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	      
	   sw=6
	   cnn.close
	   response.Write(sw & "//ERROR SQL " & ErrMsg)
	   response.End() 			   
	end if
	sql="exec [spUsuario_ConsultarPorLogin] '" + usr_cod + "'"
	set rs = cnn.Execute(sql)	
	if not rs.eof then
		if rs("USR_Estado")=1 and rs("PER_Estado")=1 then
			if (NOT ISNULL(rs("USR_LDAP")) and rs("USR_LDAP"))=1 then
				'LDAP
				if(AuthenticateUser(usr_cod,usr_pass,"MINTRAB.MS")) then					
					session("ds5_usrperfil")	= rs("PER_Id")
					session("ds5_usrpernom")	= rs("PER_Nombre")
					session("ds5_usuario") 		= rs("USR_Usuario")
					session("ds5_usrnom")		= rs("USR_Nombre") & " " & rs("USR_Apellido")
					session("ds5_usrid")		= rs("USR_Id")
					session("ds5_usrtoken")		= rs("USR_Identificador")
					session("ds5_usrdep")		= rs("DEP_Descripcion")
					session("ds5_usrdepid")		= rs("DEP_Id")
					session("ds5_usrdepcorta")	= rs("DEP_DescripcionCorta")
					session("ds5_usrldap")		= rs("USR_LDAP")
					session("dialogosocialv5")	= Session.SessionID		'Sesion activa
					sw=0	'ok
					response.Write(sw & "//Validaci&oacute;n Exitosa LDAP")							
				else
					sw=4	'credenciales incorrectas / usuario no existe
					response.Write(sw & "//Credenciales incorrectas LDAP")
				end if
			else
				'SQL
				sqly="exec spUsuario_Login '" + usr_cod + "','" + passwenc + "'"
				set rx = cnn.Execute(sqly)
				if not rx.eof then
					if rx("USR_Estado")=1 and rx("PER_Estado")=1 then				
						if rx("USR_ClaveProvisoria")=0 then		'Clave real
							session("ds5_usrperfil")	= rx("PER_Id")
							session("ds5_usrpernom")	= rx("PER_Nombre")
							session("ds5_usuario") 		= rx("USR_Usuario")
							session("ds5_usrnom")		= rx("USR_Nombre") & " " & rs("USR_Apellido")
							session("ds5_usrid")		= rx("USR_Id")
							session("ds5_usrtoken")		= rx("USR_Identificador")
							session("ds5_usrdep")		= rx("DEP_Descripcion")
							session("ds5_usrdepid")		= rx("DEP_Id")
							session("ds5_usrldap")		= rx("USR_LDAP")
							session("dialogosocialv5")	= Session.SessionID		'Sesion activa
							sw=0	'ok
							response.Write(sw & "//Validaci&oacute;n Exitosa SQL")
						else
							sw=3	'Clave provisoria
							response.Write(sw & "//Clave Provisoria")
						end if
					else
						sw=2	'usuario no activo
						response.Write(sw & "//Usuario no activo")
					end if
				else
					sw=1	'credenciales incorrectas
					response.Write(sw & "//Credenciales incorrectas SQL")
				end if
			end if
		else
			sw=2	'usuario no activo
			response.Write(sw & "//Usuario no activo")
		end if
	else
		sw=5 'Usuario no existe
		response.Write(sw & "//Usuario no existe")
	end if	
	
	function AuthenticateUser(Username,Password,Domain)
        dim strUser,strPass,strQuery,oConn,cmd,oRS
        AuthenticateUser = false
        strQuery = "SELECT cn FROM 'LDAP://" & Domain & "' WHERE objectClass='*'"
		'strQuery = "SELECT CN=Organizational-Unit,CN=Schema,CN=Configuration FROM 'LDAP://" & Domain & "' WHERE objectClass='*'"
        set oConn = server.CreateObject("ADODB.Connection")
        oConn.Provider = "ADsDSOOBJECT"
        oConn.properties("User ID") = Username
        oConn.properties("Password")=Password
        oConn.properties("Encrypt Password") = true
        oConn.open "DS Query", Username,Password
        set cmd = server.CreateObject("ADODB.Command")
        set cmd.ActiveConnection = oConn
        cmd.CommandText = strQuery
        on error resume next
        set oRS = cmd.Execute
        if oRS.bof or oRS.eof then
            AuthenticateUser = false			
        else
            AuthenticateUser = true					
        end if
        set oRS = nothing
        set oConn = nothing
	end function    
%>
