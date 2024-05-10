<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	
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
		action="/mod-10-h2-s3"
		checkbox="required"
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
			
	anio=year(date())
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
		if(mode="vis") then
			lblSelect = "active"
		end if		
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End()
		end if
		if not rs.eof then
			PRY_Identificador=rs("PRY_Identificador")
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")
			LFO_PorcentajeMinEjecutado=rs("LFO_PorcentajeMinEjecutado")
			PRY_PorcentajeEjecutadoAprobado=rs("PRY_PorcentajeEjecutadoAprobado")
			PRY_FechaPorcentajeEjecutado=rs("PRY_FechaPorcentajeEjecutado")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if		
	
	sql="exec [spTotalHorasPorRealizaryRealizadas_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	end if
	if not rs.eof then
		HorasTotalesRealizadas=rs("HorasTotalesRealizadas")
		HorasTotalesPedagogicasRealizadas=rs("HorasTotalesPedagogicasRealizadas")
		PRY_HorasPedagogicasMin=rs("PRY_HorasPedagogicasMin")
		PorcentajeHorasPedagogicasRealizadas=rs("PorcentajeHorasPedagogicasRealizadas")

		if HorasTotalesRealizadas="" or IsNULL(HorasTotalesRealizadas) then
			HorasTotalesRealizadas=0
		end if
		if HorasTotalesPedagogicasRealizadas="" or IsNULL(HorasTotalesPedagogicasRealizadas) then
			HorasTotalesPedagogicasRealizadas=0
		end if
		if PRY_HorasPedagogicasMin="" or IsNULL(PRY_HorasPedagogicasMin) then
			PRY_HorasPedagogicasMin=0
		end if
		if (PorcentajeHorasPedagogicasRealizadas="" or IsNULL(PorcentajeHorasPedagogicasRealizadas)) then
			PorcentajeHorasPedagogicasRealizadas=0
		end if
	else
		HorasTotalesRealizadas=0
		HorasTotalesPedagogicasRealizadas=0
		PRY_HorasPedagogicasMin=0
		PorcentajeHorasPedagogicasRealizadas=0
	end if
	if(PRY_PorcentajeEjecutadoAprobado="" or IsNULL(PRY_PorcentajeEjecutadoAprobado)) then
		PRY_PorcentajeEjecutadoAprobado=0		
	end if
	xmode="vis"
	if(CDbl(PRY_PorcentajeEjecutadoAprobado)=0 or CDbl(PorcentajeHorasPedagogicasRealizadas)<CDbl(PRY_PorcentajeEjecutadoAprobado)) then
		PRY_PorcentajeEjecutadoAprobado=CDbl(PorcentajeHorasPedagogicasRealizadas)
		xmode="mod"
		PRY_FechaPorcentajeEjecutado=""
	end if
	PorcentajeHorasPedagogicasxRealizar = 100 - CDbl(PorcentajeHorasPedagogicasRealizadas)

	if(CDbl(PRY_PorcentajeEjecutadoAprobado)<CDbl(LFO_PorcentajeMinEjecutado)) then
		error=1
		background_tem="rgba(217, 83, 79, .3);"
		PRY_FechaPorcentajeEjecutado=""
		'Limpiar campos
		sql="exec [spProyectoPorcentajeFecha_Actualizar] " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
		set rs = cnn.Execute(sql)
	else
		background_tem="rgba(92, 184, 92, .3);"
		error=0
	end if

	rs.close
	response.write("200/@/")%>

	<h5>Planificación</h5>
	<h6>Porcentajes horas ejecutadas y por ejecutar</h6>
	<div class="row px-4" style="padding-top:30px;padding-bottom:30px;">
		<table id="tbl-planificacionPor" class="ts table table-striped table-bordered dataTable table-sm" data-id="planificacionPor" data-page="true" data-selected="true" data-keys="1"> 
			<thead>				
				<tr>
					<th rowspan="1" scope="row" style="text-align: center;vertical-align: middle;"></th>
					<th style="text-align: center;vertical-align: middle;">Porcentaje por ejecutar</th>
					<th style="text-align: center;vertical-align: middle;">Porcentaje ejecutado</th>
					<th style="text-align: center;vertical-align: middle;">Fecha de aprobación</th>
					<th style="text-align: center;vertical-align: middle;">Porcentaje ejecutado real</th>
					<th style="text-align: center;vertical-align: middle;">Mínimo ejecutado exigido</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>Totales</th>
					<td><%=PorcentajeHorasPedagogicasxRealizar%>%</td>
					<td style="background:<%=background_tem%>"><%=PRY_PorcentajeEjecutadoAprobado%>%</td>
					<td><%=PRY_FechaPorcentajeEjecutado%></td>
					<td><%=CDbl(PorcentajeHorasPedagogicasRealizadas)%>%</td>
					<td><%=LFO_PorcentajeMinEjecutado%>%</td>
				</tr>
			</tbody>					
		</table>
	</div>

	<h5>Detalle de Planificación</h5>
	<h6>Planificación por Ejecutar</h6>
	<div class="row px-4" style="padding-top:30px;">
		<table id="tbl-porejecutar" class="ts table table-striped table-bordered dataTable table-sm" data-id="porejecutar" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>				
				<tr> 
					<th style="width:10px;">#</th>                            
					<th>Curso</th>
					<th>Metodología</th>
					<th>Relator</th>
					<th>Fecha</th>
				</tr> 
			</thead>
			<tbody><%
				sql = "exec spPlanificacionPorRealizar_Listar " & PRY_Id  & ",'" & PRY_Identificador & "'" 
				set rs = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description	   
					cnn.close
					response.Write("503/@/Error Conexión:" & ErrMsg)
					response.End()
				End If
				do while not rs.eof	
					x=x+1%>
					<tr>
						<td><%response.Write(x)%></td>
						<td><%=rs("TEM_Nombre")%></td>
						<td><%=rs("MET_Descripcion")%></td>
						<td><%=rs("REL_Nombres") & " " & rs("REL_Paterno") & " " & rs("REL_Materno")%></td>
						<td><%=rs("PLN_Fecha")%></td>
					</tr><%
					rs.movenext				
				loop
				rs.close%>
			</tbody>
			
		</table>	
	</div>			
	<h6>Planificación Ejecutada</h6>	
	<div class="row px-4" style="padding-top:30px;">
		<table id="tbl-ejecutadas" class="ts table table-striped table-bordered dataTable table-sm" data-id="ejecutadas" data-page="true" data-selected="true" data-keys="1" width="100%"> 
			<thead>
				<tr>
					<th style="width:10px;">#</th>                            
					<th>Cursos</th>
					<th>Metodología</th>
					<th>Relator</th>
					<th>Fecha</th>
				</tr>
			</thead><%					
			sql = "exec spPlanificacionRealizada_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
			set rsx = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close
				response.Write("503/@/Error Conexión:" & ErrMsg)
				response.End()
			End If
			x=0
			do while not rsx.eof				
				x=x+1%>
				<tr>
					<td><%response.Write(x)%></td>
					<td><%=rsx("TEM_Nombre")%></td>
					<td><%=rsx("MET_Descripcion")%></td>
					<td><%=rsx("REL_Nombres") & " " & rsx("REL_Paterno") & " " & rsx("REL_Materno")%></td>
					<td><%=rsx("PLN_Fecha")%></td>
				</tr><%
				rsx.movenext
			loop%>		
		</table>
	</div>					
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>
				<form role="form" action="<%=action%>" method="POST" name="frm10s3" id="frm10s3" class="needs-validation">
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s3" name="btn_frm10s3"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="3">
					<input type="hidden" id="PRY_Hito" value="2" name="PRY_Hito">
					<input type="hidden" id="error" value="<%=error%>" name="error">
					<input type="hidden" id="mode" value="<%=xmode%>" name="mode">
					<input type="hidden" id="PRY_PorcentajeEjecutadoAprobado" value="<%=PRY_PorcentajeEjecutadoAprobado%>" name="PRY_PorcentajeEjecutadoAprobado">					
				</form><%
			else%>				
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>			
	</div>
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
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
	$(document).ready(function() {
		var tables = $.fn.dataTable.fnTables(true);
		$(tables).each(function () {
			$(this).dataTable().fnDestroy();				
		});	
		porejecutarTable = $('#tbl-porejecutar').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		ejecutadasTable = $('#tbl-ejecutadas').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		
		$("#btn_frm10s3").click(function(){
			formValidate("#frm10s3")
			if($("#frm10s3").valid()){
				if($("#error").val()==1){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'ERROR',
						text:'El porcentaje de horas realizadas es menor al exigido. Debes corregir esto antes de avanzar'
					});
				}else{
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm10s3").attr("action"),
						data: $("#frm10s3").serialize(),
						success: function(data) {						
							param=data.split(bb);						
							if(param[0]=="200"){
								Toast.fire({
								icon: 'success',
								title: 'Planificaciónes grabadas correctamente'
								});
								var modo = <%=modo%>;
								var PRY_Id = <%=PRY_Id%>;
								if(modo==1){
									PRY_Id=param[1];
									modo=2;
								}
								var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:2};
								$.ajax( {
									type:'POST',					
									url: '/mnu-10',
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
									title: 'Ups!, no pude grabar los datos del proyecto'								
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
		});		
	});
</script>