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
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		PRY_InformeIcicialEstado=rs("PRY_InformeIcicialEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
	end if
	response.write("200\\#planificacionModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-calendar-alt"></i> Planificación</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="frmPlanificacion" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="" method="POST" name="frmaddplanificacion" id="frmaddplanificacion" class="needs-validation">

						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--frmPlanificacion-->

				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">
						<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-planificacion" style="overflow-y:auto;max-height:500px">
							<!--Table-->
							<table id="tbl-planificacion" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="planificacion" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead> 
									<tr> 
										<th style="width:10px;">Sesión</th> 
										<th>Id</th> 
										<th>Curso</th>
										<th>Id</th> 
										<th>Perspectiva</th>
										<th>Id</th> 
										<th>Módulo</th>
										<th>Fecha</th>
										<th>Inicio</th>
										<th>Fin</th>										
										<th>H.Pla</th>
										<th>H.Pen</th>	
										<th>H.Tot</th>									
										<th>Relator</th>
										<th>Metodología</th><%
										if (PRY_InformeInicioEstado=0 and PRY_Estado=1) then%>
											<th>Acciones</th><%
										end if%>										
									</tr> 
								</thead>
							</table>
						</div>
					</div>
				</div>
				<!--col-->										
			</div>
			<!--body-->
			<div class="modal-footer">
				<div style="float:left;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Ver Planificación" id="btn_agregaplanificacion" name="btn_agregaplanificacion"><i class="fas fa-angle-up ml-1"></i></button>
				</div>
				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="planificacion"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->	
		</div>
	</div>

<script>
    var planificacionTable;
	var tablaPlanificacionAlto;
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		$("#planificacionModal").on('show.bs.modal', function(e){			
				
		})

		$("#planificacionModal").on('shown.bs.modal', function(){
			tablaPlanificacionAlto=$("#container-table-planificacion").height();
			exportTable();			
		});		

		$("#planificacionModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").removeClass("modal-open")
			$("#frmPlanificacion").css("height","0");			
			$("#btn_agregaplanificacion").find('i').toggleClass("openmenu");
			$("#container-table-planificacion").css("height",tablaPlanificacionAlto + "px");
			$("#planificacionModal").empty();	
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

		$("#planificacionModal").on("click","#btn_agregaplanificacion",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			planificacion_grid(e);
			planificacionTable.ajax.reload();
			
			
			$("#btn_frmaddplanificacion").show();
			if($("#frmPlanificacion").css("height")=="500px"){				
				$("#frmPlanificacion").css("height","0");				
				$("#btn_agregaplanificacion").find('i').toggleClass("openmenu");
				$("#container-table-planificacion").css("height",tablaPlanificacionAlto + "px");

			}else{								
				$("#frmPlanificacion").css("height","500px");								
				$("#btn_agregaplanificacion").find('i').toggleClass("openmenu");
				$("#container-table-planificacion").css("height","0");				
			}			
		})

		$("#planificacionModal").on("click","#btn_salirplanificacion",function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			if($("#frmPlanificacion").css("height")=="500px"){				
				$("#frmPlanificacion").css("height","0");				
				$("#btn_agregaplanificacion").find('i').toggleClass("openmenu");
				$("#container-table-planificacion").css("height",tablaPlanificacionAlto + "px");
			}
			planificacionTable.ajax.reload();
		})						

		$("#planificacionModal").on("click","#btn_frmaddplanificacion",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var event = e;
			formValidate("#frmaddplanificacion");
			if($("#frmaddplanificacion").valid()){
			
				$("#btn_frmaddplanificacion").attr("disabled","disabled");
				$("#btn_frmaddplanificacion").css("color","green");
				$("#btn_frmaddplanificacion").css("cursor","not-allowed");
				$("#btn_frmaddplanificacion i").removeClass("fa-plus");
				$("#btn_frmaddplanificacion i").addClass("fa-sync-alt fa-spin");
			
				var data=$("#frmaddplanificacion").serialize();
				
				$.ajax( {
					type:'POST',					
					url: '/agrega-planificacion',
					data:data,
					dataType: "json",
					success: function ( data ) {						
						if(data.state=="200"){
							planificacion_grid(e);
							Toast.fire({
								icon: 'success',
								title: 'Planificación agregada correctamente!'
							});			
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){					
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto',					
						});				
					},
					complete: function(){
						$("#btn_frmaddplanificacion").removeAttr("disabled");
						$("#btn_frmaddplanificacion").css("color","white");
						$("#btn_frmaddplanificacion").css("cursor","pointer");
						$("#btn_frmaddplanificacion i").addClass("fa-plus");
						$("#btn_frmaddplanificacion i").removeClass("fa-sync-alt fa-spin");
					}
				});
			}else{

				Toast.fire({
					icon: 'error',
					title: 'Existen planificaciones sin agregar!'
				});			
			}
		})	

	    function planificacion_grid(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("#frmaddplanificacion").append("<div class='loader_wrapper'><div class='loader'></div></div>");
			$.ajax( {
				type:'POST',					
				url: '/planificacion-modal-grid',
				data:data,					
				success: function ( data ) {
					var param = data.split(ss)					
					if(param[0]=="200"){
						$("#frmaddplanificacion").html(param[1]);						
						$("#planificacionadd-tab").tabsmaterialize({menumovil:false},function(){});
						$(".calendario").datepicker({
							beforeShow: function(input, inst) {
								$(document).off('focusin.bs.modal');
							},
							onClose:function(){
								$(document).on('focusin.bs.modal');
							},
						});
						$('.hora').timepicker({
							timeFormat: 'H:mm',
							interval: 5,
							minTime: '6',
							maxTime: '23:00',
							startTime: '6:00',
							dynamic: true,
							dropdown: true,
							scrollbar: true,
							change:function(time){									
								$(this).siblings("label").addClass("active");
								 calculaHorasPlanificadas($(this));
							},
							beforeShow: function(input, inst) {
								$(document).off('focusin.bs.modal');
							},
							onClose:function(){
								$(document).on('focusin.bs.modal');
							},
						});						
						
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){					
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar el menú del proyecto',					
					});				
				},
				complete: function(){
					$(".loader_wrapper").remove();
				}
			});
		}
		
		$("#planificacionModal").on("click",".delpla",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var PLN_Sesion 	= $(this).data("sesion")
			var PRY_Id		= $(this).data("pry")
			var PRY_Identificador = $(this).data("token")
			var TEM_Id		= $(this).data("tem")
			
			swalWithBootstrapButtons.fire({
		  		title: '¿Estas seguro?',
		  		text: "¿Deseas eliminar la planificación seleccioanda?",
		  		icon: 'warning',
		  		showCancelButton: true,
		  		confirmButtonColor: '#3085d6',
		  		cancelButtonColor: '#d33',
		  		confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar',
		  		cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
		  		if (result.value) {
					var data={PRY_Id:PRY_Id,PRY_Identificador:PRY_Identificador,PLN_Sesion:PLN_Sesion};
					$.ajax( {
						type:'POST',					
						url: '/elimina-planificacion',
						data:data,
						dataType: "json",
						success: function ( data ) {						
							if(data.state=="200"){								
								planificacionTable.ajax.reload();
								Toast.fire({
									icon: 'success',
									title: 'Planificación eliminada correctamente!'
								});			
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar la planificación',
									text: data.message
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
		
		function tablePlanificacion(){
			if(planificacionTable!=undefined){
				planificacionTable.destroy();
			}else{
				$('#tbl-planificacion').dataTable().fnClearTable();
				$('#tbl-planificacion').dataTable().fnDestroy();
			}
			planificacionTable = $('#tbl-planificacion').DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/planificacion",
					type:"POST"
				},

			});
		}		

		function calculaHorasPlanificadas(obj){
			const arrayId = obj.attr("id").split("-");
			if(arrayId[0]==='PLN_HoraFin' || arrayId[0]==='PLN_HoraInicio'){
				const PLN_HoraInicio = "#PLN_HoraInicio-" + arrayId.slice(1).join("-");
				const PLN_HoraFin = "#PLN_HoraFin-" + arrayId.slice(1).join("-");
				const TEM_HorasPlanificadas = "#TEM_HorasPlanificadas-" + arrayId.slice(1).join("-");
				const TEM_HorasReales = "#TEM_HorasReales-" + arrayId.slice(1).join("-");
				const TEM_HorasFaltantes = "#TEM_HorasFaltantes-" + arrayId.slice(1).join("-");
				const horasFaltantes = $(TEM_HorasFaltantes).data("oldvalue");
				const horaInicio = $(PLN_HoraInicio).val();
				const horaFin = $(PLN_HoraFin).val();
				const horaInicioArray = horaInicio.split(":");
				const horaFinArray = horaFin.split(":");
				const horaInicioDate = new Date(0, 0, 0, horaInicioArray[0], horaInicioArray[1], 0);
				const horaFinDate = new Date(0, 0, 0, horaFinArray[0], horaFinArray[1], 0);
				const diff = horaFinDate - horaInicioDate;
				const minutes = Math.floor((diff/1000)/60);
				const horasReales = Math.floor(minutes/60) ? Math.floor(minutes/60) : 0;
				const horasPedagogicas = Math.ceil(minutes/45) ? Math.ceil(minutes/45) : 0;
				
				$(TEM_HorasPlanificadas).val(horasPedagogicas);
				$(TEM_HorasReales).val(horasReales);
				$(TEM_HorasFaltantes).val(horasFaltantes - horasPedagogicas);				
				
			}
		}

		$("#planificacionModal").on("change","select",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();

			const arrayId = $(this).attr("id").split("-");
			console.log(arrayId);
			if(arrayId[0]==='MET_Id' && arrayId[1]==='new'){
				console.log("MET_Id");
				const PLN_Fecha = "#PLN_Fecha-" + arrayId.slice(1).join("-");
				const PLN_HoraInicio = "#PLN_HoraInicio-" + arrayId.slice(1).join("-");
				const PLN_HoraFin = "#PLN_HoraFin-" + arrayId.slice(1).join("-");
				const REL_Id = "#REL_Id-" + arrayId.slice(1).join("-");
				const MET_Id = "#MET_Id-" + arrayId.slice(1).join("-");
				const TEM_HorasPlanificadas = "#TEM_HorasPlanificadas-" + arrayId.slice(1).join("-");
				const TEM_HorasReales = "#TEM_HorasReales-" + arrayId.slice(1).join("-");
				const TEM_HorasFaltantes = "#TEM_HorasFaltantes-" + arrayId.slice(1).join("-");

				if($(this).val()!=""){
					$(PLN_Fecha).attr("required","required");
					$(PLN_Fecha).removeAttr("hidden");
					$(PLN_HoraInicio).attr("required","required");
					$(PLN_HoraInicio).removeAttr("hidden");
					$(PLN_HoraFin).attr("required","required");
					$(PLN_HoraFin).removeAttr("hidden");
					$(REL_Id).attr("required","required");
					$(REL_Id).removeAttr("hidden");
					$(MET_Id).attr("required","required");
					$(TEM_HorasPlanificadas).removeAttr("hidden");
					$(TEM_HorasReales).removeAttr("hidden");
					$(TEM_HorasFaltantes).removeAttr("hidden");
				}else{
					$(PLN_Fecha).removeAttr("required");
					$(PLN_Fecha).attr("hidden","hidden");
					$(PLN_HoraInicio).attr("hidden","hidden");
					$(PLN_HoraInicio).removeAttr("required");
					$(PLN_HoraFin).attr("hidden","hidden");
					$(PLN_HoraFin).removeAttr("required");
					$(REL_Id).attr("hidden","hidden");
					$(REL_Id).removeAttr("required");
					$(MET_Id).removeAttr("required");
					$(TEM_HorasPlanificadas).attr("hidden","hidden");
					$(TEM_HorasReales).attr("hidden","hidden");
					$(TEM_HorasFaltantes).attr("hidden","hidden");
				}				

			}
		})

		$("body").append("<button id='btn_modalplanificacion' name='btn_modalplanificacion' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalplanificacion").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#planificacionModal").modal("show");
			$("body").addClass("modal-open");
			tablePlanificacion();			
		});
		$("#btn_modalplanificacion").click();		
		$("#btn_modalplanificacion").remove();
	})
</script>