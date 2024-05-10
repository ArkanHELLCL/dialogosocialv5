<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if
	
	Dim ruta
	Dim streamFile, fileItem, filePath, up
	Dim sFileName

	Set up = New FreeASPUpload
	up.Upload()

	Response.Flush	
	
	PRY_Id						= up.form("PRY_Id")	
	PRY_Identificador			= up.form("PRY_Identificador")
	TAD_Id						= up.form("TAD_Id")
	ADE_DescripcionAdecuacion	= LimpiarUrl(up.form("ADE_DescripcionAdecuacion"))
	ADE_JustificacionAdecuacion	= LimpiarUrl(up.form("ADE_JustificacionAdecuacion"))
	
	'Datos adecuacion de calendarización para escuela y cursos
	PLN_Sesion        	= up.form("PLN_Sesion")
	PLN_Fecha         	= up.form("PLN_Fecha")
	PLN_HoraInicio    	= up.form("PLN_HoraInicio")
	PLN_HoraFin       	= up.form("PLN_HoraFin")	
	PLN_Estado        	= up.form("PLN_Estado")
	MET_Id				= up.form("MET_Id")
	
	'Datos adecuacion de calendarización para mesas
	TED_Id				= up.form("TED_Id")
	TED_Fecha			= up.form("TED_FechaAde")
	TED_HoraInicio		= up.form("TED_HoraInicio")
	TED_HoraTermino		= up.form("TED_HoraTermino")
	
	'Datos adecuacion de relator para mesas
	TED_Relator			= LimpiarUrl(up.form("TED_Relator"))
	
	'Datos Justificacion inasistencia
	ALU_Rut				= up.form("ALU_Rut")
	PLN_Sesion        	= up.form("PLN_Sesion")
	
	'Datos Docente/Relator
	PLN_NombreDocente	= LimpiarUrl(up.form("PLN_NombreDocente"))		'Ya no se utiliza
	REL_Id				= up.form("REL_Id")
	
	'Datos Coordinador de Proyecto
	PRY_EncargadoProyecto			 = LimpiarUrl(up.form("PRY_EncargadoProyecto"))
	PRY_EncargadoProyectoMail		 = up.form("PRY_EncargadoProyectoMail")
	PRY_EncargadoProyectoCelular	 = up.form("PRY_EncargadoProyectoCelular")
	SEX_IdEncargadoProyecto			 = up.form("SEX_IdEncargadoProyectoADE")
	EDU_IdEncargadoProyecto			 = up.form("EDU_IdEncargadoProyecto")
	PRY_EncargadoProyectoCarrera	 = up.form("PRY_EncargadoProyectoCarrera")
	
	'Datos Encargado de actividades
	PRY_EncargadoActividades		 = LimpiarUrl(up.form("PRY_EncargadoActividades"))
	PRY_EncargadoActividadesMail	 = up.form("PRY_EncargadoActividadesMail")
	PRY_EncargadoActividadesCelular	 = up.form("PRY_EncargadoActividadesCelular")
	SEX_IdEncargadoActividades		 = up.form("SEX_IdEncargadoActividadesADE")
	EDU_IdEncargadoActividades		 = up.form("EDU_IdEncargadoActividades")
	PRY_EncargadoActividadesCarrera	 = up.form("PRY_EncargadoActividadesCarrera")
	
	'Datos facilitador
	PRY_Facilitador					 = up.form("PRY_Facilitador")
	PRY_FacilitadorMail				 = up.form("PRY_FacilitadorMail")
	SEX_IdFacilitador				 = up.form("SEX_IdFacilitadorADE")
	PRY_FacilitadorCelular			 = up.form("PRY_FacilitadorCelular")
	EDU_IdFacilitador				 = up.form("EDU_IdFacilitador")
	PRY_FacilitadorCarrera			 = up.form("PRY_FacilitadorCarrera")
	PRY_FacilitidorForEsp			 = up.form("PRY_FacilitidorForEspADE")
	
	'Datos Desvinculacion Alumno	
	ALU_RutDes						 = up.form("ALU_RutDes")
	
	'Adjuntos
	EAD_AdjuntoX					 = up.form("EAD_AdjuntoX")
	CAD_AdjuntoX					 = up.form("CAD_AdjuntoX")
	FAD_AdjuntoX					 = up.form("FAD_AdjuntoX")
	ADE_AdjuntoX					 = up.form("ADE_AdjuntoX")

	EAD_Y 	  				 		= up.form("EAD_Adjunto")
	CAD_Y 					 		= up.form("CAD_Adjunto")
	FAD_Y 					 		= up.form("FAD_Adjunto")
	ADE_Y 					 		= up.form("ADE_Adjunto")

	'Porcentaje de focalización
	GRF_Porcentaje					= up.form("GRF_Porcentaje")

	if(EAD_Y<>"") then	
		EAD_AdjuntoY	= CInt(EAD_Y)
	else
		EAD_AdjuntoY	= 0
	end if
	if(CAD_Y<>"") then	
		CAD_AdjuntoY	= CInt(CAD_Y)
	else
		CAD_AdjuntoY	= 0
	end if
	if(FAD_Y<>"") then	
		FAD_AdjuntoY	= CInt(FAD_Y)
	else
		FAD_AdjuntoY	= 0
	end if
	if(ADE_Y<>"") then	
		ADE_AdjuntoY	= CInt(ADE_Y)
	else
		ADE_AdjuntoY	= 0
	end if	 					 
	
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
		ErrMsg = cnn.Errors(0).description	   
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		response.End() 	
	End If
	if not rs.eof then
		LFO_Id=rs("LFO_Id")
	end if

	'Mensaje de adecuacion de calendarizacion
	if(TAD_Id=1) then
		if(LFO_Id<>11) then
			MEN_Texto	= "Se ha solicitado una modificación a la planificación del proyecto : " & PRY_Id & ", en la sesión nro : " & PLN_Sesion
			TIP_Id		= 40	'Solicitud de modificacion de planificacion
			MEN_Archivo	= ""		
		end if
		if(LFO_Id=11) then
			MEN_Texto	= "Se ha solicitado una modificación al plan de trabajo del proyecto : " & PRY_Id & ", con el id nro : " & TED_Id
			TIP_Id		= 56	'Solicitud de modificacion de plan de trabajo
			MEN_Archivo	= ""		
		end if
	end if
	
	'Mensaje de adecuacion Encargado de actividades
	if(TAD_Id=3) then	
		MEN_Texto	= "Se ha solicitado una modificación al Coordinador del proyecto : " & PRY_Id
		TIP_Id		= 48	'Solicitud de modificacion del coordinador del proyecto
		MEN_Archivo	= ""
	end if
	
	'Mensaje de adecuacion Encargado de actividades
	if(TAD_Id=4) then	
		MEN_Texto	= "Se ha solicitado una modificación al Encargado de Actividades del proyecto : " & PRY_Id
		TIP_Id		= 51	'Solicitud de modificacion de encargado de activiades
		MEN_Archivo	= ""
	end if
	
	'Mensaje de adecuacion de Docente/Relator
	if(TAD_Id=5) then
		if(LFO_Id<>11) then
			MEN_Texto	= "Se ha solicitado una modificación al Relator del proyecto : " & PRY_Id & ", en la sesión nro : " & PLN_Sesion
			TIP_Id		= 45	'Solicitud de modificacion de Relator
			MEN_Archivo	= ""
		end if
		if(LFO_Id=11) then
			MEN_Texto	= "Se ha solicitado una modificación al Relator del proyecto : " & PRY_Id & ", en el plan de trabajo id nro : " & TED_Id
			TIP_Id		= 45	'Solicitud de modificacion de Relator
			MEN_Archivo	= ""
		end if
	end if
	
	'Mensaje de adecuacion de justificacion de inasistencia
	if(TAD_Id=6) then	
		MEN_Texto	= "Se ha solicitado una justificación de inasistendia al rut : " & ALU_Rut & ", en la sesión nro : " & PLN_Sesion
		TIP_Id		= 33	
		MEN_Archivo	= ""
		RutSplit = split(ALU_Rut,"-")
		ALU_Rut = RutSplit(0)
	end if
	
	'Mensaje de adecuacion
	if(TAD_Id=7) then	
		MEN_Texto	= "Se ha solicitado una adecuación"
		TIP_Id		= 2	
		MEN_Archivo	= ""		
	end if
	
	'Mensaje de adecuacion de justificacion de inasistencia
	if(TAD_Id=8) then	
		MEN_Texto	= "Se ha solicitado una desvinculación del alumno rut : " & ALU_RutDes & ", al proyecto nro : " & PRY_Id
		TIP_Id		= 59	
		MEN_Archivo	= ""
		RutSplit = split(ALU_RutDes,"-")
		ALU_RutDes = RutSplit(0)
	end if
	
	'Mensaje de adecuacion de facilitador
	if(TAD_Id=9) then	
		MEN_Texto	= "Se ha solicitado una modificación al Facilitador del proyecto : " & PRY_Id
		TIP_Id		= 62	
		MEN_Archivo	= ""		
	end if
	
	'Mensaje de adecuacion de facilitador
	if(TAD_Id=10) then	
		MEN_Texto	= "Se ha solicitado una modificación a una red de apoyo : " & PRY_Id
		TIP_Id		= 63	
		MEN_Archivo	= ""		
	end if
	
	'Mensaje de adecuacion de facilitador
	if(TAD_Id=11) then	
		MEN_Texto	= "Se ha solicitado una modificación a un representante : " & PRY_Id
		TIP_Id		= 64
		MEN_Archivo	= ""		
	end if

	'Mensaje de adecuacion de porcentaje de focalización
	if(TAD_Id=12) then	
		MEN_Texto	= "Se ha solicitado una modificación al porcentaje de focalización : " & PRY_Id
		TIP_Id		= 72
		MEN_Archivo	= ""		
	end if
	
	if(TAD_Id=1 or TAD_Id=5) then
		if(LFO_Id<>11) then
			'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
			set rs = cnn.Execute("exec spPlanificacion_SolicitudPendiente " & PLN_Sesion & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
				response.End() 	
			End If
			if not rs.eof then%>
				{"state": 10, "message": "Error: Existe una planificación pendiente para esta sesión","data": "Sesion :<%=PLN_Sesion%> - Solicitud:<%=rs("SPL_Id")%>"}<%
				rs.close
				cnn.close
				response.end()
			end if	
		end if
		if(LFO_Id=11) then
			'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
			set rs = cnn.Execute("exec spPlanTrabajo_SolicitudPendiente " & TED_Id & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
				response.End() 	
			End If
			if not rs.eof then%>
				{"state": 10, "message": "Error: Existe una planificación pendiente para este plan de trabajo","data": "ID :<%=TED_Id%> - Solicitud:<%=rs("SPL_Id")%>"}<%
				rs.close
				cnn.close
				response.end()
			end if	
		end if
	end if
	
	if(TAD_Id=3) then	'Coordinador del proyecto	
		'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
		set rs = cnn.Execute("exec spEncargados_SolicitudPendiente " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description	   
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
			response.End() 	
		End If
		if not rs.eof then
			if(rs("ENC_EncargadoProyectoNew")<>"") then%>
				{"state": 10, "message": "Error: Existe una solicitud pendiente para este proyecto","data": "Solicitud:<%=rs("ENC_Id")%>"}<%
				rs.close
				cnn.close
				response.end()
			end if
		end if	
	end if
	
	if(TAD_Id=4) then	'Encargado de actividades	
		'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
		set rs = cnn.Execute("exec spEncargados_SolicitudPendiente " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description	   
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
			response.End() 	
		End If
		if not rs.eof then
			if(rs("ENC_EncargadoActividadesNew")<>"") then%>
				{"state": 10, "message": "Error: Existe una solicitud pendiente para este proyecto","data": "Solicitud:<%=rs("ENC_Id")%>"}<%
				rs.close
				cnn.close
				response.end()
			end if
		end if	
	end if
	
	if(TAD_Id=6) then	'Asistencia		
		'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
		set rs = cnn.Execute("exec spAsistencia_SolicitudPendiente " & PRY_Id & "," & ALU_RUT & "," & PLN_Sesion & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description	   
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
			response.End() 	
		End If
		if not rs.eof then%>
			{"state": 10, "message": "Error: Existe una solicitud pendiente para esta sesión de este alumno","data": "Sesion:<%=rs("PLN_Sesion")%> - RUT:<%=rs("ALU_Rut")%>"}<%
			rs.close
			cnn.close
			response.end()
		end if
	end if
	
	if(TAD_Id=8) then	'Desvinculación		
		'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
		set rs = cnn.Execute("exec spDesvinculacion_SolicitudPendiente " & PRY_Id & "," & ALU_RUTDes & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description	   
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
			response.End() 	
		End If
		if not rs.eof then%>
			{"state": 10, "message": "Error: Existe una solicitud pendiente para esta este alumno en este proyecto","data": "Proyecto<%=rs("SDA_PRYIdOri")%> - RUT:<%=rs("SDA_ALURutOri")%>"}<%
			rs.close
			cnn.close
			response.end()
		end if
	end if
	
	if(TAD_Id=9) then	'Facilitador
		'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
		set rs = cnn.Execute("exec spEncargados_SolicitudPendiente " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description	   
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
			response.End() 	
		End If
		if not rs.eof then
			if(rs("ENC_FacilitadorNew")<>"") then%>
				{"state": 10, "message": "Error: Existe una solicitud pendiente para este proyecto","data": "Solicitud:<%=rs("ENC_Id")%>"}<%
				rs.close
				cnn.close
				response.end()
			end if
		end if	
	end if

	if(TAD_Id=12) then	'Porcentaje de Focalización
		'Antes de agregar una nueva solicitud se verifica que la adecuacion no tenga una adecuacion pendiente.
		set rs = cnn.Execute("exec spGrupoFocalPorcentaje_SolicitudPendiente " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description	   
			cnn.close%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "Solicitudes Pendientes"}<%
			response.End() 	
		End If
		if not rs.eof then
			if(rs("GFS_GRFPorcentajeNew")<>"") then%>
				{"state": 10, "message": "Error: Existe una solicitud pendiente para este proyecto","data": "Solicitud:<%=rs("GFS_Id")%>"}<%
				rs.close
				cnn.close
				response.end()
			end if
		end if	
	end if
	
	sqx="exec [spAdecuaciones_Agregar] " & PRY_Id & "," & TAD_Id & ",'" & ADE_DescripcionAdecuacion & "','" & ADE_JustificacionAdecuacion & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sqx)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	if not rx.eof then
		ADE_Id = trim(rx("ADE_Id"))
	end if	
	
	'rescatando noombre de archivo de encargados, si es que existen
	EAD_AdjuntoX=""
	CAD_AdjuntoX=""
	FAD_AdjuntoX=""
	fileItems = up.UploadedFiles.Items
	ultimo = ubound(fileItems)
	if(ultimo>=0) then
		'Encargado	
		if(ADE_AdjuntoY=1) and (EAD_AdjuntoY=1)  then												
			set EAD_Adjunto = fileItems(0)
			'EAD_Adjunto.Path = path
			EAD_AdjuntoX = EAD_Adjunto.FileName			
		end if				
		'Coordinador	
		if(ADE_AdjuntoY=1) and (CAD_AdjuntoY=1)  then									
			set CAD_Adjunto = fileItems(0)
			'CAD_Adjunto.Path = path
			CAD_AdjuntoX = CAD_Adjunto.FileName			
		end if		
		'Facilitador	
		if(ADE_AdjuntoY=1) and (FAD_AdjuntoY=1)  then											
			set FAD_Adjunto = fileItems(0)
			'FAD_Adjunto.Path = path
			FAD_AdjuntoX = FAD_Adjunto.FileName			
		end if
	end if		
	
	'Logica para Calendarizacion
	if(TAD_Id=1) then
		if(LFO_Id<>11) then
			'Grabar cambios solicitados en tabla
			datos =  PLN_Sesion & "," & PRY_Id & ",'" & PLN_Fecha & "','" & PLN_HoraInicio & "','" & PLN_HoraFin & "'," & MET_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			sqz = "exec spPlanificacion_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				SPL_Id = trim(rz("SPL_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or SPL_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - SPL_Id : <%=SPL_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionPlanificacion_Agregar " & ADE_Id & "," & SPL_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
		if(LFO_Id=11) then
			'Grabar cambios solicitados en tabla calendarización
			datos =  TED_Id & "," & PRY_Id & ",'" & TED_Fecha & "','" & TED_HoraInicio & "','" & TED_HoraTermino & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			sqz = "exec spPlanTrabajoFechaHora_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				SPT_Id = trim(rz("SPT_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or SPT_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - SPT_Id : <%=SPT_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionPlanTrabajo_Agregar " & ADE_Id & "," & SPT_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
	end if
	
	'Logica para Coordinador de Proyecto
	if(TAD_Id=3) then
		if(LFO_Id<>11) then
			'Grabar cambios solicitados en tabla
			datos =  PRY_Id & ",'" & PRY_EncargadoProyecto & "','" & PRY_EncargadoProyectoMail & "','" & PRY_EncargadoProyectoCelular & "'," & SEX_IdEncargadoProyecto & ",'" & CAD_AdjuntoX & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			
			sqz = "exec spEncargadoProyecto_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				ENC_Id = trim(rz("ENC_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or ENC_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - ENC_Id : <%=ENC_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionCambioEncargados_Agregar " & ADE_Id & "," & ENC_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If		
		end if
		if(LFO_Id=11) then
			'Grabar cambios solicitados en tabla
			datos =  PRY_Id & ",'" & PRY_EncargadoProyecto & "','" & PRY_EncargadoProyectoMail & "','" & PRY_EncargadoProyectoCelular & "'," & SEX_IdEncargadoProyecto & "," & EDU_IdEncargadoProyecto & ",'" & PRY_EncargadoProyectoCarrera & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			
			sqz = "exec spEncargadoProyectoMesas_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				ENC_Id = trim(rz("ENC_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or ENC_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - ENC_Id : <%=ENC_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionCambioEncargados_Agregar " & ADE_Id & "," & ENC_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
	end if
	
	'Logica para Encargado de actividades
	if(TAD_Id=4) then
		if(LFO_Id<>11) then
			'Grabar cambios solicitados en tabla
			datos =  PRY_Id & ",'" & PRY_EncargadoActividades & "','" & PRY_EncargadoActividadesMail & "','" & PRY_EncargadoActividadesCelular & "'," & SEX_IdEncargadoActividades & ",'" & EAD_AdjuntoX & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			sqz = "exec spEncargadoActividades_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				ENC_Id = trim(rz("ENC_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or ENC_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - ENC_Id : <%=ENC_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionCambioEncargados_Agregar " & ADE_Id & "," & ENC_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
		if(LFO_Id=11) then
			'Grabar cambios solicitados en tabla
			datos =  PRY_Id & ",'" & PRY_EncargadoActividades & "','" & PRY_EncargadoActividadesMail & "','" & PRY_EncargadoActividadesCelular & "'," & SEX_IdEncargadoActividades & "," & EDU_IdEncargadoActividades & ",'" & PRY_EncargadoActividadesCarrera & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			sqz = "exec spEncargadoActividadesMesas_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				ENC_Id = trim(rz("ENC_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or ENC_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - ENC_Id : <%=ENC_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionCambioEncargados_Agregar " & ADE_Id & "," & ENC_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
	end if
	
	'Logica para Relator/Docente
	if(TAD_Id=5) then
		if(LFO_Id<>11) then
			'Grabar cambios solicitados en tabla
			datos =  PLN_Sesion & "," & PRY_Id & ",'" & PLN_NombreDocente & "'," & REL_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			sqz = "exec spDocente_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				SPL_Id = trim(rz("SPL_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or SPL_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - SPL_Id : <%=SPL_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionRelator_Agregar " & ADE_Id & "," & SPL_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
		if(LFO_Id=11) then
			
		end if
	end if
	
	'Logica para Justificacion de inasistencia
	if(TAD_Id=6) then
		'graba solicitud de justificacion de inasistencia en tabla asistencai (legado)
		ASI_MotivoJustificacion=""
		ASI_RutaArchivo=""
		sql="exec spSolicita_Justificacion " & PRY_Id & ",'" & PRY_Identificador & "'," & ALU_Rut & "," & PLN_Sesion & ",'" & ASI_MotivoJustificacion & "','" & ASI_RutaArchivo & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
		set rz = cnn.Execute(sql)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rz.close
			cnn.close
			response.end()
		End If
		
		'Grabar tabla relacion entre la solicitud y la modificacion
		sqw="exec spAdecuacionJustificacion_Agregar " & ADE_Id & "," & PLN_Sesion & "," & PRY_Id & "," & ALU_Rut & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rw = cnn.Execute(sqw)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
			rw.close
			cnn.close
			response.end()
		End If		
	end if
	
	'Logica para Desvinculacion
	if(TAD_Id=8) then
		'graba solicitud de desvinculacion tabla SolicitudDesvinculaAlumno
		ASI_MotivoJustificacion=""
		ASI_RutaArchivo=""
		sql="exec [spSolicitudDesvinculaAlumno_Agregar] " & ALU_RutDes & "," & PRY_Id  & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 				
		set rz = cnn.Execute(sql)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
			rz.close
			cnn.close
			response.end()
		End If
		if not rz.eof then
			SDA_Id = trim(rz("SDA_Id"))
		end if	
		
		'Verificando que se hayan creado correctamente los registros en las tablas anteiores
		if(ADE_Id="" or SDA_Id="") then%>
			{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - SDA_Id : <%=SDA_Id%>"}<%		
			response.end()
		end if
		
		'Grabar tabla relacion entre la solicitud y la modificacion AdecuacionDesvinculaAlumno 
		sqw="exec spAdecuacionDesvinculaAlumno_Agregar " & ADE_Id & "," & SDA_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"				
		set rw = cnn.Execute(sqw)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
			rw.close
			cnn.close
			response.end()
		End If		
	end if
	
	If(LFO_Id=11) then
		if(TAD_Id=9) then
			'Grabar cambios solicitados en tabla
			datos =  PRY_Id & ",'" & PRY_Facilitador & "','" & PRY_FacilitadorMail & "','" & PRY_FacilitadorCelular & "'," & SEX_IdFacilitador & "," & EDU_IdFacilitador & ",'" & PRY_FacilitadorCarrera & "'," & PRY_FacilitidorForEsp & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"						

			sqz = "exec spFacilitadorMesas_SolicitarModificar " & datos
			set rz = cnn.Execute(sqz)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
				rz.close
				cnn.close
				response.end()
			End If
			if not rz.eof then
				ENC_Id = trim(rz("ENC_Id"))
			end if	

			'Verificando que se hayan creado correctamente los registros en las tablas anteiores
			if(ADE_Id="" or ENC_Id="") then%>
				{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - ENC_Id : <%=ENC_Id%>"}<%		
				response.end()
			end if

			'Grabar tabla relacion entre la solicitud y la modificacion
			sqw="exec spAdecuacionCambioEncargados_Agregar " & ADE_Id & "," & ENC_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rw = cnn.Execute(sqw)	
			on error resume next
			if cnn.Errors.Count > 0 then
				ErrMsg = cnn.Errors(0).description%>
				{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
				rw.close
				cnn.close
				response.end()
			End If
		end if
	end if

	if(TAD_Id=12) then
		'Grabar cambios solicitados en tabla
		datos =  PRY_Id & "," & GRF_Porcentaje & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"						

		sqz = "exec spGrupoFocalPorcentaje_SolicitarModificar " & datos
		set rz = cnn.Execute(sqz)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqz%>"}<%
			rz.close
			cnn.close
			response.end()
		End If
		if not rz.eof then
			GFS_Id = trim(rz("GFS_Id"))
		end if	

		'Verificando que se hayan creado correctamente los registros en las tablas anteiores
		if(ADE_Id="" or GFS_Id="") then%>
			{"state": 11, "message": "Error: Creación incompleta","data": "ADE_Id : <%=ADE_Id%> - GFS_Id : <%=GFS_Id%>"}<%		
			response.end()
		end if

		'Grabar tabla relacion entre la solicitud y la modificacion
		sqw="exec spAdecuacionGrupoFocal_Agregar " & ADE_Id & "," & GFS_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rw = cnn.Execute(sqw)	
		on error resume next
		if cnn.Errors.Count > 0 then
			ErrMsg = cnn.Errors(0).description%>
			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqw%>"}<%
			rw.close
			cnn.close
			response.end()
		End If
	end if
	
	'Rescatando carpeta del proyecto
	sql="exec spProyectoCarpeta_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		LIN_AgregaTematica=rs("LIN_AgregaTematica")
		
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\adecuaciones\ade-" & ADE_Id & "\"
	else%>
	   	{"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
		
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f

	folders = Split(path, "\")
	currentFolder = ""
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	For i = 0 To UBound(folders)
		currentFolder = currentFolder & folders(i)
		'response.write("</br>" & currentFolder & "</br>")
		If fs.FolderExists(currentFolder) <> true Then
			Set f=fs.CreateFolder(currentFolder)
			Set f=nothing       
		End If      
		currentFolder = currentFolder & "\"
	Next

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe	

	ruta=path				
	up.Save(ruta)	'Subiendo archivo	
	
	'Creando mensaje de Solicitud de adecuacion
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
	{"state": 200, "message": "Grabación de solicitud de adecuación correcta","data": null}