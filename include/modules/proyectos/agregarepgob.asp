<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
		
	PRY_Id				= request("PRY_Id")
	RPG_Nombre 			= LimpiarUrl(request("RPG_Nombre"))
	RPG_ApellidoPaterno	= LimpiarUrl(request("RPG_ApellidoPaterno"))
	RPG_ApellidoMaterno	= LimpiarUrl(request("RPG_ApellidoMaterno"))
	Rut					= request("Rut_RPG")
	RPG_Rut				= mid(Rut,1,Len(Rut)-1)
	RPG_Dv				= mid(Rut,Len(Rut),1)
	RPG_Cargo			= LimpiarUrl(request("RPG_Cargo"))
	SEX_Id				= request("SEX_Id")
	RPG_Mail			= request("RPG_Mail")
	RPG_Telefono		= request("RPG_Telefono")	
	SER_Id				= request("SER_Id")
	JGS_Justificacion	= LimpiarUrl(request("JGS_Justificacion"))
	RPG_Compromiso		= LimpiarUrl(request("RPG_Compromiso"))
	RPG_VerificadorCumplimiento = LimpiarUrl(request("RPG_VerificadorCumplimiento"))
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	
	set rx=cnn.execute("spRepProyectoGobierno_Listar 1," & PRY_Id & "," & SER_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	required="required"
	if not rx.eof then		
		JGS_Id=rx("JGS_Id")
		required=""
		rx.movefirst
	end if
		
	if JGS_Id="" or isnull(JGS_Id) then		'Registro nuevo				
		set ry=cnn.execute("exec spJustificacionGobSer_Agregar " & SER_Id & "," & PRY_Id & ",'" & JGS_Justificacion & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close%>
		   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		   response.End() 			   
		end if		
		if not ry.eof then
			JGS_Id=ry("JGS_Id")
		else
			response.write("1,")
			response.end()
		end if
		set ry=nothing	
	else
		set ry=cnn.execute("exec spJustificacionGobSer_Modificar " & JGS_Id & "," & SER_Id & "," & PRY_Id & ",'" & JGS_Justificacion & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close%>
		   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		   response.End() 			   
		end if	
	end if	
	
	sqx="exec spRepProyectoGobierno_Agregar '" & RPG_Nombre & "','" & RPG_ApellidoPaterno & "','" & RPG_ApellidoMaterno & "'," & SEX_Id & ",'" & RPG_Cargo & "'," & RPG_Rut & ",'" & RPG_Dv & "','" & RPG_Telefono & "','" & RPG_Mail & "'," & SER_Id & "," & JGS_Id & ",'" & RPG_Compromiso & "','" & RPG_VerificadorCumplimiento & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sqx)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de representante de gobierno correcta","data": "<%=JGS_Justificacion%>"}