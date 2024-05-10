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
							<button class="btn btn-success btn-rounded btn-sm waves-effect" title="Crear un nueva liena formativa" type="button" data-url="" data-toggle="tooltip" data-id="10" id="btn_addrelatoresModal" name="btn_addrelatoresModal">Agregar<i class="fas fa-plus ml-1"></i></button><%
						end if%>
					</div>
					<a href="" class="white-text mx-3"><i class="fas fa-server"></i> Mantenedor de Relatores</a>
					<div>						
						<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="relatores">Exportar<i class="fas fa-download ml-1"></i></button>
					</div>
				</div>
				<!--/Card image-->					
				<div class="table-wrapper col-sm-12">
					<div style="overflow-x:hidden">
					<!--Table-->
					<table id="tbl-relatores" class="table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="relatores" >
						<thead>
							<tr> 
								<th>Id</th>                         
								<th>Paterno</th>
								<th>Materno</th>
								<th>Nombres</th>
								<th>RUT</th>
								<th>Género</th>
								<th>Nivel Educacional</th>
								<th>Carrera</th>
								<th>Estado</th>									
								<th>PRYs/Acciones</th>									
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
		var relatoresTable;
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
										
		function tablerelatores(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});
			$('#tbl-relatores').css('width','100%')
			relatoresTable = $('#tbl-relatores').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"/tbl-relatores",					
					type:"POST",
					dataSrc:function(json){												
						return json.data;
					}
				},			
				order: [
					[1, 'asc']
				],
				columnDefs:[					
					{"targets": [0],"width":"10px"}
				],
				autoWidth: false,
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					//$(nRow).click(function(e){
					$("td:not(:last)",nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();
												
						var REL_Id = $(nRow).find("td")[0].innerText;
						$.ajax( {
							type:'POST',					
							url: '/modal-relatores',
							data: {REL_Id:REL_Id,mode:'mod'},
							success: function ( data ) {
								param = data.split(bb)
								if(param[0]==200){							
									$("#relatoresModal").html(param[1]);
									$("#relatoresModal").modal("show");
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
				}
			});
		}
		
		$("#tbl-relatores").on("click",".arcrel",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			var INF_Arc=$(this).data("arc");			
			var PRY_Hito=111
			var REL_Rut=$(this).data("rut");
			
			var data={PRY_Id:0, INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, REL_Rut:REL_Rut};			
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
		});
		
		$("#tbl-relatores").on("click",".delrel",function(){			
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
				text: "Solo si el relator no está asociado a ningún proyecto se podrá eliminar.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar igual!',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					var REL_Id  = $(this).data("id");
					var REL_Rut = $(this).data("rut");
					$.ajax({
						type: "POST",
						url: "/eliminar-relator",
						data: {REL_Id:REL_Id,REL_Rut:REL_Rut},
						dataType: "json",
						success: function(data) {
							if(data.state=='200'){
								relatoresTable.ajax.reload();
								Toast.fire({
									icon: 'success',
									title: 'Relator eliminado exitosamente.'
								});								
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:data.message
								});
							}
						}
					});				
				}	
			})
		})
		
		$("#relatoresModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation()
			tablerelatores();
		})
		
		tablerelatores();		
		
		$("#btn_addrelatoresModal").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			$.ajax( {
				type:'POST',					
				url: '/modal-relatores',
				data: {mode:'add'},
				success: function ( data ) {
					param = data.split(bb)
					if(param[0]==200){							
						$("#relatoresModal").html(param[1]);
						$("#relatoresModal").modal("show");
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
		
		$("#tbl-relatores").on("click",".verpry",function(e){			
			var tr  = $(this).closest("tr");
			var row = relatoresTable.row(tr);			
			var id  = $(this).data("id");			

			$(this) .toggleClass("openmenu");			

			if (row.child.isShown()) {				  
			  $("div.slider", row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass("shown");				 
			  } );
			  $(this).parent().toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuesta(row.data(),"tbl-pryrelVER_" + iTermGPACounter )).show();
			  tr.addClass("shown");
			  $("div.slider", row.child()).slideDown();			  
			  $(this).parent().toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
		});
		
		function formatRespuesta(rowData,table_id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/ver-proyectosrelator-asociados',
				data: {REL_Id: rowData[0],table: table_id,},
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}
						$("#" + table_id).DataTable({								
							lengthMenu: [ 4, 6, 10 ],
							order: [[ 0, 'desc' ]]
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

			wrk_reportes("/prt-relatores",idTable);			
		});
	})
</script>