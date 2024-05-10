<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	ADE_Id 	= request("ADE_Id")
	table 	= request("table")
	TAD_Id	= request("TAD_Id")
	PRY_Id	= request("PRY_Id")
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
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
	
	if(TAD_Id=1) then
		if(LFO_Id<>11) then
			set rs2 = cnn.Execute("exec spAdecuacionPlanificacion_Listar  " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description		
				cnn.close 		
				response.end
			End If	
		end if
		if(LFO_Id=11) then
			set rs2 = cnn.Execute("exec spAdecuacionPlanTrabajo_Listar  " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description		
				cnn.close 		
				response.end
			End If	
		end if
	else
		if(TAD_Id=3) then
			set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar  " & ADE_Id)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description		
				cnn.close 		
				response.end
			End If	
		else
			if(TAD_Id=4) then
				set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar  " & ADE_Id)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description		
					cnn.close 		
					response.end
				End If	
			else
				if(TAD_Id=5) then
					if(LFO_Id<>11) then
						set rs2 = cnn.Execute("exec spAdecuacionRelator_Listar  " & ADE_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description		
							cnn.close 		
							response.end
						End If	
					end if
					if(LFO_Id=11) then
						set rs2 = cnn.Execute("exec spAdecuacionPlanTrabajo_Listar  " & ADE_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description		
							cnn.close 		
							response.end
						End If	
					end if
				else
					if(TAD_Id=6) then			 
						set rs2 = cnn.Execute("exec [spAdecuacionJustificacion_Listar]  " & ADE_Id)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description		
							cnn.close 		
							response.end
						End If	
					else
						if(TAD_Id=8) then			 
							set rs2 = cnn.Execute("exec [spAdecuacionDesvinculaAlumno_Listar]  " & ADE_Id)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description		
								cnn.close 		
								response.end
							End If	
						else
							if(TAD_Id=9) then
								set rs2 = cnn.Execute("exec spAdecuacionCambioEncargados_Listar  " & ADE_Id)
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description		
									cnn.close 		
									response.end
								End If	
							else
								if(TAD_Id=12) then
									set rs2 = cnn.Execute("exec spAdecuacionGrupoFocal_Listar  " & ADE_Id)
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description		
										cnn.close 		
										response.end
									End If	
								else
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end if
	cont=1	
	if (TAD_Id=1) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Registro</th>
					<th>#</th>
					<th>Sesion</th>
					<th>Fecha</th>
					<th>Hora Ini</th>
					<th>Hora Fin</th>
					<th>Metodología</th>
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof
				if(LFO_Id<>11) then%>
					<tr>
						<td>Original</td>
						<td><%=rs2("SPL_Id")%></td>
						<td><%=rs2("SPL_PLNSesion")%></td>
						<td><%=rs2("SPL_PLNFechaOri")%></td>
						<td><%=rs2("SPL_PLNHoraInicioOri")%></td>
						<td><%=rs2("SPL_PLNHoraFinOri")%></td>
						<td><%=rs2("MET_DescripcionOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("SPL_Id")%></td>
						<td><%=rs2("SPL_PLNSesion")%></td>
						<td><%=rs2("SPL_PLNFechaNew")%></td>
						<td><%=rs2("SPL_PLNHoraInicioNew")%></td>
						<td><%=rs2("SPL_PLNHoraFinNew")%></td>
						<td><%=rs2("MET_DescripcionNew")%></td>
					</tr><%
				end if
				if(LFO_Id=11) then%>
					<tr>
						<td>Original</td>
						<td><%=rs2("SPT_Id")%></td>						
						<td><%=rs2("SPT_TEDId")%></td>
						<td><%=rs2("SPT_TEDFechaOri")%></td>
						<td><%=rs2("SPT_TEDHoraInicioOri")%></td>
						<td><%=rs2("SPT_TEDHoraTerminoOri")%></td>				
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("SPT_Id")%></td>
						<td><%=rs2("SPT_TEDId")%></td>
						<td><%=rs2("SPT_TEDFechaNew")%></td>
						<td><%=rs2("SPT_TEDHoraInicioNew")%></td>
						<td><%=rs2("SPT_TEDHoraTerminoNew")%></td>					
					</tr><%
				end if
				rs2.movenext
			loop	
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=3) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Registro</th>
					<th>Nombre</th>
					<th>Mail</th>
					<th>Telefono</th>
					<th>Sexo</th><%
					if(LFO_Id<>11) then%>
						<th>Adjunto</th><%
					else%>
						<th>Nivel Educacional</th>
						<th>Nombre Carrera</th><%
					end if%>
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof
				if(LFO_Id<>11) then%>
					<tr>
						<td>Original</td>
						<td><%=rs2("ENC_EncargadoProyectoOri")%></td>
						<td><%=rs2("ENC_EncargadoProyectoMailOri")%></td>
						<td><%=rs2("ENC_EncargadoProyectoCelularOri")%></td><%
						if(rs2("ENC_EncargadoProyectoSexoOri")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if%>
						<td><%=rs2("ENC_EncargadoProyectoAdjuntoOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("ENC_EncargadoProyectoNew")%></td>
						<td><%=rs2("ENC_EncargadoProyectoMailNew")%></td>
						<td><%=rs2("ENC_EncargadoProyectoCelularNew")%></td><%
						if(rs2("ENC_EncargadoProyectoSexoNew")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if%>
						<td><%=rs2("ENC_EncargadoProyectoAdjuntoNew")%></td>
					</tr><%
				else%>
					<tr>
						<td>Original</td>
						<td><%=rs2("ENC_EncargadoProyectoOri")%></td>
						<td><%=rs2("ENC_EncargadoProyectoMailOri")%></td>
						<td><%=rs2("ENC_EncargadoProyectoCelularOri")%></td><%
						if(rs2("ENC_EncargadoProyectoSexoOri")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if
						if(rs2("ENC_EncargadoProyectoNivelEducacionalOri")="" or IsNULL(rs2("ENC_EncargadoProyectoNivelEducacionalOri"))) then
							ENC_EncargadoProyectoNivelEducacionalOri="NULL"
						else
							ENC_EncargadoProyectoNivelEducacionalOri=rs2("ENC_EncargadoProyectoNivelEducacionalOri")
						end if						
						set rs9 = cnn.Execute("exec spEducacion_Consultar " & ENC_EncargadoProyectoNivelEducacionalOri)		
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close%>
							{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
							response.End() 	
						End If%>
						<td><%=rs9("EDU_Nombre")%></td>
						<td><%=rs2("ENC_EncargadoProyectoCarreraOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("ENC_EncargadoProyectoNew")%></td>
						<td><%=rs2("ENC_EncargadoProyectoMailNew")%></td>
						<td><%=rs2("ENC_EncargadoProyectoCelularNew")%></td><%
						if(rs2("ENC_EncargadoProyectoSexoNew")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if
						if(rs2("ENC_EncargadoProyectoNivelEducacionalNew")="" or IsNULL(rs2("ENC_EncargadoProyectoNivelEducacionalNew"))) then
							ENC_EncargadoProyectoNivelEducacionalNew="NULL"
						else
							ENC_EncargadoProyectoNivelEducacionalNew=rs2("ENC_EncargadoProyectoNivelEducacionalNew")
						end if						
						set rs9 = cnn.Execute("exec spEducacion_Consultar " & ENC_EncargadoProyectoNivelEducacionalNew)						
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close%>
							{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
							response.End() 	
						End If%>
						<td><%=rs9("EDU_Nombre")%></td>						
						<td><%=rs2("ENC_EncargadoProyectoCarreraNew")%></td>
					</tr><%
				end if
				rs2.movenext
			loop	
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=4) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Registro</th>
					<th>Nombre</th>
					<th>Mail</th>
					<th>Telefono</th>
					<th>Sexo</th><%
					if(LFO_Id<>11) then%>
						<th>Adjunto</th><%
					else%>
						<th>Nivel Educacional</th>
						<th>Nombre Carrera</th><%
					end if%>
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof
				if(LFO_Id<>11) then%>
					<tr>
						<td>Original</td>
						<td><%=rs2("ENC_EncargadoActividadesOri")%></td>
						<td><%=rs2("ENC_EncargadoActividadesMailOri")%></td>
						<td><%=rs2("ENC_EncargadoActividadesCelularOri")%></td><%
						if(rs2("ENC_EncargadoActividadesSexoOri")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if%>
						<td><%=rs2("ENC_EncargadoActividadesAjuntoOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("ENC_EncargadoActividadesNew")%></td>
						<td><%=rs2("ENC_EncargadoActividadesMailNew")%></td>
						<td><%=rs2("ENC_EncargadoActividadesCelularNew")%></td><%
						if(rs2("ENC_EncargadoActividadesSexoNew")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if%>
						<td><%=rs2("ENC_EncargadoActividadesAjuntoNew")%></td>
					</tr><%
				else%>
					<tr>
						<td>Original</td>
						<td><%=rs2("ENC_EncargadoActividadesOri")%></td>
						<td><%=rs2("ENC_EncargadoActividadesMailOri")%></td>
						<td><%=rs2("ENC_EncargadoActividadesCelularOri")%></td><%
						if(rs2("ENC_EncargadoActividadesSexoOri")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if
						if(rs2("ENC_EncargadoActividadesNivelEducacionalOri")="" or IsNULL(rs2("ENC_EncargadoActividadesNivelEducacionalOri"))) then
							ENC_EncargadoActividadesNivelEducacionalOri="NULL"
						else
							ENC_EncargadoActividadesNivelEducacionalOri=rs2("ENC_EncargadoActividadesNivelEducacionalOri")
						end if						
						set rs9 = cnn.Execute("exec spEducacion_Consultar " & ENC_EncargadoActividadesNivelEducacionalOri)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close%>
							{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
							response.End() 	
						End If%>
						<td><%=rs9("EDU_Nombre")%></td>						
						<td><%=rs2("ENC_EncargadoActividadesCarreralOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("ENC_EncargadoActividadesNew")%></td>
						<td><%=rs2("ENC_EncargadoActividadesMailNew")%></td>
						<td><%=rs2("ENC_EncargadoActividadesCelularNew")%></td><%
						if(rs2("ENC_EncargadoActividadesSexoNew")=1) then%>
							<td>Femenino</td><%
						else%>
							<td>Masculino</td><%
						end if
						if(rs2("ENC_EncargadoActividadesNivelEducacionalNew")="" or IsNULL(rs2("ENC_EncargadoActividadesNivelEducacionalNew"))) then
							ENC_EncargadoActividadesNivelEducacionalNew="NULL"
						else
							ENC_EncargadoActividadesNivelEducacionalNew=rs2("ENC_EncargadoActividadesNivelEducacionalNew")
						end if						
						set rs9 = cnn.Execute("exec spEducacion_Consultar " & ENC_EncargadoActividadesNivelEducacionalNew)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close%>
							{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
							response.End() 	
						End If%>
						<td><%=rs9("EDU_Nombre")%></td>					
						<td><%=rs2("ENC_EncargadoActividadesCarreralNew")%></td>
					</tr><%
				end if
				rs2.movenext
			loop	
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=5) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Registro</th>
					<th>#</th>
					<th>Sesion</th>
					<th>Relator</th>
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof
				if(LFO_Id<>11) then%>
					<tr>
						<td>Original</td>
						<td><%=rs2("SPL_Id")%></td>
						<td><%=rs2("SPL_PLNSesion")%></td>
						<td><%=rs2("REL_NombresOri") & " " & rs2("REL_PaternoOri") & " " & rs2("REL_MaternoOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("SPL_Id")%></td>
						<td><%=rs2("SPL_PLNSesion")%></td>
						<td><%=rs2("REL_NombresNew") & " " & rs2("REL_PaternoNew") & " " & rs2("REL_MaternoNew")%></td>
					</tr><%
				end if
				if(LFO_Id=11) then%>
					<tr>
						<td>Original</td>
						<td><%=rs2("SPT_Id")%></td>						
						<td><%=rs2("SPT_TEDId")%></td>						
						<td><%=rs2("REL_NombresOri") & " " & rs2("REL_PaternoOri") & " " & rs2("REL_MaternoOri")%></td>
					</tr>
					<tr>
						<td>Modificación</td>
						<td><%=rs2("SPT_Id")%></td>						
						<td><%=rs2("SPT_TEDId")%></td>						
						<td><%=rs2("REL_NombresNew") & " " & rs2("REL_PaternoNew") & " " & rs2("REL_MaternoNew")%></td>
					</tr><%
				end if
				rs2.movenext
			loop	
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=6) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>RUT</th>
					<th>Nombre</th>
					<th>Paterno</th>
					<th>Materno</th>
					<th>Sesion</th>
					<th>Dia</th>
					<th>Módulo</th>					
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof%>
				<tr>
					<td><%=rs2("ALU_Rut")%>-<%=rs2("ALU_DV")%></td>
					<td><%=rs2("ALU_Nombre")%></td>
					<td><%=rs2("ALU_ApellidoPaterno")%></td>
					<td><%=rs2("ALU_ApellidoMaterno")%></td>
					<td><%=rs2("PLN_Sesion")%></td>
					<td><%=rs2("PLN_Fecha")%></td>
					<td><%if (rs2("TEM_Nombre")<>"") then
							response.write(rs2("TEM_Nombre"))
						else
							response.write(rs2("TPR_Nombre"))
						end if
					%></td>
				</tr><%
				rs2.movenext
			loop
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=8) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Id</th>
					<th>RUT</th>
					<th>Nombre</th>
					<th>Paterno</th>
					<th>Materno</th>										
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof%>
				<tr>
					<td><%=rs2("SDA_APRIdOri")%></td>
					<td><%=rs2("SDA_ALURutOri")%>-<%=rs2("ALU_DV")%></td>
					<td><%=rs2("ALU_Nombre")%></td>
					<td><%=rs2("ALU_ApellidoPaterno")%></td>
					<td><%=rs2("ALU_ApellidoMaterno")%></td>					
				</tr><%
				rs2.movenext
			loop
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=9) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Registro</th>
					<th>Nombre</th>
					<th>Mail</th>
					<th>Telefono</th>
					<th>Sexo</th>										
					<th>Nivel Educacional</th>
					<th>Nombre Carrera</th>
					<th>Especialización</th>
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof%>
				<tr>
					<td>Original</td>
					<td><%=rs2("ENC_FacilitadorOri")%></td>
					<td><%=rs2("ENC_FacilitadorMailOri")%></td>
					<td><%=rs2("ENC_FacilitadorCelularOri")%></td><%
					if(rs2("ENC_FacilitadorSexoOri")=1) then%>
						<td>Femenino</td><%
					else%>
						<td>Masculino</td><%
					end if
					if(rs2("ENC_FacilitadorNivelEducacionalOri")="" or IsNULL(rs2("ENC_FacilitadorNivelEducacionalOri"))) then
						ENC_FacilitadorNivelEducacionalOri="NULL"
					else
						ENC_FacilitadorNivelEducacionalOri=rs2("ENC_FacilitadorNivelEducacionalOri")
					end if
					set rs9 = cnn.Execute("exec spEducacion_Consultar " & ENC_FacilitadorNivelEducacionalOri)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description	   
						cnn.close%>
						{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
						response.End() 	
					End If%>
					<td><%=rs9("EDU_Nombre")%></td>
					<td><%=rs2("ENC_FacilitadorCarreraOri")%></td><%
					if(rs2("ENC_FacilitadorFormacionEspecializadaOri")=1) then%>
						<td>Si</td><%
					else%>
						<td>No</td><%
					end if%>
				</tr>
				<tr>
					<td>Modificación</td>
					<td><%=rs2("ENC_FacilitadorNew")%></td>
					<td><%=rs2("ENC_FacilitadorMailNew")%></td>
					<td><%=rs2("ENC_FacilitadorCelularNew")%></td><%
					if(rs2("ENC_FacilitadorSexoNew")=1) then%>
						<td>Femenino</td><%
					else%>
						<td>Masculino</td><%
					end if
					if(rs2("ENC_FacilitadorNivelEducacionalNew")="" or IsNULL(rs2("ENC_FacilitadorNivelEducacionalNew"))) then
						ENC_FacilitadorNivelEducacionalNew="NULL"
					else
						ENC_FacilitadorNivelEducacionalNew=rs2("ENC_FacilitadorNivelEducacionalNew")
					end if
					set rs9 = cnn.Execute("exec spEducacion_Consultar " & ENC_FacilitadorNivelEducacionalNew)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description	   
						cnn.close%>
						{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
						response.End() 	
					End If%>
					<td><%=rs9("EDU_Nombre")%></td>						
					<td><%=rs2("ENC_FacilitadorCarreraNew")%></td><%
					if(rs2("ENC_FacilitadorFormacionEspecializadaNew")=1) then%>
						<td>Si</td><%
					else%>
						<td>No</td><%
					end if%>
				</tr><%				
				rs2.movenext
			loop	
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if
	if (TAD_Id=12) then%>
		<table class="table table-striped" id="<%=table%>">
			<thead>
				<tr>
					<th>Registro</th>
					<th>#</th>
					<th>Porcentaje</th>					
				</tr>
			</thead>
			<tbody><%
			do while not rs2.eof%>
				<tr>
					<td>Original</td>
					<td><%=rs2("GFS_Id")%></td>					
					<td><%=rs2("GFS_GRFPorcentajeOri")%></td>					
				</tr>
				<tr>
					<td>Modificación</td>
					<td><%=rs2("GFS_Id")%></td>					
					<td><%=rs2("GFS_GRFPorcentajeNew")%></td>					
				</tr><%
				rs2.movenext
			loop
			rs2.Close
			cnn.Close%>

			</tbody>
		</table><%
	end if%>