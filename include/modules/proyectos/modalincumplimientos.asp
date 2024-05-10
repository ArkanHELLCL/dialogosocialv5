<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	'if(session("ds5_usrperfil")=5) then	'Adminsitrativo
	''   response.Write("403\\Error Perfil no autorizado")
	''   response.End() 
	'end if
	splitruta=split(ruta,"/")		
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	
	if(xm="modificar") then
		modo=2
		mode="mod"
		required="required"
	end if
	if(xm="visualizar") or (session("ds5_usrperfil")=4) then
		modo=4
		mode="vis"
		required="disabled"
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
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		PRY_IdLicitacion=rs("PRY_IdLicitacion")
		PRY_NombreLicitacion=rs("PRY_NombreLicitacion")
		FON_Nombre=rs("FON_Nombre")
		PRY_NumResAprueba=rs("PRY_NumResAprueba")
		PRY_FechaResolucion=rs("PRY_FechaResolucion")
		PRY_Adjunto=rs("PRY_Adjunto")
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
		PRY_EmpresaEjecutora=rs("PRY_EmpresaEjecutora")
		PRY_Nombre=rs("PRY_Nombre")
		REG_Nombre=rs("REG_Nombre")
		PRY_EncargadoProyecto=rs("PRY_EncargadoProyecto")
		PRY_EncargadoActividades=rs("PRY_EncargadoActividades")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
	end if
	columnsDefsincumplimientos="[]"
	columDefsRespIncCum="[]"
	if (session("ds5_usrperfil")=3 or session("ds5_usrperfil")=1) then
		columDefsRespIncCum="[{'targets': [1,3],'width':'20%'},{'targets': [6],'width':'40%'},{ 'targets': [8, 9, 10], 'visible': true, 'searchable': false, 'width':'0%', orderable: false}]"	
	end if
	response.write("200\\#incumplimientosModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-thumbs-down"></i> Incumplimientos</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">																				
				<div id="frmincumplimientos" class="px-4">
																				
				</div>				
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
					<div class="px-4">
						<div class="table-wrapper col-sm-12" id="container-table-incumplimientos">
							<!--Table-->
							<table id="tbl-incumplimientos" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="incumplimientos" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead>	
									<tr>
										<th>Id</th>
										<th>Incumplimiento</th>
										<th>Gravedad</th>
										<th>Monto</th>
										<th>Moneda</th>
										<th>Veces</th>										
										<th>Total</th>																				
										<th>Aplicado</th>
										<th>Medida</th>
										<th>Acciones</th>
									</tr>
								</thead>									
							</table>
						</div>
					</div>							
				</div>									
			</div>
			<!--body-->
			<div class="modal-footer">				
				<div style="float:left;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Agregar nuevo Incumplimiento" id="btn_agregaincumplimiento" name="btn_agregaincumplimiento"><i class="fas fa-angle-up ml-1"></i></button>
				</div>				

				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="incumplimientos"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->

<script>    
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
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
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);						
				
		var incumplimientosTable;
		var tablaincumplimientosAlto;
		var disabled={};
		var iTermGPACounter = 1;	
		var listincumplimientospry;
		var tbl_incumplimientosTable;
		var respincumTable;
		var incdocrecTable;
		var incdocenvTable;
		
		$("#incumplimientosModal").on('show.bs.modal', function(e){					
			
		})		
					
		function loadTableincumplimientos(){			
			if($.fn.DataTable.isDataTable( "#tbl-incumplimientos")){				
				if(incumplimientosTable!=undefined){
					incumplimientosTable.destroy();
				}else{
					$('#tbl-incumplimientos').dataTable().fnClearTable();
    				$('#tbl-incumplimientos').dataTable().fnDestroy();
				}
			}	
			incumplimientosTable = $('#tbl-incumplimientos').DataTable({
				lengthMenu: [ 3,5 ],
				ajax:{
					url:"/incumplimientos",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},
				"order": [[ 0, "asc" ]],
				"columnDefs": <%=columnsDefsincumplimientos%>				
			});	
		}								
		
		$("#incumplimientosModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();									
			
			$(document).off('focusin.modal');
			$("body").addClass("modal-open");
			loadTableincumplimientos();			
			exportTable();
		});				
		
		$("#incumplimientosModal").on("click","#btn_frmaddincumplimientos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var mod = false;
			var form;
			var formdata = new FormData();
			formValidate("#frmincumplimientosadd");
										
			if($("#frmincumplimientosadd").valid()){
				var data1 = $("#frmincumplimientosadd").serializeArray();								
				var file_data = $('#INC_Adjunto').prop('files');				
				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i])
				}
				$.each(data1, function(i, field) { 
                   formdata.append(field.name,field.value);
                });
				var Veces=$("#INC_Veces").val();
				var errores=false;
				var INC_Id;
				var x=0;
				var Incumplimientos="";
				$.ajaxSetup({async:false});
				for(i = 0; i < parseInt(Veces); i++){
					if(i>0){
						Incumplimientos=Incumplimientos + ","
					}
					$.ajax({
						url: "/agregar-incumplimientos",
						method: 'POST',					
						data:formdata,
						enctype: 'multipart/form-data',
						cache: false,
						contentType: false,
						processData: false,
						dataType: "json",
						success: function (data) {						
							x=x+1
							if(data.state==200){
								if(x==0){
									x=1									
								}	INC_Id=data.data							
							}else{
								errores=true								
							}
						}
					});
					Incumplimientos=Incumplimientos + INC_Id										
				}				
				$("#frmincumplimientosadd")[0].reset();
				if(!errores){
					Toast.fire({
					  icon: 'success',
					  title: 'Incumplimiento(s) agregado(s) exitosamente.'
					});					
					$.ajax({
						url: "/enviar-correo-incumplimientos",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,Veces:Veces,INC_Id:INC_Id,Incumplimientos:Incumplimientos},						
						dataType: "json",
						success: function (data) {						
							if(data.state==200){

							}else{								
							}
						}
					});		
				}else{					
					Toast.fire({
					  icon: 'error',
					  title: 'Uno o más Incumplimiento(s) no fueron agregados.'
					})
				}
				$.ajaxSetup({async:true});
			}else{
				Toast.fire({
				  icon: 'error',
				  title: 'Corrige los campos con error antes de guardar'
				});
			}
		})
		
		$("#incumplimientosModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("body").removeClass("modal-open")
			$("#frmincumplimientos").css("height","0");			
			$("#btn_agregaincumplimiento").find('i').toggleClass('openmenu');			
			$('#container-table-incumplimientos').animate({
				height: $('#container-table-incumplimientos').get(0).scrollHeight
			}, 700, function(){
				$(this).height('auto');
			});
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
		
		$("#incumplimientosModal").on("click","#btn_agregaincumplimiento",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			incumplimientos_ingreso(e)			
			$("#btn_frmaddincumplimientos").show();
			if($("#frmincumplimientos").css("height")=="500px"){				
				$("#frmincumplimientos").css("height","0");				
				$("#btn_agregaincumplimiento").find('i').toggleClass('openmenu');				
				$('#container-table-incumplimientos').animate({
					height: $('#container-table-incumplimientos').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});								
			}else{								
				$("#frmincumplimientos").css("height","500px");								
				$("#btn_agregaincumplimiento").find('i').toggleClass('openmenu');
				$("#container-table-incumplimientos").css("height","0");				
			}						
		})
		
		$("#incumplimientosModal").on("click","#btn_salirincumplimientos, #btn_frmcandoc",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			incumplimientosTable.ajax.reload();			
			$("#frmincumplimientos").find(":input").each(function(){
				if(disabled[$(this).attr("id")]=="disabled"){
					$(this).attr("disabled","disbaled");
				}else{
					$(this).removeAttr("disabled");
				}
				disabled={}				
			});
			if($("#frmincumplimientos").css("height")=="500px"){				
				$("#frmincumplimientos").css("height","0");				
				$("#btn_agregaincumplimiento").find('i').toggleClass('openmenu');				
				$('#container-table-incumplimientos').animate({
					height: $('#container-table-incumplimientos').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');					
				});				
			}			
		})		
		
		
		$("#incumplimientosModal").on("click",".arcalm",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var PRY_Id=$(this).data("pry");
			var INF_Arc=$(this).data("arc");
			var PRY_Identificador=$(this).data("token");
			var PRY_Hito=$(this).data("hito");
			var ALU_Rut=$(this).data("rut");
			
			var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador, INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut};			
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
		
		function carga_respuestas(){
			if($.fn.DataTable.isDataTable( "#tbl-respincum")){				
				if(respincumTable!=undefined){
					respincumTable.destroy();
				}else{
					$('#tbl-respincum').dataTable().fnClearTable();
					$('#tbl-respincum').dataTable().fnDestroy();
				}
			}
			respincumTable = $("#tbl-respincum").DataTable({
				lengthMenu: [ 5,7,10 ],
				order: [[ 0, 'desc' ]],
				ajax:{
					url:"/ver-respuestas-incumplimientos",
					data:{PRY_Id:<%=PRY_Id%>},
					type:"POST",
					complete:function(){						
					}
				},
				columnDefs: <%=columDefsRespIncCum%>,
				autoWidth: false
			});	
			$('#tbl-respincum').css("width","99%");
		}
		
		function carga_envio(){			
			if($.fn.DataTable.isDataTable( "#tbl-incdocenv")){				
				if(incdocenvTable!=undefined){
					incdocenvTable.destroy();
				}else{
					$('#tbl-incdocenv').dataTable().fnClearTable();
					$('#tbl-incdocenv').dataTable().fnDestroy();
				}
			}
			incdocenvTable = $("#tbl-incdocenv").DataTable({
				lengthMenu: [ 3,5 ],
				order: [[ 0, 'desc' ]],
				ajax:{
					url:"/ver-documentos-enviados-incumplimientos",
					data:{PRY_Id:<%=PRY_Id%>},
					type:"POST"				
				}
			})
			$('#tbl-incdocenv').css("width","99%");
		}
		
		function carga_recepcion(){
			if($.fn.DataTable.isDataTable( "#tbl-incdocrec")){				
				if(incdocrecTable!=undefined){
					incdocrecTable.destroy();
				}else{
					$('#tbl-incdocrec').dataTable().fnClearTable();
					$('#tbl-incdocrec').dataTable().fnDestroy();
				}
			}
			incdocrecTable = $("#tbl-incdocrec").DataTable({
				lengthMenu: [ 3,5 ],
				order: [[ 0, 'desc' ]],
				ajax:{
					url:"/ver-documentos-recepcionados-incumplimientos",
					data:{PRY_Id:<%=PRY_Id%>},
					type:"POST"				
				}
			})
			$('#tbl-incdocrec').css("width","99%");
		}
		
		function incumplimientos_ingreso(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			$.ajax( {
				type:'POST',					
				url: '/incumplimientos-modal-ingreso',
				data:data,					
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmincumplimientos").html(param[1]);
						
						$("#frmincumplimientos").tabsmaterialize({menumovil:false},function(){});
						
						$(".calendario").datepicker({
							beforeShow: function(input, inst) {
								$(document).off('focusin.bs.modal');
							},
							onClose:function(){
								$(document).on('focusin.bs.modal');
							},
						});
						
						carga_envio()
						carga_recepcion()
						carga_respuestas();												
																		
						$("#INC_AdjuntoX").click(function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							$("#INC_Adjunto").click();
						})
						$("#INC_Adjunto").change(function(click){								
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
							$('#INC_AdjuntoX').val("Archivo(s) adjunto(s) : " + cont);
						})	
						
						
						$("#frmincumplimientos").on("click","#IPR_IdRec",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							ajax_icon_handling('load','Buscando incumplimientos del proyecto','','');
							$.ajax({
								type: 'POST',								
								url:'/listar-incumplimientos-proyecto',			
								data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',Type:2},
								success: function(data) {
									var param=data.split(bb);			
									if(param[0]=="200"){				
										ajax_icon_handling(true,'Listado de Incumplimientos del proyecto creado.','',param[1]);
										$(".swal2-popup").css("width","60rem");
										listincumplimientospry = $("#tbl-listincumplimientospry").DataTable({
											columnDefs: [ {
												targets: 0,
												data: null,
												defaultContent: '',
												orderable: false,
												className: 'select-checkbox',
												width:"50px"
											} ],
											select: {
												style:    'multi',
												selector: 'td:first-child'

											},
											order: [[ 1, 'desc' ]],
											lengthMenu: [ 3,5,7 ]
										});
									}else{
										ajax_icon_handling(false,'No fue posible crear el listado de incumplimientos.','','');
									}						
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){				
									ajax_icon_handling(false,'No fue posible crear el listado de incumplimientos.','','');	
								},
								complete: function(){																		
								}
							})
						})
						
						$("#frmincumplimientos").on("click","#IPR_IdEnv",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							ajax_icon_handling('load','Buscando incumplimientos del proyecto','','');
							$.ajax({
								type: 'POST',								
								url:'/listar-incumplimientos-proyecto',			
								data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',Type:1},
								success: function(data) {
									var param=data.split(bb);			
									if(param[0]=="200"){				
										ajax_icon_handling(true,'Listado de Incumplimientos del proyecto creado.','',param[1]);
										$(".swal2-popup").css("width","60rem");
										listincumplimientospry = $("#tbl-listincumplimientospry").DataTable({
											columnDefs: [ {
												targets: 0,
												data: null,
												defaultContent: '',
												orderable: false,
												className: 'select-checkbox',
												width:"50px"
											} ],
											select: {
												style:    'multi',
												selector: 'td:first-child'

											},
											order: [[ 1, 'desc' ]],
											lengthMenu: [ 3,5,7 ]
										});
									}else{
										ajax_icon_handling(false,'No fue posible crear el listado de incumplimientos.','','');
									}						
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){				
									ajax_icon_handling(false,'No fue posible crear el listado de incumplimientos.','','');	
								},
								complete: function(){																		
								}
							})
						})
						
						
						$("#frmincumplimientosdocrec").on("change","#TDG_IdRec",function(e){
							var tipo;
							if($(this).val()==1 || $(this).val()==7 || $(this).val()==8){
								$("#FechaRec").siblings("label").html("F.Recepción");
								$("#FechaRecDoc").hide();
							}else{					
								$("#FechaRecDoc").show();
								$("#FechaRec").siblings("label").html("F.Total Tramitación")								
							}
						})
						
						$("#frmincumplimientosdocrec").on("click","#btn_frmadddocrec",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							
							formValidate("#frmincumplimientosdocrec");										
							if($("#frmincumplimientosdocrec").valid()){							
								var IPR_Id = $("#IPR_IdRec").val().split(",");
								var TDG_Id = $("#TDG_IdRec").val();
								var DIN_NumDocumento = $("#DIN_NumDocumentoRec").val();
								var Fecha = $("#FechaRec").val();
								var DIN_AplicaDesestimaMultaRec = $('input:checkbox[name=DIN_AplicaDesestimaMultaRec]:checked').val();
								var IPR_MontoAplicadoRec = $("#IPR_MontoAplicadoRec").val();
								
								$(IPR_Id).each(function(i,e){
									var data = {IPR_Id: e, TDG_Id: TDG_Id, DIN_NumDocumento: DIN_NumDocumento, PRY_Id:<%=PRY_Id%>,FechaRec: Fecha, DIN_AplicaDesestimaMultaRec:DIN_AplicaDesestimaMultaRec, IPR_MontoAplicadoRec:IPR_MontoAplicadoRec}
									
									$.ajax({
										type: "POST",		
										url: "/agregar-documento-recepcionado-incumplimiento",
										data: data,									
										success: function (data) {	
											var param = data.split(bb)
											if(param[0]==200){												
												
											}else{
											}
										},
										error: function(){											
										}																											
									})
								})
								Toast.fire({
								  icon: 'success',
								  title: 'Documento agregado exitosamente'
								});												
								incdocrecTable.ajax.reload();
								$("#frmincumplimientosdocrec")[0].reset();
							}else{
								Toast.fire({
								  icon: 'error',
								  title: 'Corrige los campos con errores antes de grabar.'
								});
							}
							
						})
						
						$("#frmincumplimientosdocenv").on("click","#btn_frmadddocenv",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							
							formValidate("#frmincumplimientosdocenv");										
							if($("#frmincumplimientosdocenv").valid()){							
								var IPR_Id = $("#IPR_IdEnv").val().split(",");
								var TDG_Id = $("#TDG_IdEnv").val();
								var DIN_NumDocumento = $("#DIN_NumDocumentoEnv").val();
								var DIN_FechaEnvio = $("#DIN_FechaEnvioEnv").val();
								
								$(IPR_Id).each(function(i,e){
									var data = {IPR_Id: e, TDG_Id: TDG_Id, DIN_NumDocumento: DIN_NumDocumento, PRY_Id:<%=PRY_Id%>, DIN_FechaEnvio:DIN_FechaEnvio }
									
									$.ajax({
										type: "POST",		
										url: "/agregar-documento-enviado-incumplimiento",
										data: data,									
										success: function (data) {	
											var param = data.split(bb)
											if(param[0]==200){
											}else{
											}
										},
										error: function(){											
										}																											
									})
								})
								Toast.fire({
								  icon: 'success',
								  title: 'Documento agregado exitosamente'
								});												
								incdocenvTable.ajax.reload();
								$("#frmincumplimientosdocenv")[0].reset();
							}else{
								Toast.fire({
								  icon: 'error',
								  title: 'Corrige los campos con errores antes de grabar.'
								});
							}
							
						})
						
						$("body").on("click", "#btn_cancel",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							Swal.close();
						});
																		
						$("body").on("click", "#btn_selinc",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							
							var Tipo=$(this).data("tipo");							
							if(listincumplimientospry.rows(".selected").data().length>0){								
								listincumplimientospry.rows(".selected").data().each(function(i,x){									
									if(x>0){
										if(Tipo==1){
											$("#IPR_IdEnv").val($("#IPR_IdEnv").val() + "," + i[1]);
										}else{
											$("#IPR_IdRec").val($("#IPR_IdRec").val() + "," + i[1]);
										}
									}else{
										if(Tipo==1){
											$("#IPR_IdEnv").val(i[1]);
										}else{
											$("#IPR_IdRec").val(i[1]);
										}										
									}									
								});
								Swal.close();
							}else{									
								shake($('#btn_selinc'));									
							}
						});
							
						$("#frmincumplimientosresp").on("click", "#btn_frmaddresp",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
														
							formValidate("#frmincumplimientosresp");
							if($("#frmincumplimientosresp").valid()){
								var data=$("#frmincumplimientosresp").serialize();
								
								$.ajax({
									type: "POST",		
									url: "/agregar-respuesta-incumplimiento",
									data: data,									
									success: function (data) {	
										var param = data.split(bb)
										if(param[0]==200){								
											Toast.fire({
											  icon: 'success',
											  title: 'Respuesta(s) agregada(s) exitosamente'
											});												
											respincumTable.ajax.reload();
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Fallo en agregar respuesta'												
											});
										}
									},
									error: function(){
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Fallo en agregar respuesta',
										});
									}																											
								})								
							}else{
								Toast.fire({
								  icon: 'error',
								  title: 'Corrige los campos con erros antes de grabar.'
								});
							}
						})
						
						$("#frmincumplimientosresp").on("click",".delres",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							var INF_Arc=$(this).data("arc");
							var RIN_Id = $(this).data("rin")
							var IPR_Id = $(this).data("ipr")

							swalWithBootstrapButtons.fire({
							  title: '¿Estas seguro?',
							  text: "¿Deseas eliminar el(los) archivo(s) adjunto(s) para este incumplimiento?",
							  icon: 'warning',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									data={PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',IPR_Id:IPR_Id};
									$.ajax({
										type: 'POST',		
										url: '/eliminar-adjuntos-incumplimientos-respuestas',
										data: data,
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												  icon: 'success',
												  title: 'Adjunto(s) eliminado(s) correctamente.'
												});												
												respincumTable.ajax.reload();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Elimiancion Fallida',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Eliminación Fallido',
												text:data.message
											});
										}																											
									})

								}
							})
						})
						
						$("#frmincumplimientosresp").on("click",".dowres",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							var IPR_Id = $(this).data("ipr")	

							ajax_icon_handling('load','Buscando adjuntos','','');
							$.ajax({
								type: 'POST',								
								url:'/listar-adjuntos-incumplimioentos-respuestas',			
								data:{IPR_Id:IPR_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
								success: function(data) {
									var param=data.split(bb);			
									if(param[0]=="200"){				
										ajax_icon_handling(true,'Listado de adjuntos creado.','',param[1]);
										$(".swal2-popup").css("width","60rem");
										loadtables("#tbl-historico");
										$(".arcalm").click(function(){
											var INF_Arc = $(this).data("file");
											var PRY_Hito=$(this).data("hito");
											var ALU_Rut;
											var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:108, ALU_Rut:ALU_Rut,IPR_Id:IPR_Id};
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
										ajax_icon_handling(false,'No fue posible crear el listado de adjuntos.','','');
									}						
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){				
									ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
								},
								complete: function(){																		
								}
							})
						})
						
						$("#frmincumplimientosresp").on("click",".uplres",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();
							
							var RIN_Id = $(this).data("rin")
							var IPR_Id = $(this).data("ipr")

							swalWithBootstrapButtons.fire({
								icon:'info',
								title: 'Selecciona un archivo',
								showCancelButton: true,
								confirmButtonText: 'Subir',
								cancelButtonText: 'Cancelar',
								input: 'file',
								onBeforeOpen: () => {
									$(".swal2-file").attr("accept",'image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.wordprocessingml.document,,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint')
									$(".swal2-file").attr("multiple","multiple")
									$(".swal2-file").change(function () {
										var reader = new FileReader();
										reader.readAsDataURL(this.files[0]);
									});
								}
							}).then((file) => {
								if (file.value) {																
									var formData = new FormData();									
									var file_data = $('.swal2-file').prop('files');				
									for (var i = 0; i < file_data.length; i++) {
										formData.append(file_data[i].name, file_data[i])
									}									
									formData.append("RIN_Id", RIN_Id);
									formData.append("IPR_Id", IPR_Id);
									formData.append("PRY_Id", <%=PRY_Id%>);
									formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

									$.ajax({
										url: "/subir-adjuntos-incumplimientos-respuestas",
										method: 'POST',					
										data:formData,
										enctype: 'multipart/form-data',
										cache: false,
										contentType: false,
										processData: false,
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												  icon: 'success',
												  title: 'Adjunto(s) subido(s) correctamente.'
												});
												respincumTable.ajax.reload();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Subida Fallida',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Subida Fallida',
												text:data.message
											});
										}
									});									
								}
							})

						})
						
						$("#frmincumplimientos").on("click",".deldocenv, .deldocrec",function(e){
							var DIN_Id = $(this).data("din");
							
							swalWithBootstrapButtons.fire({
							  title: '¿Estas seguro?',
							  text: "Con esta acción eliminarás el registro seleccionado",
							  icon: 'question',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {									
									$.ajax({
										type: "POST",
										url:"/elimina-documento-enviado-incumplimiento",
										data:{DIN_Id:DIN_Id},
										success: function(data) {
											var param=data.split(bb);			
											if(param[0]=="200"){
												Toast.fire({
												  icon: 'success',
												  title: 'Incumplimiento eliminado exitosamente.'
												});
												incdocenvTable.ajax.reload();
												incdocrecTable.ajax.reload();
											}else{
												Toast.fire({
												  icon: 'error',
												  title: 'No fue posible eliminar el incumplimiento.'
												});
											}						
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){				
											Toast.fire({
											  icon: 'error',
											  title: 'No fue posible eliminar el incumplimiento. (2)'
											});
										},
										complete: function(){																		
										}
									})									
							  	}
							})
						})												
						
						$("#frmincumplimientos").on("click","#INC_Id",function(e){
							e.preventDefault();
							e.stopImmediatePropagation();
							e.stopPropagation();

							ajax_icon_handling('load','Buscando incumplimientos','','');
							$.ajax({
								type: 'POST',								
								url:'/listar-incumplimientos',			
								data:{PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
								success: function(data) {
									var param=data.split(bb);			
									if(param[0]=="200"){				
										ajax_icon_handling(true,'Listado de Incumplimientos creado.','',param[1]);
										$(".swal2-popup").css("width","60rem");
										$("#tbl-listincumplimientos").dataTable({
											lengthMenu: [ 5,10,20 ],
											"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {												
												$(nRow).click(function(e){
													e.preventDefault();
													e.stopImmediatePropagation();
													e.stopPropagation();

													$(this).find("td").each(function(e){
														$($("#frmincumplimientos input, #frmincumplimientos textarea")[e]).val(this.innerText)
														$($("#frmincumplimientos input, #frmincumplimientos textarea")[e]).siblings("label").addClass("active")
													})
													Swal.close();
												})
											}
										});

									}else{
										ajax_icon_handling(false,'No fue posible crear el listado de incumplimientos.','','');
									}						
								},
								error: function(XMLHttpRequest, textStatus, errorThrown){				
									ajax_icon_handling(false,'No fue posible crear el listado de incumplimientos.','','');	
								},
								complete: function(){																		
								}
							})
						})
															
					}
				}
			})
		}
		
		$("#incumplimientosModal").on("click",".dowinc",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var IPR_Id = $(this).data("id")	
			var data = {IPR_Id:IPR_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',PRY_Hito:107};			
			ajax_icon_handling('load','Buscando adjuntos','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-adjuntos-incumplimientos',			
				data:data,
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de adjuntos creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:107, ALU_Rut:ALU_Rut,IPR_Id:IPR_Id};
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
						ajax_icon_handling(false,'No fue posible crear el listado de adjuntos.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
		$("#incumplimientosModal").on("click", ".verinc", function() {
			var tr = $(this).closest('tr');
			var row = incumplimientosTable.row(tr);			
			var id=$(this).data("id");			
			
			$(this).toggleClass('openmenu');
			var TAD_Id = $(this).parent().parent().find("td")[3].innerHTML;
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".verinc").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuesta(row.data(),"tbl-incMOD_" + iTermGPACounter ,TAD_Id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".verinc").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		
		function formatRespuesta(rowData,table_id,TAD_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/ver-detalle-incumplimientos',
				data: {INC_Id: rowData[0],table: table_id,PRY_Id:<%=PRY_Id%>},        
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}
						$("#" + table_id).DataTable({								
							lengthMenu: [ 3 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			});			

			return div;
		}				
		
		function exportTable(){
			$(".buttonExport").click(function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
				var idTable = $(this).data("id")
						
				const inputValue=idTable + '.csv';
				const { value: csvFilename } = swalWithBootstrapButtons.fire({
					icon:'info',
					title: 'Ingresa el nombre del archivo',
					input: 'text',
					inputValue: inputValue,
					showCancelButton: true,
					confirmButtonText: '<i class="fas fa-sync-alt"></i> Generar',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
					inputValidator: (value) => {
					if (!value) {
					  return 'Debes escribir un nombre de archivo!';
					}
				  }
				}).then((result) => {
					if(result.value){				
						$('#tbl-'+idTable).exporttocsv({
							fileName  : result.value,
							separator : ';',
							table	  : 'dt'
						});				
					}

				});							
			});
		}				
		
		
		$("body").append("<button id='btn_modalincumplimientos' name='btn_modalincumplimientos' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalincumplimientos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#incumplimientosModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalincumplimientos").click();		
		$("#btn_modalincumplimientos").remove();
	})
</script>