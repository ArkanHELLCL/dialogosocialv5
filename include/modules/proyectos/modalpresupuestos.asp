<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	if(session("ds5_usrperfil")=3) then	'Ejecutor
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
	if(xm="visualizar") or (session("ds5_usrperfil")=4) then
		modo=4
		mode="vis"	
		required="readonly"
		disabled="disabled"	
	end if				
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		PRY_InformeSistematizacionAceptado = rs("PRY_InformeSistematizacionAceptado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")				
		PRY_MontoAdjudicado=rs("PRY_MontoAdjudicado")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
		if(PRY_InformeFinalAceptado="" or IsNULL(PRY_InformeFinalAceptado)) then
			PRY_InformeFinalAceptado=false
		end if
		if(PRY_InformeSistematizacionAceptado="" or IsNULL(PRY_InformeSistematizacionAceptado)) then
			PRY_InformeSistematizacionAceptado=false
		end if
	end if
	if(LFO_Id=10 or LFO_Id=12) then
		PRY_InfFinal = PRY_InformeFinalAceptado
	end if
	if(LFO_Id=11) then
		PRY_InfFinal = PRY_InformeSistematizacionAceptado
	end if
	'Requerimiento de Dialogo, mantener abiero el modulo despues de que el proyecto haya sido cerrado
	PRY_InfFinal = False
	'Requerimiento de Dialogo, mantener abiero el modulo despues de que el proyecto haya sido cerrado
	if(session("ds5_usrperfil")=4) and not PRY_InfFinal then
		required="readonly"
		disabled="disabled"
	else
		if (session("ds5_usrperfil")<>4) and not PRY_InfFinal then
			required="required"
			disabled=""
		else
			required="readonly"
			disabled="disabled"
		end if
	end if

	response.write("200\\#presupuestosModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-hand-holding-usd"></i> Presupuesto</div>				
			</div><%
			if(not PRY_InfFinal) then%>
				<form role="form" action="/agrega-presupuestos" method="POST" name="frmpresupuestos" id="frmpresupuestos" class="form-signin needs-validation" enctype="multipart/form-data">			
					<div class="modal-body">
						<h5>Presupuesto</h5>					
						<h6>Cuota <i class="fas fa-sync-alt limpiar" data-toogle="tooltip" title="Limpiar formulario para ingresar nuevo registro"></i></h6>
						<div class="row align-items-center">
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message"><%
										if(PRE_NumCuota<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="number" id="PRE_NumCuota" name="PRE_NumCuota" class="form-control" <%=required%> value="<%=PRE_NumCuota%>">
										<span class="select-bar"></span>
										<label for="PRE_NumCuota" class="<%=lblClass%>">#</label>
									</div>
								</div>
							</div>					
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message"><%
										if(PRE_PorcentajeMonto<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="number" id="PRE_PorcentajeMonto" name="PRE_PorcentajeMonto" class="form-control" <%=required%> value="<%=PRE_PorcentajeMonto%>">
										<span class="select-bar"></span>
										<label for="PRE_PorcentajeMonto" class="<%=lblClass%>">%</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message"><%
										if(PRE_MontoCuota<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="number" id="PRE_MontoCuota" name="PRE_MontoCuota" class="form-control" readonly <%=disabled%> value="<%=PRE_MontoCuota%>">
										<span class="select-bar"></span>
										<label for="PRE_MontoCuota" class="<%=lblClass%>">$</label>
									</div>
								</div>
							</div>							
							<div class="col-sm-12 col-md-12 col-lg-2">
								<div class="md-form input-with-post-icon">
									<div class="error-message">								
										<i class="fas fa-calendar input-prefix"></i><%
										if(PRE_FechaVenCuota<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="text" id="PRE_FechaVenCuota" name="PRE_FechaVenCuota" class="form-control calendario" readonly value="<%=PRE_FechaVenCuota%>" <%=disabled%>>
										<span class="select-bar"></span>
										<label for="PRE_FechaVenCuota" class="<%=lblClass%>">Vence</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-6 col-lg-4" style="text-align: center;">							
								<div class="md-radio radio-lightBlue md-radio-inline">
										<input id="PRE_EstadoCuotaPendiente" type="radio" name="PRE_EstadoCuota" checked value="0" disabled="">
									<label for="PRE_EstadoCuotaPendiente">Pendiente</label>
								</div>
								<div class="md-radio radio-lightBlue md-radio-inline">
										<input id="PRE_EstadoCuotaCancelado" type="radio" name="PRE_EstadoCuota" value="1" disabled="">
									<label for="PRE_EstadoCuotaCancelado">Cancelada</label>
								</div>			
							</div>												
												
						</div>
						<h6>Factura</h6>
						<div class="row">						
							<div class="col-sm-12 col-md-12 col-lg-3">
								<div class="md-form input-with-post-icon">
									<div class="error-message"><%
										if(PRE_NumFactura<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="number" id="PRE_NumFactura" name="PRE_NumFactura" class="form-control" value="<%=PRE_NumFactura%>" <%=disabled%>>
										<span class="select-bar"></span>
										<label for="PRE_NumFactura" class="<%=lblClass%>">#</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-3">
								<div class="md-form input-with-post-icon">
									<div class="error-message">								
										<i class="fas fa-dollar-sign input-prefix"></i><%
										if(PRE_MontoFactura<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="number" id="PRE_MontoFactura" name="PRE_MontoFactura" class="form-control" value="<%=PRE_MontoFactura%>" <%=disabled%>>
										<span class="select-bar"></span>
										<label for="PRE_MontoFactura" class="<%=lblClass%>">Monto</label>
									</div>
								</div>
							</div>
							<div class="col-sm-12 col-md-12 col-lg-3">
								<div class="md-form input-with-post-icon">
									<div class="error-message">								
										<i class="fas fa-calendar input-prefix"></i><%
										if(PRE_FechaFactura<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="text" id="PRE_FechaFactura" name="PRE_FechaFactura" class="form-control calendario" readonly value="<%=PRE_FechaFactura%>" <%=disabled%>>
										<span class="select-bar"></span>
										<label for="PRE_FechaFactura" class="<%=lblClass%>">Fecha</label>
									</div>
								</div>
							</div>	
							<div class="col-sm-12 col-md-12 col-lg-3">
								<div class="md-form input-with-post-icon">
									<div class="error-message">								
										<i class="fas fa-calendar input-prefix"></i><%
										if(PRE_FechaPagoCuota<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="text" id="PRE_FechaPagoCuota" name="PRE_FechaPagoCuota" class="form-control calendario" readonly value="<%=PRE_FechaPagoCuota%>" <%=disabled%>>
										<span class="select-bar"></span>
										<label for="PRE_FechaPagoCuota" class="<%=lblClass%>">Fecha Pago Real</label>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form input-with-post-icon">
									<div class="error-message">								
										<i class="fas fa-comment input-prefix"></i><%
										if(PRE_GlosaFactura<>"") then
											lblClass="active"
										else
											lblClass=""
										end if%>
										<input type="text" id="PRE_GlosaFactura" name="PRE_GlosaFactura" class="form-control" value="<%=PRE_GlosaFactura%>" <%=disabled%>>
										<span class="select-bar"></span>
										<label for="PRE_GlosaFactura" class="<%=lblClass%>">Glosa</label>
									</div>
								</div>
							</div>																					
						</div>																								

						<div class="row footer">							
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message ">
											<i class="fas fa-dollar-sign input-prefix"></i><%
											if(PRY_MontoAdjudicado<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="PRY_MontoAdjudicado" name="PRY_MontoAdjudicado" class="form-control" readonly value="<%=PRY_MontoAdjudicado%>">
											<span class="select-bar"></span>
											<label for="PRY_MontoAdjudicado" class="<%=lblClass%>">Monto adjudicado</label>
										</div>
									</div>
								</div>	
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<i class="fas fa-percent input-prefix"></i><%
											if(PRE_PorAvance<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="PRE_PorAvance" name="PRE_PorAvance" class="form-control" readonly value="0">
											<span class="select-bar"></span>
											<label for="PRE_PorAvance" class="active">% Avance</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">														
											<i class="fas fa-cloud-upload-alt input-prefix"></i>
											<input type="text" id="PRE_AdjuntoX" name="PRE_AdjuntoX" class="form-control" readonly value="" <%=disabled%>>
											<input type="file" id="PRE_Adjunto" name="PRE_Adjunto" readonly multiple size="5" accept="image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
											<span class="select-bar"></span>
											<label for="PRE_AdjuntoX" class="">Adjunto(s)</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select" id="selHitosLin">
												<select name="LFH_Id" id="LFH_Id" class="validate select-text form-control" required data-msg="Debes seleccionar un informe">
													<option value="" disabled selected></option><%													
													set rs = cnn.Execute("exec [spLineaFormativaHitosDisponibles_Listar] " & PRY_Id)
													on error resume next					
													do While Not rs.eof%>
														<option value="<%=rs("LFH_Id")%>"><%=rs("LFH_HitoDescripcion")%></option><%
														rs.movenext						
													loop
													rs.Close%>
												</select>														
												<i class="fas fa-list-ol input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Informe</label>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3"><%
									if (session("ds5_usrperfil")=5 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) then%>
										<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frmaddpresupuestos" name="btn_frmaddpresupuestos" data-toggle="tooltip" title="Agregar nuevo registro"><i class="fas fa-plus"></i></button><%
									end if%>							
									<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" data-dismiss="modal" data-toggle="tooltip" title="Salir depresupuesto"><i class="fas fa-sign-out-alt"></i></button>
								</div>
							
						</div>

					</div>
					<!--modal-body-->				
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRE_Id" name="PRE_Id" value="">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="PorTot" name="PorTot" value="">
					<input type="hidden" id="PorTotOri" name="PorTotOri" value="">
					<input type="hidden" id="PRE_PorAvanceOri" name="PRE_PorAvanceOri" value="">
					<input type="hidden" id="LFO_Id" name="LFO_Id" value="<%=LFO_Id%>">
				</form><%			
			end if%>
			<!--form-->			
			<div class="row">
				<div class="col-12">
					<div class="px-4">
						<table id="tbl-presupuestos" class="ts table table-striped table-bordered dataTable table-sm" data-id="presupuestos" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">Id</th>
									<th>Informe</th>
									<th>Cuota</th>
									<th>%</th>
									<th>Monto</th> 
									<th>Estado</th>									
									
									<th>M.Factura</th>
									<th>F.Factura</th> 
									<th>N.Factura</th>									
									<th>F.P.Cuota</th> 									
									
									<%
									if(session("ds5_usrperfil")<>3 and session("ds5_usrperfil"))<>4 then%>
										<th>Acciones</th><%
									end if%>
								</tr> 
							</thead>					
							<tbody> 
							      	
							</tbody>
						</table>
					</div>
				</div>
			</div><%
			if(PRY_InfFinal) then%>
				<div class="row" style="margin-bottom:20px;">
					<div class="col-sm-12 col-md-12 col-lg-9">
					</div>
					<div class="col-sm-12 col-md-12 col-lg-3">
						<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" data-dismiss="modal" data-toggle="tooltip" title="Salir depresupuesto" style="float:right;margin-right:20px"><i class="fas fa-sign-out-alt"></i>Salir</button>
					</div>
				</div><%
			end if%>
			
		</div>
		<!--modal-cotent-->
	</div>
	<!--modal-dialogo-->

<script>   
	function tooltipfunction(){
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})	
	}
	tooltipfunction();
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("h6").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);		
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var portot = 0
		var portotori = 0
		
		var presupuestosTable;						
		loadTablePresupuestos();
		$('#tbl-presupuestos').css('width','99%');
		
		
		$(".limpiar").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#frmpresupuestos")[0].reset();
			$("#frmpresupuestos").attr("action","/agrega-presupuestos");
			
			$("#PRE_MontoFactura").removeAttr("required");
			$("#PRE_FechaFactura").removeAttr("required");
			$("#PRE_NumFactura").removeAttr("required");
			$("#PRE_GlosaFactura").removeAttr("required");
			$("#PRE_MontoFactura").siblings("label").removeClass("active");
			$("#PRE_FechaFactura").siblings("label").removeClass("active");
			$("#PRE_NumFactura").siblings("label").removeClass("active");
			$("#PRE_GlosaFactura").siblings("label").removeClass("active");
			$("#PRE_EstadoCuotaPendiente").attr("checked","checked");
			$("#PRE_EstadoCuotaCancelado").removeAttr("checked");
			
			$("#btn_frmaddpresupuestos").removeClass("btn-warning");
			$("#btn_frmaddpresupuestos").addClass("btn-success");
			$("#btn_frmaddpresupuestos").html("<i class='fas fa-plus'></i>");
			$("#btn_frmaddpresupuestos").attr("data-original-title","Agregar nuevo registro")
			$(".limpiar").slideUp();
			tooltipfunction();
			$.ajax({
				url:"/select-hitos",
				data:{PRY_Id:$("#PRY_Id").val()},
				type:"POST",
				success:function(data){
					dataSplit = data.split(sas);
					if(dataSplit[0]==200){
						$("#selHitosLin").html(dataSplit[1]);
					}											
				}
			})
			
			
		})
		
		$("#PRE_NumFactura").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			if($(this).val()!=""){
				$("#PRE_MontoFactura").attr("required","required");
				$("#PRE_FechaFactura").attr("required","required");
				
				$("#PRE_GlosaFactura").attr("required","required");
			}else{
				$("#PRE_MontoFactura").removeAttr("required");
				$("#PRE_FechaFactura").removeAttr("required");
				$("#PRE_FechaFactura").removeClass("is-invalid");
				
				$("#PRE_GlosaFactura").removeAttr("required");
			}
		})
		
		$("#PRE_PorcentajeMonto").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			if(parseInt($(this).val())>0){
				$("#PRE_MontoCuota").val((parseInt($("#PRY_MontoAdjudicado").val())*parseInt($(this).val())/100))
			}
		})		
		
		$("#PRE_MontoFactura").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			estadoCuota($(this).val())
		})				
		
		function estadoCuota(valor){
			if(parseInt(valor)>=parseInt($("#PRE_MontoCuota").val())){
				$("#PRE_EstadoCuotaPendiente").removeAttr("checked");
				$("#PRE_EstadoCuotaCancelado").attr("checked","checked");
				$("#PRE_PorAvance").val(parseInt($("#PRE_PorAvanceOri").val()) + parseInt($("#PRE_PorcentajeMonto").val()));
				$("#PRE_PorAvance").siblings("label").addClass("active");
			}else{
				$("#PRE_EstadoCuotaPendiente").attr("checked","checked");
				$("#PRE_EstadoCuotaCancelado").removeAttr("checked");
				$("#PRE_PorAvance").val(parseInt($("#PRE_PorAvanceOri").val()) + parseInt($("#PRE_PorcentajeMonto").val()));
				$("#PRE_PorAvance").siblings("label").addClass("active");
			}						
		}
		
		function loadTablePresupuestos() {
			if($.fn.DataTable.isDataTable( "#tbl-presupuestos")){				
				presupuestosTable.destroy();				
			}	
			presupuestosTable = $('#tbl-presupuestos').DataTable({				
				lengthMenu: [ 5,10,20 ],				
				ajax:{
					url:"/tbl-presupuestos",					
					type:"POST",
					dataSrc:function(json){
						$("#PRE_PorAvance").val(json.PorTotCan);
						$("#PRE_PorAvanceOri").val(json.PorTotCan);
						$("#PRE_PorAvance").siblings("label").addClass("active");
						$("#PorTot").val(json.PorTot);
						$("#PorTotOri").val(json.PorTot);
						return json.data;
					},
					data:{PRY_Id:<%=PRY_Id%>,mode:"<%=mode%>"}
				},
				"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {										
					$(nRow).each(function(e){
						var largo = $(nRow).find("td").length - 2;						
						$(this).find("td").each(function(e){
							if(e<=largo){								
								$(this).click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();
									
									$("#tbl-presupuestos tbody tr").each(function(e){
										$(this).removeClass("selected");									
									})
									
									var PRE_Id = $(this).parent().find("td")[0].innerText;						
									var data={PRE_Id:PRE_Id,mode:'mod'}
									$(nRow).toggleClass("selected");
									
									$("#btn_frmaddpresupuestos").removeClass("btn-success");
									$("#btn_frmaddpresupuestos").addClass("btn-warning");
									$("#btn_frmaddpresupuestos").html("<i class='fas fa-download'></i>");
									$("#btn_frmaddpresupuestos").attr("data-original-title","Actualizar registro existente")
									$(".limpiar").slideDown(function(){
										tooltipfunction();
									});
									$("#frmpresupuestos").attr("action","/modifica-presupuestos");												
									$("#frmpresupuestos")[0].reset();
									
									
									var portotTR = parseInt($(this).parent().find("td")[2].innerText)
									$("#PorTot").val(parseInt($("#PorTotOri").val()) - portotTR);
									
									
									$.ajax({
										type:'POST',										
										url: '/consultar-presupuestos',					
										data: {PRE_Id:PRE_Id},
										dataType: "json",
										success: function ( json ) {
											var datos = json.data[0];											
											$("#PRE_Id").val(datos[0]);
											$("#PRE_NumCuota").val(datos[1]);
											$("#PRE_NumCuota").siblings("label").addClass("active");											
											$("#PRE_PorcentajeMonto").val(datos[2]);
											$("#PRE_PorcentajeMonto").siblings("label").addClass("active");
											$("#PRE_MontoCuota").val(datos[3]);
											$("#PRE_MontoCuota").siblings("label").addClass("active");
											if(parseInt(datos[4])==1){
												$("#PRE_EstadoCuotaPendiente").removeAttr("checked");
												$("#PRE_EstadoCuotaCancelado").attr("checked","checked");
											}else{
												$("#PRE_EstadoCuotaPendiente").attr("checked","checked");
												$("#PRE_EstadoCuotaCancelado").removeAttr("checked");
											}
											$("#PRE_MontoFactura").val(datos[5]);
											$("#PRE_MontoFactura").siblings("label").addClass("active");
											$("#PRE_FechaFactura").val(datos[6]);
											$("#PRE_FechaFactura").siblings("label").addClass("active");
											$("#PRE_NumFactura").val(datos[7]);
											$("#PRE_NumFactura").siblings("label").addClass("active");											
											$("#PRE_FechaPagoCuota").val(datos[8]);					
											$("#PRE_FechaPagoCuota").siblings("label").addClass("active");
											$("#PRE_FechaVenCuota").val(datos[9]);
											$("#PRE_FechaVenCuota").siblings("label").addClass("active");
											$("#PRE_GlosaFactura").val(datos[10]);						
											$("#PRE_GlosaFactura").siblings("label").addClass("active");
											$("#PRE_PorAvanceOri").val($("#PRE_PorAvanceOri").val() - parseInt(datos[2]));
											$.ajax({
												url:"/select-hitos",
												data:{PRY_Id:$("#PRY_Id").val()},
												type:"POST",
												success:function(data){
													dataSplit = data.split(sas);
													if(dataSplit[0]==200){
														$("#selHitosLin").html(dataSplit[1]);
														$("select#LFH_Id").append('<option value="'+datos[11]+'" selected>'+datos[12]+'</option>');
													}											
												}
											})																						
											estadoCuota($("#PRE_MontoFactura").val());
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){					
											swalWithBootstrapButtons.fire({
												icon:'error',								
												title: 'Ups!, no pude cargar el menú del proyecto',					
											});				
										}
									});																											
								})
							}else{
								$(this).find("i.delpre").click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();
									
									var PRY_Id=$(this).data("pry");
									var PRE_Id=$(this).data("pre");
									var PRE_NumCuota=$(this).data("num");									
									
									swalWithBootstrapButtons.fire({
										title: '¿Estas seguro?',
										text: "¿Realmente quiere eliminar la cuota " + PRE_NumCuota + " y todos sus anexos del presupuesto?",
										icon: 'question',
										showCancelButton: true,
										confirmButtonColor: '#3085d6',
										cancelButtonColor: '#d33',
										confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar',
										cancelButtonText: '<i class="fas fa-thumbs-down"></i> No todavía'
									}).then((result) => {
										if (result.value) {													
											$.ajax({
												type:'POST',										
												url: '/elimina-presupuestos',					
												data: {PRY_Id:PRY_Id,PRY_Identificador:'<%=PRY_Identificador%>',PRE_Id:PRE_Id,PRE_NumCuota:PRE_NumCuota},
												dataType: "json",
												success: function ( data ) {						
													if(data.state=="200"){							
														Toast.fire({
															icon: 'success',
															title: 'Presupuesto y sus anexos eliminado correctamente!'
														});	
														presupuestosTable.ajax.reload();
														$("#frmpresupuestos")[0].reset();
														$.ajax({
															url:"/select-hitos",
															data:{PRY_Id:$("#PRY_Id").val()},
															type:"POST",
															success:function(data){
																dataSplit = data.split(sas);
																if(dataSplit[0]==200){
																	$("#selHitosLin").html(dataSplit[1]);
																}											
															}
														})
													}else{
														swalWithBootstrapButtons.fire({
															icon:'error',								
															title: 'Ups!, no pude grabar datos del contratoo',
															text: data.data
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
										}
									})
								})								
								$(this).find("i.downloadFile").click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();
									
									var PRY_Id=$(this).data("pry");
									var PRE_Id=$(this).data("pre");
									var PRE_NumCuota=$(this).data("num");									
																		
									ajax_icon_handling('load','Buscando archivos de presupuestos','','');
									$.ajax({
										type: 'POST',								
										url:'/listar-presupuestos',			
										data:{PRY_Id:PRY_Id,PRE_NumCuota:PRE_NumCuota},
										success: function(data) {
											var param=data.split(sas);			
											if(param[0]=="200"){				
												ajax_icon_handling(true,'Listado de archivos de presupuestos creado.','',param[1]);
												$(".swal2-popup").css("width","60rem");
												loadtables("#tbl-cuotas");
												$(".arcalm").click(function(){
													var INF_Arc = $(this).data("file");
													var PRY_Hito= $(this).data("hito");
													var PRY_Id  = $("#PRY_Id").val();
													var PRY_Identificador  = $("#PRY_Identificador").val();
													var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador,PRY_Hito:101,INF_Arc:INF_Arc,PRE_NumCuota:PRE_NumCuota};
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
												ajax_icon_handling(false,'No fue posible crear el listado de archivos.','','');
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											ajax_icon_handling(false,'No fue posible crear el listado de archivos.','','');	
										},
										complete: function(){																		
										}
									})									
								})																
							}
						})
					})
				}
			});
			tooltipfunction();
			$(".table-wrapper").mCustomScrollbar({
				theme:scrollTheme,				
				axis:"x"
			});		
		}	
				
		$("#presupuestosModal").on('show.bs.modal', function(e){			
				
		})

		$("#presupuestosModal").on('shown.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();	
			$("#PRE_AdjuntoX").click(function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();	
				$("#PRE_Adjunto").click();
			})
			$("#PRE_Adjunto").change(function(click){
				click.preventDefault();
				click.stopImmediatePropagation();
				click.stopPropagation();
				var fakepath_1 = "C:" + ss + "fakepath" + ss
				var fakepath_2 = "C:" + bb + "fakepath" + bb
				var fakepath_3 = "C:" + s + "fakepath" + s
				var fakepath_4 = "C:" + b + "fakepath" + b												
				
				var cont = 0;
				$.each (this.files,function(e){					
					cont = cont +1;
				});
				$('#PRE_AdjuntoX').val("Archivo(s) adjunto(s) : " + cont);
			})
			$(".calendario").datepicker({
				beforeShow: function(input, inst) {
					$(document).off('focusin.bs.modal');
				},
				onClose:function(){
					$(document).on('focusin.bs.modal');
				},
			});
		});		

		$("#presupuestosModal").on('hidden.bs.modal', function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#presupuestosModal").empty();	
			var PAR_Hito = window.location.href.split("/")[8];
			var PAR_Step = window.location.href.split("/")[9];
			var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,PRY_Hito:PAR_Hito,CRT_Step:PAR_Step};
			$.ajax( {
				type:'POST',					
				url: '/mnu-<%=LFO_Id%>',
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
		});					

		$("#presupuestosModal").on("click","#btn_frmaddpresupuestos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			formValidate("#frmpresupuestos");
			if($("#frmpresupuestos").valid()){				
				var formdata = new FormData();	  	  									
				var file_data = $('#PRE_Adjunto').prop('files');				
				var sizerror=false;
				var sumsize=0;

				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i]);
					if(file_data[i].size>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					};
					sumsize=sumsize+file_data[i].size;
				};
				
				formdata.append("PRE_Id",$("#PRE_Id").val());
				formdata.append("PRY_Id",$("#PRY_Id").val());
				formdata.append("PRY_Identificador",$("#PRY_Identificador").val());
				formdata.append("PRE_NumCuota",$("#PRE_NumCuota").val());
				formdata.append("PRE_PorcentajeMonto",$("#PRE_PorcentajeMonto").val());
				formdata.append("PRE_MontoCuota",$("#PRE_MontoCuota").val());
				formdata.append("PRE_FechaVenCuota",$("#PRE_FechaVenCuota").val());
				formdata.append("PRE_EstadoCuotaPendiente",$("#PRE_EstadoCuotaPendiente").val());
				formdata.append("PRE_EstadoCuotaCancelado",$("#PRE_EstadoCuotaCancelado").val());
				formdata.append("PRE_EstadoCuota",$('input:radio[name=PRE_EstadoCuota]:checked').val());				
				formdata.append("PRE_NumFactura",$("#PRE_NumFactura").val());
				formdata.append("PRE_MontoFactura",$("#PRE_MontoFactura").val());
				formdata.append("PRE_FechaFactura",$("#PRE_FechaFactura").val());
				formdata.append("PRE_FechaPagoCuota",$("#PRE_FechaPagoCuota").val());
				formdata.append("PRE_GlosaFactura",$("#PRE_GlosaFactura").val());								
				formdata.append("PRE_AdjuntoX",$("#PRE_AdjuntoX").val());
				formdata.append("LFH_Id",$("#LFH_Id").val());
				
				if($("#frmpresupuestos").attr('action')=="/agrega-presupuestos"){
					var msg="Presupuesto agregado correctamente!";
					var rs=true;
				}else{
					var msg="Presupuesto modificado correctamente!";
					var rs=false;
				}
				if(sumsize>parseInt(maxupload[maxsize].size)){
					sizerror=true;					
				}
				if(sizerror){
					$("#PRE_AdjuntoX").removeClass("is-valid");
					$("#PRE_AdjuntoX").addClass("is-invalid");
					$("#PRE_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
					$("#PRE_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
					$("#PRE_AdjuntoX").parent().after('<div id="PRE_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">'+ maxupload[maxsize]['msg-invalid'] +'</div>');
					Toast.fire({
						icon: 'error',
						title: maxupload[maxsize]['msg-toast']
					});	
				}else{
					$.ajax({
						type:'POST',
						enctype: $("#frmpresupuestos").attr('enctype'),
						cache: false,
						contentType: false,
						processData: false,					
						url: $("#frmpresupuestos").attr('action'),
						data: formdata,
						dataType: "json",
						success: function ( data ) {						
							if(data.state=="200"){								
								presupuestosTable.ajax.reload();
								Toast.fire({
									icon: 'success',
									title: msg
								});									
								if(rs){
									$("#frmpresupuestos")[0].reset();
									$("#PRE_MontoFactura").removeAttr("required");
									$("#PRE_FechaFactura").removeAttr("required");
									$("#PRE_NumFactura").removeAttr("required");
									$("#PRE_GlosaFactura").removeAttr("required");
									$("#PRE_MontoFactura").siblings("label").removeClass("active");
									$("#PRE_FechaFactura").siblings("label").removeClass("active");
									$("#PRE_NumFactura").siblings("label").removeClass("active");
									$("#PRE_GlosaFactura").siblings("label").removeClass("active");
									$("#PRE_EstadoCuotaPendiente").attr("checked","checked");
									$("#PRE_EstadoCuotaCancelado").removeAttr("checked");
									presupuestosTable.ajax.reload();
									$.ajax({
										url:"/select-hitos",
										data:{PRY_Id:$("#PRY_Id").val()},
										type:"POST",
										success:function(data){
											dataSplit = data.split(sas);
											if(dataSplit[0]==200){
												$("#selHitosLin").html(dataSplit[1]);
											}											
										}
									})
								}			
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude grabar datos del presupuesto',
									text: data.data
								});
							}
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){					
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude cargar el menú del proyecto',					
							});				
						}
					})
				}
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen datos de presupuestos sin agregar!'
				});			
			}
		})				
		
		
		$("body").append("<button id='btn_modalpresupuestos' name='btn_modalpresupuestos' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalpresupuestos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#presupuestosModal").modal("show");
			$("body").addClass("modal-open");
			$(".modal-open #presupuestosModal").mCustomScrollbar({
				theme:scrollTheme,
			})
		});
		$("#btn_modalpresupuestos").click();		
		$("#btn_modalpresupuestos").remove();
	})
</script>