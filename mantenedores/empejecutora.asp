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
							<button class="btn btn-success btn-rounded btn-sm waves-effect" title="Crear un nueva empresa ejecutora" type="button" data-url="" data-toggle="tooltip" data-id="10" id="btn_addempejecutoraModal" name="btn_addempejecutoraModal">Agregar<i class="fas fa-plus ml-1"></i></button><%
						end if%>
					</div>
					<a href="" class="white-text mx-3"><i class="fas fa-server"></i> Mantenedor de Ejecutores</a>
					<div>						
						<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="empejecutora">Exportar<i class="fas fa-download ml-1"></i></button>
					</div>
				</div>
				<!--/Card image-->
					
					<div class="table-wrapper col-sm-12">						
						<!--Table-->
						<table id="tbl-empejecutora" class="table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="empejecutora" >
							<thead>
								<tr> 
									<th>Id</th>                         
									<th>ROL</th>									
									<th>Nombre</th>
									<th>Tipo</th>
									<th>Región Id</th>
									<th>Región</th>
									<th>Comuna Id</th>
									<th>Comuna</th>
									<th>Dirección</th>
									<th>Teléfono</th>
									<th>Contacto</th>
									<th>Cargo</th>
									<th>Mail</th>									
									<th>Página Web</th>
									<th>Estado</th>
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
		var empejecutoraTable;
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		$(function () {
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})		
		});
		$('#tbl-empejecutora tbody').on( 'click', 'td', function (e) {
			e.stopImmediatePropagation();
			e.stopPropagation();
		} );							
		function tableempejecutora(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			empejecutoraTable = $('#tbl-empejecutora').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"/tbl-empejecutora",					
					type:"POST",
					dataSrc:function(json){												
						return json.data;
					}
				},				
				"columnDefs": [{
						"targets": [ 1,4,6,9,11,12,13 ],
						"visible": false,
						"searchable": false
					},					
				],
				"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					$(nRow).click(function(e){						
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();
						
						var EME_Id = $(this).find("td")[0].innerText;
						var data={EME_Id:EME_Id,mode:'mod'}
						
						$.ajax( {
							type:'POST',
							url: '/modal-empejecutora',
							data: data,
							success: function ( data ) {
								param = data.split(bb)
								if(param[0]==200){							
									$("#empejecutoraModal").html(param[1]);
									$("#empejecutoraModal").modal("show");
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
		
		$("#empejecutoraModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation()
			tableempejecutora();
		})
		
		tableempejecutora();		
		
		$("#btn_addempejecutoraModal").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();						
			$.ajax( {
				type:'POST',					
				url: '/modal-empejecutora',
				data: {mode:'add'},
				success: function ( data ) {
					param = data.split(bb)
					if(param[0]==200){							
						$("#empejecutoraModal").html(param[1]);
						$("#empejecutoraModal").modal("show");
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

		$(".buttonExport").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			var idTable = $(this).data("id")

			wrk_reportes("/prt-ejecutores",idTable);			
		});
	})
</script>