<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	INC_Id=request("INC_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmincumplimiento="frmincumplimiento"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-incumplimiento"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-incumplimiento"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmincumplimiento=""
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
		set rs = cnn.Execute("exec [spIncumplimientos_Consultar] " & INC_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			INC_Id				= rs("INC_Id")
			INC_Incumplimiento	= replace(rs("INC_Incumplimiento"),"\","")
			INC_Monto			= rs("INC_Monto")	
			MON_Id				= rs("MON_Id")
			GRA_Id				= rs("GRA_Id")
			UME_Id				= rs("UME_Id")
			BAS_Id				= rs("BAS_Id")		
			INC_Estado			= rs("INC_Estado")			
		end if		
		rs.Close		
	end if	
	if(INC_Estado=1) then
		Estado="checked"
	else
		Estado=""		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Incumplimientos</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmincumplimiento" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmincumplimiento%>" id="<%=frmincumplimiento%>" class="needs-validation">
							<div class="row">																							
								<div class="col-sm-12 col-md-12 col-lg-12">									
									<div class="md-form">
										<div class="error-message">																
											<textarea id="INC_Incumplimiento" name="INC_Incumplimiento" rows="10" required> <%=INC_Incumplimiento%> </textarea>				
										</div>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-dollar-sign input-prefix"></i><%
											if(INC_Monto<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="INC_Monto" name="INC_Monto" class="form-control" <%=disabled%> value="<%=INC_Monto%>">
											<span class="select-bar"></span>
											<label for="INC_Monto" class="<%=lblClass%>">Monto</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="MON_Id" id="MON_Id" class="select-text form-control" <%=ds%>><%
													if((MON_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spMoneda_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(MON_Id = rs("MON_Id")) then%>
															<option value="<%=rs("MON_Id")%>" selected><%=rs("MON_Descripcion")%></option><%
														else%>
															<option value="<%=rs("MON_Id")%>"><%=rs("MON_Descripcion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-dollar-sign input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Tipo Moneda</label>
											</div>
										</div>
									</div>
								</div>									
							
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="GRA_Id" id="GRA_Id" class="select-text form-control" <%=ds%>><%
													if((GRA_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spGravedadIncumplimiento_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(GRA_Id = rs("GRA_Id")) then%>
															<option value="<%=rs("GRA_Id")%>" selected><%=rs("GRA_Descripcion")%></option><%
														else%>
															<option value="<%=rs("GRA_Id")%>"><%=rs("GRA_Descripcion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-procedures input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Gravedad</label>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="UME_Id" id="UME_Id" class="select-text form-control" <%=ds%>><%
													if((UME_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec [spUnidadMedida_Listar] -1")
													on error resume next					
													do While Not rs.eof
														if(UME_Id = rs("UME_Id")) then%>
															<option value="<%=rs("UME_Id")%>" selected><%=rs("UME_Descripcion")%></option><%
														else%>
															<option value="<%=rs("UME_Id")%>"><%=rs("UME_Descripcion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-ruler-horizontal input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Unidad de Medida</label>
											</div>
										</div>
									</div>
								</div>								
							</div>
							<div class="row align-items-center">
								<div class="col-sm-12 col-md-10 col-lg-10">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="BAS_Id" id="BAS_Id" class="select-text form-control" <%=ds%>><%
													if((BAS_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec [spBases_Listar] -1")
													on error resume next					
													do While Not rs.eof
														if(BAS_Id = rs("BAS_Id")) then%>
															<option value="<%=rs("BAS_Id")%>" selected><%=rs("BAS_NombreBases")%></option><%
														else%>
															<option value="<%=rs("BAS_Id")%>"><%=rs("BAS_NombreBases")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-tag input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Bases</label>
											</div>
										</div>
									</div>
								</div>							
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="INC_Estado" class="switch__input" <%=Estado%>>
										<label for="INC_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="INC_Id" name="INC_Id" value="<%=INC_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmincumplimiento-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar incumplimiento" id="btn_frmincumplimiento" name="btn_frmincumplimiento"><%=typeFrm%></button>
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
		
		$("#INC_Incumplimiento").jqte();
		
		$("#btn_frmincumplimiento").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="incumplimiento agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="incumplimiento modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmincumplimiento");			
			if($("#frmincumplimiento").valid()){
				if($("#INC_Estado").is(":checked")){
					var INC_Estado = 1
				}else{
					var INC_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmincumplimiento").attr("action"),
					data: $("#frmincumplimiento").serialize() + "&INC_Estado=" + INC_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmincumplimiento")[0].reset();
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