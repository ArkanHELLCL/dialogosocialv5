<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	BAS_Id=request("BAS_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmbases="frmbases"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-bases"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-bases"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmbases=""
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
		set rs = cnn.Execute("exec spBases_Consultar " & BAS_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			BAS_Id					= rs("BAS_Id")
			BAS_NombreBases 		= rs("BAS_NombreBases")
			BAS_NumResolucion 		= rs("BAS_NumResolucion")
			BAS_FechaTramitacion 	= rs("BAS_FechaTramitacion")
			BAS_Estado				= rs("BAS_Estado")
		end if		
		rs.Close		
	end if	
	if(BAS_Estado=1) then
		Estado="checked"
	else
		Estado=""		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Bases</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmbases" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmbases%>" id="<%=frmbases%>" class="needs-validation">
							<div class="row">																							
								<div class="col-sm-12 col-md-8 col-lg-8">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(BAS_NombreBases<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="BAS_NombreBases" name="BAS_NombreBases" class="form-control" <%=disabled%> value="<%=BAS_NombreBases%>">
											<span class="select-bar"></span>
											<label for="BAS_NombreBases" class="<%=lblClass%>">Nombre</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-file-contract input-prefix"></i><%
											if(BAS_NumResolucion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="BAS_NumResolucion" name="BAS_NumResolucion" class="form-control" <%=disabled%> value="<%=BAS_NumResolucion%>">
											<span class="select-bar"></span>
											<label for="BAS_NumResolucion" class="<%=lblClass%>">Resolución</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-calendar input-prefix"></i><%
											if(BAS_FechaTramitacion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="BAS_FechaTramitacion" name="BAS_FechaTramitacion" class="form-control calendario" <%=disabled%> readonly value="<%=BAS_FechaTramitacion%>">
											<span class="select-bar"></span>
											<label for="BAS_FechaTramitacion" class="<%=lblClass%>">Tramitación</label>
										</div>
									</div>
								</div>
							</div>							
							
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-10">
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="BAS_Estado" class="switch__input" <%=Estado%>>
										<label for="BAS_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="BAS_Id" name="BAS_Id" value="<%=BAS_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmbases-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Bases" id="btn_frmbases" name="btn_frmbases"><%=typeFrm%></button>
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
		
		$("#btn_frmbases").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Bases agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Bases modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmbases");			
			if($("#frmbases").valid()){
				if($("#BAS_Estado").is(":checked")){
					var BAS_Estado = 1
				}else{
					var BAS_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmbases").attr("action"),
					data: $("#frmbases").serialize() + "&BAS_Estado=" + BAS_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmbases")[0].reset();
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