<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	TRE_Id=request("TRE_Id")	
	mode=request("mode")			
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmtramoetareo="frmtramoetareo"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-tramo-etareo"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-tramo-etareo"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmtramoetareo=""
		disabled="readonly"
		calendario=""
		typeFrm=""
		button=""
	end if
	
	if (session("ds5_usrperfil")>2) then
		ds = "disabled"
		lblSelect = "active"
	else
		if(mode="add") then
			ds="required"
		else
			ds = ""		
			lblSelect = ""
		end if
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
	
	if(mode="mod") then
		set rs = cnn.Execute("exec [spTramoEtario_Consultar] " & TRE_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then			
			TRE_Descripcion	= rs("TRE_Descripcion")			
			TRE_EdadDesde	= rs("TRE_EdadDesde")
			TRE_EdadHasta	= rs("TRE_EdadHasta")
			TRE_Estado		= rs("TRE_Estado")
		else
			TRE_Estado = 1
		end if		
		rs.Close				
	end if

	if(mode="mod") or (mode="vis") then
		if(TRE_Estado=1) then
			Estado="checked"
		else
			Estado=""		
		end if
	else
		TRE_Estado = 1
		Estado="checked"
	end if
	
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document" style="z-index: 1050">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Tramo Etareo</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmtramoetareo" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmtramoetareo%>" id="<%=frmtramoetareo%>" class="needs-validation">
							<div class="row">								
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(TRE_Descripcion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="TRE_Descripcion" name="TRE_Descripcion" class="form-control" <%=disabled%> value="<%=TRE_Descripcion%>">
											<span class="select-bar"></span>
											<label for="TRE_Descripcion" class="<%=lblClass%>">Descripción</label>
										</div>
									</div>
								</div>																
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(TRE_EdadDesde<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="TRE_EdadDesde" name="TRE_EdadDesde" class="form-control" <%=disabled%> value="<%=TRE_EdadDesde%>">
											<span class="select-bar"></span>
											<label for="TRE_EdadDesde" class="<%=lblClass%>">Edad Desde</label>
										</div>
									</div>
								</div>																
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(TRE_EdadHasta<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="TRE_EdadHasta" name="TRE_EdadHasta" class="form-control" <%=disabled%> value="<%=TRE_EdadHasta%>">
											<span class="select-bar"></span>
											<label for="TRE_EdadHasta" class="<%=lblClass%>">Edad Hasta</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-10">
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="TRE_Estado" class="switch__input" <%=Estado%>>
										<label for="TRE_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="TRE_Id" name="TRE_Id" value="<%=TRE_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmtramoetareo-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Festivo" id="btn_frmtramoetareo" name="btn_frmtramoetareo"><%=typeFrm%></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">					
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i> Salir</button>
				</div>					
			</div>		  
			<!--footer-->	
		</div>
	</div>

<script>    
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});	

	$(".calendario").datepicker({
		beforeShow: function(input, inst) {
			$(document).off('focusin.bs.modal');
		},
		onClose:function(){
			$(document).on('focusin.bs.modal');
		},
	});

	$(document).ready(function() {
		var ss = String.fromCharCode(47) + String.fromCharCode(47);		
		
		$("#btn_frmtramoetareo").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Tramo Etareo agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Tramo Etareo modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmtramoetareo");			
			if($("#frmtramoetareo").valid()){
				if($("#TRE_Estado").is(":checked")){
					var TRE_Estado = 1
				}else{
					var TRE_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmtramoetareo").attr("action"),
					data: $("#frmtramoetareo").serialize() + "&TRE_Estado=" + TRE_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmtramoetareo")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de Tramo Etareo Fallido',
								text:data.message
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){						
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del requerimiento',					
						});				
					}
				})
			}
		})				
	})
</script>