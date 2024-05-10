<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	LLC_Id=request("LLC_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmlineaformativalicitacion="frmlineaformativalicitacion"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-lineaformativalicitacion"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-lineaformativalicitacion"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmlineaformativalicitacion=""
		disabled="readonly"
		calendario=""
		typeFrm=""
		button=""
	end if
	
	if (session("ds5_usrperfil")<>1) then
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
		set rs = cnn.Execute("exec splineaformativalicitacion_Consultar " & LLC_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			LLC_Id				= rs("LLC_Id")
			LFO_Id 				= rs("LFO_Id")			
			LLC_IdLicitacion	= rs("LLC_IdLicitacion")
			LLC_Estado			= rs("LLC_Estado")
		end if		
		rs.Close		
	end if	
	if(LLC_Estado=1) then
		Estado="checked"
	else
		Estado=""		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Línea Formativa / Licitación</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmlineaformativalicitacion" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmlineaformativalicitacion%>" id="<%=frmlineaformativalicitacion%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-8">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="LFO_Id" id="LFO_Id" class="select-text form-control" <%=ds%>><%
													if((LFO_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spLineaFormativa_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(LFO_Id = rs("LFO_Id")) then%>
															<option value="<%=rs("LFO_Id")%>" selected><%=rs("LFO_Nombre")%></option><%
														else%>
															<option value="<%=rs("LFO_Id")%>"><%=rs("LFO_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-tag input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Línea Formativa</label>
											</div>
										</div>
									</div>
								</div>								
								<div class="col-sm-12 col-md-12 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(LLC_IdLicitacion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="LLC_IdLicitacion" name="LLC_IdLicitacion" class="form-control" <%=disabled%> value="<%=LLC_IdLicitacion%>">
											<span class="select-bar"></span>
											<label for="LLC_IdLicitacion" class="<%=lblClass%>">Id Licitación</label>
										</div>
									</div>
								</div>								
							</div>							
							
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-10">
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="LLC_Estado" class="switch__input" <%=Estado%>>
										<label for="LLC_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="LLC_Id" name="LLC_Id" value="<%=LLC_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmlineaformativalicitacion-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa / Licitación" id="btn_frmlineaformativalicitacion" name="btn_frmlineaformativalicitacion"><%=typeFrm%></button>
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
		
		$("#btn_frmlineaformativalicitacion").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="lineaformativalicitacion agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="lineaformativalicitacion modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmlineaformativalicitacion");			
			if($("#frmlineaformativalicitacion").valid()){
				if($("#LLC_Estado").is(":checked")){
					var LLC_Estado = 1
				}else{
					var LLC_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmlineaformativalicitacion").attr("action"),
					data: $("#frmlineaformativalicitacion").serialize() + "&LLC_Estado=" + LLC_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmlineaformativalicitacion")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de usuario Fallido',
								text:data.message
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){						
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto',					
						});				
					}
				})
			}
		})				
	})
</script>