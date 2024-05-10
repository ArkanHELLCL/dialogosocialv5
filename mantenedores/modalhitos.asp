<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	TIM_Id=request("TIM_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmhitos="frmhitos"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-hitos"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-hitos"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmhitos=""
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
		set rs = cnn.Execute("exec spTipoMesa_Consultar " & TIM_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			TIM_Id		= rs("TIM_Id")
			TIM_NombreMesa	= rs("TIM_NombreMesa")
			TIM_RelatorObligatorio = rs("TIM_RelatorObligatorio")
			TIM_Estado = rs("TIM_Estado")
		end if
		if(TIM_RelatorObligatorio=1) then
			swTIM_RelatorObligatorio="checked"
		else
			swTIM_RelatorObligatorio=""
		end if
		if(TIM_Estado=1) then
			swTIM_Estado="checked"
		else
			swTIM_Estado=""		
		end if
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Hitos</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmhitos" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmhitos%>" id="<%=frmhitos%>" class="needs-validation">
							<div class="row align-items-center">																							
								<div class="col-sm-12 col-md-9 col-lg-9">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(TIM_NombreMesa<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="TIM_NombreMesa" name="TIM_NombreMesa" class="form-control" <%=disabled%> value="<%=TIM_NombreMesa%>">
											<span class="select-bar"></span>
											<label for="TIM_NombreMesa" class="<%=lblClass%>">Hito</label>
										</div>
									</div>
								</div>								
								<div class="col-sm-12 col-md-3 col-lg-3">
									<div class="switch">
										<input type="checkbox" id="TIM_RelatorObligatorio" class="switch__input" <%=swTIM_RelatorObligatorio%>>
										<label for="TIM_RelatorObligatorio" class="switch__label">Relator Obligatorio</label>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-10 col-lg-10">
								</div>								
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="switch LDAP">
										<input type="checkbox" id="TIM_Estado" class="switch__input" <%=swTIM_Estado%>>
										<label for="TIM_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="TIM_Id" name="TIM_Id" value="<%=TIM_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmhitos-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmhitos" name="btn_frmhitos"><%=typeFrm%></button>
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
	
	$(document).ready(function() {
		var ss = String.fromCharCode(47) + String.fromCharCode(47);		
		
		$("#btn_frmhitos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Hito agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Hito modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmhitos");			
			if($("#frmhitos").valid()){
				if($("#TIM_RelatorObligatorio").is(":checked")){
					var TIM_RelatorObligatorio = 1
				}else{
					var TIM_RelatorObligatorio = 0
				}
				
				if($("#TIM_Estado").is(":checked")){
					var TIM_Estado = 1
				}else{
					var TIM_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmhitos").attr("action"),
					data: $("#frmhitos").serialize() + '&TIM_RelatorObligatorio=' + TIM_RelatorObligatorio + '&TIM_Estado=' + TIM_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmhitos")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de Hito Fallido',
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