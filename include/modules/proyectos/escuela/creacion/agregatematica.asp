<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")	
	PRY_Identificador	= request("PRY_Identificador")
	TPR_Nombre			= LimpiarUrl(request("TPR_Nombre"))

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	
	'Agregando modulo especialidad de forma automatica
	sql = "exec spModuloProyecto_Listar " & PRY_Id
	set rs=cnn.execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		rs.close
		cnn.close		
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
		response.End()
	End If	
	if rs.eof then
		'Crear modulo
		sql = "exec spModuloProyecto_Agregar 'MENCIONES - ESPECIALIZACIÓN', " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
		cnn.execute sql
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			cnn.close 			   			
			response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
			response.End()
		End If	
	end if
	'Agregando Perspectiva de manera automatica
	'Buscando modulos creados
	sql = "exec spModuloProyecto_Listar " & PRY_Id
	set rs=cnn.execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		rs.close
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
		response.End()
	End If	
	'response.write(sql)
	if not rs.eof then		
		MPR_Id=rs("MPR_Id")
		sql="exec spPerspectivaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & MPR_Id
		set rs2=cnn.execute(sql)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			cnn.close 			   
			response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
			response.End()
		End If	
		if not rs2.eof then
			PPR_Id=rs("PPR_Id")
		else
			sql="exec spPerspectivaProyecto_Agregar " & MPR_Id & ",'Electivo'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"				
			cnn.execute sql
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				cnn.close 			   
				response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
				response.End()
			End If	
			'response.write(sql)
		end if
	else
		'response.write("No hay modulos " & sql)
		response.Write("1")
		response.End()
	end if
	rs.close
	rs2.close
	
	sql="exec spPerspectivaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & MPR_Id
	set rs2=cnn.execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
		response.End()
	End If
	'response.write(sql)
	if not rs2.eof then
		PPR_Id=rs2("PPR_Id")
	else
		'response.write("No hay perspectivas " & sql)
		response.Write("1")
		response.End()
	end if
		
	rs2.close	
	'Creando la tematica
	sql = "exec spTematicaProyecto_Agregar " & PPR_Id & ",'" & TPR_Nombre & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	cnn.execute sql
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
		response.End()
	End If	
	'response.write(sql)			
		
	'Leyendo tabla para retornar todos los registros de ella	
	set rs=cnn.execute("spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "',-1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataModulosAdd = "["
	do While Not rs.EOF
		dataModulosAdd = dataModulosAdd & "{""TPR_Id"":""" & rs("TPR_Id") & """,""PPR_Id"":""" & rs("PPR_Id") & """,""TPR_Nombre"":""" & rs("TPR_Nombre") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-tpr='" & rs("TPR_Id") & "' data-pry='" & PRY_Id & "' data-ppr='" & rs("PPR_Id") & "'></i>"""
		dataModulosAdd = dataModulosAdd & "}"		
		rs.movenext
		if not rs.eof then
			dataModulosAdd = dataModulosAdd & ","
		end if
	loop
	dataModulosAdd=dataModulosAdd & "]"								
	rs.close							
	
	response.write("200\\" & dataModulosAdd)
%>