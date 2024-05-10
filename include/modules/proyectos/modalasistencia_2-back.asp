<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	if(session("ds5_usrperfil")=5) then	'Adminsitrativo
	   response.Write("403\\Error Perfil no autorizado")
	   response.End() 
	end if
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
		modo=4
		mode="vis"
	end if		
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_InformeInicioEstado		= rs("PRY_InformeInicioEstado")		
		PRY_InformeFinalEstado		= rs("PRY_InformeFinalEstado")
		PRY_Identificador			= rs("PRY_Identificador")
		PRY_Estado					= rs("PRY_Estado")
		LFO_Id						= rs("LFO_Id")
		LIN_DiasIngresoAsistencia	= rs("LIN_DiasIngresoAsistencia")
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if
	if(LIN_DiasIngresoAsistencia="" or IsNULL(LIN_DiasIngresoAsistencia)) then
		LIN_DiasIngresoAsistencia=365
	end if	
	
	sql="exec spAlumnoProyecto_Listar " & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close
		response.Write("503//Error Conexión 1:" & ErrMsg)
	   	response.End() 
	End If

	dim alumnos(200)
	dim aluest(200)
	dim aluestid(200)
	dim alunom(200)
	dim aludv(200)
	dim alusex(200)
	dim aluasis(200)
	TotAlu=0
	do while not rs.eof
		alumnos(TotAlu)=rs("ALU_Rut")		
		alunom(TotAlu)=rs("ALU_ApellidoPaterno") & " " & rs("ALU_Nombre")
		aludv(TotAlu)=rs("ALU_Dv")
		alusex(TotAlu)=rs("SEX_Descripcion")
		
		set ry = cnn.Execute("exec spEstadosAlumnoProyecto_Listar " & rs("ALU_Rut") & "," & PRY_Id)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			response.write("Error AlumnoProyecto")
			cnn.close 		
			response.end
		End If	
		if not ry.eof then
			aluest(TotAlu) = ry("TES_Descripcion")		'Primer registro, utimo en ingresar
			aluestid(TotAlu) = ry("EST_Estado")
		end if
		
		
		sql="exec spEstadoAcademicoxRut_Modificar " & rs("ALU_Rut") & "," & PRY_Id & ",'" & PRY_Identificador & "'"
		set rs2 = cnn.Execute(sql)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			response.write("Error spEstadoAcademicoxRut_Modificar")
			cnn.close 		
			response.end
		End If		
		TotAsis=0								
		if not rs2.eof then
			TotAsis=round(rs2("TotalHorasAsistidas"),1)
		end if
		rs2.close
		if TotAsis>=1 then											
			aluasis(TotAlu) = TotAsis & "%"
		else
			aluasis(TotAlu) = "0%"
		end if	
		
		TotAlu=TotAlu+1
		rs.movenext			
	loop
	rs.close

	sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs3 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close
	   	response.Write("503//Error Conexión 1:" & ErrMsg)
	   	response.End() 
	End If	

	dim sesiones(200)
	'dim sessiones_val(200)
	dim sesnom(200)
	dim sesfec(200)
	dim seshra(200)
	TotSes=0
	do while not rs3.eof
		sesiones(TotSes)= rs3("PLN_Sesion")
		sesnom(TotSes)	= rs3("TEM_Nombre")
		sesfec(TotSes)	= rs3("PLN_Fecha")
		seshra(TotSes)	= rs3("PLN_HoraInicio")
		TotSes=TotSes+1
		rs3.movenext
	loop
	rs3.close

	sql="exec spFecha_Obtener"
	set rs4 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close
	   	response.Write("503//Error Conexión 1:" & ErrMsg)
	   	response.End() 
	End If	
	dia=trim(rs4("dia"))
	if len(dia)=1 then
		dia="0" & dia
	end if
	mes=trim(rs4("mes"))
	if len(mes)=1 then
		mes="0" & mes
	end if		
	ano=trim(rs4("año"))
	FechaHoySQL = ano & "-" & mes & "-" & dia
	'DiasMaximos = 7
	'DiasMaximos = 365
	DiasMaximos = LIN_DiasIngresoAsistencia
	'HoySql=cdate(FechaHoySQL)
	rs4.close
		
	response.write("200//")%>
	
	<table id="tbl-modasis" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="modasis">
		<thead>
			<tr>				
				<th colspan="5">Evidencias</th><%
				TotArc=0
				for k=1 to TotSes
					sql="exec spEvidenciaAsistencia_Consultar " & PRY_Id & ",'" & PRY_Identificador & "',95," & sesiones(k-1)
					set rs2 = cnn.Execute(sql)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						cnn.close
						response.Write("503//Error Conexión 1:" & ErrMsg)
						response.End() 
					End If
					dbfileName=""
					if not rs.eof then
						dbfileName=rs2("EVI_Nombre")
					end if										
					if dbfileName<>"" then
						colorup="text-white-50"
						disabledup="disabled"
						cursorup="not-allowed"
						tooltipup=""

						colordw="text-success"
						disableddw=""
						cursordw="pointer"
						tooltipdw="Bajar Evidencia de " & sesnom(k-1)

						colordel="text-danger"
						disableddel=""
						cursordel="pointer"
						tooltipdel="Eliminar Evidencia de " & sesnom(k-1)						

						'background="#b0e0b0;"
						background="transparent"
						
						TotArc=TotArc+1						
					else
						colorup="text-primary"
						disabledup=""
						cursorup="pointer"
						tooltipup="Subir Evidencia de " & sesnom(k-1)

						colordw="text-white-50"
						disableddw="disabled"
						cursordw="not-allowed"
						tooltipdw=""

						colordel="text-white-50"
						disableddel="disabled"
						cursordel="not-allowed"
						tooltipdel=""
						functiondel=""

						'background="#2577d466"
						background="transparent"						
					end if
					%>
				<th style="text-align: center;padding: 0;margin: 0;background-color:<%=background%>;" id="evi-<%=sesiones(k-1)%>" name="evi-<%=sesiones(k-1)%>" class="evi" data-sesion="<%=sesiones(k-1)%>"><%
					if(mode="mod") then%>
						<i class="fas fa-cloud-upload-alt upload <%=colorup%>" style="cursor:<%=cursorup%>" title="<%=tooltipup%>" id="upd_evi-<%=sesiones(k-1)%>" name="upd_evi-<%=sesiones(k-1)%>" data-modulo="<%=sesiones(k-1)%>" data-mode="upload" data-modulodes="<%=sesnom(k-1)%>" <%=disabledup%> data-sesion="<%=sesiones(k-1)%>"></i><%
					else%>
						<i class="fas fa-cloud-upload-alt text-white-50" style=";cursor:not-allowed" disabled></i><%
					end if%>
					<i class="fas fa-cloud-download-alt download <%=colordw%>" style="cursor:<%=cursordw%>" title="<%=tooltipdw%>" id="dwn_evi-<%=sesiones(k-1)%>" name="dwn_evi-<%=sesiones(k-1)%>" data-modulo="<%=sesiones(k-1)%>" data-mode="download" data-modulodes="<%=sesnom(k-1)%>" <%=disableddw%> data-sesion="<%=sesiones(k-1)%>" data-arc="<%=dbfileName%>"></i><span style="display:none"><%=dbfileName%></span>
					<%if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) and (mode="mod") then%>
						<i class="fas fa-trash delete <%=colordel%>" style="cursor:<%=cursordel%>" title="<%=tooltipdel%>" id="del_evi-<%=sesiones(k-1)%>" name="del_evi-<%=sesiones(k-1)%>" data-modulo="<%=sesiones(k-1)%>" data-mode="delete" data-modulodes="<%=sesnom(k-1)%>" <%=disableddel%> data-sesion="<%=sesiones(k-1)%>"></i><%
					else%>
						<i class="fas fa-trash text-white-50>" style="cursor:not-allowed" disabled></i><%
					end if%>
				</th><%
				next%>
			</tr>
			<tr>
				<th>Hidden</th>
				<th style="text-align: center;vertical-align: top;">Alumno</th>
				<th style="text-align: center;vertical-align: top;">RUT</th>
				<th style="text-align: center;vertical-align: top;">Estado</th>
				<th style="text-align: center;vertical-align: top;">Asist.<br/>(%)</th><%
					for j=0 to TotSes-1%>
						<th style="text-align: center;vertical-align: top;"><%=response.Write(sesnom(j) & " [" & sesfec(j) & "/" & seshra(j) & "]")%></th><%
					next%>                                        
			  </tr>
		</thead>                                
		<tbody><%
			for i=0 to TotAlu-1%>
			<tr><%
				if(aluestid(i)=6) then
					colorx="rgba(217, 83, 79, .3)"
					colory="red"
				else
					colorx="transparent"
					colory=""
				end if%>
				<td></td>
				<th style="background:<%=color%>"><%=response.Write(alunom(i))%></th>
				<td style="background:<%=color%>"><%=response.write(alumnos(i) & "-" & aludv(i))%></td>
				<th style="background:<%=colorx%>;color:<%=colory%>"><%=response.Write(aluest(i))%></th>
				<td style="background:<%=color%>" id="por-<%=alumnos(i)%>" style="text-align: center;" data-asis="0" class="rut" data-rut="<%=alumnos(i)%>">
					<%=response.Write(aluasis(i))%>
				</td><%										                                        
					p=0
					TotAsis=0
						for k=p to TotSes-1												                                                
							sql="exec spAsistenciaRut_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & alumnos(i) & "," & sesiones(k)
							set rs2 = cnn.Execute(sql)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								cnn.close
								response.Write("503//Error Conexión 1:" & ErrMsg)
								response.End() 
							End If

							'Dias=datediff("d",cdate(trim(sesfec(k))),HoySql)												
							sql99="select dbo.fnDiasHabiles_Consultar('" & trim(sesfec(k)) & "', 1, 1) as DiasHabiles"
							set rs99 = cnn.Execute(sql99)
							on error resume next
							'if cnn.Errors.Count > 0 then 
							''	ErrMsg = cnn.Errors(0).description
							''	cnn.close
							''	response.Write("503//Error Conexión 1:" & ErrMsg)
							''	response.End() 
							'End If
							Dias=0
							if not rs99.eof then
								Dias = rs99("DiasHabiles")
							end if
							
							if not rs2.eof then
								'if (Dias<=DiasMaximos and Dias>=0 and (isnull(aluest(i)) or aluest(i)=0)) or (session("ds5_usrperfil")<>4 or session("ds5_usrperfil")<>5) then 'Solo auditor y administrativo no puede modificar la asistencia
								if (Dias<=DiasMaximos and Dias>=0 and aluestid(i)<>6) and (session("ds5_usrperfil")<>2 and session("ds5_usrperfil")<>4 and session("ds5_usrperfil")<>5) then								
									if rs2("ASI_Asistio")=1 or rs2("ASI_Justifica") then
										TotAsis=TotAsis+1
										if rs2("ASI_Justifica") then
											response.write("<td style='text-align: center;background:" & color & "' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-indigo'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox' checked disabled='disabled'> <span class='checkbox'></span></label></div><span style='display:none'>Si-1</span></td>")
										else
											response.write("<td style='text-align: center;background:" & color & "' class='abierto modreg' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox' checked> <span class='checkbox'></span></label></div><span style='display:none'>Si-2</span></td>")
										end if
									else
										response.write("<td style='text-align: center;background:" & color & "' class='abierto modreg' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox'> <span class='checkbox'></span></label></div><span style='display:none'>No-1</span></td>")															
									end if
								else													
									if rs2("ASI_Asistio")=1 or rs2("ASI_Justifica") then
										TotAsis=TotAsis+1
										if rs2("ASI_Justifica") then
											chkcolor="indigo"
										else
											chkcolor="amber"
										end if
										response.write("<td style='text-align: center;background:" & color & "' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-" & chkcolor & "'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox' checked disabled='disabled'> <span class='checkbox'></span></label></div><span style='display:none'>Si-3</span></td>")
									else
										'response.write("<td style='text-align: center;background:" & color & "' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-amber'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox' disabled='disabled'> <span class='checkbox'></span></label></div><span style='display:none'>No-2</span></td>")
										response.write("<td style='text-align: center;background:" & color & "' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'>-<span style='display:none'>No-2</span></td>")
									end if
								end if
								'exit for
							else
								if (Dias<=DiasMaximos and Dias>=0 and aluestid(i)<>6) then								
								'if (Dias<=DiasMaximos and Dias>=0 and (isnull(aluest(i)) or aluest(i)=0)) then
								'if (Dias<=DiasMaximos and Dias=0 and (isnull(aluest(i)) or aluest(i)=0)) then
									response.write("<td style='text-align: center;background:" & color & "' class='abierto newreg' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox'> <span class='checkbox'></span></label></div><span style='display:none'>No-3</span></td>")
								else
									'if session("ds5_usrperfil")<>3 then
									''	response.write("<td style='text-align: center;' class='abierto newreg' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox'> <span class='checkbox'></span></label></div><span style='display:none'>No-4</span></td>")	
									'else										
									'if(aluestid(i)<>6) then										
									''	response.write("<td style='text-align: center;' data-rut='" & alumnos(i) & "' data-sesion='" & sesiones(k) & "'><div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-amber'><input id='S-" & sesiones(k) & "R-" & alumnos(i) & "' name='S-" & sesiones(k) & "R-" & alumnos(i) & "' type='checkbox' disabled='disabled'> <span class='checkbox'></span></label></div><span style='display:none'>No-2</span></td>")
									'else
										response.Write("<td style='text-align: center;background:" & color & "'>")
										response.write("-")
										response.Write("</td>")
									'end if
								end if
							end if											
						next%>     											
			</tr><%								
			next
			rs2.close%>			
	</tbody>                            
	</table><%
			
	if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) and (mode="mod") then%>
		<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddasistencia" name="btn_frmaddasistencia"><i class="fas fa-plus"></i> Agregar</button><%
	else%>
		<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddasistencia" name="" disabled><i class="fas fa-plus"></i> Agregar</button><%
	end if%>
	<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salirasistencia" name="btn_salirasistencia"><i class="fas fa-sign-out-alt"></i> Salir</button>
	
	
