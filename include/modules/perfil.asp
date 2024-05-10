<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="session.min.inc" -->
<!-- #INCLUDE FILE="functions.inc" -->
<%=response.write("200/@/")%>
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End
	end if	
				
	'Mensajes nuevos
	sql="exec spUsuarioMensajeUsuarioHeadNuevo_Contar " & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs=cnn.execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503/@/Error Conexión:" & ErrMsg)
		cnn.close 			   
		Response.end
	End If
	if not rs.eof then
		mennuevos=rs("MensajeUsuarioNuevos")
	end if
	'Respuestas nuevas
	sql="exec spUsuarioMensajeUsuarioRespuestaNuevo_Contar " & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs=cnn.execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503/@/Error Conexión:" & ErrMsg)
		cnn.close 			   
		Response.end
	End If
	if not rs.eof then
		resnuevos=rs("MensajeRespuestaProyectosNuevos")
	end if
	perfil=lcase(replace(session("ds5_usrpernom")," ","_"))
%>
<div class="btn-toolbar" role="toolbar" style="float:right;">
	<div class="perfil"><%		
		style=""		
		if mennuevos>0 then
			style="margin-left: 20px;"%>
			<span class="badge left red"><%=mennuevos%></span><%							
		end if
		if resnuevos>0 then
			if mennuevos>0 then
				style="margin-left: 40px;"
			else
				style="margin-left: 20px;"
			end if%>
			<span class="badge right blue"><%=resnuevos%></span><%
		end if%>
		<span class="user"><%response.write(session("ds5_usrnom"))%></span><img src="/foto/<%response.write(session("ds5_usuario"))%>" class="imgPerfil" />		
		<span class="desperfil" style="<%=style%>"><%response.write(session("ds5_usrpernom"))%><%=jefe%><%=vista%></span>
		<span class="desdepartamento" style="<%=style%>"><%response.write(abreviar(session("ds5_usrdepcorta")))%></span>				
	</div>	  	
	<div class="content-perfil">
		<ul class="menuperfil">
			<li data-toggle="modal" data-target="#misMensajesModal"><i class="fas fa-comments"></i> Mis mensajes<%
				if mennuevos>0 then%>
					<span class="badge left red"><%=mennuevos%></span><%							
				end if
				if resnuevos>0 then%>
					<span class="badge right blue"><%=resnuevos%></span><%
				end if%>					
			</li><%
			if session("ds5_usrldap")="" or session("ds5_usrldap")<>1 or ISNULL(session("ds5_usrldap")) then%>
				<li data-toggle="modal" data-target="#camPassModal"><i class="fas fa-key"></i> Cambiar clave</li><%
			end if%>
			<li data-url="salir" class="text-danger"><i class="fas fa-power-off"></i> Cerrar sesión</li>
		</ul>
	</div>
</div>

<%if(session("ds5_usrldap"))<>1 or ISNULL(session("ds5_usrldap")) then%>
<!-- Modal Cambio de Clave-->
<div class="modal fade in" id="camPassModal" tabindex="-1" role="dialog" aria-labelledby="camPassModalLabel" aria-hidden="true">
	<div class="modal-dialog cascading-modal narrower" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-key"></i> Cambia tu Clave</div>        
      		</div>
	  		<form role="form" action="/cambia-contrasena" method="POST" name="cam-pass" id="cam-pass" class="form-signin needs-validation">			
      			<div class="modal-body">        			
					
					<div class="md-form" style="text-align:initial;">
						<div class="error-message input-field">						
							<i class="material-icons prefix">vpn_key</i>
							<i class="far fa-eye-slash viewpass" data-key="#usr_pass2"></i>
							<input type="password" id="usr_pass2" name="usr_pass2" class="form-control validate" required>
							<span class="select-bar"></span>
							<label for="usr_pass2">Clave Actual</label>							
						</div>						
					</div>		
					
					<div class="md-form" style="text-align:initial;">
						<div class="error-message input-field">						
							<i class="material-icons prefix">vpn_key</i>
							<i class="far fa-eye-slash viewpass" data-key="#inputPassword"></i>
							<input type="password" id="inputPassword" name="inputPassword" class="form-control validate" required>
							<span class="select-bar"></span>
							<label for="inputPassword">Nueva Clave</label>							
						</div>						
					</div>							

					<div class="md-form" style="text-align:initial;">
						<div class="error-message input-field">						
							<i class="material-icons prefix">vpn_key</i>
							<i class="far fa-eye-slash viewpass" data-key="#inputPasswordConfirm"></i>
							<input type="password" id="inputPasswordConfirm" name="inputPasswordConfirm" class="form-control validate" required>
							<span class="select-bar"></span>
							<label for="inputPasswordConfirm">Repetir Clave</label>							
						</div>						
					</div>
				
		  		</div>
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="submit" class="btn btn-primary btn-md waves-effect" id="btn_campas"><i class="fas fa-download"></i> Grabar</button>
				</div>		  
			</form>	
    	</div>
  	</div>
</div>
<!-- Modal Cambio de Clave-->
<%end if%>

<!-- Modal Mis Mensajes-->
<div class="modal fade bottom" id="misMensajesModal" tabindex="-1" role="dialog" aria-labelledby="misMensajesModalLabel" aria-hidden="true">
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Mis Mensajes</div>				
      		</div>
	  		<form role="form" action="" method="POST" name="mis-mess" id="mis-mess" class="form-signin needs-validation">			
      			<div class="modal-body" style="padding:0px;">					
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
						<div class="px-4">
							<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-1">
								<!--Table-->
								<table id="tbl-mismensajes" class="table table-striped table-bordered table-sm no-hover" cellspacing="0" width="100%" data-id="mismensajes" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
									<thead>										
											<th>&nbsp;</th>
											<th>id</th>	
											<th>Remitente</th>
											<th>Destinatario</th>											
											<th>Mensaje</th>
											<th>Fecha</th>
											<th>R</th>
											<th class="no-sort">&nbsp;</th>
										</tr>
									</thead> 
									<tbody><%
										set rs = cnn.Execute("exec spMensajeUsuario_Listar " & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
										on error resume next
										if cnn.Errors.Count > 0 then 
											ErrMsg = cnn.Errors(0).description
											cnn.close 			   
											response.end
										End If	
										cont=1
										data = "["
										do While Not rs.EOF
											data = data & "{""MEN_Id"":""" & rs("MEN_Id") & """,""MEN_Corr"":""" & rs("MEN_Corr")  & """,""USR_Nombre"":""" & rs("USR_Nombre") & " " & rs("USR_Apellido") & """,""USR_NombreDestinatario"":""" & rs("USR_NombreDestinatario") & " " & rs("USR_ApellidoDestinatario") & """,""TIP_Mensaje"":""" & rs("TIP_Mensaje") & """,""MEN_Texto"":""" & rs("MEN_Texto") & """,""MEN_Fecha"":""" & rs("MEN_Fecha") & """,""R"":""" & rs("MaxCorrelativo") & """,""RES"":"" <i class='fas fa-reply resp text-primary' data-id='" & rs("MEN_Id") & "' data-toggle='tooltip' title='Responder mensaje'></i> """
											
											data = data & "}"											
											rs.movenext
											if not rs.eof then
												data = data & ","
											end if
										loop
										data=data & "]"%>
									</tbody>
								</table>
							</div>
						</div>							
					</div>									
		  		</div>
		  		<div class="modal-footer">
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-success btn-md waves-effect" type="button" data-url="" data-toggle="modal" data-target="#nuevoMensajeModal" title="Crear nuevo mensaje" id="btn_creaconsulta" name="btn_creaconsulta"><i class="fas fa-plus ml-1"></i></button>
					</div>
				
					<div style="float:right;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-default Export btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla"><i class="fas fa-download ml-1"></i></button>
						<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
					</div>					
		  		</div>		  
			</form>	
    	</div>
  	</div>
</div>
<!-- Modal Mis Mensajes-->

<!-- Formulario para crear un nuevo mensaje -->
<div class="modal fade in" id="nuevoMensajeModal" tabindex="-1" role="dialog" aria-labelledby="nuevoMensajeModalLabel" aria-hidden="true">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Ingresa tu consulta</div>				
      		</div>
			<form role="form" action="" method="POST" name="frmcreamensaje" id="frmcreamensaje" class="needs-validation">
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select">
										<select name="USR_Id" id="USR_Id" class="validate select-text form-control" required>
											<option value="" disabled selected></option><%
											set rx = cnn.Execute("exec spPerfil_Listar 1")
											on error resume next	
											do while not rx.eof%>
												<optgroup label="<%=rx("PER_Nombre")%>"><%
												set rs = cnn.Execute("exec spMensajeDestinatario_Listar " & session("ds5_usrid") & "," & rx("PER_Id") )
												on error resume next					
												do While Not rs.eof 
													if rs("USR_Id")<>session("ds5_usrid") then%>							
														<option value="<%=rs("USR_Id")%>"><%=rs("USR_Nombre") & " " & rs("USR_Apellido")%></option><%
													end if
													rs.movenext						
												loop%>
												</optgroup><%
												rx.movenext
											loop
											rx.close
											rs.Close	
											cnn.Close%>
										</select>
										<i class="fas fa-user input-prefix"></i>
										<span class="select-highlight"></span>
										<span class="select-bar"></span>
										<label class="select-label">Destinatario</label>
									</div>
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form">
								<div class="error-message">								
									<i class="fas fa-comment prefix"></i>										
									<textarea id="MEN_Texto" name="MEN_Texto" class="md-textarea form-control" rows="3" required></textarea>
									<span class="select-bar"></span>
									<label for="MEN_Texto" class="">Mensaje</label>									
								</div>
							</div>
						</div>					
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" class="btn btn-primary btn-md waves-effect" id="btn_creamsj" name="btn_creamsj"><i class="fas fa-paper-plane"></i> Enviar</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Formulario para crear un nuevo mensaje -->

<!-- Formulario pra responder a una consulta -->
<div class="modal fade in" id="nuevaRespuestaModal" tabindex="-1" role="dialog" aria-labelledby="nuevaRespuestaModalLabel" aria-hidden="true">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Ingresa tu respuesta</div>				
      		</div>
			<form role="form" action="" method="POST" name="frmcrearespuesta" id="frmcrearespuesta" class="needs-validation">
				<div class="modal-body">
					<div class="row">					
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form">
								<div class="error-message">								
									<i class="fas fa-comment prefix"></i>										
									<textarea id="MEN_Texto" name="MEN_Texto" class="md-textarea form-control" rows="3" required></textarea>
									<span class="select-bar"></span>
									<label for="MEN_Texto" class="">Mensaje</label>
								</div>						
							</div>	
						</div>					
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" id="btn_respuesta" name="btn_respuesta" class="btn btn-primary btn-md waves-effect"><i class="fas fa-paper-plane"></i> Responder</button>
				</div>
				<input type="hidden" id="MEN_Id" value="" name="MEN_Id">
			</form>
		</div>
	</div>
</div>
<!-- Formulario pra responder a una consulta -->

<script>
var tablaRES={};
$(document).ready(function() {	
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	if(darkmode()){
		$(".waves-effect").removeClass("waves-light");
		$(".waves-effect").addClass("waves-dark");
	}else{
		$(".waves-effect").addClass("waves-light");
		$(".waves-effect").removeClass("waves-dark");
	};
	formValidate("#cam-pass");	
	$(".viewpass").mousedown(function(){		
		event.preventDefault();
		key=$(this).data("key");
        $(key).attr('type', 'text');
		$(this).removeClass("fa-eye-slash");
		$(this).addClass("fa-eye");
	}).mouseup(function(){
		event.preventDefault();        
		$('#usr_pass2').attr('type', 'password');
		$('#inputPassword').attr('type', 'password');
		$('#inputPasswordConfirm').attr('type', 'password');
		$(this).addClass("fa-eye-slash");
		$(this).removeClass("fa-eye");
	});
	$("html").mouseup(function(){
		event.preventDefault();        
		$('#usr_pass2').attr('type', 'password');
		$('#inputPassword').attr('type', 'password');
		$('#inputPasswordConfirm').attr('type', 'password');
		$(".viewpass").addClass("fa-eye-slash");
		$(".viewpass").removeClass("fa-eye");
	});
	$("#camPassModal").on('hidden.bs.modal', function(){
		$("#cam-pass")[0].reset();
	});
	$("#misMensajesModal").on('shown.bs.modal', function(e) {
		e.preventDefault();
		e.stopImmediatePropagation();
		e.stopPropagation();
			
		$("#tbl-mismensajes").parent().css("overflow-y","auto");
		$("#tbl-mismensajes").parent().css("overflow-x","hidden");
		$("#tbl-mismensajes").parent().css("max-height","500px");
        
		$(".perfil span.badge").remove();
		$(".Export").click(function(e){
			e.preventDefault();
			e.stopPropagation();
			idTable = "mismensajes"
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
					$.get("/mis-preguntas-y-respuestas", function(html) {
						var param=html.split("//");									
						if(param[0]=="200"){
							var tableRes = $(param[1]);
							/*console.log(tableRes);*/
							tableRes.exporttocsv({
								fileName  : result.value,
								separator : ';',
								table	  : 'ndt'
							});
						}else{												
						}										
					});							
				}

			});			
		})
    });
	$("#nuevoMensajeModal").on('shown.bs.modal', function() {
		formValidate("#frmcreamensaje");
	});
	$("#nuevoMensajeModal").on('hidden.bs.modal', function() {
		$("#frmcreamensaje")[0].reset();
	});	
	$("body").on("click", "#btn_creamsj",function(){
		if($("#frmcreamensaje").valid()){
			$.ajax( {
				type:'POST',					
				url: '/enviar-mensaje-usuario',
				data: $("#frmcreamensaje").serialize(),
				success: function ( data ) {
					param = data.split("//")
					if(param[0]==200){						
						messageTable.rows.add([jQuery.parseJSON(param[1])]).draw()						
						$("#nuevoMensajeModal").modal("hide")						
						swalWithBootstrapButtons.fire({
							icon:'success',								
							title: 'Consulta enviada'
						});														
													
					}            
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude enviar tu respuesta',							
					});				
				}
			});
		}
	});
			
	var tr,row,xdata;
	$("body").on("click", ".resp",function(){		
		tr = $(this).closest('tr');		
		$("#nuevaRespuestaModal").modal("show")
	});
	$("body").on("click", "#btn_respuesta",function(){
		if($("#frmcrearespuesta").valid()){				
			$.ajax( {
				type:'POST',					
				url: '/responder-usuario',
				data: $("#frmcrearespuesta").serialize(),
				success: function ( data ) {
					param = data.split("//")
					if(param[0]==200){						
						$.each(messageTable.data(),function(i,e){							
							if($(this)[0].MEN_Id==$(MEN_Id).val()){																
								messageTable.cell({row:i,column:6}).data(parseInt($(this)[0].R) + 1);
							}							
						});						
						$("#nuevaRespuestaModal").modal("hide")
						swalWithBootstrapButtons.fire({
							icon:'success',								
							title: 'Respuesta enviada',
						});														
						row.child(formatRespuesta(xdata)).show();
						tr.addClass('shown');
						$('div.slider', row.child()).slideDown();							
					}            
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude enviar tu respuesta',							
					});					
				}
			});
		}
	});
	$("#nuevaRespuestaModal").on('show.bs.modal', function() {
		row = messageTable.row(tr);
		xdata = row.data();
		if(xdata!=undefined){
			var MEN_Id = xdata.MEN_Id;
			$("#nuevaRespuestaModal").find("#MEN_Id").val(MEN_Id);
		}else{
			/*console.log("xdata no definido");*/
		}
		
	});
	$("#nuevaRespuestaModal").on('shown.bs.modal', function() {
		formValidate("#frmcrearespuesta");
	});
	$("#nuevaRespuestaModal").on('hidden.bs.modal', function() {
		$("#frmcrearespuesta")[0].reset();
	});
	$(".child").click(function(){
		var key=".MEN-" + $(this).data("key")
		$(key).toggle();
	})
	
	//Carga de tabla con respuestas
	var iTermGPACounter = 1;	
	var messageTable;
	
	loadDetailsByCourse();
	
	function loadDetailsByCourse() {
		if ( $.fn.DataTable.isDataTable( '#tbl-mismensajes' ) ) {
			$("#tbl-mismensajes").dataTable().fnDestroy();
		}
		messageTable = $('#tbl-mismensajes').DataTable({
			sDom: 'l<"tbl-toolbar preguntas">frtip',
			lengthMenu: [ 5,10,20 ],
			data:<%=data%>,
			columnDefs: [ {
			  targets  : 'no-sort',
			  orderable: false,
			}],
			columns: [{
				className: 'term-details-control',
				orderable: false,
				data: null,
				defaultContent: '<i class="fas fa-chevron-down mas text-secondary" data-toggle="tooltip" title="Ver respuestas"></i>'
			},{
				data: "MEN_Id"
			},{ 
				data: "USR_Nombre"
			},{
				data: "USR_NombreDestinatario"
			},{
				data: "MEN_Texto"
			},{
				data: "MEN_Fecha"
			},{
				data: "R"
			},{
				data: "RES"
			}],
			order: [
				[1, 'desc']
			]			
		});
		$("div.tbl-toolbar.preguntas").html('<b>Mis Preguntas</b>');
		
		// Add event listener for opening and closing details
	  	$('#tbl-mismensajes tbody').on('click', 'td.term-details-control', function() {
			var tr = $(this).closest('tr');
			var row = messageTable.row(tr);
			var id = row.data().MEN_Id
			var r = row.data().R			
			if(parseInt(r)>0){
				if (row.child.isShown()) {
				  // This row is already open - close it
				  $('div.slider', row.child()).slideUp( function () {
					 row.child.hide();
					 tr.removeClass('shown');				 
				  } );
				  $(this).parent().find(".mas").toggleClass("collapsed")

				} else {
				  // Open this row			  
				  row.child(formatRespuesta(row.data(),"tbl-menRES_" + iTermGPACounter )).show();
				  tr.addClass('shown');
				  $('div.slider', row.child()).slideDown();			  
				  $(this).parent().find(".mas").toggleClass("collapsed")				 			  
				  
				  iTermGPACounter += 1;						 
				}
			}
	  	});
	  }	  
});	

function formatRespuesta(rowData,table_id) {	
	var div = $('<div class="slider"/>')
        .addClass( 'loading' )
        .text( 'Loading...' );
 	
    $.ajax( {
		type:'POST',
        url: '/mis-respuestas',
        data: {MEN_Id: rowData.MEN_Id,table: table_id},        
        success: function ( data ) {
			param = data.split("//")
			if(param[0]==200){
				div
					.html( param[1] )
					.removeClass( 'loading' );
					if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
						$("#" + table_id).dataTable().fnDestroy();
					}
					$("#" + table_id).DataTable({					 	
						sDom: 'l<"tbl-toolbar respuestas">frtip',						
						lengthMenu: [ 4, 6, 10 ],
						order: [[ 0, 'desc' ]]
					});
				$("div.tbl-toolbar.respuestas").html('<b>Mis Respuestas</b>');
			}            
        },
		error: function(XMLHttpRequest, textStatus, errorThrown){				

		}
    } );
 
    return div;
}
</script>