<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	GOB_Id=request("GOB_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmministerios="frmministerios"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-ministerios"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-ministerios"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmministerios=""
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
		set rs = cnn.Execute("exec spGobierno_Consultar " & GOB_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			GOB_Id                  = rs("GOB_Id")
			GOB_Rut                 = rs("GOB_Rut")
			GOB_NombreInstitucion 	= rs("GOB_NombreInstitucion")
			GOB_DirPaginaWeb        = rs("GOB_DirPaginaWeb")			
		end if		
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Ministerio</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmministerios" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmministerios%>" id="<%=frmministerios%>" class="needs-validation">
							<div class="row">																							
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(GOB_Rut<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="GOB_Rut" name="GOB_Rut" class="form-control" <%=disabled%> value="<%=GOB_Rut%>">
											<span class="select-bar"></span>
											<label for="GOB_Rut" class="<%=lblClass%>">ROL</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-10">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(GOB_NombreInstitucion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="GOB_NombreInstitucion" name="GOB_NombreInstitucion" class="form-control" <%=disabled%> value="<%=GOB_NombreInstitucion%>">
											<span class="select-bar"></span>
											<label for="GOB_NombreInstitucion" class="<%=lblClass%>">Nombre</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(GOB_DirPaginaWeb<>"") then
												lblClass="active"
											else
												lblClass=""
											end if
											if(mode="add" or mode="mod") then
												disabled=""
											end if%>
											<input type="url" id="GOB_DirPaginaWeb" name="GOB_DirPaginaWeb" class="form-control" <%=disabled%> value="<%=GOB_DirPaginaWeb%>">
											<span class="select-bar"></span>
											<label for="GOB_DirPaginaWeb" class="<%=lblClass%>">Página web</label>
										</div>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="GOB_Id" name="GOB_Id" value="<%=GOB_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmministerios-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmministerios" name="btn_frmministerios"><%=typeFrm%></button>
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
		
		$("#btn_frmministerios").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Ministerio agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Ministerio modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmministerios");			
			if($("#frmministerios").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmministerios").attr("action"),
					data: $("#frmministerios").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmministerios")[0].reset();
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