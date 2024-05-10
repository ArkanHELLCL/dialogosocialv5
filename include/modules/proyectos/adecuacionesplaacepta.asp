<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id	= request("PRY_Id")			
	ADE_Id	= request("ADE_Id")		
	TAD_Id	= request("TAD_Id")	
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
		rz.close
		cnn.close
		response.end()
	End If
	If not rs.eof then
		PRY_Identificador			= rs("PRY_Identificador")
		LIN_AgregaTematica			= rs("LIN_AgregaTematica")
		'PRY_EncargadoProyecto		= rs("PRY_EncargadoProyecto")
		'PRY_EncargadoProyectoMail	= rs("PRY_EncargadoProyectoMail")
		'PRY_EncargadoProyectoCelular= rs("PRY_EncargadoProyectoCelular")
		'SEX_IdEncargadoProyecto		= rs("SEX_IdEncargadoProyecto")				
		
		'PRY_EncargadoActividades	= rs("PRY_EncargadoActividades")
		'PRY_EncargadoActividadesMail= rs("PRY_EncargadoActividadesMail")
		'PRY_EncargadoActividadesCelular=rs("PRY_EncargadoActividadesCelular")
		'SEX_IdEncargadoActividades	= rs("SEX_IdEncargadoActividades")
				
		PRY_Carpeta					= rs("PRY_Carpeta")
		LFO_Id						= rs("LFO_Id")
	end if
	
	dim fs,f
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	
	if(TAD_Id=1) then
		if(LFO_Id<>11) then
			set rs2 = cnn.Execute("exec spAdecuacionPlanificacion_Listar  " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionPlanificacion_Listar"}<%
				rs2.close
				cnn.close
				response.end()
			End If
			if not rs2.eof then
				SPL_Id=rs2("SPL_Id")
				PLN_Sesion=rs2("SPL_PLNSesion")		
				PLN_Fecha=rs2("SPL_PLNFechaNew")
				PLN_HoraInicio=rs2("SPL_PLNHoraInicioNew")
				PLN_HoraFin=rs2("SPL_PLNHoraFinNew")
				MET_Id=rs2("MET_IdNew")
			end if

			'Mensaje de aducuacion de calendarizacion
			MEN_Texto	= "Se ha aceptado la solicitado de modificación a la planificación del proyecto : " & PRY_Id & ", en la sesión nro : " & PLN_Sesion
			TIP_Id		= 41	'Solicitud de modificacion de planificacion	

			datos =  PLN_Sesion & "," & PRY_Id & ",'" & PLN_Fecha & "','" & PLN_HoraInicio & "','" & PLN_HoraFin & "'," & MET_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			if LIN_AgregaTematica=1 and not isNull(LIN_AgregaTematica) then
				sql="exec spPlanificacionProyectoSolicitud_Modificar " & datos 
			else
				sql="exec spPlanificacionSolicitud_Modificar " & datos 
			end if	
			cnn.execute sql
			on error resume next	
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
				rz.close
				cnn.close
				response.end()
			End If

			set rs = cnn.Execute("exec spPlanificacion_SolicitarResponder " & SPL_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spPlanificacion_SolicitarResponder"}<%
				rz.close
				cnn.close
				response.end()
			End If
		end if
		if(LFO_Id=11) then
			set rs2 = cnn.Execute("exec spAdecuacionPlanTrabajo_Listar " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionPlanTrabajo_Listar"}<%
				rs2.close
				cnn.close
				response.end()
			End If
			if not rs2.eof then
				SPT_Id=rs2("SPT_Id")
				TED_Id=rs2("SPT_TEDId")		
				TED_Fecha=rs2("SPT_TEDFechaNew")
				TED_HoraInicio=rs2("SPT_TEDHoraInicioNew")
				TED_HoraTermino=rs2("SPT_TEDHoraTerminoNew")
			end if

			'Mensaje de aducuacion de calendarizacion
			MEN_Texto	= "Se ha aceptado la solicitado de modificación al plan de trabajo del proyecto : " & PRY_Id & ", con el id nro : " & TED_Id
			TIP_Id		= 57	'Solicitud de modificacion de plan de trabajo	

			datos =  TED_Id & "," & PRY_Id & ",'" & TED_Fecha & "','" & TED_HoraInicio & "','" & TED_HoraTermino & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"			 
			sql="exec spPlanTrabajoFechaHoraSolicitud_Modificar " & datos
			set rs2 = cnn.Execute(sql)
			on error resume next	
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
				rz.close
				cnn.close
				response.end()
			End If

			set rs = cnn.Execute("exec spPlanTrabajo_SolicitarResponder " & SPT_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spPlanTrabajo_SolicitarResponder"}<%
				rz.close
				cnn.close
				response.end()
			End If									
		end if
	end if
	
	if(TAD_Id=3) then
		set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionCambioEncargados_Listar"}<%
			rs2.close
			cnn.close
			response.end()
		End If
		if not rs2.eof then
			ENC_Id=rs2("ENC_Id")
			ENC_EncargadoProyectoNew = rs2("ENC_EncargadoProyectoNew")
		   	ENC_EncargadoProyectoMailNew = rs2("ENC_EncargadoProyectoMailNew")
		   	ENC_EncargadoProyectoCelularNew = rs2("ENC_EncargadoProyectoCelularNew")
		   	ENC_EncargadoProyectoSexoNew = rs2("ENC_EncargadoProyectoSexoNew")
			ENC_EncargadoProyectoNivelEducacionalNew = rs2("ENC_EncargadoProyectoNivelEducacionalNew")
			if(ENC_EncargadoProyectoNivelEducacionalNew="" or IsNULL(ENC_EncargadoProyectoNivelEducacionalNew)) then
				ENC_EncargadoProyectoNivelEducacionalNew = "NULL"
			end if
			ENC_EncargadoProyectoCarreraNew = rs2("ENC_EncargadoProyectoCarreraNew")			   
			ENC_EncargadoProyectoAdjuntoNew	= rs2("ENC_EncargadoProyectoAdjuntoNew")						
		end if
				
		'Mensaje de aducuacion de coordinador de proyecto
		MEN_Texto	= "Se ha aceptado la solicitado de modificación del/la coordinador/a del proyecto : " & PRY_Id				
		TIP_Id		= 49	
				
		datos =  PRY_Id & ",'" & ENC_EncargadoProyectoNew & "','" & ENC_EncargadoProyectoMailNew & "','" & ENC_EncargadoProyectoCelularNew & "'," & ENC_EncargadoProyectoSexoNew & ",'" & ENC_EncargadoProyectoAdjuntoNew & "'," & ENC_EncargadoProyectoNivelEducacionalNew & ",'" & ENC_EncargadoProyectoCarreraNew & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		sql="exec spEncargadoProyectoSolicitud_Modificar " & datos 
		cnn.execute sql
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rz.close
			cnn.close
			response.end()
		End If		
		
		if(LFO_Id<>11) then
			'Eliminando archivo antiguo
			carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)						
			pathCOR="D:\DocumentosSistema\dialogosocial\" & carpeta & "\curriculums\coordinador"
			path=pathCOR & "\"
			
			fs.DeleteFolder pathCOR
			
			folders = Split(path, "\")
			currentFolder = ""			
			For i = 0 To UBound(folders)
				currentFolder = currentFolder & folders(i)			
				If fs.FolderExists(currentFolder) <> true Then
					Set f=fs.CreateFolder(currentFolder)
					Set f=nothing       
				End If      
				currentFolder = currentFolder & "\"
			Next

			fileORI = "D:\DocumentosSistema\dialogosocial\" & carpeta & "\adecuaciones\ade-" & ADE_Id & "\" & ENC_EncargadoProyectoAdjuntoNew
			fileDES = path & ENC_EncargadoProyectoAdjuntoNew
			'Copiando archivo nuevo a directorio final
			fs.CopyFile fileORI, fileDES
			
			set f=nothing
			set fs=nothing

		end if
		
		set rs = cnn.Execute("exec spEncargadoProyecto_SolicitarResponder " & ENC_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spEncargadoProyecto_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if
	
	if(TAD_Id=4) then
		set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionCambioEncargados_Listar"}<%
			rs2.close
			cnn.close
			response.end()
		End If
		if not rs2.eof then
			ENC_Id=rs2("ENC_Id")
			ENC_EncargadoActividadesNew = rs2("ENC_EncargadoActividadesNew")
		   	ENC_EncargadoActividadesMailNew = rs2("ENC_EncargadoActividadesMailNew")
		   	ENC_EncargadoActividadesCelularNew = rs2("ENC_EncargadoActividadesCelularNew")
		   	ENC_EncargadoActividadesSexoNew = rs2("ENC_EncargadoActividadesSexoNew")
			ENC_EncargadoActividadesNivelEducacionalNew = rs2("ENC_EncargadoActividadesNivelEducacionalNew")	   
			if(ENC_EncargadoActividadesNivelEducacionalNew="" or IsNULL(ENC_EncargadoActividadesNivelEducacionalNew)) then
				ENC_EncargadoActividadesNivelEducacionalNew = "NULL"
			end if
			ENC_EncargadoActividadesCarreralNew = rs2("ENC_EncargadoActividadesCarreralNew")
			ENC_EncargadoActividadesAjuntoNew = rs2("ENC_EncargadoActividadesAjuntoNew")
		end if
		
		'Mensaje de aducuacion de encargado de actividades
		MEN_Texto	= "Se ha aceptado la solicitado de modificación del/la encargado/a de actividades del proyecto : " & PRY_Id				
		TIP_Id		= 52
		
		datos =  PRY_Id & ",'" & ENC_EncargadoActividadesNew & "','" & ENC_EncargadoActividadesMailNew & "','" & ENC_EncargadoActividadesCelularNew & "'," & ENC_EncargadoActividadesSexoNew & ",'" & ENC_EncargadoActividadesAjuntoNew & "'," & ENC_EncargadoActividadesNivelEducacionalNew & ",'" & ENC_EncargadoActividadesCarreralNew & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		sql="exec spEncargadoActividadesSolicitud_Modificar " & datos 
		cnn.execute sql
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rz.close
			cnn.close
			response.end()
		End If		
		
		if(LFO_Id<>11) then
			'Eliminando archivo antiguo
			carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)						
			pathENC="D:\DocumentosSistema\dialogosocial\" & carpeta & "\curriculums\encargado"
			path=pathENC & "\"
			
			fs.DeleteFolder pathENC
			
			folders = Split(path, "\")
			currentFolder = ""			
			For i = 0 To UBound(folders)
				currentFolder = currentFolder & folders(i)			
				If fs.FolderExists(currentFolder) <> true Then
					Set f=fs.CreateFolder(currentFolder)
					Set f=nothing       
				End If      
				currentFolder = currentFolder & "\"
			Next

			fileORI = "D:\DocumentosSistema\dialogosocial\" & carpeta & "\adecuaciones\ade-" & ADE_Id & "\" & ENC_EncargadoActividadesAjuntoNew
			fileDES = path & ENC_EncargadoActividadesAjuntoNew
			'Copiando archivo nuevo a directorio final
			fs.CopyFile fileORI, fileDES
			
			set f=nothing
			set fs=nothing
		end if
		
		set rs = cnn.Execute("exec spEncargadoActividades_SolicitarResponder " & ENC_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spPlanificacion_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if
	
	if(TAD_Id=5) then
		if(LFO_Id<>11) then
			set rs2 = cnn.Execute("exec spAdecuacionRelator_Listar " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionRelator_Listar"}<%
				rs2.close
				cnn.close
				response.end()
			End If
			if not rs2.eof then
				SPL_Id=rs2("SPL_Id")
				PLN_Sesion=rs2("SPL_PLNSesion")
				REL_IdNew=rs2("REL_IdNEw")
				'SPL_PLNNombreDocenteNew=rs2("SPL_PLNNombreDocenteNew")			
			end if

			'Mensaje de aducuacion de calendarizacion
			MEN_Texto	= "Se ha aceptado la solicitado de modificación de relator del proyecto : " & PRY_Id & ", en la sesión nro : " & PLN_Sesion
			TIP_Id		= 46	'Solicitud de modificacion de relator

			datos =  PLN_Sesion & "," & PRY_Id & ",'" & SPL_PLNNombreDocenteNew & "'," & REL_IdNEw & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			sql="exec spDocenteSolicitud_Modificar " & datos 
			cnn.execute sql
			on error resume next	
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
				rz.close
				cnn.close
				response.end()
			End If

			set rs = cnn.Execute("exec spPlanificacion_SolicitarResponder " & SPL_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spPlanificacion_SolicitarResponder"}<%
				rz.close
				cnn.close
				response.end()
			End If
		end if
		if(LFO_Id=11) then
			set rs2 = cnn.Execute("exec spAdecuacionPlanTrabajo_Listar " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionPlanTrabajo_Listar"}<%
				rs2.close
				cnn.close
				response.end()
			End If
			if not rs2.eof then
				SPT_Id=rs2("SPT_Id")
				TED_Id=rs2("SPT_TEDId")					
				REL_IdNew=rs2("REL_IdNEw")
				'SPT_TEDRelatorNew=rs2("SPT_TEDRelatorNew")			
			end if

			'Mensaje de aducuacion de calendarizacion
			MEN_Texto	= "Se ha aceptado la solicitado de modificación de relator del proyecto : " & PRY_Id & ", en el plan de trabajo nro : " & TED_Id
			TIP_Id		= 46	'Solicitud de modificacion de relator

			datos =  TED_Id & "," & PRY_Id & ",'" & SPT_TEDRelatorNew & "'," & REL_IdNEw & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			sql="exec spPlanTrabajoRelatorSolicitud_Modificar " & datos 
			cnn.execute sql
			on error resume next	
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			
			set rs = cnn.Execute("exec spPlanTrabajo_SolicitarResponder " & SPT_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spPlanTrabajo_SolicitarResponder"}<%
				rz.close
				cnn.close
				response.end()
			End If
		end if
	end if
	
	if(TAD_Id=6) then
		set rs = cnn.Execute("exec spAdecuacionJustificacion_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionJustificacion_Listar"}<%
			rz.close
			cnn.close
			response.end()
		End If
		if not rs.eof then
			ALU_Rut = rs("ALU_Rut")
			PLN_Sesion = rs("PLN_Sesion")
		else%>
			{"state": 503, "message": "Error Adecuacion no encontrada","data": "spAdecuacionJustificacion_Listar"}<%
			rz.close
			cnn.close
			response.end()		
		end if
		
		'Mensaje adecuacion de justificacion de inasistencia
		MEN_Texto	= "Se ha aceptado la solicitado de justificacion de inasistencia del rut : " & ALU_Rut & ", en la sesión nro : " & PLN_Sesion
		TIP_Id		= 34
		ASI_MotivoJustificacion = ""
		ASI_RutaArchivo = ""
		ASI_Justifica = 1	'Si
		
		sql="exec spAsistenciaJustificacion_Agregar " & PRY_Id & ",'" & PRY_Identificador & "'," & ALU_Rut & "," & PLN_Sesion & "," & ASI_Justifica & ",'" & ASI_MotivoJustificacion & "','" & ASI_RutaArchivo & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
		on error resume next
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAsistenciaJustificacion_Agregar"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if
	if(TAD_Id=7) then
		MEN_Texto	= "Se ha aceptado la solicitado de Adecuación"
		TIP_Id		= 54
	end if
	
	if(TAD_Id=8) then
		set rs = cnn.Execute("exec spAdecuacionDesvinculaAlumno_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionDesvinculaAlumno_Listar"}<%
			rs.close
			cnn.close
			response.end()
		End If
		if not rs.eof then
			APR_Id = rs("SDA_APRIdOri")
			ALU_Rut = rs("SDA_ALURutOri")
			ALU_DV = rs("ALU_DV")
			PRY_Id	= rs("SDA_PRYIdOri")
		else%>
			{"state": 503, "message": "Error Adecuacion no encontrada","data": "spAdecuacionDesvinculaAlumno_Listar"}<%
			rs.close
			cnn.close
			response.end()		
		end if
		
		'Mensaje adecuacion de justificacion de inasistencia
		MEN_Texto	= "Se ha aceptado la solicitado de desvinculación del alumno rut : " & ALU_Rut & "-" & ALU_DV & ", en el proyecto : " & PRY_Id
		TIP_Id		= 60		
		
		sql="exec spSolicitudDesvinculaAlumno_Eliminar " & APR_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
		on error resume next
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spSolicitudDesvinculaAlumno_Eliminar"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if
	
	if(TAD_Id=9) then
		set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionCambioEncargados_Listar"}<%
			rs2.close
			cnn.close
			response.end()
		End If
		if not rs2.eof then
			ENC_Id=rs2("ENC_Id")
			ENC_FacilitadorNew = rs2("ENC_FacilitadorNew")
		   	ENC_FacilitadorMailNew = rs2("ENC_FacilitadorMailNew")
		   	ENC_FacilitadorCelularNew = rs2("ENC_FacilitadorCelularNew")
		   	ENC_FacilitadorSexoNew = rs2("ENC_FacilitadorSexoNew")
			ENC_FacilitadorNivelEducacionalNew = rs2("ENC_FacilitadorNivelEducacionalNew")	   
			if(ENC_FacilitadorNivelEducacionalNew="" or IsNULL(ENC_FacilitadorNivelEducacionalNew)) then
				ENC_FacilitadorNivelEducacionalNew = "NULL"
			end if
			ENC_FacilitadorCarreraNew = rs2("ENC_FacilitadorCarreraNew")
			ENC_FacilitadorFormacionEspecializadaNew = rs2("ENC_FacilitadorFormacionEspecializadaNew")
		end if
		
		'Mensaje de aducuacion de encargado de actividades
		MEN_Texto	= "Se ha aceptado la solicitado de modificación del/la Relator del proyecto : " & PRY_Id				
		TIP_Id		= 65
		
		datos =  PRY_Id & ",'" & ENC_FacilitadorNew & "','" & ENC_FacilitadorMailNew & "','" & ENC_FacilitadorCelularNew & "'," & ENC_FacilitadorSexoNew & "," & ENC_FacilitadorFormacionEspecializadaNew & "," & ENC_FacilitadorNivelEducacionalNew & ",'" & ENC_FacilitadorCarreraNew & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		sql="exec spFacilitadorSolicitud_Modificar " & datos 
		cnn.execute sql
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rz.close
			cnn.close
			response.end()
		End If	
		
		set rs = cnn.Execute("exec spEncargadoActividades_SolicitarResponder " & ENC_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spPlanificacion_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if

	if(TAD_Id=12) then
		set rs2 = cnn.Execute("exec spAdecuacionGrupoFocal_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionGrupoFocal_Listar"}<%
			rs2.close
			cnn.close
			response.end()
		End If
		if not rs2.eof then
			GFS_Id=rs2("GFS_Id")
			GFS_GRFPorcentajeNew = rs2("GFS_GRFPorcentajeNew")		   
		end if
		
		'Mensaje de aducuacion de encargado de actividades
		MEN_Texto	= "Se ha aceptado la solicitado de modificación del Porcentaje de Focalización del proyecto : " & PRY_Id				
		TIP_Id		= 73
		
		datos =  PRY_Id & "," & GFS_GRFPorcentajeNew & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		sql="exec spGrupoFocalPorcentajeSolicitud_Modificar " & datos 
		cnn.execute sql
		on error resume next	
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rz.close
			cnn.close
			response.end()
		End If	
		
		set rs = cnn.Execute("exec spGrupoFocalPorcentaje_SolicitarResponder " & GFS_Id & ",2," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spGrupoFocalPorcentaje_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if
		
	sqlw="exec spAdecuacionesAcepto_Modificar " & ADE_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	on error resume next
	cnn.execute sqlw
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqlw%>"}<%
		rz.close
		cnn.close
		response.end()
	End If
	
	sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	on error resume next
	cnn.execute sql
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rz.close
		cnn.close
		response.end()
	End If
	
	%>	
	{"state": 200, "message": "Grabación de aceptación de adecuación correcta","data": null}