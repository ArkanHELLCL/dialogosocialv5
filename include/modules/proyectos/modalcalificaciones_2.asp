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
	if(xm="visualizar") or session("ds5_usrperfil")=4 then
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
		PRY_NotaActual				= rs("PRY_NotaActual")
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if
	if (IsNull(rs("PRY_NotaActual")) or rs("PRY_NotaActual")="") then
		PRY_NotaActual=0
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

	dim alumnos(100)
	dim aluest(100)
	dim alunom(100)
	dim aludv(100)
	dim alusex(100)
	TotAlu=0
	do while not rs.eof
		alumnos(TotAlu)=rs("ALU_Rut")
		aluest(TotAlu)=rs("ALU_InfoEstadoAcademico")
		alunom(TotAlu)=rs("ALU_ApellidoPaterno") & " " & rs("ALU_Nombre")
		aludv(TotAlu)=rs("ALU_Dv")
		alusex(TotAlu)=rs("SEX_Descripcion")
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

	dim sesiones(100)
	'dim sessiones_val(100)
	dim sesnom(100)
	dim sesfec(100)
	dim seshra(100)
	TotSes=0
	do while not rs3.eof
		sesiones(TotSes)= rs3("PLN_Sesion")
		sesnom(TotSes)=rs3("TEM_Nombre")
		sesfec(TotSes)=rs3("PLN_Fecha")
		seshra(TotSes)=rs3("PLN_HoraInicio")
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
	DiasMaximos = 365
	HoySql=cdate(FechaHoySQL)
	rs4.close
		
	response.write("200//")%>
	
	<table id="tbl-addcal" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="addcal">
		<thead>
			<tr>                                      	
				<th scope="col" style="text-align: center;vertical-align: top;" class="colfix">Alumno</th>
				<td style="text-align: center;vertical-align: top;">RUT</td>
				<td style="text-align: center;vertical-align: top;">Estado</td>
				<td style="text-align: center;vertical-align: top;">Asist.(%)</td>
				<td style="text-align: center;vertical-align: top;">Prom.</td><%
					if PRY_NotaActual>=1 then
						for x=0 to PRY_NotaActual-1%>
							<td scope="col" style="text-align: center;vertical-align: top;" data-sorter="false" data-filter="false">N -	<%response.Write(x+1)%></td><%											
						next
					end if%>
				<td scope="col" style="text-align: center;vertical-align: top;" data-sorter="false" data-filter="false">N(*)</td>
			  </tr>
		</thead>                                
		<tbody><%
			for i=0 to TotAlu-1%>
			<tr>
				<th><%=response.Write(alunom(i))%></th>
				<td><%=response.write(alumnos(i) & "-" & aludv(i))%></td>
				<td class="estado"><%
						if isnull(aluest(i)) or aluest(i)=0 then
							response.Write("Activo")
						else
							if aluest(i)=1 then
								response.Write("Aprobado")
							else
								if aluest(i)=2 then
									response.Write("Reprobado")
								else
									if aluest(i)=3 then
										response.Write("Desertado")
									else													
										response.Write("Sin estado")
									end if
								end if
							end if
						end if%>
				</td><%
				sql="exec spEstadoAcademicoxRut_Modificar " & alumnos(i) & "," & PRY_Id & ",'" & PRY_Identificador & "'"
				set rs2 = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
					cnn.close
					response.Write("503//Error Conexión 1:" & ErrMsg)
					response.End()
				End If
				Tot=0
				Sum=0
				sql="exec spAsistenciaRut_Listar " & PRY_Id & ",'" & PRY_Identificador & "'" & "," & alumnos(i) & ",-1"
				set rs9 = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
					cnn.close
					response.Write("503//Error Conexión 1:" & ErrMsg)
					response.End()
				End If
				do while not rs9.eof										
					Tot=Tot+1
					if rs9("ASI_Asistio")=1 or rs9("ASI_Justifica") then
						Sum=Sum+1
					else
					end if
					rs9.movenext
				loop

				if not rs2.eof then
					TotAsis=round(rs2("TotalHorasAsistidas"),1)
				end if
				'If Tot>=1 then
				If TotAsis>1 then										
					'response.Write("<td style='text-align: center;vertical-align: top;'>" & round((Sum/TotSes)*100,1) & "%</td>")
					response.Write("<td style='text-align: center;vertical-align: top;'>" & TotAsis & "%</td>")
				else
					response.Write("<td style='text-align: center;vertical-align: top;'>0%</td>")
				end if

				'Promedio de notas%>										
			<td style="text-align: center;vertical-align: top;" id="pnot-<%=alumnos(i)%>"><%
					ProNot=0
					sql="exec spNota_PromedioConsultar " & alumnos(i) & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" &  session("ds5_usrtoken") & "'"
					set rs7 = cnn.Execute(sql)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						cnn.close
						response.Write("503//Error Conexión 1:" & ErrMsg)
						response.End()
					End If									
					if not rs3.eof then										
						ProNot=rs7("NOT_Promedio")										
					else
						ProNot=0
					end if									
					response.Write(round(ProNot,1))%>
			</td><% 
				'Promedio de notas


				sql="exec spNota_Consultar " & alumnos(i) & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" &  session("ds5_usrtoken") & "'"
				'response.write(sql)
				set rs6 = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
					cnn.close
					response.Write("503//Error Conexión 1:" & ErrMsg)
					response.End()
				End If
				'Si no existe ningun registro de nota
				if rs6.eof then
					for k=1 to PRY_NotaActual
						response.write("<td style='text-align: center;vertical-align: top;' class='notcalif'>-</td>")
					next
				end if
				'Si no existe ningun registro de nota

				az=1
				ac=1										
				do while not rs6.eof
					for ax=ac to PRY_NotaActual
						az=az+1
						if rs6("NOT_Corr")=ax then
							if (isnull(rs6("NOT_Nota"))) then
								response.write("<td style='text-align: center;vertical-align: top;' class='notcalif'>-</td>")
							else
								if (isnull(aluest(i)) or aluest(i)=0) and (((Sum/TotSes)*100)>0) then
									response.write("<td style='text-align: center;vertical-align: top;'><input data-rut='" & alumnos(i) & "' data-id='" & rs6("NOT_Id") & "' type='number' step='any' value='" & replace(rs6("NOT_Nota"),",",".") & "' class='modcalif' /></td>")														
								else
									response.write("<td style='text-align: center;vertical-align: top;'>" & rs6("NOT_Nota") & "</td>")
								end if					
							end if
							exit for
						else
							response.write("<td style='text-align: center;vertical-align: top;' class='notcalif'>-</td>")
						end if												
					next
					ac=az
					rs6.movenext
				loop
				'response.write("-" & ac & "-")
				if (ac>1) and (ac<=PRY_NotaActual) then
					for x=0 to PRY_NotaActual-ac
						response.write("<td style='text-align: center;vertical-align: top;' class='notcalif'>-</td>")
					next
				end if
				'Solo si hay notas

				'Nueva columna para gregar notas
				if (isnull(aluest(i)) or aluest(i)=0) and (((Sum/TotSes)*100)>0) then%>
				<td style="text-align: center;vertical-align: top;"><input data-rut="<%=alumnos(i)%>" data-id="0" type="number" step="any" value="0" class="newcalif" /></td><%
				else%>
				<td style="text-align: center;vertical-align: top;" class="notcalif">-</td><%
				end if%>
		</tr><%									
		'end if
		next
		rs2.close%>		
	</tbody>                            
	</table><%
			
	if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>
		<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddcalificacion" name="btn_frmaddcalificacion" style="float:right;"><i class="fas fa-plus"></i> Agregar</button><%
	end if%>
	<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salircalificacion" name="btn_salircalificacion" style="float:right;"><i class="fas fa-sign-out-alt"></i> Salir</button>
	
	
