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
							<button class="btn btn-success btn-rounded btn-sm waves-effect" title="Crear nuevo tipo de ejecutor" type="button" data-url="" data-toggle="tooltip" data-id="10" id="btn_addtipoejecutorModal" name="btn_addtipoejecutorModal">Agregar<i class="fas fa-plus ml-1"></i></button><%
						end if%>
					</div>
					<a href="" class="white-text mx-3"><i class="fas fa-server"></i> Mantenedor de Tipos de Ejecutor</a>
					<div>						
						<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="tipoejecutor">Exportar<i class="fas fa-download ml-1"></i></button>
					</div>
				</div>
				<!--/Card image-->
					
					<div class="table-wrapper col-sm-12">						
						<!--Table-->
						<table id="tbl-tipoejecutor" class="table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="tipoejecutor" >
							<thead>
								<tr> 
									<th>#</th>
									<th>Nombre</th>									
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
		var tipoejecutorTable;
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		$(function () {
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})		
		});
		$('#tbl-tipoejecutor tbody').on( 'click', 'td', function (e) {
			e.stopImmediatePropagation();
			e.stopPropagation();
		} );							
		function tabletipoejecutor(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			tipoejecutorTable = $('#tbl-tipoejecutor').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"/tbl-tipoejecutor",					
					type:"POST",
					dataSrc:function(json){												
						return json.data;
					}
				},
				"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					$(nRow).click(function(e){						
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();
						
						var TEJ_Id = $(this).find("td")[0].innerText;						
						var data={TEJ_Id:TEJ_Id,mode:'mod'}
						
						$.ajax( {
							type:'POST',
							url: '/modal-tipoejecutor',
							data: data,
							success: function ( data ) {
								param = data.split(bb)
								if(param[0]==200){							
									$("#tipoejecutorModal").html(param[1]);
									$("#tipoejecutorModal").modal("show");
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
		
		$("#tipoejecutorModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation()
			tabletipoejecutor();
		})
		
		tabletipoejecutor();
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
		
		$("#btn_addtipoejecutorModal").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			$.ajax( {
				type:'POST',					
				url: '/modal-tipoejecutor',
				data: {mode:'add'},
				success: function ( data ) {
					param = data.split(bb)
					if(param[0]==200){							
						$("#tipoejecutorModal").html(param[1]);
						$("#tipoejecutorModal").modal("show");
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
	})
</script>