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
		PRY_Estado = rs("PRY_Estado")	
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
		LFO_Calif = rs("LFO_Calif")
	end if
	
	if(PRY_Estado=9) then
		msg="(Archivado)"
	end if	
	
	sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs3 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
	   	cnn.close
	   	response.Write("503\\Error Conexión:" & ErrMsg)
	   	response.End()
	End If	

	TotSes=0
	do while not rs3.eof		
		TotSes=TotSes+1
		rs3.movenext
	loop
	rs3.close	

	'Horas Ejecutadas
	sqlx = "exec spPlanificacionHoras_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	'response.write(sqlx)
	set rsx = cnn.Execute(sqlx)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
	   	cnn.close
	   	response.Write("503\\Error Conexión:" & ErrMsg)
	   	response.End()		
	End If	
	if not rsx.eof then
		HorasTotalesRealizadas=rsx("HorasTotalesRealizadas")
		HorasTotalesPedagogicasRealizadas=rsx("HorasTotalesPedagogicasRealizadas")
	end if

	sql="exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		ErrMsg = cnn.Errors(0).description	   
	   	cnn.close
	   	response.Write("503\\Error Conexión:" & ErrMsg)
	   	response.End()
	End If
	TotalHorasProyecto=0
	do while not rs.eof		
		TotalHorasProyecto=TotalHorasProyecto+CInt(rs("TEM_Horas"))
		rs.movenext
	loop
	PorHoras=round((cint(HorasTotalesPedagogicasRealizadas)*100)/cint(TotalHorasProyecto),1)			
	
	columnsDefscalificacion="[]"
	response.write("200\\#calificacionModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="far fa-check-square"></i> Calificaciones</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="frmcalificacion" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="" method="POST" name="frmaddcalificacion" id="frmaddcalificacion" class="needs-validation">

						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--frmPlanificacion-->				
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
					<div class="px-4">
						<div class="table-wrapper col-sm-12" id="container-table-calificacion">
							<!--Table-->
							<table id="tbl-calificacion" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="calificacion" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead>	
									<tr>										
										<th>RUT</th> 
										<th>Nombres</th>
										<th>Paterno</th>
										<th>Materno</th>
										<th>Sexo</th>
										<th>Email</th>
										<th>Asis.(%)</th>
										<th>Nota (Prom)</th>
										<th>Estado</th>								
									</tr>
								</thead>									
							</table>
						</div>
					</div>							
				</div>									
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or session("ds5_usrperfil")=1 or ((PRY_InformeFinalEstado=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3))) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-primary btn-md waves-effect" type="button" data-url="" title="Agregar nueva calificacion" id="btn_agregacalificacion" name="btn_agregacalificacion"><i class="fas fa-angle-up ml-1"></i></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="calificacion"><i class="fas fa-download ml-1"></i></button>
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
	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);		
				
		var calificacionTable;
		$("#calificacionModal").on('show.bs.modal', function(e){					
			
		})		
		$(".calendario").datepicker({
			beforeShow: function(input, inst) {
				$(document).off('focusin.bs.modal');
			},
			onClose:function(){
				$(document).on('focusin.bs.modal');
			},
		});
					
		function loadTablecalificacion(){
			if(calificacionTable!=undefined){
				calificacionTable.destroy();
			}else{
				$('#tbl-calificacion').dataTable().fnClearTable();
				$('#tbl-calificacion').dataTable().fnDestroy();
			}			
			calificacionTable = $('#tbl-calificacion').DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/calificacion",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},
				"columnDefs": <%=columnsDefscalificacion%>
			});	
		}				
		
		$("#calificacionModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").addClass("modal-open");
			loadTablecalificacion();			
			exportTable();
		});				
		
		$("#calificacionModal").on("click","#btn_frmaddcalificacion",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var alumnos = Object.keys(asisobj);
			var sesiones = Object.values(asisobj)
			var event = e;			
			
			$.ajax({
				url: "/agregar-correlativo-nota",
				method: 'POST',
				data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'},
				dataType: "json",
				success: function (json) {							
					if(json.state==200){
					
						$(sesiones).each(function(i,e){				
							var ALU_Rut = alumnos[i];				
							$(this).each(function(){
								var Nota = Object.values($(this)[0])[0];
								var Id = Object.keys($(this)[0])[0].replace("id-","");					
								$.ajax({
									url: "/agregar-calificacion",
									method: 'POST',
									data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',ALU_Rut:ALU_Rut,Nota:Nota},
									dataType: "json",
									success: function (json) {							
										if(json.state==200){
											calificacion_grid(event);
											Toast.fire({
											  icon: 'success',
											  title: 'Calificación Agregada/Modificada exitosamente.'
											});
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Ingreso/Modificación Fallida',
												text:param[1]
											});
										}
									}
								});
							})						
						})
						
					
					}else{
						
					}
				}
			});												
				
		})
		
		$("#calificacionModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("body").removeClass("modal-open")
			$("#frmcalificacion").css("height","0");			
			$("#btn_agregacalificacion").find('i').toggleClass('openmenu');			
			$('#container-table-calificacion').animate({
				height: $('#container-table-calificacion').get(0).scrollHeight
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
		
		$("#calificacionModal").on("click","#btn_agregacalificacion",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			calificacionTable.ajax.reload();
			calificacion_grid(e);
			$("#btn_frmaddcalificacion").show();
			if($("#frmcalificacion").css("height")=="700px"){				
				$("#frmcalificacion").css("height","0");				
				$("#btn_agregacalificacion").find('i').toggleClass('openmenu');				
				$('#container-table-calificacion').animate({
					height: $('#container-table-calificacion').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmcalificacion").css("height","700px");								
				$("#btn_agregacalificacion").find('i').toggleClass('openmenu');
				$("#container-table-calificacion").css("height","0");				
			}						
		})
		
		$("#calificacionModal").on("click","#btn_salircalificacion",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			calificacionTable.ajax.reload();
			if($("#frmcalificacion").css("height")=="700px"){				
				$("#frmcalificacion").css("height","0");				
				$("#btn_agregacalificacion").find('i').toggleClass('openmenu');				
				$('#container-table-calificacion').animate({
					height: $('#container-table-calificacion').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');					
				});				
			}			
		})	
		var asisobj={};
		var alumno=[];
		$("#calificacionModal").on("change",":input",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var ALU_Rut = $(this).data("rut");
			var Id = $(this).data("id");
			var Nota = $(this).val();
			
			$(this).parent().parent().siblings("span").html("Si")				
			var txtobj = '{"id-' + Id + '":' + Nota + '}';				
			var existe = false;				
			if(asisobj[ALU_Rut]==undefined){
				alumno = asisobj[ALU_Rut]=[];	
			}else{
				alumno = asisobj[ALU_Rut];
				var txtobj2 = "id-" + Id;
				$(alumno).each(function(e,i){
					if(i[txtobj2]!=undefined){
						existe=true;
						i[txtobj2]=1;							
						return false;
					}
				})												
			}
			if(!existe){
				alumno.push(JSON.parse(txtobj));																																
			}							
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
		
		function calificacion_grid(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			$.ajax( {
				type:'POST',					
				url: '/calificacion-modal-grid',
				data:data,					
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmaddcalificacion").html(param[1]);
						if(addcalTable!=undefined){
							addcalTable.destroy();
						}else{
							$('#tbl-addcal').dataTable().fnClearTable();
							$('#tbl-addcal').dataTable().fnDestroy();
						}
						addcalTable = $('#tbl-addcal').DataTable({
							lengthMenu: [ 5,10,15 ],
							"scrollY": "300px",
							"scrollX": "700px",
							"scrollCollapse": true,
							columnDefs: [
							{
								targets: 0,
								visible: false,
								render: function (data, type, row) {
									if (row[1].includes('Evidencia')) {
										return 0;
								  	}else {
										return 1;
								  	}
								}
							}],
							orderFixed: [[0, 'asc']],
							order:[[1,'asc']]
						});
					}
				}
			})
		}						
		
		$("#frmaddcalificacion").on("click",".delete",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var INF_Arc=$(this).data("arc");
			var PLN_Sesion=$(this).data("sesion")
			var PRY_Hito=95;	
			
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "¿Deseas eliminar el archivo adjunto para este curso?",
			  icon: 'warning',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					data={PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PLN_Sesion:PLN_Sesion};
					$.ajax({
						type: 'POST',		
						url: '/eliminar-evidencia-calificacion',
						data: data,
						dataType: "json",
						success: function (data) {							
							if(data.state==200){								
								Toast.fire({
								  icon: 'success',
								  title: 'Evidencia eliminada correctamente.'
								});
								$("#dwn_evi-" + PLN_Sesion).css("cursor","not-allowed");
								$("#dwn_evi-" + PLN_Sesion).css("color","#aaa");

								$("#del_evi-" + PLN_Sesion).css("cursor","not-allowed");
								$("#del_evi-" + PLN_Sesion).css("color","#aaa");

								$("#upd_evi-" + PLN_Sesion).css("cursor","pointer");
								$("#upd_evi-" + PLN_Sesion).css("color","blue");
								
								/*$("#ArcTot").html((parseInt($("#TotArc").val(),10)-1).toString() + "/" + $("#TotSes").val().toString());*/

								$("#downloadevi-" + PLN_Sesion).attr("href","");																
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
								title:'Subida Fallido',
								text:data.message
							});
						}																											
					})
				
			  	}
			})
		})
		
		$("#frmaddcalificacion").on("click",".download",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var INF_Arc=$(this).data("arc");
			var PLN_Sesion=$(this).data("sesion")
			var PRY_Hito=95;			
			
			var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, PLN_Sesion:PLN_Sesion};			
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
		
		$("#frmaddcalificacion").on("click",".upload",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var MOD_Id = $(this).data("modulo") 
			var PLN_Sesion = $(this).data("sesion")									
			
			swalWithBootstrapButtons.fire({
				title: 'Selecciona un archivo',
				showCancelButton: true,
				confirmButtonText: 'Subir',
				cancelButtonText: 'Cancelar',
				input: 'file',
				onBeforeOpen: () => {
					$(".swal2-file").change(function () {
						var reader = new FileReader();
						reader.readAsDataURL(this.files[0]);
					});
				}
			}).then((file) => {
				if (file.value) {
					var formData = new FormData();
					var file = $('.swal2-file')[0].files[0];
					formData.append("fileToUpload", file);
					formData.append("PLN_Sesion", PLN_Sesion);
					formData.append("PRY_Id", <%=PRY_Id%>);
					formData.append("PRY_Identificador", '<%=PRY_Identificador%>');
					
					$.ajax({
						url: "/subir-evidencia-calificacion",
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
								  title: 'Evidencia subida correctamente.'
								});
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Subida Fallido',
									text:data.message
								});
							}
						},
						error: function(){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Subida Fallido',
								text:data.message
							});
						}
					});		
				}
			})
			
		})
		
		
		$("body").append("<button id='btn_modalcalificacion' name='btn_modalcalificacion' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalcalificacion").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#calificacionModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalcalificacion").click();		
		$("#btn_modalcalificacion").remove();
	})
</script>