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
		PRY_Identificador=rs("PRY_Identificador")
		LFO_Id=rs("LFO_Id")
	end if
	
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
			end if

			'Mensaje de aducuacion de calendarizacion
			MEN_Texto	= "Se ha rechazado la solicitado de modificación a la planificación del proyecto : " & PRY_Id & ", en la sesión nro : " & PLN_Sesion
			TIP_Id		= 42	'Solicitud de modificacion de planificacion

			set rs = cnn.Execute("exec spPlanificacion_SolicitarResponder " & SPL_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
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
			set rs2 = cnn.Execute("exec spAdecuacionPlanTrabajo_Listar  " & ADE_Id)
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
			end if

			'Mensaje de aducuacion de calendarizacion
			MEN_Texto	= "Se ha rechazado la solicitado de modificación al plan de trabajo del proyecto : " & PRY_Id & ", en la sesión nro : " & TED_Id
			TIP_Id		= 58	'Solicitud de modificacion de plan de trabajo

			set rs = cnn.Execute("exec spPlanTrabajo_SolicitarResponder " & SPT_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
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
		set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar  " & ADE_Id)
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
		end if
		
		'Mensaje de aducuacion de docente
		MEN_Texto	= "Se ha rechazado la solicitado de modificación al/la coordinador/a de actividades del proyecto : " & PRY_Id
		TIP_Id		= 50	'Solicitud de modificacion de Relator rechazada
		
		set rs = cnn.Execute("exec spEncargadoActividades_SolicitarResponder " & ENC_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spEncargadoActividades_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If
	end if

	if(TAD_Id=4) then
		set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar  " & ADE_Id)
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
		end if
		
		'Mensaje de aducuacion de docente
		MEN_Texto	= "Se ha rechazado la solicitado de modificación al/la coordinador/a de actividades del proyecto : " & PRY_Id
		TIP_Id		= 53	'Solicitud de modificacion de Relator rechazada
		
		set rs = cnn.Execute("exec spEncargadoActividades_SolicitarResponder " & ENC_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spDocente_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If
	end if

	if(TAD_Id=5) then
		if(LFO_Id<>11) then
			set rs2 = cnn.Execute("exec spAdecuacionRelator_Listar  " & ADE_Id)
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
			end if

			'Mensaje de aducuacion de Relator
			MEN_Texto	= "Se ha rechazado la solicitado de modificación a la planificación del proyecto : " & PRY_Id & ", en la sesión nro : " & PLN_Sesion
			TIP_Id		= 47	'Solicitud de modificacion de docente rechazada

			set rs = cnn.Execute("exec spDocente_SolicitarResponder " & SPL_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spDocente_SolicitarResponder"}<%
				rz.close
				cnn.close
				response.end()
			End If
		end if
		if(LFO_Id=11) then
			set rs2 = cnn.Execute("exec spAdecuacionPlanTrabajo_Listar  " & ADE_Id)
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
			end if

			'Mensaje de aducuacion de docente
			MEN_Texto	= "Se ha rechazado la solicitado de modificación a la planificación del proyecto : " & PRY_Id & ", en el plan de trabajo id nro : " & TED_Id
			TIP_Id		= 47	'Solicitud de modificacion de Relator rechazada

			set rs = cnn.Execute("exec spPlanTrabajo_SolicitarResponder " & SPT_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
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
		MEN_Texto	= "Se ha rechazado la solicitado de justificacion de inasistencia del rut : " & ALU_Rut & ", en la sesión nro : " & PLN_Sesion
		TIP_Id		= 44
		ASI_MotivoJustificacion = ""
		ASI_RutaArchivo = ""
		
		sqlw="exec spAsistenciaJustificacion_Rechaza " & PRY_Id & ",'" & PRY_Identificador & "'," & ALU_Rut & "," & PLN_Sesion & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		on error resume next
		cnn.execute sqlw
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqlw%>"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if

	if(TAD_Id=7) then
		MEN_Texto	= "Se ha rechazado la solicitado de Adecuación"
		TIP_Id		= 55
	end if

	if(TAD_Id=8) then
		set rs = cnn.Execute("exec spAdecuacionDesvinculaAlumno_Listar " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionDesvinculaAlumno_Listar"}<%
			rz.close
			cnn.close
			response.end()
		End If
		if not rs.eof then
			APR_Id = rs("SDA_APRIdOri")
			ALU_Rut = rs("SDA_ALURutOri")
			ALU_DV = rs("ALU_DV")
			PRY_Id	= rs("SDA_PRYIdOri")
			SDA_Id = rs("SDA_Id")
		else%>
			{"state": 503, "message": "Error Adecuacion no encontrada","data": "spAdecuacionDesvinculaAlumno_Listar"}<%
			rz.close
			cnn.close
			response.end()		
		end if
		
		'Mensaje adecuacion de justificacion de inasistencia
		MEN_Texto	= "Se ha rechazado la solicitado de desvinculación de Alumno rut : " & ALU_Rut & "-" & ALU_DV & ", en el proyecto : " & PRY_Id
		TIP_Id		= 61		
		
		sqlw="exec spDesvinculacion_SolicitarResponder " & SDA_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"				
		on error resume next
		cnn.execute sqlw
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqlw%>"}<%
			rz.close
			cnn.close
			response.end()
		End If		
	end if

	if(TAD_Id=9) then
		set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar  " & ADE_Id)
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
		end if
		
		'Mensaje de aducuacion de docente
		MEN_Texto	= "Se ha rechazado la solicitado de modificación al/la facilitador/a del proyecto : " & PRY_Id
		TIP_Id		= 68	'Solicitud de modificacion de Relator rechazada
		
		set rs = cnn.Execute("exec spEncargadoActividades_SolicitarResponder " & ENC_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spDocente_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If
	end if

	if(TAD_Id=12) then
		set rs2 = cnn.Execute("exec spAdecuacionGrupoFocal_Listar  " & ADE_Id)
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
		end if
		
		'Mensaje de aducuacion de porcentaje
		MEN_Texto	= "Se ha rechazado la solicitado de modificación del porcentaje de Focalización del proyecto : " & PRY_Id
		TIP_Id		= 74	'Solicitud de modificacion de porcentaje rechazada
		
		set rs = cnn.Execute("exec spGrupoFocalPorcentaje_SolicitarResponder " & GFS_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spGrupoFocalPorcentaje_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If
	end if

	if(TAD_Id=13) then
		set rs2 = cnn.Execute("exec spAdecuacionMetodologiaPor_Listar  " & ADE_Id)
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spAdecuacionMetodologiaPor_Listar"}<%
			rs2.close
			cnn.close
			response.end()
		End If
		if not rs2.eof then
			MES_Id=rs2("MES_Id")
		end if
		
		'Mensaje de aducuacion de porcentaje
		MEN_Texto	= "Se ha rechazado la solicitado de modificación del porcentaje de Metodología del proyecto : " & PRY_Id
		TIP_Id		= 78	'Solicitud de modificacion de porcentaje rechazada
		
		set rs = cnn.Execute("exec spMetodologiaPorcentaje_SolicitarResponder " & MES_Id & ",3," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "spMetodologiaPorcentaje_SolicitarResponder"}<%
			rz.close
			cnn.close
			response.end()
		End If
	end if
	
	sqlw="exec spAdecuacionesRechazo_Modificar " & ADE_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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
	{"state": 200, "message": "Grabación de rechazo de adecuación correcta","data": null}