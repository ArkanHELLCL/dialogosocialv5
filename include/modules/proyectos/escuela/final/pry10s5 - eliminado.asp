<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	PRY_Hito=3
	
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
		action="/mod-10-h3-s5"
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
			PRY_ObsCumplimientosPropuestos=rs("PRY_ObsCumplimientosPropuestos")
			PRY_ObsCumplimientosFechas=rs("PRY_ObsCumplimientosFechas")		
			MET_Id=rs("MET_Id")
			MET_Descripcion=rs("MET_Descripcion")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if		
	
	rs.close
	response.write("200/@/")%>
	<style>
		.select:after{
			right:0px;
		}
	</style>
	<form role="form" action="<%=action%>" method="POST" name="frm10s5_evaluacion" id="frm10s5_evaluacion" class="needs-validation">
	<h5 style="padding-bottom:20px;">Evaluación del Programa</h5>
	<!--container-nav-->
	<div class="container-nav" id="evaluacionprog-tab">
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
					<a id="evaluacionprog-tab<%=rs("MOD_Id")%>" href="#evaluacionprogtab<%=rs("MOD_Id")%>" class="<%=active%> tab"><i class="fas fa-book-reader"></i> <%=rs("MOD_Nombre")%><%
					if(TematicasPendientes>0) then%>
						<!--<span class="badge right red badgeemp"><%=TematicasPendientes%></span>--></a><%
					else%>
						<!--<span class="badge right blue badgeemp"><%=TematicasPendientes%></span>--></a><%
					end if					
					rs.movenext
				loop%>								
				<span class="yellow-bar"></span>				
				<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
					<div class="animated-icon1"><span></span><span></span><span></span></div>
				</button>
			</div>	
		</div>
		<div class="tab-content tab-validate">
			<!--tab-content--><%											
			
			set rs = cnn.Execute("exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'")
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
					<div id="evaluacionprogtab<%=rs("MOD_Id")%>" class="tabs-pane">
					<table id="tbl-plan-<%=rs("MOD_Id")%>" class="table-striped table-bordered table-sm no-hover no-footer dataTable" data-id="plan-<%=rs("MOD_Id")%>" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="" role="grid" aria-describedby="tbl-alumnos_info" style="width: 100%;" width="100%" cellspacing="0">

						<thead> 												
							<tr>													
								<th style="text-align: center;vertical-align: middle;">Perspectiva</th>
								<th style="text-align: center;vertical-align: middle;">Módulo</th>                                                    
								<th style="text-align: center;vertical-align: middle;">Pertinencia</th>
								<th style="text-align: center;vertical-align: middle;">Metodología</th>
								<th style="text-align: center;vertical-align: middle;">Observación</th>								
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
				dif=round((rs("TEM_Horas")*45),2) * -1
				if not rsx.eof then
					dif = rsx("TotalMinutosTematica") - rsx("TotalMinutosPlanificados")
					if(dif<0) then
						dif="(0)"
					else
						dif="(" & dif & ")"
					end if
					if(rsx("TotalMinutosPlanificados")<rsx("TotalMinutosTematica")) then
						background="rgba(217, 83, 79, .3)"
						if(mode="mod") and required<>"readonly" then
							'required="required"
							required=""
						else
							required="readonly"
						end if
					else
						background="rgba(92, 184, 92, .3)"
						if(mode="mod") and required<>"readonly" then
							required=""
						else
							'required="readonly"
							'required=""
						end if
					end if
				else
					background="rgba(217, 83, 79, .3)"
					if(mode="mod") then
						'required="required"
						'required=""
					else
						required="readonly"
					end if
				end if
				'response.write(sqlx)
				'Busqueda de tematicas planificadas

				if PER_Id<>rs("PER_Id") then	'Cambio de perspectiva%>					                                    			
					<th rowspan="<%=rs("CANT_PER_Id")%>" scope="row" style="text-align: center;vertical-align: middle;" id="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></th><%
				end if

				if TEM_Id<>rs("TEM_Id") then%>										
					<td rowspan="<%=rs("CANT_TEM_Id")%>" style="text-align: center;vertical-align: middle;font-size: 12px;font-weight: initial;background:<%=background%>;" id="<%=rs("TEM_Id")%>"><%=rs("TEM_Nombre")%></td><%
				end if								
				'Buscando las observaciones por tematica
				set rs9 = cnn.Execute("exec spTematicaFeedback_Consultar " & rs("TEM_Id") & "," & PRY_Id)
				on error resume next			
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión 4:" & ErrMsg)
				   response.End() 			   
				end if
				if not rs9.eof then
					TEF_Pertinencia = rs9("TEF_Pertinencia")
					'TEF_Metodologia = rs9("TEF_Metodologia")
					MET_Idx = rs9("MET_Id")
					reg="old"					
					id=rs9("TEF_Id")
				else
					TEF_Pertinencia = 99
					MET_Idx = ""
					'TEF_Metodologia = 0
					reg="new"					
					id=rs("TEM_Id")
				end if%>
					<td style="text-align: center;vertical-align: middle;">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<div class="select"><%
								if TEF_Pertinencia=0 then%>
									<select name="TEF_Pertinencia" id="TEF_Pertinencia-<%=id%>" class="validate select-text form-control" <%=disabled%>>
										<option value="2">Muy pertinente</option>
										<option value="1">Pertinente</option>
										<option value="0" selected>No pertinente</option>
									</select><%
								else
									if TEF_Pertinencia=1 then%>
										<select name="TEF_Pertinencia" id="TEF_Pertinencia-<%=id%>" class="validate select-text form-control" <%=disabled%>>
											<option value="2">Muy pertinente</option>
											<option value="1" selected>Pertinente</option>
											<option value="0">No pertinente</option>												
										</select><%
									else
										if TEF_Pertinencia=2 then%>
											<select name="TEF_Pertinencia" id="TEF_Pertinencia-<%=id%>" class="validate select-text form-control" <%=disabled%>>
												<option value="2" selected>Muy pertinente</option>
												<option value="1">Pertinente</option>
												<option value="0">No pertinente</option>												
											</select><%
										else%>
											<select name="TEF_Pertinencia" id="TEF_Pertinencia-<%=id%>" class="validate select-text form-control" <%=disabled%>>
												<option value="" selected readonly></option>
												<option value="2">Muy pertinente</option>
												<option value="1">Pertinente</option>
												<option value="0">No pertinente</option>												
											</select><%
										end if
									end if
								end if%>
								<span class="select-highlight"></span>
								<span class="select-bar"></span>
							</div>							
						</div>
					</td>					
					<td style="text-align: center;vertical-align: middle;"><%						
						if(MET_Id=3) then%>
							<div class="md-form input-with-post-icon">
								<div class="error-message">
									<div class="select">
										<select name="MET_Id" id="MET_Id-<%=id%>" class="validate select-text form-control" <%=disabled%>><%
											if(MET_Idx="" or IsNULL(MET_Idx)) then%>
												<option value="" selected></option><%
											end if
											set rsw = cnn.Execute("exec spMetodologia_Listar 1")
											on error resume next					
											do While Not rsw.eof
												if rsw("MET_Id")=MET_Idx then%>
													<option value="<%=rsw("MET_Id")%>" selected ><%=rsw("MET_Descripcion")%></option><%
												else%>
													<option value="<%=rsw("MET_Id")%>"><%=rsw("MET_Descripcion")%></option><%
												end if
												rsw.movenext						
											loop
											rsw.Close%>
										</select>									
										<span class="select-highlight"></span>
										<span class="select-bar"></span>									
									</div>
								</div>
							</div><%
						else%>
							<input type="hidden" name="MET_Id" id="MET_Id-<%=id%>-<%=rs("TEM_Id")%>" value="<%=MET_Id%>">
							<%=MET_Descripcion%><%
						end if%>						
					</td>
					<td>						
						<textarea class="md-textarea form-control" name="TEF_Observaciones" id="TEF_Observaciones-<%=id%>" row="15" style="height: 150px;" <%=disabled%>><%=rs9("TEF_Observaciones")%></textarea>							
					</td>					
					<input type="hidden" id="Id-<%=id%>" name="Id" value="<%=id%>">
					<input type="hidden" id="Type-<%=id%>" name="Type" value="<%=reg%>">					
				</tr><%
				MOD_Id=rs("MOD_Id")
				PER_Id=rs("PER_Id")
				TEM_Id=rs("TEM_Id")
				corr=corr+1									
				rs.movenext
			loop%>
				</tbody>
			</table>
		</div>
		<!--tab-->	
		<!--tab-content-->
	</div>
	<!--container-nav-->
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>				
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s5" name="btn_frm10s5"><%=txtBoton%></button>
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
				<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
				<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
				<input type="hidden" id="Step" name="Step" value="5">
				<input type="hidden" id="PRY_Hito" value="<%=PRY_Hito%>" name="PRY_Hito"><%
			else%>				
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>			
	</div>
	</form>
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
	$("#evaluacionprog-tab").tabsmaterialize({menumovil:false},function(){});
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
		
		$("#btn_frm10s5").click(function(){
			formValidate("#frm10s5_evaluacion")
			if($("#frm10s5_evaluacion").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm10s5_evaluacion").attr("action"),
					data: $("#frm10s5_evaluacion").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Evaluaciones grabadas correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:$("#PRY_Hito").val()};
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
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Faltan evaluaciones que ingresar'
				});
			}
		});		
	});
</script>