<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")<>1) then	'Todos menos el administrador
		response.write("503/@/Error Perfil no autorizado")
		response.End() 			   
	end if	
	
	PRY_Id		= request("PRY_Id")	
	MEN_Texto	= LimpiarUrl(request("MEN_Texto"))
	PRY_Estado 	= 1						'Archivado
	TIP_Id		= 39					'Archivar Proyecto
	MEN_Archivo	= ""
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if				
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if	
	
	if not rs.eof then
		PRY_Identificador=rs("PRY_Identificador")
	else
		response.write("1")
		cnn.close
		response.End()
	end if
	
	sql = "exec spProyectoEstado_Modificar " & PRY_Id & ",'"  & PRY_Identificador & "'," & PRY_Estado & ",'" & MEN_Texto & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
	cnn.execute sql
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if	
	
	sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id &  ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.write("503/@/Error de conexion")
	   response.End() 			   
	end if
	 response.write("200/@/")
%>