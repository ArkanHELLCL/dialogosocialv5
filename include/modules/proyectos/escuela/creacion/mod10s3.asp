<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id							 = request("PRY_Id")
	PRY_Identificador		         = request("PRY_Identificador")
	
	PRY_InformeInicioFecha           = request("PRY_InformeInicioFecha")
	PRY_InformeParcialFecha          = request("PRY_InformeParcialFecha")
	PRY_InformeDesarrolloFecha       = request("PRY_InformeDesarrolloFecha")
	PRY_InformeFinalFecha            = request("PRY_InformeFinalFecha")	
	Step							 = CInt(request("Step"))
	PRY_InformeInicioFechaOriginal	 = request("PRY_InformeInicioFechaOriginal")
	PRY_InformeParcialFechaOriginal	 = request("PRY_InformeParcialFechaOriginal")
	PRY_InformeFinalFechaOriginal	 = request("PRY_InformeFinalFechaOriginal")
	PRY_FechaTramitacionContrato	 = request("PRY_FechaTramitacionContrato")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión:" & ErrMsg)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step=rs("PRY_Step")
		LFO_Id = rs("LFO_Id")
		xPRY_Identificador = rs("PRY_Identificador")
		xPRY_InformeInicioFecha = rs("PRY_InformeInicioFecha")
		xPRY_InformeParcialFecha = rs("PRY_InformeParcialFecha")
		xPRY_InformeFinalFecha = rs("PRY_InformeFinalFecha")
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")		
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_CreacionProyectoEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if	

	informe=""
	if(xPRY_InformeInicioFecha<>PRY_InformeInicioFecha) then
		if LFO_Id=10 then
			informe="Inicio (Escuela)"
		end if
		if LFO_Id=12 then
			informe="Inicio (Curso)"
		end if
		oldValue=xPRY_InformeInicioFecha
		newValue=PRY_InformeInicioFecha

		MEN_Texto	= "Se ha modificado fecha de cierre del informe " & informe & " para el proyecto : " & PRY_Id & ". Fecha Original : " & oldValue & " - Nuevo Valor : " & newValue
		TIP_Id		= 43	'Solicitud de modificacion de planificacion
		MEN_Archivo	= ""	

		sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id &  ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		on error resume next
		cnn.execute sql
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description
		   'response.write ErrMsg & " strig= " & sql
		    response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
		   rs.close
		   cnn.close
		   response.end()
		'Else
		''	response.Write("0")	
		End If 
	end if

	if(xPRY_InformeParcialFecha<>PRY_InformeParcialFecha) then
		informe="Desarrollo (Escuela)"
		oldValue=xPRY_InformeParcialFecha
		newValue=PRY_InformeParcialFecha

		MEN_Texto	= "Se ha modificado fecha de cierre del informe " & informe & " para el proyecto : " & PRY_Id & ". Fecha Original : " & oldValue & " - Nuevo Valor : " & newValue
		TIP_Id		= 43	'Solicitud de modificacion de planificacion
		MEN_Archivo	= ""	

		sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id &  ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		on error resume next
		cnn.execute sql
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description
		   'response.write ErrMsg & " strig= " & sql
		   response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)	   
		   rs.close
		   cnn.close
		   response.end()
		'Else
		''	response.Write("0")	
		End If 
	end if

	if(xPRY_InformeFinalFecha<>PRY_InformeFinalFecha) then
		if LFO_Id=10 then
			informe="Final (Escuela)"
		end if
		if LFO_Id=12 then
			informe="Final (Curso)"
		end if	
		oldValue=xPRY_InformeFinalFecha
		newValue=PRY_InformeFinalFecha

		MEN_Texto	= "Se ha modificado fecha de cierre del informe " & informe & " para el proyecto : " & PRY_Id & ". Fecha Original : " & oldValue & " - Nuevo Valor : " & newValue
		TIP_Id		= 43	'Solicitud de modificacion de planificacion
		MEN_Archivo	= ""	

		sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id &  ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		on error resume next
		cnn.execute sql
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description
		   'response.write ErrMsg & " strig= " & sql
		   response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)	   
		   rs.close
		   cnn.close
		   response.end()
		'Else
		''	response.Write("0")	
		End If 
	end if
	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_InformeInicioFecha & "','" & PRY_InformeParcialFecha & "','" & PRY_InformeFinalFecha & "'," & PRY_Step & ",'" & PRY_InformeInicioFechaOriginal & "','" & PRY_InformeParcialFechaOriginal & "','" & PRY_InformeFinalFechaOriginal & "','" & PRY_FechaTramitacionContrato & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	sql="exec [spProyecto_FechasdeCierreModificar] " & datos 

	set rs=cnn.execute(sql)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   'response.write ErrMsg & " strig= " & sql
	   response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)	   
	   rs.close
	   cnn.close
	   response.end()			
	end if	
	response.write("200\\")		
	
	cnn.close
	set cnn = nothing
%>