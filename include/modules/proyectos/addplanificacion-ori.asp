<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	
	'largo = ((Request.Form.count) / 7)
	largoNew=-1
	For Each oItem In Request.Form
		'response.write(Request.Form(oItem) & "," & oItem)
		'response.write(oItem & ",")
		If InStr(oItem,"PLN_Fecha-new") > 0 Then	
			largoNew=largoNew + 1	
		End If
	Next
	
	largoOld=-1
	For Each oItem In Request.Form
		'response.write(Request.Form(oItem) & "," & oItem)
		'response.write(oItem & ",")
		If InStr(oItem,"PLN_Fecha-old") > 0 Then	
			largoOld=largoOld + 1	
		End If
	Next
	
	'response.write(largo & "-" & Request.Form.count & "--")
	
	dim PLN_FechaNew()
	redim PLN_FechaNew(largoNew)
	
	dim PLN_HoraInicioNew()
	redim PLN_HoraInicioNew(largoNew)
	
	dim PLN_HoraFinNew()
	redim PLN_HoraFinNew(largoNew)
	
	dim PLN_NombreDocenteNew()
	redim PLN_NombreDocenteNew(largoNew)
	
	dim TEM_IdNew()
	redim TEM_IdNew(largoNew)
	
	dim TemNew()
	redim TemNew(largoNew)
	
	dim PLN_SesionNew()
	redim PLN_SesionNew(largoNew)
	
	
	dim PLN_FechaOld()
	redim PLN_FechaOld(largoOld)
	
	dim PLN_HoraInicioOld()
	redim PLN_HoraInicioOld(largoOld)
	
	dim PLN_HoraFinOld()
	redim PLN_HoraFinOld(largoOld)
	
	dim PLN_NombreDocenteOld()
	redim PLN_NombreDocenteOld(largoOld)
	
	dim TEM_IdOld()
	redim TEM_IdOld(largoOld)
	
	dim TemOld()
	redim TemOld(largoOld)
	
	dim PLN_SesionOld()
	redim PLN_SesionOld(largoOld)
	
	c1=0
	c2=0
	c3=0
	c4=0
	c5=0
	c6=0
	c7=0
	
	d1=0
	d2=0
	d3=0
	d4=0
	d5=0
	d6=0
	d7=0
	
	For Each oItem In Request.Form
		'response.write(Request.Form(oItem) & "," & oItem)
		'response.write(oItem & ",")
		If InStr(oItem,"PLN_Fecha-new") > 0 Then						
			PLN_FechaNew(c1) = Request.Form(oItem)
			c1=c1+1			
		End If
		If InStr(oItem,"PLN_HoraInicio-new") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_HoraInicioNew(c2) = Request.Form(oItem)
			c2=c2+1
		End If
		If InStr(oItem,"PLN_HoraFin-new") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_HoraFinNew(c3) = Request.Form(oItem)
			c3=c3+1
		End If
		If InStr(oItem,"PLN_NombreDocente-new") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_NombreDocenteNew(c4) = LimpiarUrl(Request.Form(oItem))
			c4=c4+1
		End If		
		If InStr(oItem,"Tem-new") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			TemNew(c5) = Request.Form(oItem)
			c5=c5+1
		End If		
		If InStr(oItem,"TEM_Id-new") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			TEM_IdNew(c6) = Request.Form(oItem)
			c6=c6+1
		End If		
		If InStr(oItem,"PLN_Sesion-new") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_SesionNew(c7) = Request.Form(oItem)
			c7=c7+1
		End If		
		
		
		
		If InStr(oItem,"PLN_Fecha-old") > 0 Then						
			PLN_FechaOld(d1) = Request.Form(oItem)
			d1=d1+1			
		End If
		If InStr(oItem,"PLN_HoraInicio-old") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_HoraInicioOld(d2) = Request.Form(oItem)
			d2=d2+1
		End If
		If InStr(oItem,"PLN_HoraFin-old") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_HoraFinOld(d3) = Request.Form(oItem)
			d3=d3+1
		End If
		If InStr(oItem,"PLN_NombreDocente-old") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			PLN_NombreDocenteOld(d4) = LimpiarUrl(Request.Form(oItem))
			d4=d4+1
		End If		
		If InStr(oItem,"Tem-old") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			TemOld(d5) = Request.Form(oItem)
			d5=d5+1
		End If		
		If InStr(oItem,"TEM_Id-old") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			TEM_IdOld(d6) = Request.Form(oItem)
			d6=d6+1
		End If		
		If InStr(oItem,"PLN_Sesion-old") > 0 Then			
			'response.write(Request.Form(oItem) & "," & oItem)
			if(d7<=UBound(PLN_SesionOld)) then
				PLN_SesionOld(d7) = Request.Form(oItem)
			end if
			d7=d7+1
		End If	
	next
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	sqx="exec spProyecto_Consultar " & PRY_Id
	set rx = cnn.Execute(sqx)
	if not rx.eof then
		LIN_AgregaTematica  	= rx("LIN_AgregaTematica")
		PRY_InformeInicioEstado	= rx("PRY_InformeInicioEstado")
		PRY_Estado				= rx("PRY_Estado")
	end if
	
	if (PRY_InformeInicioEstado<>0 or PRY_Estado<>1) then%>
		{"state": 1, "message": "Error estado del proyecto no válido","data": "<%=PRY_Estado%>"}<%
		response.end()
	end if	
		
	for i=0 to UBound(TEM_IdNew)		
		'if(TEM_IdNew(i)<>"" or Not IsNull(TEM_IdNew(i))) then
		if(TEM_IdNew(i)<>"" or Not IsNull(TEM_IdNew(i))) and (trim(PLN_FechaNew(i))<>"") and (trim(PLN_HoraInicioNew(i))<>"") and (trim(PLN_HoraFinNew(i))<>"") and (trim(PLN_NombreDocenteNew(i))<>"") then
			datos =  PRY_Id & "," & TEM_IdNew(i) & ",'" & PLN_FechaNew(i) & "','" & PLN_HoraInicioNew(i) & "','" & PLN_HoraFinNew(i) & "','" & PLN_NombreDocenteNew(i) & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			if TemNew(i)=0 then	
				sql="spPlanificacion_Agregar " & datos 
			else
				sql="spPlanificacionTematicaProyecto_Agregar " & datos 
			end if		
			set rs = cnn.Execute(sql)
			'x=x & datos & "]-" & UBound(TEM_IdNew) & "-" & i
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=datos%>}"<%
				response.End() 			   
			end if
		end if
	next
	
	for i=0 to UBound(TEM_IdOld)		
		'if(TEM_IdOld(i)<>"" or Not IsNull(TEM_IdOld(i))) then
		if(TEM_IdOld(i)<>"" or Not IsNull(TEM_IdOld(i))) and (trim(PLN_FechaOld(i))<>"") and (trim(PLN_HoraInicioOld(i))<>"") and (trim(PLN_HoraFinOld(i))<>"") and (trim(PLN_NombreDocenteOld(i))<>"") then
			datos =  PLN_SesionOld(i) & "," & PRY_Id & "," & TEM_IdOld(i) & ",'" & PLN_FechaOld(i) & "','" & PLN_HoraInicioOld(i) & "','" & PLN_HoraFinOld(i) & "','" & PLN_NombreDocenteOld(i) & "',1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			if TemOld(i)=0 then	
				sql="spPlanificacion_Modificar " & datos 
			else
				sql="spPlanificacionProyecto_Modificar " & datos 
			end if		
			set rs = cnn.Execute(sql)			
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=datos%>"}<%
				response.End() 			   
			end if
		end if
	next%>	
	{"state": 200, "message": "Grabación de planificación correcta","data": null}