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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
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
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
	end if
	columnsDefsVerificadores="[]"
	response.write("200\\#verificadoresModal\\")%>
	<style>
	.tab .badge {
		position:relative!important;
		top: -.75rem!important;
	}
	</style>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document"> 
		<div class="modal-content">
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-check"></i> Verificadores</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">				
				<!--container-nav-->
				<div class="container-nav" style="margin-right: 15px;margin-left: 15px;margin-bottom: 20px;width:auto;" id="frmVerficadores">
					<div class="header">				
						<div class="content-nav">
							<a id="verficadorredesapoyo-tab" href="#verficadorredesapoyotab" class="active tab"><i class="fas fa-check"></i> Redes de Apoyo
							</a><%
							'if(LFO_Id=10) then
							if(LFO_Id=99) then%>
								<a id="verficadorenfoquesped-tab" href="#verficadorenfoquespedtab" class="active tab"><i class="fas fa-check"></i> Enfoques Pedagógicos
								</a><%
							end if%>
							<a id="verficadorestrategiaconv-tab" href="#verficadorestrategiaconvtab" class="tab"><i class="fas fa-check"></i> Estrategia de Convocatoria
							</a>
							<a id="verficadoresplancom-tab" href="#verficadoresplancomtab" class="tab"><i class="fas fa-check"></i> Plan de Difusón
							</a>
							<a id="verficadoresplancon-tab" href="#verficadoresplancontab" class="tab"><i class="fas fa-check"></i> Estrategia de Permancencia
							</a>
							<span class="yellow-bar"></span>							
						</div>				
					</div>
					<!--tab-content-->
					<div class="tab-content tab-validate">
						<!--verficadorredesapoyotab-->
						<div id="verficadorredesapoyotab" class="tabs-pane tabscroll">
							<div class="table-wrapper " id="container-table-redesapoyo">
								<table id="tbl-redesapoyo" class="ts table table-striped table-bordered dataTable table-sm" data-id="redesapoyo" data-page="true" data-selected="true" data-keys="1"> 
									<thead> 
										<tr> 
											<th style="width:10px;">Id</th>
											<th>Nombre</th>
											<th>Rubro</th>				 
											<th>Compromiso</th>
											<th>Tipo</th>
											<th>Subido</th>
											<th>Revisado</th>
											<th>Aprobado</th>
											<th>Rechazado</th>
											<th>Acciones</th>
										</tr>
									</thead>
								</table>
							</div>							
						</div><%
						if(LFO_Id=99) then%>
							<!--verficadorenfoquespedtab-->
							<div id="verficadorenfoquespedtab" class="tabs-pane tabscroll">
								<div class="table-wrapper " id="container-table-enfoquepedagogico">
									<table id="tbl-enfoquepedagogico" class="ts table table-striped table-bordered dataTable table-sm" data-id="enfoquepedagogico" data-page="true" data-selected="true" data-keys="1"> 
										<thead> 
											<tr> 
												<th style="width:10px;">Id</th>
												<th>Acción</th>
												<th>Descripción</th>
												<th>Justificacion</th>
												<th>Subido</th>
												<th>Revisado</th>
												<th>Aprobado</th>
												<th>Rechazado</th>
												<th>Acciones</th>
											</tr> 
										</thead>
									</table>
								</div>
							</div><%
						end if%>
						<!--verficadorestrategiaconvtab-->
						<div id="verficadorestrategiaconvtab" class="tabs-pane tabscroll">
							<div class="table-wrapper " id="container-table-estrategiaconv">
								<table id="tbl-estrategiaconv" class="ts table table-striped table-bordered dataTable table-sm" data-id="estrategiaconv" data-page="true" data-selected="true" data-keys="1"> 
									<thead> 
										<tr> 
											<th style="width:10px;">Id</th>
											<th>Acción</th>
											<th>Descripción</th>																						
											<th>Subido</th>
											<th>Revisado</th>
											<th>Aprobado</th>
											<th>Rechazado</th>
											<th>Acciones</th>
										</tr> 
									</thead>
								</table>
							</div>
						</div>
						<!--verficadoresplancomtab-->
						<div id="verficadoresplancomtab" class="tabs-pane tabscroll">
							<div class="table-wrapper " id="container-table-plancomunicacional">
								<table id="tbl-plancomunicacional" class="ts table table-striped table-bordered dataTable table-sm" data-id="plancomunicacional" data-page="true" data-selected="true" data-keys="1"> 
									<thead> 
										<tr> 
											<th style="width:10px;">Id</th>
											<th>Acción</th>
											<th>Descripción</th>																						
											<th>Medio Comunicación</th>
											<th>Frec/Cant</th>
											<th>Etapa Desarrollo</th>
											<th>Subido</th>
											<th>Revisado</th>
											<th>Aprobado</th>
											<th>Rechazado</th>
											<th>Acciones</th>
										</tr> 
									</thead>
								</table>
							</div>
						</div>
						<!--verficadoresplancontab-->
						<div id="verficadoresplancontab" class="tabs-pane tabscroll">
							<div class="table-wrapper " id="container-table-plancotingencia">
								<table id="tbl-plancotingencia" class="ts table table-striped table-bordered dataTable table-sm" data-id="plancotingencia" data-page="true" data-selected="true" data-keys="1"> 
									<thead> 
										<tr> 
											<th style="width:10px;">Id</th>
											<th>Riesgo identificado</th>
											<th>Descripción</th>																						
											<th>Etapa</th>											
											<th>Medida de mitigación</th>
											<th>Subido</th>
											<th>Revisado</th>
											<th>Aprobado</th>
											<th>Rechazado</th>
											<th>Acciones</th>
										</tr> 
									</thead>
								</table>
							</div>
						</div>
					</div>
					<!--tab-content-->
				</div>
				<!--container-nav-->				
			</div>
			<!--body-->
			<div class="modal-footer">
				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="verificadorespry"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->

<script>	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);						
		
		$("#frmVerficadores").tabsmaterialize({menumovil:false,contentAnimation:false},function(){});
		$("#verificadoresModal").on('show.bs.modal', function(e){					
			
		})		
		
		var VER_EstadoAprobado;
		var VER_EstadoSubido;
		var VER_EstadoRechazado;
		var VER_EstadoRevisado;
		var VER_SubidosPendientes;
		var VER_Total;

		var redesapoyoTable;
		var estrategiaconvTable;
		var enfoquepedagogicoTable;
		var plancomunicacionalTable;
		var plandecontingenciaTable;

		var LFO_Id = <%=LFO_Id%>;
		function loadTableVerificadores() {
			if($.fn.DataTable.isDataTable( "#tbl-redesapoyo")){
				$('#tbl-redesapoyo').dataTable().fnClearTable();
    			$('#tbl-redesapoyo').dataTable().fnDestroy();
			}	
			redesapoyoTable = $("#tbl-redesapoyo").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/redes-de-apoyo",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
						
						VER_EstadoAprobado = data.responseJSON["VER_EstadoAprobado"]
						VER_EstadoSubido = data.responseJSON["VER_EstadoSubido"]
						VER_EstadoRechazado = data.responseJSON["VER_EstadoRechazado"]
						VER_EstadoRevisado = data.responseJSON["VER_EstadoRevisado"]
						VER_Total = data.responseJSON["VER_Total"]

						$("#verficadorredesapoyo-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadorredesapoyo-tab").append(badgets)
					}
				}
			});
			if($.fn.DataTable.isDataTable( "#tbl-estrategiaconv")){
				$('#tbl-estrategiaconv').dataTable().fnClearTable();
				$('#tbl-estrategiaconv').dataTable().fnDestroy();
			}	
			estrategiaconvTable = $("#tbl-estrategiaconv").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/estrategia-de-convocatoria",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

						VER_EstadoAprobado = data.responseJSON["VER_EstadoAprobado"]
						VER_EstadoSubido = data.responseJSON["VER_EstadoSubido"]
						VER_EstadoRechazado = data.responseJSON["VER_EstadoRechazado"]
						VER_EstadoRevisado = data.responseJSON["VER_EstadoRevisado"]
						VER_Total = data.responseJSON["VER_Total"]

						$("#verficadorestrategiaconv-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadorestrategiaconv-tab").append(badgets)
					}
				}				
			});
			<%if(LFO_Id=99) then%>				
				if($.fn.DataTable.isDataTable( "#tbl-enfoquepedagogico")){
					$('#tbl-enfoquepedagogico').dataTable().fnClearTable();
					$('#tbl-enfoquepedagogico').dataTable().fnDestroy();
				}
				enfoquepedagogicoTable = $("#tbl-enfoquepedagogico").dataTable({
					lengthMenu: [ 5,10,20 ],
					autoWidth: false,
					ajax:{
						url:"/enfoque-pedagogico",
						type:"POST",
						data:{PRY_Id:<%=PRY_Id%>},					
						complete: function(data){						
							$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
							$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
							$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
							$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
							$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

							VER_EstadoAprobado = data.responseJSON["VER_EstadoAprobado"]
							VER_EstadoSubido = data.responseJSON["VER_EstadoSubido"]
							VER_EstadoRechazado = data.responseJSON["VER_EstadoRechazado"]
							VER_EstadoRevisado = data.responseJSON["VER_EstadoRevisado"]
							VER_Total = data.responseJSON["VER_Total"]
							
							$("#verficadorenfoquesped-tab span").remove();
							const badgets = badgetsver();						
							$("#verficadorenfoquesped-tab").append(badgets)
						}
					}				
				});		
			<%end if%>

			if($.fn.DataTable.isDataTable( "#tbl-plancomunicacional")){
				$('#tbl-plancomunicacional').dataTable().fnClearTable();
				$('#tbl-plancomunicacional').dataTable().fnDestroy();
			}			
			plancomunicacionalTable = $("#tbl-plancomunicacional").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/plan-comunicacional",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

						VER_EstadoAprobado = data.responseJSON["VER_EstadoAprobado"]
						VER_EstadoSubido = data.responseJSON["VER_EstadoSubido"]
						VER_EstadoRechazado = data.responseJSON["VER_EstadoRechazado"]
						VER_EstadoRevisado = data.responseJSON["VER_EstadoRevisado"]
						VER_Total = data.responseJSON["VER_Total"]

						$("#verficadoresplancom-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadoresplancom-tab").append(badgets)
					}
				}				
			});
						
			if($.fn.DataTable.isDataTable( "#tbl-plancotingencia")){
				$('#tbl-plancotingencia').dataTable().fnClearTable();
				$('#tbl-plancotingencia').dataTable().fnDestroy();
			}
			plandecontingenciaTable = $("#tbl-plancotingencia").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/plan-de-contingencia",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

						VER_EstadoAprobado = data.responseJSON["VER_EstadoAprobado"]
						VER_EstadoSubido = data.responseJSON["VER_EstadoSubido"]
						VER_EstadoRechazado = data.responseJSON["VER_EstadoRechazado"]
						VER_EstadoRevisado = data.responseJSON["VER_EstadoRevisado"]
						VER_Total = data.responseJSON["VER_Total"]

						$("#verficadoresplancon-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadoresplancon-tab").append(badgets)
					}
				}				
			});
			
			
			$('#tbl-redesapoyo').css('width','99%');
			$('#tbl-estrategiaconv').css('width','99%');
			<%if(LFO_Id=99) then%>				
				$('#tbl-enfoquepedagogico').css('width','99%');
			<%end if%>
			$('#tbl-plancomunicacional').css('width','99%');			
			$('#tbl-plancotingencia').css('width','99%');
			
		}		
		
		$('#tbl-redesapoyo').on('page.dt', function(){
			setTimeout(
				function() 
				{
					$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
					$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
					$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
				}, 100);						
		})
		
		$('#tbl-estrategiaconv').on('page.dt', function(){
			setTimeout(
				function() 
				{
					$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
					$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
					$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
				}, 100);						
		})

		$('#tbl-enfoquepedagogico').on('page.dt', function(){
			setTimeout(
				function() 
				{
					$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
					$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
					$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
				}, 100);						
		})		

		$('#tbl-plancomunicacional').on('page.dt', function(){
			setTimeout(
				function() 
				{
					$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
					$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
					$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
					$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
				}, 100);						
		})
		
		<%if(LFO_Id=99) then%>
			$('#tbl-plancotingencia').on('page.dt', function(){
				setTimeout(
					function() 
					{
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
					}, 100);						
			})
		<%end if%>
		
		$("#verificadoresModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").addClass("modal-open");
			loadTableVerificadores();
			exportTable();
		});				
		
		$("#verificadoresModal").on("click","#btn_frmaddverificadores",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
		})
		
		$("#verificadoresModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
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
		
		$("#verificadoresModal").on("click","#btn_salirverificadores",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();				
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

		/*Primer tab Redes de apoyo*/
		$("#frmVerficadores").on("click",".upverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id")
			var PAT_Tipo = $(this).data("tip")
			var progressBar = $($(this).parent()).find(".progress-bar")
			var progress = $($(this).parent()).find(".progress")
			var element = $(this);
			var errorfile=false;
			
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
					var file = $('.swal2-file').prop('files');
					var fileName;
					var extFile;
					var fileOk = true;
					var sizerror=false;
					var sumsize=0;
					
					for (var i = 0; i < file.length; i++) {
						formData.append(file[i].name, file[i])
						fileName = file[i].name;
						extFile  = fileName.split('.').pop()
						if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){
							
						}else{
							fileOk = false;
						};
						if(file[i].size>parseInt(maxupload[maxsize].size)){
							sizerror=true;
						};
						sumsize=sumsize+parseInt(file[i].size);
					}
					if(sumsize>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					}
					if(fileOk){					
						formData.append("fileToUpload", file);
						formData.append("PAT_Id", PAT_Id);
						formData.append("PAT_Tipo", PAT_Tipo);
						formData.append("PRY_Id", <%=PRY_Id%>);
						formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

						if(sizerror){
							Toast.fire({
								icon: 'error',
								title: maxupload[maxsize]['msg-toast']
							});	
						}else{
							$.ajax({
								xhr: function() {
									var xhr = new window.XMLHttpRequest();								
									xhr.upload.addEventListener("progress", ({loaded, total}) =>{
										let fileLoaded = Math.floor((loaded / total) * 100);
										let fileTotal = Math.floor(total / 1000);
										let fileSize;
										(fileTotal < 1024) ? fileSize = fileTotal + " KB" : fileSize = (loaded / (1024*1024)).toFixed(2) + " MB";

										//console.log(loaded, total, this)
										//console.log(progress)
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-patrocicion",
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
										title: 'Verificador subido correctamente.'
										});
										loadTableVerificadores();
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
					}else{
						Toast.fire({
						  icon: 'error',
						  title: 'Formato de archivo no válido!.'
						});
					}
				}
			})			
		})
		
		$("#frmVerficadores").on("click",".doverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id")	
			var PAT_Tipo = $(this).data("tip")
			var PRY_Hito = $(this).data("hito")
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-patrocinios',			
				data:{PAT_Id:PAT_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',PAT_Tipo:PAT_Tipo},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,PAT_Id:PAT_Id};
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
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
		$("#frmVerficadores").on("click",".delverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id");
			var PAT_Tipo = $(this).data("tip");

			swalWithBootstrapButtons.fire({
			  title: '¿Estás seguro?',
			  text: "Esta acción eliminará todos los adjuntos que contiene este verificador",
			  icon: 'warning',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax({
						url: "/eliminar-verificador-patrocinio",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PAT_Id:PAT_Id,PAT_Tipo:PAT_Tipo},						
						dataType: "json",
						success: function (data) {							
							if(data.state==200){								
								Toast.fire({
								  icon: 'success',
								  title: 'Verificador eliminado correctamente.'
								});
								loadTableVerificadores();
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Eliminación Fallida',
									text:data.message
								});
							}
						},
						error: function(){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Eliminación Fallida',
								text:data.message
							});
						}
					});
			  	}
			})
		})
		
		$("#frmVerficadores").on("click",".rejectverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id");			
			var PAT_Tipo = $(this).data("tip");
			var PRY_Id	= $(this).data("pry");
			var msg;
						
			$.ajax({
				url: "/consultar-estados-patrocinios",
				method: 'POST',					
				data:{PAT_Id:PAT_Id,PAT_Tipo:PAT_Tipo,PRY_Id:PRY_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.PAT_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.PAT_EstadoRechazado=="0"){
								PAT_EstadoRechazado = 1;
								msg = "RECHAZADO";
							}else{
								PAT_EstadoRechazado = 0;
								msg = "NO RECHAZADO";
							}												
							swalWithBootstrapButtons.fire({
							  title: '¿Estás seguro?',
							  text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							  icon: 'question',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-objetivos-patrocinios",
										method: 'POST',					
										data:{PAT_Id:PAT_Id,PAT_EstadoRechazado:PAT_EstadoRechazado,PAT_Tipo:PAT_Tipo,PRY_Id:PRY_Id},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												  icon: 'success',
												  title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						}
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})
		
		$("#frmVerficadores").on("click",".checkverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id");
			var PAT_Tipo = $(this).data("tip");
			var PRY_Id	= $(this).data("pry");
			var PAT_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-patrocinios",
				method: 'POST',					
				data:{PAT_Id:PAT_Id,PAT_Tipo:PAT_Tipo,PRY_Id:PRY_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.PAT_EstadoRevisado=="0"){
							PAT_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							PAT_EstadoRevisado = 0;
							msg = "NO REVISADO";
						}												
						swalWithBootstrapButtons.fire({
						  title: '¿Estás seguro?',
						  text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
						  icon: 'question',
						  showCancelButton: true,
						  confirmButtonColor: '#3085d6',
						  cancelButtonColor: '#d33',
						  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
						  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
						}).then((result) => {
							if (result.value) {
								$.ajax({
									url: "/estados-objetivos-patrocinios",
									method: 'POST',					
									data:{PAT_Id:PAT_Id,PAT_EstadoRevisado:PAT_EstadoRevisado,PAT_Tipo:PAT_Tipo,PRY_Id:PRY_Id},
									dataType: "json",
									success: function (data) {							
										if(data.state==200){								
											Toast.fire({
											  icon: 'success',
											  title: 'Estado ' + msg + ' modificado correctamente.'
											});
											loadTableVerificadores();
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									},
									error: function(){
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Cambio de estado Fallido',
											text:data.message
										});
									}
								});
							}
						})																								
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})
				
		$("#frmVerficadores").on("click",".acceptverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id");			
			var PAT_Tipo = $(this).data("tip");
			var PRY_Id	= $(this).data("pry");
			var msg;
						
			$.ajax({
				url: "/consultar-estados-patrocinios",
				method: 'POST',					
				data:{PAT_Id:PAT_Id,PAT_Tipo:PAT_Tipo,PRY_Id:PRY_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.PAT_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{						
							if(data.PAT_EstadoAprobado=="0"){
								PAT_EstadoAprobado = 1;
								msg = "APROBADO";
							}else{
								PAT_EstadoAprobado = 0;
								msg = "NO APROBADO";
							}
							swalWithBootstrapButtons.fire({
							  title: '¿Estás seguro?',
							  text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							  icon: 'question',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-objetivos-patrocinios",
										method: 'POST',					
										data:{PAT_Id:PAT_Id,PAT_EstadoAprobado:PAT_EstadoAprobado,PAT_Tipo:PAT_Tipo,PRY_Id:PRY_Id},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												  icon: 'success',
												  title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						
						}						
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})
		
		<%if(LFO_Id=99) then%>
			/*Segundo tab*/
			$("#frmVerficadores").on("click",".upverenfped",function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
							
				var ENP_Id = $(this).data("id");
				var progressBar = $($(this).parent()).find(".progress-bar")
				var progress = $($(this).parent()).find(".progress")
				var element = $(this)
				
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
						var file = $('.swal2-file').prop('files');
						var fileName;
						var extFile;
						var fileOk = true;
						var sizerror=false;
						var sumsize=0;
						
						for (var i = 0; i < file.length; i++) {
							formData.append(file[i].name, file[i])
							fileName = file[i].name;
							extFile  = fileName.split('.').pop()
							if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){
								
							}else{
								fileOk = false;
							};
							if(file[i].size>parseInt(maxupload[maxsize].size)){
								sizerror=true;
							};
							sumsize=sumsize+parseInt(file[i].size);
						}
						if(sumsize>parseInt(maxupload[maxsize].size)){
							sizerror=true;
						}
						if(fileOk){					
							formData.append("fileToUpload", file);
							formData.append("ENP_Id", ENP_Id);						
							formData.append("PRY_Id", <%=PRY_Id%>);
							formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

							if(sizerror){
								Toast.fire({
									icon: 'error',
									title: maxupload[maxsize]['msg-toast']
								});	
							}else{
								$.ajax({
									xhr: function() {
										var xhr = new window.XMLHttpRequest();								
										xhr.upload.addEventListener("progress", ({loaded, total}) =>{
											let fileLoaded = Math.floor((loaded / total) * 100);
											let fileTotal = Math.floor(total / 1000);
											let fileSize;
											(fileTotal < 1024) ? fileSize = fileTotal + " KB" : fileSize = (loaded / (1024*1024)).toFixed(2) + " MB";

											//console.log(loaded, total, this)
											//console.log(progress)
											progressBar.show();
											element.css("cursor","not-allowed");
											element.removeClass("text-primary");
											element.removeClass("upverpat");
											element.addClass("text-white-50");
											progress.css("width",fileLoaded + "%")
										}, false);
										return xhr;
									},
									url: "/subir-verificador-enfoque",
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
											title: 'Verificador subido correctamente.'
											});
											loadTableVerificadores();
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
						}else{
							Toast.fire({
							icon: 'error',
							title: 'Formato de archivo no válido!.'
							});
						}
					}
				})			
			})

			$("#frmVerficadores").on("click",".doverenfped",function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
							
				var ENP_Id = $(this).data("id")	
			
				ajax_icon_handling('load','Buscando verificadores','','');
				$.ajax({
					type: 'POST',								
					url:'/listar-verificadores-enfoques-pedagogicos',			
					data:{ENP_Id:ENP_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
					success: function(data) {
						var param=data.split(bb);			
						if(param[0]=="200"){				
							ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
							$(".swal2-popup").css("width","60rem");
							loadtables("#tbl-historico");
							$(".arcalm").click(function(){
								var INF_Arc = $(this).data("file");
								var PRY_Hito=$(this).data("hito");
								var ALU_Rut;
								var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:116, ALU_Rut:ALU_Rut,ENP_Id:ENP_Id};
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
							ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
						}						
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
					},
					complete: function(){																		
					}
				})
			})

			$("#frmVerficadores").on("click",".delverenfped",function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
							
				var ENP_Id = $(this).data("id");
				var PRY_Id = $(this).data("pry");

				swalWithBootstrapButtons.fire({
				title: '¿Estás seguro?',
				text: "Esta acción eliminará todos los adjuntos que contiene este verificador",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#3085d6',
				cancelButtonColor: '#d33',
				confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
				}).then((result) => {
					if (result.value) {
						$.ajax({
							url: "/eliminar-verificador-enfoque-pedagogico",
							method: 'POST',					
							data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',ENP_Id:ENP_Id},						
							dataType: "json",
							success: function (data) {							
								if(data.state==200){								
									Toast.fire({
									icon: 'success',
									title: 'Verificador eliminado correctamente.'
									});
									loadTableVerificadores();
								}else{
									swalWithBootstrapButtons.fire({
										icon:'error',
										title:'Eliminación Fallida',
										text:data.message
									});
								}
							},
							error: function(){
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Eliminación Fallida',
									text:data.message
								});
							}
						});
					}
				})
			})

			$("#frmVerficadores").on("click",".rejectverenfped",function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
							
				var ENP_Id = $(this).data("id");
				var PRY_Id = $(this).data("pry");
				var ENP_EstadoRechazado;
				var msg;
							
				$.ajax({
					url: "/consultar-estados-enfoque-pedagogico",
					method: 'POST',					
					data:{PRY_Id:PRY_Id,ENP_Id:ENP_Id},
					dataType: "json",
					success: function (data) {							
						if(data.state==200){						
							loadTableVerificadores();
							if(data.ENP_EstadoRevisado=="0"){
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:'Debes REVISAR el documento antes de RECHAZARLO'
								});
							}else{	
								if(data.ENP_EstadoRechazado=="0"){
									ENP_EstadoRechazado = 1;
									msg = "RECHAZADO";
								}else{
									ENP_EstadoRechazado = 0;
									msg = "NO RECHAZADO";
								}												
								swalWithBootstrapButtons.fire({
								title: '¿Estás seguro?',
								text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
								icon: 'question',
								showCancelButton: true,
								confirmButtonColor: '#3085d6',
								cancelButtonColor: '#d33',
								confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
								cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
								}).then((result) => {
									if (result.value) {
										$.ajax({
											url: "/estados-enfoques-pedagogicos",
											method: 'POST',					
											data:{PRY_Id:PRY_Id,ENP_Id:ENP_Id,ENP_EstadoRechazado:ENP_EstadoRechazado},
											dataType: "json",
											success: function (data) {							
												if(data.state==200){								
													Toast.fire({
													icon: 'success',
													title: 'Estado ' + msg + ' modificado correctamente.'
													});
													loadTableVerificadores();
												}else{
													swalWithBootstrapButtons.fire({
														icon:'error',
														title:'Cambio de estado Fallido',
														text:data.message
													});
												}
											},
											error: function(){
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										});
									}
								})																								
							}
						}else{																		
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Cambio de estado Fallido',
								text:data.message
							});
						}
					},
					error: function(){
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				});						
			})

			$("#frmVerficadores").on("click",".chkverenfped",function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
							
				var ENP_Id = $(this).data("id");
				var PRY_Id = $(this).data("pry");
				var ENP_EstadoRevisado;
				var msg;
							
				$.ajax({
					url: "/consultar-estados-enfoque-pedagogico",
					method: 'POST',					
					data:{PRY_Id:PRY_Id, ENP_Id:ENP_Id},
					dataType: "json",
					success: function (data) {							
						if(data.state==200){						
							loadTableVerificadores();						
							if(data.ENP_EstadoRevisado=="0"){
								ENP_EstadoRevisado = 1;
								msg = "REVISADO";
							}else{
								ENP_EstadoRevisado = 0;
								msg = "NO REVISADO";
							}												
							swalWithBootstrapButtons.fire({
							title: '¿Estás seguro?',
							text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-enfoques-pedagogicos",
										method: 'POST',					
										data:{PRY_Id:PRY_Id, ENP_Id:ENP_Id,ENP_EstadoRevisado:ENP_EstadoRevisado},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												icon: 'success',
												title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						}else{																		
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Cambio de estado Fallido',
								text:data.message
							});
						}
					},
					error: function(){
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				});						
			})

			$("#frmVerficadores").on("click",".acceptverenfped",function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();
							
				var ENP_Id = $(this).data("id");
				var PRY_Id = $(this).data("pry");
				var ENP_EstadoAprobado;
				var msg;
							
				$.ajax({
					url: "/consultar-estados-enfoque-pedagogico",
					method: 'POST',					
					data:{PRY_Id:PRY_Id,ENP_Id:ENP_Id},
					dataType: "json",
					success: function (data) {							
						if(data.state==200){						
							loadTableVerificadores();						
							if(data.ENP_EstadoRevisado=="0"){
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:'Debes REVISAR el documento antes de ACEPTARLO'
								});
							}else{						
								if(data.ENP_EstadoAprobado=="0"){
									ENP_EstadoAprobado = 1;
									msg = "APROBADO";
								}else{
									ENP_EstadoAprobado = 0;
									msg = "NO APROBADO";
								}
								swalWithBootstrapButtons.fire({
								title: '¿Estás seguro?',
								text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
								icon: 'question',
								showCancelButton: true,
								confirmButtonColor: '#3085d6',
								cancelButtonColor: '#d33',
								confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
								cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
								}).then((result) => {
									if (result.value) {
										$.ajax({
											url: "/estados-enfoques-pedagogicos",
											method: 'POST',					
											data:{PRY_Id:PRY_Id,ENP_Id:ENP_Id,ENP_EstadoAprobado:ENP_EstadoAprobado},
											dataType: "json",
											success: function (data) {							
												if(data.state==200){								
													Toast.fire({
													icon: 'success',
													title: 'Estado ' + msg + ' modificado correctamente.'
													});
													loadTableVerificadores();
												}else{
													swalWithBootstrapButtons.fire({
														icon:'error',
														title:'Cambio de estado Fallido',
														text:data.message
													});
												}
											},
											error: function(){
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										});
									}
								})																								
							
							}						
						}else{																		
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Cambio de estado Fallido',
								text:data.message
							});
						}
					},
					error: function(){
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				});						
			})							
		<%end if%>

		/*Tercer Tab Estrategia de convocatoria*/
		$("#frmVerficadores").on("click",".upverestconv",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ESC_Id = $(this).data("id")
			var PRY_Id = $(this).data("pry");
			var progressBar = $($(this).parent()).find(".progress-bar")
			var progress = $($(this).parent()).find(".progress")
			var element = $(this)
			
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
					var file = $('.swal2-file').prop('files');
					var fileName;
					var extFile;
					var fileOk = true;
					var sizerror=false;
					var sumsize=0;
					
					for (var i = 0; i < file.length; i++) {
						formData.append(file[i].name, file[i])
						fileName = file[i].name;
						extFile  = fileName.split('.').pop()
						if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){
							
						}else{
							fileOk = false;
						};
						if(file[i].size>parseInt(maxupload[maxsize].size)){
							sizerror=true;
						};
						sumsize=sumsize+parseInt(file[i].size);
					}
					if(sumsize>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					}
					if(fileOk){					
						formData.append("fileToUpload", file);
						formData.append("ESC_Id", ESC_Id);
						formData.append("PRY_Id", PRY_Id);
						formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

						if(sizerror){
							Toast.fire({
								icon: 'error',
								title: maxupload[maxsize]['msg-toast']
							});	
						}else{
							$.ajax({
								xhr: function() {
									var xhr = new window.XMLHttpRequest();								
									xhr.upload.addEventListener("progress", ({loaded, total}) =>{
										let fileLoaded = Math.floor((loaded / total) * 100);
										let fileTotal = Math.floor(total / 1000);
										let fileSize;
										(fileTotal < 1024) ? fileSize = fileTotal + " KB" : fileSize = (loaded / (1024*1024)).toFixed(2) + " MB";

										//console.log(loaded, total, this)
										//console.log(progress)
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-estrategia-de-convocatoria",
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
										title: 'Verificador subido correctamente.'
										});
										loadTableVerificadores();
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
					}else{
						Toast.fire({
						icon: 'error',
						title: 'Formato de archivo no válido!.'
						});
					}
				}
			})			
		})
		
		$("#frmVerficadores").on("click",".doverestconv",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ESC_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-estrategia-de-convocatoria',			
				data:{ESC_Id:ESC_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:115, ALU_Rut:ALU_Rut,ESC_Id:ESC_Id};
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
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
		$("#frmVerficadores").on("click",".delverestconv",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ESC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");

			swalWithBootstrapButtons.fire({
			title: '¿Estás seguro?',
			text: "Esta acción eliminará todos los adjuntos que contiene este verificador",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
			cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax({
						url: "/eliminar-verificador-estrategia-de-convocatoria",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',ESC_Id:ESC_Id},						
						dataType: "json",
						success: function (data) {							
							if(data.state==200){								
								Toast.fire({
								icon: 'success',
								title: 'Verificador eliminado correctamente.'
								});
								loadTableVerificadores();
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Eliminación Fallida',
									text:data.message
								});
							}
						},
						error: function(){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Eliminación Fallida',
								text:data.message
							});
						}
					});
				}
			})
		})				
		
		$("#frmVerficadores").on("click",".rejectverestconv",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ESC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var ESC_EstadoRechazado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-estrategia-de-convocatoria",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,ESC_Id:ESC_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.ESC_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.ESC_EstadoRechazado=="0"){
								ESC_EstadoRechazado = 1;
								msg = "RECHAZADO";
							}else{
								ESC_EstadoRechazado = 0;
								msg = "NO RECHAZADO";
							}												
							swalWithBootstrapButtons.fire({
							title: '¿Estás seguro?',
							text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-estrategia-de-convocatoria",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,ESC_Id:ESC_Id,ESC_EstadoRechazado:ESC_EstadoRechazado},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												icon: 'success',
												title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						}
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})
		
		$("#frmVerficadores").on("click",".chkverestconv",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ESC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var ESC_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-estrategia-de-convocatoria",
				method: 'POST',					
				data:{PRY_Id:PRY_Id, ESC_Id:ESC_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.ESC_EstadoRevisado=="0"){
							ESC_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							ESC_EstadoRevisado = 0;
							msg = "NO REVISADO";
						}												
						swalWithBootstrapButtons.fire({
						title: '¿Estás seguro?',
						text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
						icon: 'question',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
						cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
						}).then((result) => {
							if (result.value) {
								$.ajax({
									url: "/estados-estrategia-de-convocatoria",
									method: 'POST',					
									data:{PRY_Id:PRY_Id, ESC_Id:ESC_Id,ESC_EstadoRevisado:ESC_EstadoRevisado},
									dataType: "json",
									success: function (data) {							
										if(data.state==200){								
											Toast.fire({
											icon: 'success',
											title: 'Estado ' + msg + ' modificado correctamente.'
											});
											loadTableVerificadores();
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									},
									error: function(){
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Cambio de estado Fallido',
											text:data.message
										});
									}
								});
							}
						})																								
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})
				
		$("#frmVerficadores").on("click",".acceptverestconv",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var ESC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var ESC_EstadoAprobado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-estrategia-de-convocatoria",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,ESC_Id:ESC_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.ESC_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{						
							if(data.ESC_EstadoAprobado=="0"){
								ESC_EstadoAprobado = 1;
								msg = "APROBADO";
							}else{
								ESC_EstadoAprobado = 0;
								msg = "NO APROBADO";
							}
							swalWithBootstrapButtons.fire({
							title: '¿Estás seguro?',
							text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-estrategia-de-convocatoria",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,ESC_Id:ESC_Id,ESC_EstadoAprobado:ESC_EstadoAprobado},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												icon: 'success',
												title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						
						}						
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		/*Cuarto Tab Plan de Difusion*/
		$("#frmVerficadores").on("click",".upverplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id")
			var PRY_Id = $(this).data("pry");
			var progressBar = $($(this).parent()).find(".progress-bar")
			var progress = $($(this).parent()).find(".progress")
			var element = $(this)
			
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
					var file = $('.swal2-file').prop('files');
					var fileName;
					var extFile;
					var fileOk = true;
					var sizerror=false;
					var sumsize=0;
					
					for (var i = 0; i < file.length; i++) {
						formData.append(file[i].name, file[i])
						fileName = file[i].name;
						extFile  = fileName.split('.').pop()
						if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){
							
						}else{
							fileOk = false;
						};
						if(file[i].size>parseInt(maxupload[maxsize].size)){
							sizerror=true;
						};
						sumsize=sumsize+parseInt(file[i].size);
					}
					if(sumsize>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					}
					if(fileOk){					
						formData.append("fileToUpload", file);
						formData.append("PLC_Id", PLC_Id);
						formData.append("PRY_Id", PRY_Id);
						formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

						if(sizerror){
							Toast.fire({
								icon: 'error',
								title: maxupload[maxsize]['msg-toast']
							});	
						}else{
							$.ajax({
								xhr: function() {
									var xhr = new window.XMLHttpRequest();								
									xhr.upload.addEventListener("progress", ({loaded, total}) =>{
										let fileLoaded = Math.floor((loaded / total) * 100);
										let fileTotal = Math.floor(total / 1000);
										let fileSize;
										(fileTotal < 1024) ? fileSize = fileTotal + " KB" : fileSize = (loaded / (1024*1024)).toFixed(2) + " MB";

										//console.log(loaded, total, this)
										//console.log(progress)
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-plan-comunicacional",
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
										title: 'Verificador subido correctamente.'
										});
										loadTableVerificadores();
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
						};
					}else{
						Toast.fire({
						icon: 'error',
						title: 'Formato de archivo no válido!.'
						});
					}
				}
			})			
		})

		$("#frmVerficadores").on("click",".chkverplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var PLC_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-comunicacional",
				method: 'POST',					
				data:{PRY_Id:PRY_Id, PLC_Id:PLC_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.PLC_EstadoRevisado=="0"){
							PLC_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							PLC_EstadoRevisado = 0;
							msg = "NO REVISADO";
						}												
						swalWithBootstrapButtons.fire({
						title: '¿Estás seguro?',
						text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
						icon: 'question',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
						cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
						}).then((result) => {
							if (result.value) {
								$.ajax({
									url: "/estados-plan-comunicacional",
									method: 'POST',					
									data:{PRY_Id:PRY_Id, PLC_Id:PLC_Id,PLC_EstadoRevisado:PLC_EstadoRevisado},
									dataType: "json",
									success: function (data) {							
										if(data.state==200){								
											Toast.fire({
											icon: 'success',
											title: 'Estado ' + msg + ' modificado correctamente.'
											});
											loadTableVerificadores();
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									},
									error: function(){
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Cambio de estado Fallido',
											text:data.message
										});
									}
								});
							}
						})																								
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		$("#frmVerficadores").on("click",".acceptverplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var PLC_EstadoAprobado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-comunicacional",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,PLC_Id:PLC_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.PLC_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.ESC_EstadoRevisado=="0"){
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:'Debes REVISAR el documento antes de ACEPTARLO'
								});
							}else{						
								if(data.PLC_EstadoAprobado=="0"){
									PLC_EstadoAprobado = 1;
									msg = "APROBADO";
								}else{
									PLC_EstadoAprobado = 0;
									msg = "NO APROBADO";
								}
								swalWithBootstrapButtons.fire({
								title: '¿Estás seguro?',
								text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
								icon: 'question',
								showCancelButton: true,
								confirmButtonColor: '#3085d6',
								cancelButtonColor: '#d33',
								confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
								cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
								}).then((result) => {
									if (result.value) {
										$.ajax({
											url: "/estados-plan-comunicacional",
											method: 'POST',					
											data:{PRY_Id:PRY_Id,PLC_Id:PLC_Id,PLC_EstadoAprobado:PLC_EstadoAprobado},
											dataType: "json",
											success: function (data) {							
												if(data.state==200){								
													Toast.fire({
													icon: 'success',
													title: 'Estado ' + msg + ' modificado correctamente.'
													});
													loadTableVerificadores();
												}else{
													swalWithBootstrapButtons.fire({
														icon:'error',
														title:'Cambio de estado Fallido',
														text:data.message
													});
												}
											},
											error: function(){
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										});
									}
								})																								
							
							}
						}
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		$("#frmVerficadores").on("click",".rejectverplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var PLC_EstadoRechazado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-comunicacional",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,PLC_Id:PLC_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.PLC_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.PLC_EstadoRechazado=="0"){
								PLC_EstadoRechazado = 1;
								msg = "RECHAZADO";
							}else{
								PLC_EstadoRechazado = 0;
								msg = "NO RECHAZADO";
							}												
							swalWithBootstrapButtons.fire({
							title: '¿Estás seguro?',
							text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-plan-comunicacional",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,PLC_Id:PLC_Id,PLC_EstadoRechazado:PLC_EstadoRechazado},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												icon: 'success',
												title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						}
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		$("#frmVerficadores").on("click",".doverplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-plan-comunicacional',			
				data:{PLC_Id:PLC_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-archivosplncom");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:117, ALU_Rut:ALU_Rut,PLC_Id:PLC_Id};
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
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})

		$("#frmVerficadores").on("click",".delverplncom",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PLC_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");

			swalWithBootstrapButtons.fire({
			title: '¿Estás seguro?',
			text: "Esta acción eliminará todos los adjuntos que contiene este verificador",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
			cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax({
						url: "/eliminar-verificador-plan-comunicacional",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PLC_Id:PLC_Id},						
						dataType: "json",
						success: function (data) {							
							if(data.state==200){								
								Toast.fire({
								icon: 'success',
								title: 'Verificador eliminado correctamente.'
								});
								loadTableVerificadores();
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Eliminación Fallida',
									text:data.message
								});
							}
						},
						error: function(){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Eliminación Fallida',
								text:data.message
							});
						}
					});
				}
			})
		})
						
		/*Quinto Tab Estrategia de Permanencia*/
		$("#frmVerficadores").on("click",".upverplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id")
			var PRY_Id = $(this).data("pry");
			var progressBar = $($(this).parent()).find(".progress-bar")
			var progress = $($(this).parent()).find(".progress")
			var element = $(this)
			
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
					var file = $('.swal2-file').prop('files');
					var fileName;
					var extFile;
					var fileOk = true;
					var sizerror=false;
					var sumsize=0;
					
					for (var i = 0; i < file.length; i++) {
						formData.append(file[i].name, file[i])
						fileName = file[i].name;
						extFile  = fileName.split('.').pop()
						if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){
							
						}else{
							fileOk = false;
						};
						if(file[i].size>parseInt(maxupload[maxsize].size)){
							sizerror=true;
						};
						sumsize=sumsize+parseInt(file[i].size);
					}
					if(sumsize>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					}
					if(fileOk){					
						formData.append("fileToUpload", file);
						formData.append("PCO_Id", PCO_Id);
						formData.append("PRY_Id", PRY_Id);
						formData.append("PRY_Identificador", '<%=PRY_Identificador%>');

						if(sizerror){
							Toast.fire({
								icon: 'error',
								title: maxupload[maxsize]['msg-toast']
							});	
						}else{
							$.ajax({
								xhr: function() {
									var xhr = new window.XMLHttpRequest();								
									xhr.upload.addEventListener("progress", ({loaded, total}) =>{
										let fileLoaded = Math.floor((loaded / total) * 100);
										let fileTotal = Math.floor(total / 1000);
										let fileSize;
										(fileTotal < 1024) ? fileSize = fileTotal + " KB" : fileSize = (loaded / (1024*1024)).toFixed(2) + " MB";

										//console.log(loaded, total, this)
										//console.log(progress)
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-plan-de-continigencia",
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
										title: 'Verificador subido correctamente.'
										});
										loadTableVerificadores();
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
						};
					}else{
						Toast.fire({
						icon: 'error',
						title: 'Formato de archivo no válido!.'
						});
					}
				}
			})			
		})

		$("#frmVerficadores").on("click",".doverplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-plan-de-contingencia',			
				data:{PCO_Id:PCO_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-archivosplncom");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:118, ALU_Rut:ALU_Rut,PCO_Id:PCO_Id};
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
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})

		$("#frmVerficadores").on("click",".checkverplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var PLC_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-de-contingencia",
				method: 'POST',					
				data:{PRY_Id:PRY_Id, PCO_Id:PCO_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.PCO_EstadoRevisado=="0"){
							PCO_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							PCO_EstadoRevisado = 0;
							msg = "NO REVISADO";
						}												
						swalWithBootstrapButtons.fire({
						title: '¿Estás seguro?',
						text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
						icon: 'question',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
						cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
						}).then((result) => {
							if (result.value) {
								$.ajax({
									url: "/estados-plan-de-contingencia",
									method: 'POST',					
									data:{PRY_Id:PRY_Id, PCO_Id:PCO_Id,PCO_EstadoRevisado:PCO_EstadoRevisado},
									dataType: "json",
									success: function (data) {							
										if(data.state==200){								
											Toast.fire({
											icon: 'success',
											title: 'Estado ' + msg + ' modificado correctamente.'
											});
											loadTableVerificadores();
										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									},
									error: function(){
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Cambio de estado Fallido',
											text:data.message
										});
									}
								});
							}
						})																								
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		$("#frmVerficadores").on("click",".acceptverplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var PCO_EstadoAprobado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-de-contingencia",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,PCO_Id:PCO_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.PCO_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{						
							if(data.PCO_EstadoAprobado=="0"){
								PCO_EstadoAprobado = 1;
								msg = "APROBADO";
							}else{
								PCO_EstadoAprobado = 0;
								msg = "NO APROBADO";
							}
							swalWithBootstrapButtons.fire({
							title: '¿Estás seguro?',
							text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-plan-de-contingencia",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,PCO_Id:PCO_Id,PCO_EstadoAprobado:PCO_EstadoAprobado},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												icon: 'success',
												title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						
						}						
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		$("#frmVerficadores").on("click",".rejectverplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var PCO_EstadoRechazado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-de-contingencia",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,PCO_Id:PCO_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.PCO_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.PCO_EstadoRechazado=="0"){
								PCO_EstadoRechazado = 1;
								msg = "RECHAZADO";
							}else{
								PCO_EstadoRechazado = 0;
								msg = "NO RECHAZADO";
							}												
							swalWithBootstrapButtons.fire({
							title: '¿Estás seguro?',
							text: "Esta acción dejará en estado " + msg + " el documento seleccionado",
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cambiar!',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									$.ajax({
										url: "/estados-plan-de-contingencia",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,PCO_Id:PCO_Id,PCO_EstadoRechazado:PCO_EstadoRechazado},
										dataType: "json",
										success: function (data) {							
											if(data.state==200){								
												Toast.fire({
												icon: 'success',
												title: 'Estado ' + msg + ' modificado correctamente.'
												});
												loadTableVerificadores();
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',
													title:'Cambio de estado Fallido',
													text:data.message
												});
											}
										},
										error: function(){
											swalWithBootstrapButtons.fire({
												icon:'error',
												title:'Cambio de estado Fallido',
												text:data.message
											});
										}
									});
								}
							})																								
						}
					}else{																		
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Cambio de estado Fallido',
							text:data.message
						});
					}
				},
				error: function(){
					swalWithBootstrapButtons.fire({
						icon:'error',
						title:'Cambio de estado Fallido',
						text:data.message
					});
				}
			});						
		})

		$("#frmVerficadores").on("click",".delverplncon",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PCO_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");

			swalWithBootstrapButtons.fire({
			title: '¿Estás seguro?',
			text: "Esta acción eliminará todos los adjuntos que contiene este verificador",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
			cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax({
						url: "/eliminar-verificador-plan-de-contingencia",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PCO_Id:PCO_Id},						
						dataType: "json",
						success: function (data) {							
							if(data.state==200){								
								Toast.fire({
								icon: 'success',
								title: 'Verificador eliminado correctamente.'
								});
								loadTableVerificadores();
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'Eliminación Fallida',
									text:data.message
								});
							}
						},
						error: function(){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Eliminación Fallida',
								text:data.message
							});
						}
					});
				}
			})
		})
		
		function badgetsver(){
			var verificadores='';			
			var VER_SubidosPendientes = VER_EstadoSubido - VER_EstadoRevisado			
			var VER_SinSubir = VER_Total - VER_EstadoSubido			

			if(VER_SinSubir>0){
				verificadores= "<span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" + VER_SinSubir + "</span> "
			}
			if(VER_SubidosPendientes>0){
				verificadores= verificadores + "<span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" + VER_SubidosPendientes + "</span> "
			}
			if(VER_EstadoRechazado>0){
				verificadores= verificadores + "</span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" + VER_EstadoRechazado + "</span>"
			}
			return verificadores
		}
		
		$("body").append("<button id='btn_modalverificadores' name='btn_modalverificadores' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalverificadores").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#verificadoresModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalverificadores").click();		
		$("#btn_modalverificadores").remove();
	})
</script>