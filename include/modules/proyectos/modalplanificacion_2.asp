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
		PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		MET_Id=rs("MET_Id")
		MET_Descripcion=rs("MET_Descripcion")
	end if
	if(PRY_InformeInicioEstado=0 or PRY_InformeInicialEstado=0) and PRY_Estado=1 then
		modo=2
		mode="mod"
	end if
	response.write("200//")%>
	<style>
		.select:after{
			right:0px;
		}
		.content-nav {
			overflow-x: auto;
		}
		.content-nav a {
			max-width: 100px;
			text-wrap: no-wrpa;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			font-size: 12px;
			padding: 5px;
		}
		.error.invalid-feedback{
			display: none!important;
		}
		.select:after{
			display: none;
		}
	</style>
	<!--container-nav-->
	<div class="container-nav" id="planificacionadd-tab">
		<div class="header">				
			<div class="content-nav"><%
				sqly="exec [spPlantillaModulo_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'"
				set rs = cnn.Execute(sqly)
				on error resume next
				if cnn.Errors.Count > 0 then 		
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión 2:" & sqly)
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
					<a id="planificacionadd-tab<%=rs("MOD_Id")%>" href="#planificacionaddtab<%=rs("MOD_Id")%>" class="<%=active%> tab"><%=rs("MOD_Nombre")%></a><%					
					rs.movenext
				loop%>								
				<span class="yellow-bar"></span>				
			</div>	
		</div>
		<div class="tab-content tab-validate">
			<!--tab-content--><%			
			if ((PRY_InformeInicioEstado=0 or PRY_InformeInicialEstado=0) and PRY_Estado=1) then
				tmode=1
				calendario="calendario"
				hora="hora"				
				required=""
				disabled=""
				sltdisabled=""
			else
				tmode=1
				calendario=""
				hora=""
				required="readonly"
				disabled="disabled"
				sltdisabled="disabled"
			end if
			set rs = cnn.Execute("exec spPlanificacionyPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & tmode)
			on error resume next			
			if cnn.Errors.Count > 0 then 
			   ErrMsg = cnn.Errors(0).description	   
			   cnn.close
			   response.Write("503/@/Error Conexión 3:" & ErrMsg)
			   response.End() 			   
			end if
			MOD_Id=0
			PER_Id=0
			TEM_Id=0								
			corr=0
			sw=0
			Modulo=1
			corrold = 0
			do while not rs.eof
				if(IsNull(rs("PLN_Sesion"))) then
					typer="new"
					'met=""
					PLN_Sesion = 0
					hidden="hidden"
				else
					typer="old"
					'met="required"
					PLN_Sesion = rs("PLN_Sesion")
					hidden=""
					corrold = corrold +1
				end if
				
				if MOD_Id<>rs("MOD_Id") then 'Cambio de Modulo - Nueva tabla
					dif = rs("TEM_Horas")
					if MOD_id<>0 then	'No es el primero
						Modulo=Modulo+1
						dif=0%>
							</tr>
						</tbody>
					</table>
					</div>
					<!--tab--><%
					end if%>
					<div id="planificacionaddtab<%=rs("MOD_Id")%>" class="tabs-pane">
						<table id="tbl-plan-<%=rs("MOD_Id")%>" class="table-striped table-bordered table-sm no-hover no-footer dataTable" data-id="plan-<%=rs("MOD_Id")%>" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="" role="grid" aria-describedby="tbl-alumnos_info" style="width: 100%;" width="100%" cellspacing="0">

						<thead> 												
							<tr>													
								<th style="text-align: center;vertical-align: middle;">Perspectiva</th>
								<th style="text-align: center;vertical-align: middle;">Módulo</th>   
								<th style="text-align: center;vertical-align: middle;">Metodología</th>   
								<th style="text-align: center;vertical-align: middle;">Fecha</th>
								<th style="text-align: center;vertical-align: middle;">Inicio</th>
								<th style="text-align: center;vertical-align: middle;">Término</th>								
								<th style="text-align: center;vertical-align: middle;">H.P.Planiifcadas</th>
								<th style="text-align: center;vertical-align: middle;">H.R.Planificadas</th>
								<th style="text-align: center;vertical-align: middle;">H.P.Faltantes</th>
								<th style="text-align: center;vertical-align: middle;">Relator</th>
							</tr>
						</thead>
						<tbody>
							<tr><%																			
				end if

				'Busqueda de tematicas planificadas
				sqlz="exec spTotalHorasTematica_Calcular " & rs("TEM_Id") & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				set rsx = cnn.Execute(sqlz)
				on error resume next			
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión 4:" & ErrMsg)
				   response.End() 			   
				end if
				'dif=round(((rs("TEM_Horas")*45)/60),2) * -1
				
				horaInicio = split(rs("PLN_HoraInicio"),":")
				horaFin = split(rs("PLN_HoraFin"),":")

				minutosInicio = (horaInicio(0)*60) + horaInicio(1)
				minutosFin = (horaFin(0)*60) + horaFin(1)				

				if not rsx.eof then
					if(typer="old") then
						'horasPlanificadas = round(((rsx("TotalMinutosPlanificados")/45)),0)
						'horasReales = round(((rsx("TotalMinutosTematica")/60)),0)
						horasPlanificadas = (minutosFin - minutosInicio)/45
						horasReales = (minutosFin - minutosInicio)/60
						hidden = "required"
						if(corrold=1) then
							bg = background
						Else
							bg = "inherit"
						end if
						'dif = dif + horasPlanificadas
					Else
						horasPlanificadas = 0
						horasReales = 0
						'dif = round(((rsx("TotalMinutosTematica") - rsx("TotalMinutosPlanificados"))/45 ),0)
						dif = 0
						hidden = "hidden"
					end If
					
					dif2 = round(((rsx("TotalMinutosTematica") - rsx("TotalMinutosPlanificados"))/45 ),0)					
					if(dif<0) then
						'dif="(0)"
						dif = 0
					'else
						'dif="(" & dif & ")"
					end if
					if(rsx("TotalMinutosPlanificados")<rsx("TotalMinutosTematica")) then
						background="rgba(217, 83, 79, .3)"
						if(mode="mod") and required<>"readonly" then							
							required=""
							disabled=""
							sltdisabled=""
						else
							required="readonly"
							disabled="disabled"
							sltdisabled="disabled"
						end if
					else
						background="rgba(92, 184, 92, .3)"
						if(mode="mod") and required<>"readonly" then
							required=""
							disabled=""
							sltdisabled=""
						else							
						end if
					end if
				else
					'dif = 0
					background="rgba(217, 83, 79, .3)"
					if(mode="mod") then						
						disabled=""
						sltdisabled=""
					else
						required="readonly"
						disabled="disabled"
						sltdisabled="disabled"
					end if
				end if

				'Busqueda de tematicas planificadas
				if PER_Id<>rs("PER_Id") then	'Cambio de perspectiva%>					                                    			
					<th rowspan="<%=rs("CANT_PER_Id")%>" scope="row" style="text-align: center;vertical-align: middle;" id="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></th><%
				end if

				if TEM_Id<>rs("TEM_Id") then%>										
					<td rowspan="<%=rs("CANT_TEM_Id")%>" style="text-align: center;vertical-align: middle;font-size: 12px;font-weight: initial;background:<%=background%>;" id="<%=rs("TEM_Id")%>"><%=rs("TEM_Nombre") & " (" & rs("TEM_Horas") & ")"%></td><%
				end if%>
					<td><%
						if(MET_Id=3) then%>
							<div class="select">
								<select name="MET_Id" id="MET_Id-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" class="select-text form-control" <%=sltdisabled%>><%
									if(rs("MET_Id")="" or IsNULL(rs("MET_Id"))) then%>
										<option value="" selected></option><%
									end if
									set rsw = cnn.Execute("exec spMetodologia_Listar 1")
									on error resume next					
									do While Not rsw.eof
										if(rsw("MET_Id")<MET_Id) then
											if rsw("MET_Id")=rs("MET_Id") then%>
												<option value="<%=rsw("MET_Id")%>" selected ><%=rsw("MET_Descripcion")%></option><%
											else%>
												<option value="<%=rsw("MET_Id")%>"><%=rsw("MET_Descripcion")%></option><%
											end if
										end if
										rsw.movenext						
									loop
									rsw.Close%>
								</select>									
								<span class="select-bar"></span>									
							</div><%
						else%>
							<div class="select">
								<select name="MET_Id" id="MET_Id-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" class="select-text form-control" <%=sltdisabled%>><%
									if(rs("MET_Id")="" or IsNULL(rs("MET_Id"))) then%>
										<option value="" selected></option><%
									end if%>
									<option value="<%=MET_Id%>"><%=MET_Descripcion%></option>
								</select>									
								<span class="select-bar"></span>									
							</div><%
						end if%>						
					</td>
					<td>																																
						<input type="text" class="form-control <%=calendario%>" name="PLN_Fecha" id="PLN_Fecha-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" readonly="readonly" <%=disabled%> <%=hidden%> value="<%=rs("PLN_Fecha")%>">
					</td>
					<td>											
						<input type="text" class="form-control <%=hora%>"  name="PLN_HoraInicio" id="PLN_HoraInicio-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" readonly="readonly" <%=disabled%> <%=hidden%> data-type="ini" value="<%=rs("PLN_HoraInicio")%>">											
					</td>
					<td>											
						<input type="text" class="form-control <%=hora%>" name="PLN_HoraFin" id="PLN_HoraFin-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" readonly="readonly" <%=disabled%> <%=hidden%> data-type="fin"  value="<%=rs("PLN_HoraFin")%>">											
					</td>					
					<td>
						<input type="text" class="form-control" name="TEM_HorasPlanificadas" id="TEM_HorasPlanificadas-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" disabled="disabled" <%=hidden%> value="<% response.write(round(horasPlanificadas,0))%>" style="text-align:center;" data-minutos="<%=round((horasPlanificadas*45),2)%>">											
					</td>
					<td>
						<input type="text" class="form-control" name="TEM_HorasReales" id="TEM_HorasReales-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" disabled="disabled" <%=hidden%> value="<% response.write(round(horasReales,0))%>" style="text-align:center;" data-minutos="<%=round(horasReales,2)%>">											
					</td>
					<td>
						<input type="text" class="form-control" name="TEM_HorasFaltantes" id="TEM_HorasFaltantes-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>" disabled="disabled" <%=hidden%> value="<% response.write(round(dif,0))%>" style="text-align:center;background:<%=bg%>" data-minutos="<%=round((rs("TEM_Horas")*45),2)%>" data-oldvalue="<% response.write(dif2)%>">											
					</td>
					<td>						
						<div class="select">
							<select name="REL_Id" id="REL_Id-<%=typer%>-<%=rs("TEM_Id")%>-<%=PLN_Sesion%>"  <%=hidden%> class="validate select-text form-control" <%=sltdisabled%>><%
								if(rs("REL_Id")="" or IsNULL(rs("REL_Id"))) then%>
									<option value="" selected></option><%
								end if
								set rsw = cnn.Execute("exec [spRelatorProyectoxProyecto_Listar] " & PRY_Id & ",1")
								on error resume next					
								do While Not rsw.eof
									if rsw("REL_Id")=rs("REL_Id") then%>
										<option value="<%=rsw("REL_Id")%>" selected ><%=rsw("REL_Nombres") & " " & rsw("REL_Paterno") & " " & rsw("REL_Materno")%></option><%
									else%>
										<option value="<%=rsw("REL_Id")%>"><%=rsw("REL_Nombres") & " " & rsw("REL_Paterno") & " " & rsw("REL_Materno")%></option><%
									end if
									rsw.movenext						
								loop
								rsw.Close%>
							</select>									
							<span class="select-highlight"></span>
							<span class="select-bar"></span>									
						</div>
					</td>					
				</tr>
				<input type="hidden" id="Tem-<%=typer%>-<%=rs("TEM_Id")%>" name="Tem" value="<%=rs("TematicaProyecto")%>">
				<input type="hidden" id="TEM_Id-<%=typer%>-<%=rs("TEM_Id")%>" name="TEM_Id" value="<%=rs("TEM_Id")%>">
				<input type="hidden" id="PLN_Sesion-<%=typer%>-<%=rs("TEM_Id")%>" name="PLN_Sesion" value="<%=rs("PLN_Sesion")%>">
				<input type="hidden" id="Type-<%=typer%>-<%=rs("TEM_Id")%>" name="Type" value="<%=typer%>"><%
				MOD_Id=rs("MOD_Id")
				PER_Id=rs("PER_Id")
				TEM_Id=rs("TEM_Id")
				minutosInicio=0
				minutosFin=0
				if(typer="new") then
					dif = (rsx("TotalMinutosTematica") - rsx("TotalMinutosPlanificados"))/45 
				Else
					dif = dif + horasPlanificadas
				end if
				corr=corr+1									
				rs.movenext
			loop%>
				</tbody>
			</table>
		</div>
		<!--tab-->	
		<!--tab-content-->
	</div>
	<!--container-nav--><%	
	if ((PRY_InformeInicioEstado=0 or PRY_InformeInicialEstado=0) and PRY_Estado=1) then%>
		<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddplanificacion" name="btn_frmaddplanificacion" style="float:right;"><i class="fas fa-plus"></i> Guardar</button><%
	else%>
		<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="" name="" style="float:right;" disabled><i class="fas fa-plus"></i> Guardar</button><%
	end if%>
	<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" id="btn_salirplanificacion" name="btn_salirplanificacion" style="float:right;"><i class="fas fa-sign-out-alt"></i> Salir</button>	

	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">