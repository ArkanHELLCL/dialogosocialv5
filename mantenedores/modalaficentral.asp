<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	ACE_Id=request("ACE_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmaficentral="frmaficentral"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-aficentral"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-aficentral"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmaficentral=""
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
		set rs = cnn.Execute("exec spAfiliacionCentral_Consultar " & ACE_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			ACE_Nombre	= rs("ACE_Nombre")
			ACE_Estado	= rs("ACE_Estado")			
		end if		
		rs.Close		
	end if	
	if(ACE_Estado=1) then
		Estado="checked"
	else
		Estado=""		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Afiliación Central</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmaficentral" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmaficentral%>" id="<%=frmaficentral%>" class="needs-validation">
							<div class="row">																							
								<div class="col-sm-12 col-md-12 col-lg-12">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(ACE_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="ACE_Nombre" name="ACE_Nombre" class="form-control" <%=disabled%> value="<%=ACE_Nombre%>">
											<span class="select-bar"></span>
											<label for="ACE_Nombre" class="<%=lblClass%>">Afiliación Central</label>
										</div>
									</div>
								</div>																
							</div>																					
							<div class="row">																
								<div class="col-sm-12 col-md-12 col-lg-10">
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="ACE_Estado" class="switch__input" <%=Estado%>>
										<label for="ACE_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="ACE_Id" name="ACE_Id" value="<%=ACE_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmaficentral-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmaficentral" name="btn_frmaficentral"><%=typeFrm%></button>
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
		
		$("#btn_frmaficentral").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Afiliación Central agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Afiliación Central modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmaficentral");			
			if($("#frmaficentral").valid()){
				if($("#ACE_Estado").is(":checked")){
					var ACE_Estado = 1
				}else{
					var ACE_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmaficentral").attr("action"),
					data: $("#frmaficentral").serialize() + "&ACE_Estado=" + ACE_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmaficentral")[0].reset();
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