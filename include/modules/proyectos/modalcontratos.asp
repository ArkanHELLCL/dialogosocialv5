<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	if(session("ds5_usrperfil")=3) then	'Ejecutor
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		PRY_InformeSistematizacionAceptado = rs("PRY_InformeSistematizacionAceptado")

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
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
		if(PRY_InformeFinalAceptado="" or IsNULL(PRY_InformeFinalAceptado)) then
			PRY_InformeFinalAceptado=false
		end if
		if(PRY_InformeSistematizacionAceptado="" or IsNULL(PRY_InformeSistematizacionAceptado)) then
			PRY_InformeSistematizacionAceptado=false
		end if
	end if
	if(LFO_Id=10 or LFO_Id=12) then
		PRY_InfFinal = PRY_InformeFinalAceptado
	end if
	if(LFO_Id=11) then
		PRY_InfFinal = PRY_InformeSistematizacionAceptado
	end if
	if(PRY_InfFinal) then
		modo=4
		mode="vis"
		required="disabled readonly"
	else
		if(session("ds5_usrperfil")=4) then
			required="disabled readonly"
		else
			required="required"
			mode="mod"
		end if
	end if
	response.write("200\\#contratosModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-file-signature"></i> Contratos</div>				
			</div>
			<form role="form" action="" method="POST" name="frmcontratos" id="frmcontratos" class="form-signin needs-validation" enctype="multipart/form-data">			
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-tag input-prefix"></i><%
									if(PRY_IdLicitacion<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_IdLicitacion" name="PRY_IdLicitacion" class="form-control" readonly value="<%=PRY_IdLicitacion%>">
									<span class="select-bar"></span>
									<label for="PRY_IdLicitacion" class="<%=lblClass%>">ID Licitación</label>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-6">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-tag input-prefix"></i><%
									if(PRY_NombreLicitacion<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_NombreLicitacion" name="PRY_NombreLicitacion" class="form-control" readonly value="<%=PRY_NombreLicitacion%>">
									<span class="select-bar"></span>
									<label for="PRY_NombreLicitacion" class="<%=lblClass%>">Nombre Licitación</label>
								</div>
							</div>
						</div>

						<div class="col-sm-12 col-md-12 col-lg-6">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-funnel-dollar input-prefix"></i><%
									if(FON_Nombre<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="FON_Nombre" name="FON_Nombre" class="form-control" readonly value="<%=FON_Nombre%>">
									<span class="select-bar"></span>
									<label for="FON_Nombre" class="<%=lblClass%>">Ítem Presupuestario</label>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-6">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-tag input-prefix"></i><%
									if(PRY_NumResAprueba<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="number" id="PRY_NumResAprueba" name="PRY_NumResAprueba" class="form-control" <%=required%> value="<%=PRY_NumResAprueba%>">
									<span class="select-bar"></span>
									<label for="PRY_NumResAprueba" class="<%=lblClass%>">N° Res. que aprueba</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-12 col-lg-6">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-calendar input-prefix"></i><%
									if(PRY_FechaResolucion<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_FechaResolucion" name="PRY_FechaResolucion" class="form-control calendario" readonly <%=required%> value="<%=PRY_FechaResolucion%>">
									<span class="select-bar"></span>
									<label for="PRY_FechaResolucion" class="<%=lblClass%>">Fecha Resolución</label>
								</div>
							</div>
						</div>
					</div>
					<div class="row align-items-center">												
						<div class="col-sm-12 col-md-3 col-lg-6">
							<div class="md-form input-with-post-icon">
								<div class="error-message">														
									<i class="fas fa-cloud-upload-alt input-prefix"></i>
									<input type="text" id="PRY_AdjuntoX" name="PRY_AdjuntoX" class="form-control" <%=required%> readonly value="">
									<input type="file" id="PRY_Adjunto" name="PRY_Adjunto" readonly multiple size="5" accept="image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint">
									<span class="select-bar"></span>
									<label for="PRY_AdjuntoX" class="">Adjunto(s)</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-3 col-lg-6" style="text-align:right;">
							<div class="downloadFile">
								<i class="fas fa-cloud-download-alt fa-4x" data-toggle="tooltip" title="Ver adjuntos cargados"></i>
							</div>
						</div>
					</div>						

					<div class="row">																	
						<div class="footer"><%
							if (session("ds5_usrperfil")=5 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) and mode="mod" then%>
								<button type="button" class="btn btn-warning btn-md waves-effect waves-dark" id="btn_frmaddcontratos" name="btn_frmaddcontratos"><i class="fas fa-download"></i> Grabar</button><%
							end if%>							
							<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" style="float:right;" data-dismiss="modal"><i class="fas fa-sign-out-alt"></i> Salir</button>						
						</div>
					</div>

				</div>
				<!--modal-body-->
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
				<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
			</form>
			<!--form-->
		</div>
		<!--modal-cotent-->
	</div>
	<!--modal-dialogo-->

<script>
    var contratosTable;
	var tablacontratosAlto;
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
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);				
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		
		$("#contratosModal").on('show.bs.modal', function(e){			
				
		})

		$("#contratosModal").on('shown.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();	
			$("#PRY_AdjuntoX").click(function(e){
				e.preventDefault();
				e.stopImmediatePropagation();
				e.stopPropagation();	
				$("#PRY_Adjunto").click();
			})
			$("#PRY_Adjunto").change(function(click){
				click.preventDefault();
				click.stopImmediatePropagation();
				click.stopPropagation();
				var fakepath_1 = "C:" + ss + "fakepath" + ss
				var fakepath_2 = "C:" + bb + "fakepath" + bb
				var fakepath_3 = "C:" + s + "fakepath" + s
				var fakepath_4 = "C:" + b + "fakepath" + b												
				
				var cont = 0;
				$.each (this.files,function(e){					
					cont = cont +1;
				});
				$('#PRY_AdjuntoX').val("Archivo(s) adjunto(s) : " + cont);
			})
			$(".calendario").datepicker({
				beforeShow: function(input, inst) {
					$(document).off('focusin.bs.modal');
				},
				onClose:function(){
					$(document).on('focusin.bs.modal');
				},
			});
		});		

		$("#contratosModal").on('hidden.bs.modal', function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#contratosModal").empty();
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

		$("#contratosModal").on("click","#btn_frmaddcontratos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			formValidate("#frmcontratos");
			if($("#frmcontratos").valid()){				
				var formdata = new FormData();	  	  									
				var file_data = $('#PRY_Adjunto').prop('files');
				var sizerror=false;
				var sumsize=0;

				for (var i = 0; i < file_data.length; i++) {
					formdata.append(file_data[i].name, file_data[i]);
					if(file_data[i].size>parseInt(maxupload[maxsize].size)){
						sizerror=true;
					};
					sumsize=sumsize+file_data[i].size;
				};
				if(sumsize>parseInt(maxupload[maxsize].size)){
					sizerror=true;					
				}
				formdata.append("PRY_Id",$("#PRY_Id").val());
				formdata.append("PRY_Identificador",$("#PRY_Identificador").val());
				formdata.append("PRY_NumResAprueba",$("#PRY_NumResAprueba").val());
				formdata.append("PRY_FechaResolucion",$("#PRY_FechaResolucion").val());
				formdata.append("PRY_AdjuntoX",$("#PRY_AdjuntoX").val());
				
				if(sizerror){
					$("#PRY_AdjuntoX").removeClass("is-valid");
					$("#PRY_AdjuntoX").addClass("is-invalid");
					$("#PRY_AdjuntoX").siblings('.select-bar').removeClass("is-valid");
					$("#PRY_AdjuntoX").siblings('.select-bar').addClass("is-invalid");
					$("#PRY_AdjuntoX").parent().after('<div id="PRY_AdjuntoX-error" class="error invalid-feedback" style="padding-left: 0rem; display: block;">'+ maxupload[maxsize]['msg-invalid'] +'</div>');
					Toast.fire({
						icon: 'error',
						title: maxupload[maxsize]['msg-toast']
					});	
				}else{
					$.ajax( {
						type:'POST',
						enctype: $(this).attr('enctype'),
						cache: false,
						contentType: false,
						processData: false,
						url: '/agrega-contratos',					
						data: formdata,
						dataType: "json",
						success: function ( data ) {						
							if(data.state=="200"){							
								Toast.fire({
									icon: 'success',
									title: 'Contrato agregado correctamente!'
								});			
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude grabar datos del contratoo',
									text: data.data
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
				};
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen datos de contratos sin agregar!'
				});			
			}
		})	  		
		
		$(".downloadFile").click(function(){
			ajax_icon_handling('load','Buscando archivos de contratos','','');
				$.ajax({
					type: 'POST',								
					url:'/listar-contratos',			
					data:data,
					success: function(data) {
						var param=data.split(sas);						
						if(param[0]=="200"){				
							ajax_icon_handling(true,'Listado de archivos de contratos creado.','',param[1]);
							$(".swal2-popup").css("width","60rem");
							loadtables("#tbl-presupuestos");
							$(".arcalm").click(function(){
								var INF_Arc = $(this).data("file");
								var PRY_Hito= $(this).data("hito");
								var PRY_Id  = $("#PRY_Id").val();
								var PRY_Identificador  = $("#PRY_Identificador").val();
								var data={PRY_Id:PRY_Id, PRY_Identificador:PRY_Identificador,PRY_Hito:100,INF_Arc:INF_Arc};								
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
							ajax_icon_handling(false,'No fue posible crear el listado de archivos.','','');
						}						
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						ajax_icon_handling(false,'No fue posible crear el listado de archivos.','','');	
					},
					complete: function(){																		
					}
				})
		})
		
		
		$("body").append("<button id='btn_modalcontratos' name='btn_modalcontratos' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalcontratos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#contratosModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalcontratos").click();		
		$("#btn_modalcontratos").remove();
	})
</script>