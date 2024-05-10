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
		mode="mod"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		calendario="calendario"
		action="/mod-11-h2-s2"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
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
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if
		if not rs.eof then	
			PRY_Identificador=rs("PRY_Identificador")
			LIN_Id=rs("LIN_Id")
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer("LIN_Mujer")
			PRY_TipoMesa=rs("PRY_TipoMesa")			
			PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
			PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
			PRY_Estado=rs("PRY_Estado")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
			
	rs.close
	response.write("200/@/")	
%>		
	<div class="row">
		<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Coordinación entre Actores</h5>
		
		<!--container-nav-->
		<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
			<div class="header">				
				<div class="content-nav">
					<a id="coordtrab-tab" href="#coordtrabtab1" class="active tab"><i class="fas fa-users"></i> Trabajadores
					</a>
					<a id="coordempl-tab" href="#coordempltab2" class="tab"><i class="fas fa-industry"></i> Empleador
					</a><%
					if PRY_TipoMesa=2 then		'Tripartita%>
						<a id="coordgobr-tab" href="#coordgobrtab3" class="tab"><i class="fas fa-university"></i> Gobierno
						</a><%
					end if%>
					<span class="yellow-bar"></span>				
					<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
						<div class="animated-icon1"><span></span><span></span><span></span></div>
					</button>
				</div>				
			</div>
			<div class="tab-content">
				<!--coordtrabtab1-->
				<div id="coordtrabtab1"><%
					if(mode="mod") then%>
						<form role="form" action="" method="POST" name="frm11s2_1" id="frm11s2_1" class="needs-validation">						
							<div class="row">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="CTR_TematicaAbordada" name="CTR_TematicaAbordada" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar un problema o temática abordada"><%=CTR_TematicaAbordada%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(CTR_TematicaAbordada<>"") then
												clase="active"
											end if%>
											<label for="" class="<%=clase%>">Identificación de problema y/o temática abordada según plan de trabajo</label>									
										</div>
									</div>
								</div>							
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="CTR_ContenidosTrabajados" name="CTR_ContenidosTrabajados" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar un contenido"><%=CTR_ContenidosTrabajados%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(CTR_ContenidosTrabajados<>"") then
												clase="active"
											end if%>
											<label for="" class="<%=clase%>">Contenidos Trabajados</label>									
										</div>
									</div>
								</div>
							</div>
							<div class="row" style="margin-bottom:20px">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="CTR_Conclusion" name="CTR_Conclusion" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una(s) conclusion(es)"><%=CTR_Conclusion%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(CTR_Conclusion<>"") then
												clase="active"
											end if%>
											<label for="" class="<%=clase%>">Principales conclusiones de la mesa</label>									
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-comment prefix"></i>
											<textarea id="CTR_Compromiso" name="CTR_Compromiso" class="md-textarea form-control" rows="5" required="" data-msg="Debes ingresar un compromiso"></textarea>
											<span class="select-bar"></span>
											<label for="CTR_Compromiso" class="">Compromiso</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row align-items-center" style="margin-bottom:20px">						
								<div class="col-sm-12 col-md-5 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-list-ol input-prefix"></i>													
											<input type="number" id="CTR_NumSesion" name="CTR_NumSesion" class="form-control" required="" value="" data-msg="Debes ingresar una sesión">
											<span class="select-bar"></span>
											<label for="CTR_NumSesion" class="">Número de Sesión</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-5 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-calendar input-prefix"></i>													
											<input type="text" id="CTR_DiaAtividad" name="CTR_DiaAtividad" class="form-control calendario" readonly required="" value="" data-msg="Debes ingresar una fecha">
											<span class="select-bar"></span>
											<label for="CTR_DiaAtividad" class="">Día de realización Actividad</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-6">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s2_1" name="btn_frm11s2_1" style="float:right;"><i class="fas fa-plus"></i></button>
								</div>
							</div>							
						
							<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">						
						</form><%
					end if%>
					
					<table id="tbl-coordtrab" class="ts table table-striped table-bordered dataTable table-sm tbl-coordtrab" data-id="coordtrab" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">#</th>
								<th style="width:10px;">S</th>
								<th>Fecha</th>												
								<th>Temáticas</th>
								<th>Contenidos</th>
								<th>Conclusiones</th>
								<th>Compromiso</th>
								<th>Adj.</th><%
								if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
									<th>Acciones</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody>
						</tbody>
					</table>										
				</div>
				<!--coordtrabtab1-->				
				<!--coordempltab2-->
				<div id="coordempltab2"><%
					if(mode="mod") then%>
						<form role="form" action="" method="POST" name="frm11s2_2" id="frm11s2_2" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="CEM_TematicaAbordada" name="CEM_TematicaAbordada" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar un problema o temática abordada"><%=CEM_TematicaAbordada%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(CEM_TematicaAbordada<>"") then
												clase="active"
											end if%>
											<label for="" class="<%=clase%>">Identificación de problema y/o temática abordada según plan de trabajo</label>									
										</div>
									</div>
								</div>							
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="CEM_ContenidosTrabajados" name="CEM_ContenidosTrabajados" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar un contenido"><%=CEM_ContenidosTrabajados%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(CEM_ContenidosTrabajados<>"") then
												clase="active"
											end if%>
											<label for="" class="<%=clase%>">Contenidos Trabajados</label>									
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="CEM_Conclusion" name="CEM_Conclusion" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una(s) conclusion(es)"><%=CEM_Conclusion%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(CEM_Conclusion<>"") then
												clase="active"
											end if%>
											<label for="" class="<%=clase%>">Principales conclusiones de la mesa</label>									
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-comment prefix"></i>
											<textarea id="CEM_Compromiso" name="CEM_Compromiso" class="md-textarea form-control" rows="5" required="" data-msg="Debes ingresar un compromiso"></textarea>
											<span class="select-bar"></span>
											<label for="CEM_Compromiso" class="">Compromiso</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row align-items-center" style="margin-bottom:20px">						
								<div class="col-sm-12 col-md-5 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-list-ol input-prefix"></i>													
											<input type="number" id="CEM_NumSesion" name="CEM_NumSesion" class="form-control" required="" value="" data-msg="Debes ingresar una sesión">
											<span class="select-bar"></span>
											<label for="CEM_NumSesion" class="">Número de Sesión</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-5 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-calendar input-prefix"></i>													
											<input type="text" id="CEM_DiaAtividad" name="CEM_DiaAtividad" class="form-control calendario" readonly required="" value="" data-msg="Debes ingresar una fecha">
											<span class="select-bar"></span>
											<label for="CEM_DiaAtividad" class="">Día de realización Actividad</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s2_2" name="btn_frm11s2_2" style="float:right;"><i class="fas fa-plus"></i></button>
								</div>
							</div>							
						
							<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">								
						</form><%
					end if%>
					
					<table id="tbl-coordempl" class="ts table table-striped table-bordered dataTable table-sm tbl-coordempl" data-id="coordempl" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">#</th>
								<th style="width:10px;">Sesión</th>
								<th>Dia Actividad</th>												
								<th>Tematicas</th>
								<th>Contenidos</th>
								<th>Conclusiones</th>
								<th>Compromiso</th>
								<th>Adj.</th><%
								if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
									<th>Acciones</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody>
						</tbody>
					</table>										
				</div>
				<!--coordempltab2-->				
				<!--coordgobrtab3--><%
				if PRY_TipoMesa=2 then		'Tripartita%>
					<div id="coordgobrtab3"><%
						if(mode="mod") then%>
							<form role="form" action="" method="POST" name="frm11s2_3" id="frm11s2_3" class="needs-validation">
								<div class="row">
									<div class="col-sm-12 col-md-6 col-lg-6">
										<div class="md-form">
											<div class="error-message">								
												<i class="fas fa-comment prefix"></i>
													<textarea id="CGO_TematicaAbordada" name="CGO_TematicaAbordada" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar un problema o temática abordada"><%=CGO_TematicaAbordada%></textarea>
												<span class="select-bar"></span><%
												clase=""
												if(CGO_TematicaAbordada<>"") then
													clase="active"
												end if%>
												<label for="" class="<%=clase%>">Identificación de problema y/o temática abordada según plan de trabajo</label>									
											</div>
										</div>
									</div>							
									<div class="col-sm-12 col-md-6 col-lg-6">
										<div class="md-form">
											<div class="error-message">								
												<i class="fas fa-comment prefix"></i>
													<textarea id="CGO_ContenidosTrabajados" name="CGO_ContenidosTrabajados" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar un contenido"><%=CGO_ContenidosTrabajados%></textarea>
												<span class="select-bar"></span><%
												clase=""
												if(CGO_ContenidosTrabajados<>"") then
													clase="active"
												end if%>
												<label for="" class="<%=clase%>">Contenidos Trabajados</label>									
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12 col-md-6 col-lg-6">
										<div class="md-form">
											<div class="error-message">								
												<i class="fas fa-comment prefix"></i>
													<textarea id="CGO_Conclusion" name="CGO_Conclusion" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una(s) conclusion(es)"><%=CGO_Conclusion%></textarea>
												<span class="select-bar"></span><%
												clase=""
												if(CGO_Conclusion<>"") then
													clase="active"
												end if%>
												<label for="" class="<%=clase%>">Principales conclusiones de la mesa</label>									
											</div>
										</div>
									</div>
									<div class="col-sm-12 col-md-6 col-lg-6">
										<div class="md-form input-with-post-icon">
											<div class="error-message">	
												<i class="fas fa-comment prefix"></i>
												<textarea id="CGO_Compromiso" name="CGO_Compromiso" class="md-textarea form-control" rows="5" required="" data-msg="Debes ingresar un compromiso"></textarea>
												<span class="select-bar"></span>
												<label for="CGO_Compromiso" class="">Compromiso</label>
											</div>
										</div>
									</div>
								</div>
								<div class="row align-items-center" style="margin-bottom:20px">
									<div class="col-sm-12 col-md-5 col-lg-5">
										<div class="md-form input-with-post-icon">
											<div class="error-message">	
												<i class="fas fa-list-ol input-prefix"></i>													
												<input type="number" id="CGO_NumSesion" name="CGO_NumSesion" class="form-control" required="" value="" data-msg="Debes ingresar una sesión>
												<span class="select-bar"></span>
												<label for="CGO_NumSesion" class="">Número de Sesión</label>
											</div>
										</div>
									</div>
									<div class="col-sm-12 col-md-5 col-lg-5">
										<div class="md-form input-with-post-icon">
											<div class="error-message">	
												<i class="fas fa-calendar input-prefix"></i>													
												<input type="text" id="CGO_DiaAtividad" name="CGO_DiaAtividad" class="form-control calendario" readonly required="" value="" data-msg="Debes ingresar una fecha">
												<span class="select-bar"></span>
												<label for="CGO_DiaAtividad" class="">Día de realización Actividad</label>
											</div>
										</div>
									</div>
									<div class="col-sm-12 col-md-2 col-lg-2">
										<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s2_3" name="btn_frm11s2_3" style="float:right;"><i class="fas fa-plus"></i></button>
									</div>
								</div>						
								<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
							</form><%
						end if%>

						<table id="tbl-coordgobr" class="ts table table-striped table-bordered dataTable table-sm tbl-coordgobr" data-id="coordgobr" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th style="width:10px;">Sesión</th>
									<th>Dia Actividad</th>												
									<th>Tematicas</th>
									<th>Contenidos</th>
									<th>Conclusiones</th>
									<th>Compromiso</th>
									<th>Adj.</th><%
									if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
										<th>Acciones</th><%
									end if%>
								</tr> 
							</thead>					
							<tbody>
							</tbody>
						</table>						
					</div><%
				end if%>
				<!--coordgobrtab3-->				
			</div>
			<!--tab-content-->
		</div>
		<!--conatiner-nav-->
	</div>
	<div class="row">
		<div class="footer"><%
			if mode="mod" then%>
			<form role="form" action="<%=action%>" method="POST" name="frm11s2" id="frm11s2" class="needs-validation">			
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s2" name="btn_frm11s2"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="2">
					<input type="hidden" id="PRY_Hito" value="2" name="PRY_Hito">
					<input type="hidden" id="PRY_TipoMesa" value="<%=PRY_TipoMesa%>" name="PRY_TipoMesa"><%
			else%>				
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>			
	</div>	
<script>	
	$(document).ready(function() {			
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);		
		var mode = '<%=mode%>'
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
		$(".content-nav").tabsmaterialize({menumovil:false},function(){});								
		$(".calendario").datepicker();
		var coordtrab;
		loadTablecoordtrab();
		
		function loadTablecoordtrab(){			
			if($.fn.DataTable.isDataTable( "#tbl-coordtrab")){				
				if(coordtrab!=undefined){
					coordtrab.destroy();
				}else{
					$('#tbl-coordtrab').dataTable().fnClearTable();
					$('#tbl-coordtrab').dataTable().fnDestroy();
				}
			}				
			coordtrab = $("#tbl-coordtrab").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/mesas-coordinacion-trabajadores",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});	
			$('#tbl-coordtrab').css('width','99%');
			$('#tbl-coordtrab').parent().css('overflow-x','scroll');
		}					
		
		$("#btn_frm11s2_1").click(function(){
			formValidate("#frm11s2_1");
			if($("#frm11s2_1").valid()){
				$.ajax({
					type: "POST",
					url: "/grabar-coordinacion-trabajadores",
					data: $("#frm11s2_1").serialize(),
					dataType:'json',
					success: function(data) {					
						if(data.state==200){						
							coordtrab.ajax.reload();	
							$("#frm11s2_1")[0].reset();
							Toast.fire({
								icon: 'success',
							  	title: 'Sesión grabada correctamente'
							});
						}else{
						
						}
					}
				})																		
			}			
		})
		
		$("#pry-content").on("click",".delcoordtrab",function(){
			var CTR_Id=$(this).data("ctr");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
			  	text: "Con esta acción eliminarás la sesión seleccionada!",
			  	icon: 'warning',
			  	showCancelButton: true,
			  	confirmButtonColor: '#3085d6',
			  	cancelButtonColor: '#d33',
			  	confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
			  	cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {					
					$.ajax({
						type: "POST",
						url: "/elimina-coordinacion-trabajadores",
						data: {PRY_Id:<%=PRY_Id%>,CTR_Id:CTR_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								coordtrab.ajax.reload();		
								Toast.fire({
									icon: 'success',
									title: 'Sesión eliminada correctamente'
								});
							}else{

							}
						}
					})
			  	}
			})	
		})				
		
		var coordempl;
		loadTablecoordempl();
		
		function loadTablecoordempl(){			
			if($.fn.DataTable.isDataTable( "#tbl-coordempl")){				
				if(coordempl!=undefined){
					coordempl.destroy();
				}else{
					$('#tbl-coordempl').dataTable().fnClearTable();
					$('#tbl-coordempl').dataTable().fnDestroy();
				}
			}				
			coordempl = $("#tbl-coordempl").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/mesas-coordinacion-empleador",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});	
			$('#tbl-coordempl').css('width','99%');
			$('#tbl-coordempl').parent().css('overflow-x','scroll');
		}					
		
		$("#btn_frm11s2_2").click(function(){
			formValidate("#frm11s2_2");
			if($("#frm11s2_2").valid()){
				$.ajax({
					type: "POST",
					url: "/grabar-coordinacion-empleador",
					data: $("#frm11s2_2").serialize(),
					dataType:'json',
					success: function(data) {					
						if(data.state==200){						
							coordempl.ajax.reload();	
							$("#frm11s2_2")[0].reset();
							Toast.fire({
								icon: 'success',
							  	title: 'Sesión grabada correctamente'
							});
						}else{
						
						}
					}
				})																		
			}			
		})
		
		$("#pry-content").on("click",".delcoordempl",function(){
			var CEM_Id=$(this).data("cem");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
			  	text: "Con esta acción eliminarás la Sesión seleccionada!",
			  	icon: 'warning',
			  	showCancelButton: true,
			  	confirmButtonColor: '#3085d6',
			  	cancelButtonColor: '#d33',
			  	confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
			  	cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {					
					$.ajax({
						type: "POST",
						url: "/elimina-coordinacion-empleador",
						data: {PRY_Id:<%=PRY_Id%>,CEM_Id:CEM_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								coordempl.ajax.reload();		
								Toast.fire({
									icon: 'success',
									title: 'Sesión eliminada correctamente'
								});
							}else{

							}
						}
					})
			  	}
			})	
		})						
		
		var TipoMesa = <%=PRY_TipoMesa%>;
		
		if(TipoMesa == 2){
			var coordgobl;
			loadTablecoordgobl();

			function loadTablecoordgobl(){			
				if($.fn.DataTable.isDataTable( "#tbl-coordgobr")){				
					if(coordgobl!=undefined){
						coordgobl.destroy();
					}else{
						$('#tbl-coordgobr').dataTable().fnClearTable();
						$('#tbl-coordgobr').dataTable().fnDestroy();
					}
				}				
				coordgobl = $("#tbl-coordgobr").DataTable({
					lengthMenu: [ 5,10,20 ],
					ajax:{
						url:"/mesas-coordinacion-gobierno",
						type:"POST",
						data:{PRY_Id:<%=PRY_Id%>}
					}
				});	
				$('#tbl-coordgobr').css('width','99%');
				$('#tbl-coordgobr').parent().css('overflow-x','scroll');
			}	
		}				

		$("#btn_frm11s2_3").click(function(){
			formValidate("#frm11s2_3");
			if($("#frm11s2_3").valid()){
				$.ajax({
					type: "POST",
					url: "/grabar-coordinacion-gobierno",
					data: $("#frm11s2_3").serialize(),
					dataType:'json',
					success: function(data) {					
						if(data.state==200){						
							coordgobl.ajax.reload();	
							$("#frm11s2_3")[0].reset();
							Toast.fire({
								icon: 'success',
								title: 'Sesión grabada correctamente'
							});
						}else{

						}
					}
				})																		
			}			
		})

		$("#pry-content").on("click",".delcoordgobl",function(){
			var CGO_Id=$(this).data("cgo");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
				text: "Con esta acción eliminarás la Sesión seleccionada!",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {					
					$.ajax({
						type: "POST",
						url: "/elimina-coordinacion-gobierno",
						data: {PRY_Id:<%=PRY_Id%>,CGO_Id:CGO_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								coordgobl.ajax.reload();		
								Toast.fire({
									icon: 'success',
									title: 'Sesión eliminada correctamente'
								});
							}else{

							}
						}
					})
				}
			})	
		})				
														
		$("#btn_frm11s2").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frm11s2_1");
			formValidate("#frm11s2_2");
			formValidate("#frm11s2_3");
			var valido = false
			
			if(TipoMesa == 2){
				if(coordtrab.data().count()>0 && coordempl.data().count()>0 && coordgobl.data().count()>0){
					valido=true;
				}
			}else{
				if(coordtrab.data().count()>0 && coordempl.data().count()>0){
					valido=true;
				}
			}
			
			if(valido){												
				$.ajax({
					type: 'POST',			
					url: $("#frm11s2").attr("action"),
					data: $("#frm11s2").serialize(),
					success: function(data) {								
						var param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Coordinación entre actores grabadas correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:2};
							$.ajax( {
								type:'POST',					
								url: '/mnu-11',
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
											text:data.message
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
			}else{
				swalWithBootstrapButtons.fire({
					icon:'error',								
					title: 'Debes agregar al menos una session para cada mesa bi/tripartita antes de avanzar.'
				});				
			}
		})

		$("#pry-content").on("click",".doverctr, .dovercem, .dovercgo",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id")
			var COO_Tipo = $(this).data("tip")
			var PRY_Hito = $(this).data("hito")
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-coordinacion',
				data:{COO_Id:COO_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',COO_Tipo:COO_Tipo},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,ENP_Id:COO_Id};
							$.ajax({
								url: "/bajar-archivo",
								method: 'POST',
								data:data,
								xhrFields: {
									responseType: 'blob'
								},
								success: function (data) {
									var a = document.createElement('a');
									var url = window.URL.createObjectURL(data);
									a.href = url;
									a.download = INF_Arc;
									document.body.append(a);
									a.click();
									a.remove();
									window.URL.revokeObjectURL(url);
								}
							});			
						})
					}else{
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
	});
</script>