<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
			
	xm=splitruta(5)
		
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
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
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if	
	if(PRY_InformeSistematizacionEstado="" or IsNULL(PRY_InformeSistematizacionEstado)) then
		PRY_InformeSistematizacionEstado=0
	end if	
	if(LFO_Id=10 or LFO_Id=12) then
		PRY_InfFinal = PRY_InformeFinalEstado
	end if
	if(LFO_Id=11) then
		PRY_InfFinal = PRY_InformeSistematizacionEstado
	end if
	response.write("200\\#mediosgraficosModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-file-signature"></i> Medios Gráficos</div>				
			</div>
			<!--form-->
			<form id="mediosgraficosupload" class="fileupload" action="" method="POST" enctype="multipart/form-data" data-upload-template-id="template-upload-2" data-download-template-id="template-download-2">
				<div class="modal-body">			
					<div class="row px-4">
						<div class="col-sm-12 col-md-12 col-lg-12">									
							<noscript><input type="hidden" name="redirect" value=""></noscript>
							<%if(PRY_Estado=1 ) then%>
							<div class="row fileupload-buttonbar">
								<div class="col-lg-12"><%
									if ((PRY_InfFinal=0 and PRY_Estado=1) and (USR_IdRevisor=session("ds5_usrid") and session("ds5_usrperfil")=2) or ((PRY_InfFinal=0 and PRY_Estado=1) and (USR_IdEjecutor=session("ds5_usrid") and session("ds5_usrperfil")=3)) or (PRY_InfFinal=0 and PRY_Estado=1) and session("ds5_usrperfil")=1) then%>
										<span class="btn btn-rounded btn-sm waves-effect btn-success fileinput-button">
											<i class="glyphicon glyphicon-plus"></i>
											<span>Agregar archivos...</span>
											<input type="file" name="files[]" multiple accept="image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation, 	application/vnd.openxmlformats-officedocument.wordprocessingml.document, audio/mp4,video/mp4,application/mp4,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,video/quicktime,application/msword,application/vnd.ms-powerpoint,video/x-msvideo">
										</span>
										<button type="submit" class="btn btn-rounded btn-sm waves-effect btn-primary start">
											<i class="glyphicon glyphicon-upload"></i>
											<span>Subir archivos</span>
										</button>						
										<button type="reset" class="btn btn-rounded btn-sm waves-effect btn-warning cancel">
											<i class="glyphicon glyphicon-ban-circle"></i>
											<span>Cancelar subida</span>
										</button>						

										<button type="button" class="btn btn-rounded btn-sm waves-effect btn-danger delete">
											<i class="glyphicon glyphicon-trash"></i>
											<span>Borrar archivos</span>
										</button>						

										<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
											<label class="input-checkbox checkbox-lightBlue">
												<input type="checkbox" id="VPM_Comprometida" name="VPM_Comprometida" class="toggle">
												<span class="checkbox"></span>
											</label>
										</div><%
									end if%>
									
									<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />						<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />									
									<input type="hidden" id="USR_Id" name="USR_Id" value="<%=session("ds5_usrid")%>" />
									<input type="hidden" id="USR_Identificador" name="USR_Identificador" value="<%=session("ds5_usrtoken")%>" />
									<input type="hidden" id="PRY_Hito" name="PRY_Hito" value="99">
									<input type="hidden" id="TPO_Id" name="TPO_Id" value="1">
																												
									<!-- The global file processing state -->
									<span class="fileupload-process"></span>
								</div>
								<div class="col-lg-5 fileupload-progress fade">
									<div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
										<div class="progress-bar progress-bar-success" style="width:0%;"></div>
									</div>
									<div class="progress-extended">&nbsp;</div>
								</div>								
							</div>
							<%end if%>
							<table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>							
						</div>			
					</div>
					<div class="row">																	
						<div class="footer">				
							<button type="button" class="btn btn-danger btn-md waves-effect waves-dark" style="float:right;" data-dismiss="modal"><i class="fas fa-sign-out-alt"></i> Salir</button>
						</div>
					</div>				
				</div>
				<!--modal-body-->
			</form>
			<!--form-->
		</div>
		<!--modal-cotent-->
	</div>
	<!--modal-dialogo-->			

<script>
    var mediosgraficosTable;
	var tablamediosgraficosAlto;
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	$("#mediosgraficosModal").on('hidden.bs.modal', function(e){
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
	})
	
	$(document).ready(function() {		
		$("body").append("<button id='btn_modalmediosgraficos' name='btn_modalmediosgraficos' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalmediosgraficos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#mediosgraficosModal").modal("show");
			$("body").addClass("modal-open");
			$(".modal-open #mediosgraficosModal").mCustomScrollbar({
				theme:scrollTheme,
			})
				
		});
		$("#btn_modalmediosgraficos").click();		
		$("#btn_modalmediosgraficos").remove();
	})
</script>