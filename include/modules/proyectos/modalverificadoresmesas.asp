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
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
	end if
	columnsDefsVerificadores="[]"
	response.write("200\\#verificadoresModalMesas\\")%>
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
				<div class="container-nav" style="margin-right: 15px;margin-left: 15px;margin-bottom: 20px;width:auto;" id="frmVerficadoresMesas">
					<div class="header">				
						<div class="content-nav">
							<a id="verficadorredesapoyomesas-tab" href="#verficadorredesapoyomesastab" class="active tab"><i class="fas fa-check"></i> Redes de Apoyo
							</a>							
							<span class="yellow-bar"></span>							
						</div>				
					</div>
					<!--tab-content-->
					<div class="tab-content tab-validate">
						<!--verficadorredesapoyomesastab-->
						<div id="verficadorredesapoyomesastab" class="tabs-pane tabscroll">
							<div class="table-wrapper " id="container-table-redesapoyo">
								<table id="tbl-redesapoyomesas" class="ts table table-striped table-bordered dataTable table-sm" data-id="redesapoyo" data-page="true" data-selected="true" data-keys="1"> 
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
		
		$("#frmVerficadoresMesas").tabsmaterialize({menumovil:false,contentAnimation:false},function(){});
		$("#verificadoresModalMesas").on('show.bs.modal', function(e){					
			
		})		
		
		var VER_EstadoAprobadoMesas;
		var VER_EstadoSubidoMesas;
		var VER_EstadoRechazadoMesas;
		var VER_EstadoRevisadoMesas;
		var VER_SubidosPendientesMesas;
		var VER_TotalMesas;

		var redesapoyoTableMesas;
		var gruposfocalesTable;		
		var coordinacionactoresTable;
		var plancomunicacionalTable;
		var plandetrabajoTable;
		
		function loadTableVerificadores() {
			if($.fn.DataTable.isDataTable( "#tbl-redesapoyomesas")){
				$('#tbl-redesapoyomesas').dataTable().fnClearTable();
    			$('#tbl-redesapoyomesas').dataTable().fnDestroy();
			}	
			redesapoyoTableMesas = $("#tbl-redesapoyomesas").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/redes-de-apoyo-mesas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
						
						VER_EstadoAprobadoMesas = data.responseJSON["VER_EstadoAprobadoMesas"]
						VER_EstadoSubidoMesas = data.responseJSON["VER_EstadoSubidoMesas"]
						VER_EstadoRechazadoMesas = data.responseJSON["VER_EstadoRechazadoMesas"]
						VER_EstadoRevisadoMesas = data.responseJSON["VER_EstadoRevisadoMesas"]
						VER_TotalMesas = data.responseJSON["VER_TotalMesas"]

						$("#verficadorredesapoyomesas-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadorredesapoyomesas-tab").append(badgets)
					}
				}
			});			
			if($.fn.DataTable.isDataTable( "#tbl-gruposfocales")){
				$('#tbl-gruposfocales').dataTable().fnClearTable();
    			$('#tbl-gruposfocales').dataTable().fnDestroy();
			}	
			gruposfocalesTable = $("#tbl-gruposfocales").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/grupos-focales-mesas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

						VER_EstadoAprobadoMesas = data.responseJSON["VER_EstadoAprobadoMesas"]
						VER_EstadoSubidoMesas = data.responseJSON["VER_EstadoSubidoMesas"]
						VER_EstadoRechazadoMesas = data.responseJSON["VER_EstadoRechazadoMesas"]
						VER_EstadoRevisadoMesas = data.responseJSON["VER_EstadoRevisadoMesas"]
						VER_TotalMesas = data.responseJSON["VER_TotalMesas"]

						$("#verficadorgrpfocalesmesas-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadorgrpfocalesmesas-tab").append(badgets)
					}
				}				
			});			
			if($.fn.DataTable.isDataTable( "#tbl-coordinacionactores")){
				$('#tbl-coordinacionactores').dataTable().fnClearTable();
    			$('#tbl-coordinacionactores').dataTable().fnDestroy();
			}
			coordinacionactoresTable = $("#tbl-coordinacionactores").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/coordinacion-actores-mesas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

						VER_EstadoAprobadoMesas = data.responseJSON["VER_EstadoAprobadoMesas"]
						VER_EstadoSubidoMesas = data.responseJSON["VER_EstadoSubidoMesas"]
						VER_EstadoRechazadoMesas = data.responseJSON["VER_EstadoRechazadoMesas"]
						VER_EstadoRevisadoMesas = data.responseJSON["VER_EstadoRevisadoMesas"]
						VER_TotalMesas = data.responseJSON["VER_TotalMesas"]
						
						$("#verficadorescoordactores-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadorescoordactores-tab").append(badgets)
					}
				}				
			});
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

						VER_EstadoAprobadoMesas = data.responseJSON["VER_EstadoAprobado"]
						VER_EstadoSubidoMesas = data.responseJSON["VER_EstadoSubido"]
						VER_EstadoRechazadoMesas = data.responseJSON["VER_EstadoRechazado"]
						VER_EstadoRevisadoMesas = data.responseJSON["VER_EstadoRevisado"]
						VER_TotalMesas = data.responseJSON["VER_Total"]
						
						$("#verficadoresplancomunicacional-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadoresplancomunicacional-tab").append(badgets)
					}
				}				
			});
			if($.fn.DataTable.isDataTable( "#tbl-plandetrabajo")){
				$('#tbl-plandetrabajo').dataTable().fnClearTable();
    			$('#tbl-plandetrabajo').dataTable().fnDestroy();
			}
			plandetrabajoTable = $("#tbl-plandetrabajo").dataTable({
				lengthMenu: [ 5,10,20 ],
				autoWidth: false,
				ajax:{
					url:"/plan-de-trabajo",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>},					
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");

						VER_EstadoAprobadoMesas = data.responseJSON["VER_EstadoAprobado"]
						VER_EstadoSubidoMesas = data.responseJSON["VER_EstadoSubido"]
						VER_EstadoRechazadoMesas = data.responseJSON["VER_EstadoRechazado"]
						VER_EstadoRevisadoMesas = data.responseJSON["VER_EstadoRevisado"]
						VER_TotalMesas = data.responseJSON["VER_Total"]
						
						$("#verficadoresplandetrabajo-tab span").remove();
						const badgets = badgetsver();						
						$("#verficadoresplandetrabajo-tab").append(badgets)
					}
				}				
			});
			$('#tbl-redesapoyomesas').css('width','99%');
			$('#tbl-gruposfocales').css('width','99%');
			$('#tbl-coordinacionactores').css('width','99%');
			$('#tbl-plancomunicacional').css('width','99%');
			$('#tbl-plandetrabajo').css('width','99%');			
		}		
		
		$('#tbl-redesapoyomesas').on('page.dt', function(){
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
		$('#tbl-gruposfocales').on('page.dt', function(){
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
		$('#tbl-coordinacionactores').on('page.dt', function(){
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
		$('#tbl-plandetrabajo').on('page.dt', function(){
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
		
		$("#verificadoresModalMesas").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").addClass("modal-open");
			loadTableVerificadores();
			exportTable();
		});				
		
		$("#verificadoresModalMesas").on("click","#btn_frmaddverificadores",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
		})
		
		$("#verificadoresModalMesas").on('hidden.bs.modal', function(e){
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
		
		$("#verificadoresModalMesas").on("click","#btn_salirverificadores",function(e){
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

		/*Primer tab*/
		$("#frmVerficadoresMesas").on("click",".upverpat",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var PAT_Id = $(this).data("id")
			var PAT_Tipo = $(this).data("tip")
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
		
		$("#frmVerficadoresMesas").on("click",".doverpat",function(e){
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
		
		$("#frmVerficadoresMesas").on("click",".delverpat",function(e){
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
		
		$("#frmVerficadoresMesas").on("click",".rejectverpat",function(e){
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
		
		$("#frmVerficadoresMesas").on("click",".checkverpat",function(e){
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
				
		$("#frmVerficadoresMesas").on("click",".acceptverpat",function(e){
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
		
		/*Segundo tab*/
		$("#frmVerficadoresMesas").on("click",".upvergrp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip")
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
						formData.append("GRP_Id", GRP_Id);
						formData.append("GRP_Tipo", GRP_Tipo);
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
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-grupos",
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

		$("#frmVerficadoresMesas").on("click",".dovergrp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip");
			var PRY_Hito = $(this).data("hito")
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-grupos',			
				data:{GRP_Id:GRP_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',GRP_Tipo:GRP_Tipo},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,ENP_Id:GRP_Id};
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

		$("#frmVerficadoresMesas").on("click",".delvergrp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip");
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
						url: "/eliminar-verificador-grupos",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',GRP_Id:GRP_Id,GRP_Tipo:GRP_Tipo},						
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

		$("#frmVerficadoresMesas").on("click",".rejectvergrp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip");
			var PRY_Id = $(this).data("pry");
			var GRP_EstadoRechazado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-grupos-foclaes",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,GRP_Id:GRP_Id,GRP_Tipo:GRP_Tipo},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.GRP_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.GRP_EstadoRechazado=="0"){
								GRP_EstadoRechazado = 1;
								msg = "RECHAZADO";
							}else{
								GRP_EstadoRechazado = 0;
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
										url: "/estados-objetivos-grupos-focales",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,GRP_Id:GRP_Id,GRP_EstadoRechazado:GRP_EstadoRechazado,GRP_Tipo:GRP_Tipo},
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

		$("#frmVerficadoresMesas").on("click",".chkvergrp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip");
			var PRY_Id = $(this).data("pry");
			var GRP_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-grupos-foclaes",
				method: 'POST',					
				data:{PRY_Id:PRY_Id, GRP_Id:GRP_Id,GRP_Tipo:GRP_Tipo},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.GRP_EstadoRevisado=="0"){
							GRP_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							GRP_EstadoRevisado = 0;
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
									url: "/estados-objetivos-grupos-focales",
									method: 'POST',					
									data:{PRY_Id:PRY_Id, GRP_Id:GRP_Id,GRP_EstadoRevisado:GRP_EstadoRevisado,GRP_Tipo:GRP_Tipo},
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

		$("#frmVerficadoresMesas").on("click",".acceptvergrp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip");
			var PRY_Id = $(this).data("pry");
			var GRP_EstadoAprobado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-grupos-foclaes",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,GRP_Id:GRP_Id,GRP_Tipo:GRP_Tipo},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.GRP_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{						
							if(data.GRP_EstadoAprobado=="0"){
								GRP_EstadoAprobado = 1;
								msg = "APROBADO";
							}else{
								GRP_EstadoAprobado = 0;
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
										url: "/estados-objetivos-grupos-focales",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,GRP_Id:GRP_Id,GRP_EstadoAprobado:GRP_EstadoAprobado,GRP_Tipo:GRP_Tipo},
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

		/*Tercer Tab*/
		$("#frmVerficadoresMesas").on("click",".upvercoord",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id")
			var COO_Tipo = $(this).data("tip")
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
						formData.append("COO_Id", COO_Id);
						formData.append("COO_Tipo", COO_Tipo);						
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
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-coordinacion",
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
		
		$("#frmVerficadoresMesas").on("click",".dovercoord",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id")
			var COO_Tipo = $(this).data("tip")
			var PRY_Hito = $(this).data("hito")
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-coordinacion',
				data:{COO_Id:COO_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',COO_Tipo:COO_Tipo},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,ENP_Id:COO_Id};
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
		
		$("#frmVerficadoresMesas").on("click",".delvercoord",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id");
			var COO_Tipo = $(this).data("tip");
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
						url: "/eliminar-verificador-coordinacion",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',COO_Id:COO_Id,COO_Tipo:COO_Tipo},						
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
		
		$("#frmVerficadoresMesas").on("click",".rejectvercoord",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id");
			var COO_Tipo = $(this).data("tip");
			var PRY_Id = $(this).data("pry");
			var COO_EstadoRechazado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-coordinacion",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,COO_Id:COO_Id,COO_Tipo:COO_Tipo},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.COO_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{	
							if(data.COO_EstadoRechazado=="0"){
								COO_EstadoRechazado = 1;
								msg = "RECHAZADO";
							}else{
								COO_EstadoRechazado = 0;
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
										url: "/estados-objetivos-coordinacion",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,COO_Id:COO_Id,COO_EstadoRechazado:COO_EstadoRechazado,COO_Tipo:COO_Tipo},
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
		
		$("#frmVerficadoresMesas").on("click",".chkvercoord",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id");
			var COO_Tipo = $(this).data("tip");
			var PRY_Id = $(this).data("pry");
			var COO_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-coordinacion",
				method: 'POST',					
				data:{PRY_Id:PRY_Id, COO_Id:COO_Id,COO_Tipo:COO_Tipo},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.COO_EstadoRevisado=="0"){
							COO_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							COO_EstadoRevisado = 0;
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
									url: "/estados-objetivos-coordinacion",
									method: 'POST',					
									data:{PRY_Id:PRY_Id, COO_Id:COO_Id,COO_EstadoRevisado:COO_EstadoRevisado,COO_Tipo:COO_Tipo},
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
				
		$("#frmVerficadoresMesas").on("click",".acceptvercoord",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var COO_Id = $(this).data("id");
			var COO_Tipo = $(this).data("tip");
			var PRY_Id = $(this).data("pry");
			var COO_EstadoAprobado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-coordinacion",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,COO_Id:COO_Id,COO_Tipo:COO_Tipo},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.COO_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{						
							if(data.COO_EstadoAprobado=="0"){
								COO_EstadoAprobado = 1;
								msg = "APROBADO";
							}else{
								COO_EstadoAprobado = 0;
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
										url: "/estados-objetivos-coordinacion",
										method: 'POST',					
										data:{PRY_Id:PRY_Id,COO_Id:COO_Id,COO_EstadoAprobado:COO_EstadoAprobado,COO_Tipo:COO_Tipo},
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

		/*Cuarto Tab*/
		$("#frmVerficadoresMesas").on("click",".upverplncom",function(e){
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
		
		$("#frmVerficadoresMesas").on("click",".chkverplncom",function(e){
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

		$("#frmVerficadoresMesas").on("click",".acceptverplncom",function(e){
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
						if(data.COO_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{	
							if(data.PLC_EstadoRevisado=="0"){
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

		$("#frmVerficadoresMesas").on("click",".rejectverplncom",function(e){
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

		$("#frmVerficadoresMesas").on("click",".doverplncom",function(e){
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:122, ALU_Rut:ALU_Rut,ENP_Id:PLC_Id};
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

		$("#frmVerficadoresMesas").on("click",".delverplncom",function(e){
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

		/*Quinto Tab*/
		$("#frmVerficadoresMesas").on("click",".upverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id")
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
						formData.append("TED_Id", TED_Id);
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
										progressBar.show();
										element.css("cursor","not-allowed");
										element.removeClass("text-primary");
										element.removeClass("upverpat");
										element.addClass("text-white-50");
										progress.css("width",fileLoaded + "%")
									}, false);
									return xhr;
								},
								url: "/subir-verificador-plan-de-trabajo",
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

		$("#frmVerficadoresMesas").on("click",".chkverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var TED_EstadoRevisado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-de-trabajo",
				method: 'POST',					
				data:{PRY_Id:PRY_Id, TED_Id:TED_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();						
						if(data.TED_EstadoRevisado=="0"){
							TED_EstadoRevisado = 1;
							msg = "REVISADO";
						}else{
							TED_EstadoRevisado = 0;
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
									url: "/estados-plan-de-trabajo",
									method: 'POST',					
									data:{PRY_Id:PRY_Id, TED_Id:TED_Id,TED_EstadoRevisado:TED_EstadoRevisado},
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

		$("#frmVerficadoresMesas").on("click",".acceptverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var TED_EstadoAprobado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-de-trabajo",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,TED_Id:TED_Id},
				dataType: "json",
				success: function (data) {							
					if(data.state==200){						
						loadTableVerificadores();
						if(data.COO_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de ACEPTARLO'
							});
						}else{	
							if(data.TED_EstadoRevisado=="0"){
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:'Debes REVISAR el documento antes de ACEPTARLO'
								});
							}else{						
								if(data.TED_EstadoAprobado=="0"){
									TED_EstadoAprobado = 1;
									msg = "APROBADO";
								}else{
									TED_EstadoAprobado = 0;
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
											url: "/estados-plan-de-trabajo",
											method: 'POST',					
											data:{PRY_Id:PRY_Id,TED_Id:TED_Id,TED_EstadoAprobado:TED_EstadoAprobado},
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

		$("#frmVerficadoresMesas").on("click",".rejectverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id");
			var PRY_Id = $(this).data("pry");
			var TED_EstadoRechazado;
			var msg;
						
			$.ajax({
				url: "/consultar-estados-plan-de-trabajo",
				method: 'POST',					
				data:{PRY_Id:PRY_Id,TED_Id:TED_Id},
				dataType: "json",
				success: function (data) {
					if(data.state==200){						
						loadTableVerificadores();
						if(data.TED_EstadoRevisado=="0"){
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'ERROR!',
								text:'Debes REVISAR el documento antes de RECHAZARLO'
							});
						}else{								
							if(data.TED_EstadoRevisado=="0"){
								swalWithBootstrapButtons.fire({
									icon:'error',
									title:'ERROR!',
									text:'Debes REVISAR el documento antes de RECHAZARLO'
								});
							}else{	
								if(data.TED_EstadoRechazado=="0"){
									TED_EstadoRechazado = 1;
									msg = "RECHAZADO";
								}else{
									TED_EstadoRechazado = 0;
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
											url: "/estados-plan-de-trabajo",
											method: 'POST',					
											data:{PRY_Id:PRY_Id,TED_Id:TED_Id,TED_EstadoRechazado:TED_EstadoRechazado},
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

		$("#frmVerficadoresMesas").on("click",".doverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id")	
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-plan-de-trabajo',			
				data:{TED_Id:TED_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>'},
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
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:123, ALU_Rut:ALU_Rut,ENP_Id:TED_Id};
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

		$("#frmVerficadoresMesas").on("click",".delverplntra",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var TED_Id = $(this).data("id");
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
						url: "/eliminar-verificador-plan-de-trabajo",
						method: 'POST',					
						data:{PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',TED_Id:TED_Id},						
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
			var verificadoresMesas='';			
			var VER_SubidosPendientesMesas = VER_EstadoSubidoMesas - VER_EstadoRevisadoMesas			
			var VER_SinSubirMesas = VER_TotalMesas - VER_EstadoSubidoMesas			

			if(VER_SinSubirMesas>0){
				verificadoresMesas = "<span class='badge blue' style='font-size:9px;' title='Archivos pendientes de carga' data-toggle='tooltip'>" + VER_SinSubirMesas + "</span> "
			}
			if(VER_SubidosPendientesMesas>0){
				verificadoresMEsas = verificadoresMesas + "<span class='badge orange' style='font-size:9px;' title='Archivos pendientes de revisión' data-toggle='tooltip'>" + VER_SubidosPendientesMesas + "</span> "
			}
			if(VER_EstadoRechazadoMesas>0){
				verificadoresMesas = verificadoresMesas + "</span> <span class='badge red' style='font-size:9px;' title='Archivos rechazados' data-toggle='tooltip'>" + VER_EstadoRechazadoMesas + "</span>"
			}
			return verificadoresMesas
		}
		
		$("body").append("<button id='btn_modalverificadoresmesas' name='btn_modalverificadoresmesas' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalverificadoresmesas").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#verificadoresModalMesas").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalverificadoresmesas").click();		
		$("#btn_modalverificadoresmesas").remove();
	})
</script>