<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	NUM_Id=request("NUM_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmnumeralmultas="frmnumeralmultas"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-numeralmultas"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-numeralmultas"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmnumeralmultas=""
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
		set rs = cnn.Execute("exec spNumeralMultas_Consultar " & NUM_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			NUM_Id					= rs("NUM_Id")
			NUM_NumeralMultas 		= replace(rs("NUM_NumeralMultas"),"\","")
			BAS_Id					= rs("BAS_Id")			
			BAS_NumResolucion 		= rs("BAS_NumResolucion")
			BAS_FechaTramitacion 	= rs("BAS_FechaTramitacion")			
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
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Numeral Multas</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmnumeralmultas" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmnumeralmultas%>" id="<%=frmnumeralmultas%>" class="needs-validation">
							<div class="row">								
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="BAS_Id" id="BAS_Id" class="select-text form-control" <%=ds%>><%
													if((BAS_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spBases_Listar -1")
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
							</div>
							<div class"row">
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
									<div class="md-form">
										<div class="error-message">																
											<textarea id="NUM_NumeralMultas" name="NUM_NumeralMultas" rows="10" required> <%=NUM_NumeralMultas%> </textarea>					
										</div>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="NUM_Id" name="NUM_Id" value="<%=NUM_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmnumeralmultas-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar numeralmultas" id="btn_frmnumeralmultas" name="btn_frmnumeralmultas"><%=typeFrm%></button>
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
		
		$("#NUM_NumeralMultas").jqte();
		
		$("#btn_frmnumeralmultas").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Numeral Multas agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Numeral Multas modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmnumeralmultas");			
			if($("#frmnumeralmultas").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmnumeralmultas").attr("action"),
					data: $("#frmnumeralmultas").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmnumeralmultas")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de Numeral Multa Fallido',
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