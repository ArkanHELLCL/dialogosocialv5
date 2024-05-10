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
	
	set rs = cnn.Execute("exec spInformeMesasSindicales_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spInformeMesasSindicales_Listar")
		cnn.close 		
		response.end
	End If	
	if not rs.eof then
		maxRep = rs("NumMaxRepresentante")
	else
		maxRep=1
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
					<a href="" class="white-text mx-3"><i class="fas fa-file-invoice"></i> Informe de Organizaciones Sindicales</a>
					<div>						
						<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="orgsindicales">Exportar<i class="fas fa-download ml-1"></i></button>
					</div>
				</div>
				<!--/Card image-->
					
					<div class="table-wrapper col-sm-12" style="overflow-x:auto">
						<!--Table-->
						<table id="tbl-orgsindicales" class="table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="orgsindicales" >
							<thead>
								<tr> 
									<th>Id Proyecto</th>                         
									<th>Empresa Ejecutora</th>
									<th>Id Linea Formativa</th>
									<th>Linea Formativa</th>	
									<th>Id Linea</th>
									<th>Linea</th>																		
									<th>Id Región</th>									
									<th>Región</th>									
									<th>Nombre Proyecto</th>
									<th>Id Organizacion Sindical</th>
									<th>Nombre Organizacion Sindical</th>									
									<th>Id Afiliación</th>
									<th>Afiliaciónn</th>									
									<th>Id Tipo de Organización</th>
									<th>Tipo de Organización</th>									
									<th>Id Rubro</th>
									<th>Rubro</th>
									<th>RSU</th>
									<th>Mail</th>
									<th>Telefono</th>
									<th>Nro de Representantes</th><%
									for i=1 to maxRep
										col=col & (20+i) & ","%>
										<th>Nombre <%=i%></th><%
									next%>									
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
		var orgsindicalesTable;
		
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		$(function () {
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})		
		});
		$('#tbl-orgsindicales tbody').on( 'click', 'td', function (e) {
			e.stopImmediatePropagation();
			e.stopPropagation();
		} );							
		function tableorgsindicales(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});
			orgsindicalesTable = $('#tbl-orgsindicales').DataTable({
				lengthMenu: [ 10,15,20 ],
				processing: true,
				columnDefs: [
					{ targets: [0,2,4,5,6,9,11,12,13,14,15,16,17,18,19,<%=col%>], visible: false},					
				],				
			});
			
			$('.btn_GenerarInfo').on('click', function() {
				$(".dataTables_empty").hide();
				$(".dataTables_processing").show();
				$.ajax({
					url: "/tbl-organizacionsindicales",
					type: "post",					
					dataSrc:function(json){												
						return json.data;
					},					
				}).done(function (result) {										
					orgsindicalesTable.clear().draw();
					orgsindicalesTable.rows.add(JSON.parse(result).data).draw();										
					$(".dataTables_processing").hide();
				}).fail(function (jqXHR, textStatus, errorThrown) {
				
				})
            });

		}				
		
		tableorgsindicales();
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