<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%		
	if(session("ds5_usrperfil")=3) then	'Ejecutor no puede ejecutar reportes		
	   response.Write("403/@/Perfil no autorizado")
	   response.End() 			   	
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

	response.write("200/@/")	
%>
	<!--wrapper-editor-->
	<div class="wrapper-editor">		
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">			
			<!-- Table with panel -->					
			<div class="card card-cascade narrower">
				<!--Card image-->
				<div class="view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center" style="height:3rem;">
					<div>
						<button class="btn btn-success btn-rounded btn-sm waves-effect btn_GenerarInfo" data-toggle="tooltip" title="Generar informe">Generar<i class="fas fa-sync-alt ml-1"></i></button>
					</div>
					<a href="" class="white-text mx-3"><i class="fas fa-file-invoice"></i> Informe de Estados de Alumnos</a>
					<div>						
						<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="repalumnoestado">Exportar<i class="fas fa-download ml-1"></i></button>
					</div>
				</div>
				<!--/Card image-->
					
					<div class="table-wrapper col-sm-12" style="overflow-x:auto">
						<!--Table-->
						<table id="tbl-repalumnoestado" class="table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="repalumnoestado" >
							<thead>
								<tr> 
									<th>Ejecutor</th>
									<th>ROL</th>
									<th>Región</th>
									<th>Linea</th>									
									<th>Linea Formativa</th>									
									<th>Rut</th>									
									<th>DV</th>									
									<th>Nombre</th>
									<th>Paterno</th>
									<th>Materno</th>
									<th>Edad</th>
									<th>Nacionalidad</th>
									<th>Sexo</th>
									<th>Discapacidad</th>
									<th>Pertenece Sinidcato</th>
									<th>Nombre Sindicato</th>
									<th>Dirigente Sindical</th>
									<th>Cargo Directivo</th>
									<th>Nombre Cargo</th>
									<th>Matriculado</th>
									<th>Beneficiario</th>
									<th>Inscrito</th>
									<th>Aprobado</th>
									<th>Desertado</th>
									<th>% Asistencia</th>
									<th>Horas Total Ptoyecyo</th>
									<th>Horas Asitidas</th>									
									<th>Dirección</th>
									<th>Teléfono</th>
									<th>Mail</th>	
									<th>Región Domicilio</th>
									<th>Comuna Domicilio</th>
								</tr> 
							</thead>
							<tbody>
							</tbody>
						</table>						
					</div>
				
			</div>
			<!-- Table with panel -->		
		</div>	  
	</div>
	<!--wrapper-editor-->
<script>
	$(document).ready(function(e) {		
		var repalumnoestadoTable;
		
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		$(function () {
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})		
		});
		$('#tbl-repalumnoestado tbody').on( 'click', 'td', function (e) {
			e.stopImmediatePropagation();
			e.stopPropagation();
		} );							
		function tablerepalumnoestado(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});
			repalumnoestadoTable = $('#tbl-repalumnoestado').DataTable({
				lengthMenu: [ 10,15,20 ],
				processing: true,
				columnDefs: [
					{ targets: [4,6,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31], visible: false},					
				],				
			});
			$(".table-wrapper").mCustomScrollbar({
				theme:scrollTheme,
				advanced:{
					autoExpandHorizontalScroll:true,
					updateOnContentResize:true,
					autoExpandVerticalScroll:true
				},
				axis:"x"
			});		
			$('.btn_GenerarInfo').on('click', function() {
				$(".dataTables_empty").hide();
				$(".dataTables_processing").show();
				$.ajax({
					url: "/tbl-repalumnosestados",
					type: "post",					
					dataSrc:function(json){												
						return json.data;
					},					
				}).done(function (result) {										
					repalumnoestadoTable.clear().draw();
					repalumnoestadoTable.rows.add(JSON.parse(result).data).draw();										
					$(".dataTables_processing").hide();
				}).fail(function (jqXHR, textStatus, errorThrown) {
				
				})
            });

		}				
		
		tablerepalumnoestado();
		exportTable();				
		
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
	})
</script>