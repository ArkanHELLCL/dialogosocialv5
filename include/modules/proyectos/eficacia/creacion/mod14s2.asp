<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id							 = request("PRY_Id")
	PRY_Identificador		         = request("PRY_Identificador")
	
	PRY_InformeInicialFecha          = request("PRY_InformeInicialFecha")
	PRY_InformeConsensosFecha        = request("PRY_InformeConsensosFecha")	
	PRY_InformeSistematizacionFecha  = request("PRY_InformeSistematizacionFecha")	
	PRY_InformeParcialFecha          = request("PRY_InformeParcialFecha")
	Step							 = CInt(request("Step"))
	PRY_InformeInicialFechaOriginal	 = request("PRY_InformeInicialFechaOriginal")
	PRY_InformeConsensosFechaOriginal= request("PRY_InformeConsensosFechaOriginal")
	PRY_InformeSistematizacionFechaOriginal	 = request("PRY_InformeSistematizacionFechaOriginal")
	PRY_InformeParcialFechaOriginal	 = request("PRY_InformeParcialFechaOriginal")

	PRY_FechaTramitacionContrato = request("PRY_FechaTramitacionContrato")

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
		xPRY_InformeInicialFecha = rs("PRY_InformeInicialFecha")
		xPRY_InformeConsensosFecha = rs("PRY_InformeConsensosFecha")
		xPRY_InformeSistematizacionFecha = rs("PRY_InformeSistematizacionFecha")
		xPRY_InformeParcialFecha = rs("PRY_InformeParcialFecha")
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
	if(xPRY_InformeInicialFecha<>PRY_InformeInicialFecha) then		
		informe="Inicial"		
		oldValue=xPRY_InformeInicialFecha
		newValue=PRY_InformeInicialFecha

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

	if(xPRY_InformeConsensosFecha<>PRY_InformeConsensosFecha) then
		informe="Avances"
		oldValue=xPRY_InformeConsensosFecha
		newValue=PRY_InformeConsensosFecha

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

	if(xPRY_InformeSistematizacionFecha<>PRY_InformeSistematizacionFecha) then		
		informe="Final"			
		oldValue=xPRY_InformeSistematizacionFecha
		newValue=PRY_InformeSistematizacionFecha

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
		informe="Desarollo"			
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

	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_InformeInicialFecha & "','" & PRY_InformeConsensosFecha & "','" & PRY_InformeSistematizacionFecha & "'," & PRY_Step & ",'" & PRY_InformeInicialFechaOriginal & "','" & PRY_InformeConsensosFechaOriginal & "','" & PRY_InformeSistematizacionFechaOriginal & "','" & PRY_FechaTramitacionContrato & "','" & PRY_InformeParcialFechaOriginal & "','" & PRY_InformeParcialFecha & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	sql="exec [spProyectoEficacia_FechasOriginalModificar] " & datos 

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