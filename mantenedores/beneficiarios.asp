<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	disabled="required"	
	if mode="add" then
		mode="mod"		
	end if
	if mode="mod" then
		modo=2		
	end if
	if(session("ds5_usrperfil")>2) then	'Solo Adminsitrador puede modificar, el resto solo visualizar
		mode="vis"
		modo=4		
	end if	
	if mode="vis" then
		modo=4		
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
	'response.write("PRY_Id-" & PRY_Id)
%>
	<!--wrapper-editor-->
	<div class="wrapper-editor">		
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">			
			<!-- Table with panel -->					
			<div class="card card-cascade narrower">
				<!--Card image-->
				<div class="view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center" style="height:3rem;">
					<div><%
						if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
							<button class="btn btn-success btn-rounded btn-sm waves-effect" title="Crear un nueva liena formativa" type="button" data-url="" data-toggle="tooltip" data-id="10" id="btn_addbeneficiariosModal" name="btn_addbeneficiariosModal">Agregar<i class="fas fa-plus ml-1"></i></button><%
						end if%>
					</div>
					<a href="" class="white-text mx-3"><i class="fas fa-server"></i> Mantenedor de Beneficiarios</a>
					<div>						
						<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="beneficiarios">Exportar<i class="fas fa-download ml-1"></i></button>
					</div>
				</div>
				<!--/Card image-->
					
					<div class="table-wrapper col-sm-12">
						<div style="overflow-x:hidden">
						<!--Table-->
						<table id="tbl-beneficiarios" class="table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="beneficiarios" >
							<thead>
								<tr> 
									<th>RUT</th>
									<th>RUT-DV</th>
									<th>DV</th>
									<th>Nombres</th>
									<th>Paterno</th>
									<th>Materno</th>
									<th>Nacionalidad</th>
									<th>Sexo</th>
									<th>Email</th>
									<th>Empresa</th>
									<th>Ingreso</th>
									<th>Estado</th>
									<th>PRYs/Ficha</th>

									<th>Fecha Nacimiento</th>
									<th>Edad</th>
									<th>Cargo Directivo</th>
									<th>Tiene Discapacidad?</th>
									<th>Tipo de Discapcidad</th>
									<th>Reconoce Pueblo Originario?</th>
									<th>Pueblo Originario</th>
									<th>Tipo de Trabajador</th>
									<th>Dirigente Sindical?</th>
									<th>Fecha Dirigente</th>
									<th>Acceso a Internet?</th>
									<th>Dispositivo Electrónico?</th>

									<th>Región</th>
									<th>Comuna</th>
									<th>Dirección</th>
									<th>Teléfono</th>
									<th>Rubro</th>
									<th>Nivel Educacional</th>
									<th>Pertenece a Sindicato</th>
									<th>Nombre de Organización</th>
									<th>RSU</th>
									<th>Fecha de Ingreso</th>
									<th>Permiso de Capacitacion</th>
									<th>Nombre Cargo Directivo</th>
									<th>Fecha de Inicio Cargo Directivo</th>
									<th>Cursos Sindicales Anteriores</th>
									<th>Año del curso anterior</th>
									<th>Institución del curso</th>

									<th>Id</th>
									<th>Linea</th>
									<th>Id</th>
									<th>Linea Formativa</th>
									<th>Fecha Asignación Proyecto</th>

									<th>Total horas Proyecto</th>
									<th>% Horas Asistencia</th>
								</tr> 
							</thead>
							<tbody>
							</tbody>
						</table>
						</div>
					</div>
				
			</div>
			<!-- Table with panel -->		
		</div>	  
	</div>
	<!--wrapper-editor-->
<script>
	$(document).ready(function(e) {				
		var beneficiariosTable;
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var iTermGPACounter = 1;
		$(function () {
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})		
		});
										
		function tablebeneficiarios(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			beneficiariosTable = $('#tbl-beneficiarios').DataTable({
				lengthMenu: [[ 10,15,20,50,100 ],['10','15','20','50','100']],
				columnDefs: [{"targets": [ 1,8,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39, 40,41,42,43,44,45,46,47 ],"visible": false,"searchable": false},{ className: "vermas", "targets": [ 12 ] }],
				processing: true,
        		serverSide: true,
				ajax:{
					url:"/tbl-beneficiarios",					
					type:"POST",
					dataSrc:function(json){												
						return json.data;
					}
				},				
				order: [[ 1, "asc" ]],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					$("td:not(:last)",nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();
						
						var ALU_Rut = $(this).parent().find("td")[0].innerText;						
						$.ajax( {
							type:"POST",					
							url: "/modal-beneficiarios",
							data: {ALU_Rut:ALU_Rut,mode:"mod"},
							success: function ( data ) {
								param = data.split(bb)
								if(param[0]==200){							
									$("#beneficiariosModal").html(param[1]);
									$("#beneficiariosModal").modal("show");
								}else{
									swalWithBootstrapButtons.fire({
										icon:'error',								
										title: 'Ups!, no pude cargar el menú del proyecto1',					
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
				},
				stateSave: true
			});
		}		
		
		$("#tbl-beneficiarios").on("click",".verpry",function(e){			
			var tr  = $(this).closest("tr");
			var row = beneficiariosTable.row(tr);			
			var id  = $(this).data("id");			

			$(this) .toggleClass("openmenu");
			var TAD_Id = $(this) .parent().parent().find("td")[3].innerHTML;

			if (row.child.isShown()) {				  
			  $("div.slider", row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass("shown");				 
			  } );
			  $(this).parent().toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuesta(row.data(),"tbl-pryVER_" + iTermGPACounter ,TAD_Id)).show();
			  tr.addClass("shown");
			  $("div.slider", row.child()).slideDown();			  
			  $(this).parent().toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
		});
		
		$("#tbl-beneficiarios").on("click",".arcalm",function(e){
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
		
		$("#beneficiariosModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation()
			tablebeneficiarios();
		})
		
		tablebeneficiarios();
												
		$("#btn_addbeneficiariosModal").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			$.ajax( {
				type:'POST',					
				url: '/modal-beneficiarios',
				data: {mode:'add'},
				success: function ( data ) {
					param = data.split(bb)
					if(param[0]==200){							
						$("#beneficiariosModal").html(param[1]);
						$("#beneficiariosModal").modal("show");
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto1',					
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
		})						
		
		function formatRespuesta(rowData,table_id,TAD_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/ver-proyectos-asociados',
				data: {ALU_Rut: rowData[0],table: table_id,},
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}
						$("#" + table_id).DataTable({								
							lengthMenu: [ 4, 6, 10 ],
							order: [[ 0, 'desc' ]],
							stateSave: true
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}

		$(".buttonExport").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			var idTable = $(this).data("id")

			//wrk_reportes("/wrk-beneficiarios",idTable);			
			wrk_reportes("/prt-beneficiarios",idTable);			
		});		
	})
</script>