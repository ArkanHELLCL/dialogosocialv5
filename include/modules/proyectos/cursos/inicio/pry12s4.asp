<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	PRY_Identificador=request("PRY_Identificador")
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="vis"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"		
		action="/mod-12-h1-s4"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		mode="vis"
		modo=4
		disabled="readonly disabled"		
	end if	
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
	end if
				
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	
	lblClass=""
	if(mode="mod" or mode="vis") then
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)		
		on error resume next
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & sql)
		   response.End() 			   
		end if		
		if not rs.eof then	
			PRY_HorasPedagogicasMinPRY=rs("PRY_HorasPedagogicasMin")
			PRY_PorcentajeMinOnline=rs("PRY_PorcentajeMinOnline")
			PRY_PorcentajeMinPresencial=rs("PRY_PorcentajeMinPresencial")
			MET_Id=rs("MET_Id")
			MET_Descripcion=rs("MET_Descripcion")
		end if			
		
		sql="exec spPlanificacionPlantillaCreacion_Listar " & LIN_Id
		set rs = cnn.Execute(sql)
		'response.write(sql)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description			
			cnn.close 			   
			response.Write("503//Error Conexión:" & ErrMsg)
			response.End()
		End If
		PRY_HorasPedagogicasMinTEM=0
		do while not rs.eof		
			PRY_HorasPedagogicasMinTEM=PRY_HorasPedagogicasMinTEM+CInt(rs("TEM_Horas"))		
			rs.movenext
		loop
		
		if(PRY_HorasPedagogicasMinPRY<>PRY_HorasPedagogicasMinTEM) then
			'Actualizando dato en tabla proyecto
			sql="exec [spProyectoHorasPedagogicas_Modificar] " & PRY_Id & "," & PRY_HorasPedagogicasMinTEM & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
			set rs = cnn.Execute(sql)
			'response.write(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description			
				cnn.close 			   
				response.Write("503//Error Conexión:" & ErrMsg)
				response.End()
			End If					
		end if
		
		PRY_HorasPedagogicasMin=PRY_HorasPedagogicasMinTEM
							
		sqlx="exec [spPlanificacionResumenMetodologia_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'"
		set rw = cnn.Execute(sqlx)
		on error resume next
		if cnn.Errors.Count > 0 then 		
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & sqlx)
		   response.End() 			   
		end if
		if not rw.EOF then
			TotalModulos=rw("ModuloCant")
			TotalPerspectivas=rw("PerspectivasCant")
			TotalTematicas=rw("TematicasCant")
			ModuloHoras=rw("ModuloHoras")
			FechaInicio=rw("FechaInicio")
			FechaFin=rw("FechaFin")		
			Horas_Pedagogicas=rw("Horas_Pedagogicas")
		else
			TotalModulos=0
			TotalPerspectivas=0
			TotalTematicas=0
			ModuloHoras=0
			FechaInicio=0
			FechaFin=0	
			Horas_Pedagogicas=0
		end if
		if(IsNULL(ModuloHoras)) then
			ModuloHoras=0
		end if
		if(IsNULL(Horas_Pedagogicas)) then
			Horas_Pedagogicas=0
		end if
		if(IsNULL(FechaInicio)) then
			FechaInicio="Sin inicio"
		end if
		if(IsNULL(FechaFin)) then
			FechaFin="Sin fin"
		end if
		rw.movefirst

		sqly="exec spPlanificacionSesiones_Total " & PRY_Id & ",'" & PRY_Identificador & "'"
		set rs = cnn.Execute(sqly)
		on error resume next
		if cnn.Errors.Count > 0 then 		
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & sqly)
		   response.End() 			   
		end if
		if not rs.EOF then
			TotalPlantilla=rs("TotalPlantilla")
			TotalPlanificado=rs("TotalPlanificado")
		end if		
		
		if(Horas_Pedagogicas<PRY_HorasPedagogicasMin) then
			dif=1
			background_hra="rgba(92, 184, 92, .3);"
		else
			background_hra="rgba(217, 83, 79, .3);"
		end if
				
		if(TotalTematicas<TotalPlantilla) then
			background_tem="rgba(217, 83, 79, .3);"
		else
			background_tem="rgba(92, 184, 92, .3);"
		end if
	end if
	
	rs.close
	response.write("200/@/")			
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)	
	'response.end
%>
<form role="form" action="<%=action%>" method="POST" name="frm12s4" id="frm12s4" class="needs-validation">
	<h5>Planificación</h5>
	<h6>La Planificación incompleta se representa con fondo rojo</h6>
	<div class="row px-4" style="padding-top:30px;padding-bottom:30px;">
		<table id="tbl-planificacionPry" class="ts table table-striped table-bordered dataTable table-sm" data-id="planificacionPry" data-page="true" data-selected="true" data-keys="1"> 
			<thead>				
				<tr>
					<th rowspan="1" scope="row" style="text-align: center;vertical-align: middle;"></th>
					<th style="text-align: center;vertical-align: middle;">Cursos</th>
					<th style="text-align: center;vertical-align: middle;">Perspectivas</th>
					<th style="text-align: center;vertical-align: middle;">Módulos (<%=TotalPlantilla%>)</th>
					<th style="text-align: center;vertical-align: middle;">Total Horas</th>
					<th style="text-align: center;vertical-align: middle;">Horas Pedagógicas (<%=PRY_HorasPedagogicasMin%>)</th>
					<th style="text-align: center;vertical-align: middle;">Fecha Inicio</th>
					<th style="text-align: center;vertical-align: middle;">Fecha Término</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>Totales</th>
					<td><%=TotalModulos%></td>
					<td><%=TotalPerspectivas%></td>
					<td style="background:<%=background_tem%>"><%=TotalTematicas%></td>
					<td><%=ModuloHoras%></td>
					<td style="background:<%=background_hra%>"><%=Horas_Pedagogicas%></td>
					<td><%=FechaInicio%></td>
                    <td><%=FechaFin%></td>
				</tr>
			</tbody>					
		</table>
	</div>
	<h5>Metodología: <%=MET_Descripcion%></h5>
	<h6>Segregación de horas pedagógicas por tipo de metodología</h6>
	<div class="row px-4" style="padding-top:30px;padding-bottom:30px;">
		<table id="tbl-planificacionPryMet" class="ts table table-striped table-bordered dataTable table-sm" data-id="planificacionPryMet" data-page="true" data-selected="true" data-keys="1"> 
			<thead>
				<tr>
					<th scope="row" style="text-align: center;vertical-align: middle;">Metodología</th>
					<th scope="row" style="text-align: center;vertical-align: middle;">Total Horas</th>
					<th scope="row" style="text-align: center;vertical-align: middle;">Total Horas Pedadgógicas</th>
					<th scope="row" style="text-align: center;vertical-align: middle;">% Horas Pedadgógicas</th>
					<th scope="row" style="text-align: center;vertical-align: middle;">% Mínimo Exigido</th>
				</tr>
			</thead>
			<tbody><%
				TotalHoras=0
				TotalHorasPedagogica=0
				TotalPorMin = 0
				TotalPorHoras = 0
				salir = false
				imprimir = false
				porerror=0
				PorMinArray=array(PRY_PorcentajeMinOnline,PRY_PorcentajeMinPresencial)
				vacio=array(true,true)				
				do while not rw.eof
					PorMin = 0
					if(MET_Id=3) then
						if(rw("MET_Id")=1) then
							PorMin = PRY_PorcentajeMinOnline
							vacio(0)=false
						end if
						if(rw("MET_Id")=2) then
							PorMin = PRY_PorcentajeMinPresencial
							vacio(1)=false
						end if
						salir = false
						imprimir = true
					else
						if(MET_Id=1) then
							vacio(1)=false		'Solo online
							if(rw("MET_Id")=1) then
								PorMin = PRY_PorcentajeMinOnline
								vacio(0)=false
								salir = true
								imprimir = true
							else
								imprimir = false
							end if							
						end if
						if(MET_Id=2) then
							vacio(0)=false		'Solo presencial
							if(rw("MET_Id")=2) then
								PorMin = PRY_PorcentajeMinPresencial
								vacio(1)=false
								salir = true
								imprimir = true
							else
								imprimir = false
							end if							
						end if
					end if
					if(imprimir) then						
						if(round((CDbl(rw("TotalHorasPedagogicasMET"))/PRY_HorasPedagogicasMin)*100)<round(CDbl(PorMin),1)) then
							porerror=1
							background_por="rgba(217, 83, 79, .3);"
						else
							background_por="rgba(92, 184, 92, .3);"
						end if%>
						<tr>
							<td><%=rw("MET_Descripcion")%></td>
							<td><%=round(CDbl(rw("TotalHorasMET")),1)%></td>
							<td><%=round(rw("TotalHorasPedagogicasMET"),1)%></td>
							<td style="background:<%=background_por%>"><%
								if(PRY_HorasPedagogicasMin>0) then%>
									<%=round((CDbl(rw("TotalHorasPedagogicasMET"))/PRY_HorasPedagogicasMin)*100)%>%</td><%
								else%>
									0%</td><%
								end if%>
							<td><%=PorMin%>%</td>
						</tr><%
					end if
					TotalHoras = TotalHoras + round(CDbl(rw("TotalHorasMET")),1)
					TotalHorasPedagogica = TotalHorasPedagogica + round(CDbl(rw("TotalHorasPedagogicasMET")),1)
					TotalPorMin = TotalPorMin + round(CDbl(PorMin ),1)
					if(PRY_HorasPedagogicasMin>0) then
						TotalPorHoras = round(TotalPorHoras + round((CDbl(rw("TotalHorasPedagogicasMET"))/PRY_HorasPedagogicasMin)*100),1)
					else
						TotalPorHoras = round(TotalPorHoras,1)
					end if
					if(salir) then
						exit do
					end if
					rw.movenext
				loop
				for i=0 to 1
					if(vacio(i)) then
						porerror=1
						background_por="rgba(217, 83, 79, .3);"										
						sqlz="exec spMetodologia_Consultar " & i+1
						set sr = cnn.Execute(sqlz)						
						on error resume next%>
						<tr>
							<td><%=sr("MET_Descripcion")%></td>
							<td>0</td>
							<td>0</td>
							<td style="background:<%=background_por%>"><%
								if(PRY_HorasPedagogicasMin>0) then%>
									0%</td><%
								else%>
									0%</td><%
								end if%>
							<td><%=PorMinArray(sr("MET_Id")-1)%>%</td>
						</tr><%												
						TotalHoras = TotalHoras + round(CDbl(rw("TotalHorasMET")),1)
						TotalHorasPedagogica = TotalHorasPedagogica + round(CDbl(rw("TotalHorasPedagogicasMET")),1)
						TotalPorMin = TotalPorMin + round(CDbl(PorMin ),1)
						if(PRY_HorasPedagogicasMin>0) then
							TotalPorHoras = round(TotalPorHoras + round((CDbl(rw("TotalHorasPedagogicasMET"))/PRY_HorasPedagogicasMin)*100),1)
						else
							TotalPorHoras = round(TotalPorHoras,1)
						end if
					end if
				next
				if(MET_Id=3) then%>
					<tr>
						<td>Totales</td>
						<td><%=TotalHoras%></td>
						<td><%=TotalHorasPedagogica%></td>
						<td style="background:<%=background_por%>"><%=TotalPorHoras%>%</td>
						<td><%=TotalPorMin%>%</td>
					</tr><%
				end if%>
			</tbody>
		</table>
	</div>
	<h5>Detalle de la Planificación</h5>
	<h6>La Planificación incompleta se representa con fondo rojo</h6>
	<!--container-nav-->
	<div class="container-nav px-4" id="planificacion-tab" style="margin-top:30px;margin-bottom:30px;">
		<div class="header">				
			<div class="content-nav"><%
				sqly="exec spPlanificacionModuloResumen_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
				set rs = cnn.Execute(sqly)
				on error resume next
				if cnn.Errors.Count > 0 then 		
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión:" & sqly)
				   response.End() 			   
				end if
				cont=1
				do while not rs.eof
					TematicasPendientes=rs("TematicasPendientes")
					if(cont=1) then
						active="active"
					else
						active=""
					end if
					cont=cont+1%>
					<a id="planificacion1-tab<%=rs("MOD_Id")%>" href="#planificaciontab<%=rs("MOD_Id")%>" class="<%=active%> tab"><i class="fas fa-book-reader"></i> <%=rs("MOD_Nombre")%></a><%					
					rs.movenext
				loop%>								
				<span class="yellow-bar"></span>				
			</div>	
		</div>
		<!--tab-content-->
		<div class="tab-content tab-validate"><%
			'set rs = cnn.Execute("exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'")		
			Set rs = Server.CreateObject("ADODB.Recordset")
			on error resume next
			if cnn.Errors.Count > 0 then 		
			   ErrMsg = cnn.Errors(0).description	   
			   cnn.close
			   response.Write("503/@/Error Conexión:" & ErrMsg)
			   response.End() 			   
			end if
			MOD_Id=0
			PER_Id=0
			TEM_Id=0
			corr=0
			sw=0
			Modulo=1
			TemPen = 0

			rs.CursorType = 1
			rs.CursorLocation = 3
			rs.Open "exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'", cnn
			do while not rs.eof                                	
				if MOD_Id<>rs("MOD_Id") then 'Cambio de Modulo - Nueva tabla
					if MOD_id<>0 then	'No es el primero
						Modulo=Modulo+1%>
								</tr>
							</tbody>
						</table>
						</div>
						<!--tab--><%
					end if%>
					<div id="planificaciontab<%=rs("MOD_Id")%>" class="tabs-pane">
					<table id="tbl-plan-<%=rs("MOD_Id")%>" class="table-striped table-bordered table-sm" data-id="plan-<%=rs("MOD_Id")%>" data-page="false" data-selected="false" data-keys="0" width="100%" style="margin-top:20px;"> 
						<thead> 							
							<tr>
								<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Perspectiva</td>
								<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Módulo</td>
								<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Metodología</td>
								<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Minutos Panificados</td>
								<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Max H.Ped. (M.Reales)</td>
								<td data-sorter="false" data-filter="false" style="text-align: center;vertical-align: middle;">Diferencia</td>
							</tr>
						</thead>
						<tbody>
							<tr><%						
				end if								
				if PER_Id<>rs("PER_Id") then	'Cambio de perspectiva
					if PER_Id<>0 then		'No es el primero
							sw=1%>
							</tr>
							<tr><%
					end if
					if rs("TematicaProyecto")=1 then
						'set rs2 = cnn.Execute("exec spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & rs("PER_Id"))	
						set rs2 = cnn.Execute("exec [spTematicaProyectoPlanificacion_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'," & rs("PER_Id"))							
						on error resume next
						if cnn.Errors.Count > 0 then 					
							ErrMsg = cnn.Errors(0).description	   
							cnn.close
							response.Write("503/@/Error Conexión:" & ErrMsg)
							response.End() 			   
						end if
					else
						'set rs2 = cnn.Execute("exec spTematica_Listar " & rs("PER_Id") & ",1")	'Solo las tematicas activas
						set rs2 = cnn.Execute("exec [spTematicaPlanificacion_Listar] " & PRY_Id & "," & rs("PER_Id") & ",1")	'Solo las tematicas activas
						on error resume next
						if cnn.Errors.Count > 0 then 					
							ErrMsg = cnn.Errors(0).description	   
							cnn.close
							response.Write("503/@/Error Conexión:" & ErrMsg)
							response.End() 			   
						end if	
					end if

					TEM_Tot=0
					do while not rs2.eof
						TEM_Tot=TEM_Tot+1
						rs2.movenext
					loop
					if(TEM_Tot=0) then
						TEM_Tot=1
					end if%>                             			
					<th rowspan="<%=TEM_Tot%>" scope="row" style="text-align: center;vertical-align: middle;" id="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></th><%
				end if				
				'Busqueda de tematicas planificadas
				'set rsx = cnn.Execute("exec spTotalHorasTematica_Calcular " & rs("TEM_Id") & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
				set rsx = cnn.Execute("exec spTotalHorasTematicaMetodologia_Calcular " & rs("TEM_Id") & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
				on error resume next
				if cnn.Errors.Count > 0 then 					
					ErrMsg = cnn.Errors(0).description	   
					cnn.close
					response.Write("503/@/Error Conexión:" & ErrMsg)
					response.End() 			   
				end if							
				background="rgba(92, 184, 92, .3);"
				Diferencia=round((rs("TEM_Horas")*45),2) * -1
				TotalMinutosPlanificados=0
				TotalMinutosTematica=0				
				if rsx.eof then
					sesion=1
					TemPen = TemPen + 1
					background="rgba(217, 83, 79, .3);"
					if (TEM_Id<>rs("TEM_Id"))  then
						if (TEM_Id<>0 and PER_Id=rs("PER_Id")) then%>
							</tr>
							<tr><%
						end if%>
						<th rowspan="<%=sesion%>" scope="row" style="text-align: center;vertical-align: middle;font-size: 12px;font-weight: initial;background:<%=background%>;" id="<%=TEM_Id%>"><%=rs("TEM_Nombre")%></th><%
					end if%>
					<td style="background-color:<%=background%>;color:<%=color%>"><%=MET_Descripcion%></td>
					<td style="background-color:<%=background%>;color:<%=color%>"><%=TotalMinutosPlanificados%></td>
					<td style="background-color:<%=background%>;color:<%=color%>"><%=TotalMinutosTematica%></td>
					<td style="background-color:<%=background%>;color:<%=color%>"><%=Diferencia%></td><%						
				else
					sesion=1
					Diferencia=0
					TotalMinutosPlanificados=0
					final=false
					MET_Id=0						
					do while not rsx.eof							
						TotalMinutosPlanificados=TotalMinutosPlanificados+rsx("TotalMinutosPlanificados")
						TotalMinutosTematica=rsx("TotalMinutosTematica")			
						imprime=false
						sw=0
						if (TEM_Id<>rs("TEM_Id"))  then
							sw=1	
							if(MET_Id<>rsx("MET_Id") and MET_Id<>0) then
								sw=3%>
								</tr>
								<tr><%
							end if		
							if (TEM_Id<>0 and PER_Id=rs("PER_Id") and sw<>3)  then
								sw=2%>
								</tr>
								<tr><%
							end if
							imprime=true
						end if						
						Diferencia = TotalMinutosPlanificados-TotalMinutosTematica
						if Diferencia<0 then											
							background="rgba(217, 83, 79, .3);"
						else
							background="rgba(92, 184, 92, .3);"
						end if
						if(imprime) then%>
							<th rowspan="<%=sesion%>" scope="row" style="text-align: center;vertical-align: middle;font-size: 12px;font-weight: initial;background:<%=background%>;" id="<%=TEM_Id%>"><%=rs("TEM_Nombre")%></th><%
						end if%>
						<td style="background-color:<%=background%>;color:<%=color%>"><%=rsx("MET_Descripcion")%></td>
						<td style="background-color:<%=background%>;color:<%=color%>"><%=TotalMinutosPlanificados%></td>
						<td style="background-color:<%=background%>;color:<%=color%>"><%=TotalMinutosTematica%></td>
						<td style="background-color:<%=background%>;color:<%=color%>"><%=Diferencia%></td><%
						MET_Id=rsx("MET_Id")
						rsx.movenext												
					loop
					if(Diferencia<0) then
						TemPen = TemPen + 1
					end if
				end if				
				'Busqueda de tematicas planificadas								
				MOD_Id=rs("MOD_Id")
				PER_Id=rs("PER_Id")
				TEM_Id=rs("TEM_Id")
				corr=corr+1									
				rs.movenext
			loop%>
			</tr>
			</tbody>
			</table>
			</div>
			<!--tab-->
		</div>
		<!--tab-content-->
	</div>
	<!--container-nav-->		
	<div class="row px-4">
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s4" name="btn_frm12s4"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="Step" name="Step" value="4" />
	<input type="hidden" id="PRY_Hito" name="PRY_Hito" value="1" />	
	
	<input type="hidden" id="Horas_Pedagogicas" name="Horas_Pedagogicas" value="<%=Horas_Pedagogicas%>" />	
	<input type="hidden" id="PRY_HorasPedagogicasMin" name="PRY_HorasPedagogicasMin" value="<%=PRY_HorasPedagogicasMin%>" />
	<input type="hidden" id="TemPen" name="TemPen" value="<%=TemPen%>" />
	<input type="hidden" id="TotalPlantilla" name="TotalPlantilla" value="<%=TotalPlantilla%>" />
	<input type="hidden" id="porerror" name="porerror" value="<%=porerror%>" />
		
</form>

<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var bb = String.fromCharCode(92) + String.fromCharCode(92);	
	
	var error = false;
	
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});	
	$(function(){
		if(document.getElementById("Horas_Pedagogicas")){			
			if(Number($('#Horas_Pedagogicas').val().replace(",","."))<Number($('#PRY_HorasPedagogicasMin').val().replace(",","."))){				
				Toast.fire({
				  icon: 'warning',
				  title: 'El total de horas pedagógicas planificadas es menor al requerido (<%=PRY_HorasPedagogicasMin%>)'
				});
				error = true
			}
		}
		
		if(!error){
			if(document.getElementById("TemPen")){			
				if(Number($('#TemPen').val().replace(",","."))>0){				
					Toast.fire({
					  icon: 'warning',
					  title: 'El total de módulos planificados es menor al requerido (<%=TotalPlantilla%>)'
					});
					error = true
				}
			}
		}

		if(!error){
			if(document.getElementById("porerror")){			
				if(Number($('#porerror').val().replace(",","."))>0){				
					Toast.fire({
					  icon: 'warning',
					  title: 'El porcentaje de horas planificadas es menor al requerido'
					});
					error = true
				}
			}
		}
	});
	
	$(document).ready(function() {
		var dif=<%=dif%>;
		if(dif==1){
			$("#planificacion-tab").tabsmaterialize({menumovil:false},function(){});
		}
		$("#btn_frm12s4").click(function(){
			formValidate("#frm12s4")
			if($("#frm12s4").valid()){
				if(Number($('#Horas_Pedagogicas').val().replace(",","."))<Number($('#PRY_HorasPedagogicasMin').val().replace(",","."))){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'La planificación esta incompleta.',						
						text:'El total de horas pedagógicas planificadas es menor al requerido (<%=PRY_HorasPedagogicasMin%>)'
					});	
				}else{
					if(Number($('#TemPen').val().replace(",","."))>0){
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'La planificación esta incompleta.',						
							text:'El total de módulos planificados es menor al requerido (<%=TotalTematicas%> de <%=TotalPlantilla%>)'
						});
					}else{
						if(Number($('#porerror').val().replace(",","."))>0){				
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'La planificación esta incompleta.',						
								text:'El porcentaje total de módulos planificados es menor al requerido'
							});
						}else{						
							var bb = String.fromCharCode(92) + String.fromCharCode(92);
							$.ajax({
								type: 'POST',			
								url: $("#frm12s4").attr("action"),
								data: $("#frm12s4").serialize(),
								success: function(data) {					
									param=data.split(bb)
									if(param[0]=="200"){
										Toast.fire({
										icon: 'success',
										title: 'Planificación grabadas correctamente'
										});
										var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:1};							
										$.ajax( {
											type:'POST',					
											url: '/mnu-12',
											data: data,
											success: function ( data ) {
												param = data.split(sas)
												if(param[0]==200){						
													$("#pry-menucontent").html(param[1]);
													moveMark(false);
												}else{
													swalWithBootstrapButtons.fire({
														icon:'error',								
														title: 'Ups!, no pude cargar el menú del proyecto',					
														text:param[1]
													});				
												}
											},
											error: function(XMLHttpRequest, textStatus, errorThrown){					
												swalWithBootstrapButtons.fire({
													icon:'error',								
													title: 'Ups!, no pude cargar el menú del proyecto',					
												});				
											}
										});

									}else{
										swalWithBootstrapButtons.fire({
											icon:'error',								
											title: 'Ups!, no pude grabar los datos del proyecto',					
											text:param[1]
										});
									}
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){
									swalWithBootstrapButtons.fire({
										icon:'error',								
										title: 'Ups!, no pude cargar el menú del proyecto'							
									});
								}
							});
						}
					}
				}
			}
		})
	});
</script>