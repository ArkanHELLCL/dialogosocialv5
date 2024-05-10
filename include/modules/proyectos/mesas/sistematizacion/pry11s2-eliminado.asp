<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="mod"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		calendario="calendario"
		action="/mod-11-h3-s2"
	end if
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"

		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""		
	end if
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		mode="vis"
		modo=4
		disabled="readonly disabled"		
	end if			
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
		
	lblClass=""
	if(mode="mod" or mode="vis") then		
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if
		if not rs.eof then	
			PRY_Identificador=rs("PRY_Identificador")
			LIN_Id=rs("LIN_Id")
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")			
			PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")
			PRY_Estado=rs("PRY_Estado")
			
			PRY_BenDirectosHombres=rs("PRY_BenDirectosHombres")
			PRY_BenDirectosMujeres=rs("PRY_BenDirectosMujeres")			
			
			PRY_SinBenIndirectosHombres=rs("PRY_SinBenIndirectosHombres")
			PRY_SinBenIndirectosMujeres=rs("PRY_SinBenIndirectosMujeres")
			
			PRY_EmpBenDirectosHombres=rs("PRY_EmpBenDirectosHombres")
			PRY_EmpBenDirectosMujeres=rs("PRY_EmpBenDirectosMujeres")
			
			PRY_EmpBenIndirectosHombres=rs("PRY_EmpBenIndirectosHombres")
			PRY_EmpBenIndirectosMujeres=rs("PRY_EmpBenIndirectosMujeres")
			
			PRY_GobBenDirectosHombres=rs("PRY_GobBenDirectosHombres")
			PRY_GobBenDirectosMujeres=rs("PRY_GobBenDirectosMujeres")
			
			PRY_GobBenIndirectosHombres=rs("PRY_GobBenIndirectosHombres")
			PRY_GobBenIndirectosMujeres=rs("PRY_GobBenIndirectosMujeres")
			
			PRY_TipoMesa=rs("PRY_TipoMesa")
			
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if		
	
	rs.close
	response.write("200/@/")%>
	
	<h5>Beneficiarios/as</h5>
	<h6>Beneficiarios/as Directos/as Sindicales</h6>
		<form role="form" action="<%=action%>" method="POST" name="frm11s2" id="frm11s2" class="needs-validation">
			<div class="row"><%
				if(LIN_Hombre) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-mars input-prefix"></i>													
								<input type="number" id="PRY_BenDirectosHombres" name="PRY_BenDirectosHombres" class="form-control" required="" value="<%=PRY_BenDirectosHombres%>">
								<span class="select-bar"></span><%
								if(PRY_BenDirectosHombres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_BenDirectosHombres" class="<%=clase%>">Hombres</label>
							</div>
						</div>
					</div><%
				end if
				if(LIN_Mujer) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-venus input-prefix"></i>													
								<input type="number" id="PRY_BenDirectosMujeres" name="PRY_BenDirectosMujeres" class="form-control" required="" value="<%=PRY_BenDirectosMujeres%>">
								<span class="select-bar"></span><%
								if(PRY_BenDirectosMujeres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_BenDirectosMujeres" class="<%=clase%>">Mujeres</label>
							</div>
						</div>
					</div><%
				end if%>
				<div class="col-sm-12 col-md-4 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-users input-prefix"></i>													
							<input type="number" id="PRY_BenDirectosTotal" name="PRY_BenDirectosTotal" class="form-control" readonly="" value="<%=PRY_BenDirectosTotal%>">
							<span class="select-bar"></span><%
							if(PRY_BenDirectosTotal<>"") then
								clase="active"
							else
								clase=""
							end if%>
							<label for="" class="<%=clase%>">Total</label>
						</div>
					</div>	
				</div>
			</div>
			<h6>Beneficiarios/as Indirectos/as Sindicales</h6>
			<div class="row"><%
				if(LIN_Hombre) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-mars input-prefix"></i>													
								<input type="number" id="PRY_SinBenIndirectosHombres" name="PRY_SinBenIndirectosHombres" class="form-control" required="" value="<%=PRY_SinBenIndirectosHombres%>">
								<span class="select-bar"></span><%
								if(PRY_SinBenIndirectosHombres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_SinBenIndirectosHombres" class="<%=clase%>">Hombres</label>
							</div>
						</div>
					</div><%
				end if
				if(LIN_Mujer) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-venus input-prefix"></i>													
								<input type="number" id="PRY_SinBenIndirectosMujeres" name="PRY_SinBenIndirectosMujeres" class="form-control" required="" value="<%=PRY_SinBenIndirectosMujeres%>">
								<span class="select-bar"></span><%
								if(PRY_SinBenIndirectosMujeres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_SinBenIndirectosMujeres" class="<%=clase%>">Mujeres</label>
							</div>
						</div>
					</div><%
				end if%>
				<div class="col-sm-12 col-md-4 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-users input-prefix"></i>													
							<input type="number" id="PRY_SinBenIndirectosTotal" name="PRY_SinBenIndirectosTotal" class="form-control" readonly="" value="<%=PRY_SinBenIndirectosTotal%>">
							<span class="select-bar"></span><%
							if(PRY_SinBenIndirectosTotal<>"") then
								clase="active"
							else
								clase=""
							end if%>
							<label for="" class="<%=clase%>">Total</label>
						</div>
					</div>	
				</div>
			</div>
			<h6>Beneficiarios/as Directos/as Empresas</h6>
			<div class="row"><%
				if(LIN_Hombre) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-mars input-prefix"></i>													
								<input type="number" id="PRY_EmpBenDirectosHombres" name="PRY_EmpBenDirectosHombres" class="form-control" required="" value="<%=PRY_EmpBenDirectosHombres%>">
								<span class="select-bar"></span><%
								if(PRY_EmpBenDirectosHombres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_EmpBenDirectosHombres" class="<%=clase%>">Hombres</label>
							</div>
						</div>
					</div><%
				end if
				if(LIN_Mujer) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-venus input-prefix"></i>													
								<input type="number" id="PRY_EmpBenDirectosMujeres" name="PRY_EmpBenDirectosMujeres" class="form-control" required="" value="<%=PRY_EmpBenDirectosMujeres%>">
								<span class="select-bar"></span><%
								if(PRY_EmpBenDirectosMujeres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_EmpBenDirectosMujeres" class="<%=clase%>">Mujeres</label>
							</div>
						</div>
					</div><%
				end if%>
				<div class="col-sm-12 col-md-4 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-users input-prefix"></i>													
							<input type="number" id="PRY_EmpBenDirectosTotal" name="PRY_EmpBenDirectosTotal" class="form-control" readonly="" value="<%=PRY_EmpBenDirectosTotal%>">
							<span class="select-bar"></span><%
							if(PRY_EmpBenDirectosTotal<>"") then
								clase="active"
							else
								clase=""
							end if%>
							<label for="" class="<%=clase%>">Total</label>
						</div>
					</div>	
				</div>
			</div>
			<h6>Beneficiarios/as Indirectos/as Empresas</h6>
			<div class="row"><%
				if(LIN_Hombre) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-mars input-prefix"></i>													
								<input type="number" id="PRY_EmpBenIndirectosHombres" name="PRY_EmpBenIndirectosHombres" class="form-control" required="" value="<%=PRY_EmpBenIndirectosHombres%>">
								<span class="select-bar"></span><%
								if(PRY_EmpBenIndirectosHombres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_EmpBenIndirectosHombres" class="<%=clase%>">Hombres</label>
							</div>
						</div>
					</div><%
				end if
				if(LIN_Mujer) then%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-venus input-prefix"></i>													
								<input type="number" id="PRY_EmpBenIndirectosMujeres" name="PRY_EmpBenIndirectosMujeres" class="form-control" required="" value="<%=PRY_EmpBenIndirectosMujeres%>">
								<span class="select-bar"></span><%
								if(PRY_EmpBenIndirectosMujeres<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="PRY_EmpBenIndirectosMujeres" class="<%=clase%>">Mujeres</label>
							</div>
						</div>
					</div><%
				end if%>
				<div class="col-sm-12 col-md-4 col-lg-4">
					<div class="md-form input-with-post-icon">
						<div class="error-message">	
							<i class="fas fa-users input-prefix"></i>													
							<input type="number" id="PRY_EmpBenIndirectosTotal" name="PRY_EmpBenIndirectosTotal" class="form-control" readonly="" value="<%=PRY_EmpBenIndirectosTotal%>">
							<span class="select-bar"></span><%
							if(PRY_EmpBenIndirectosTotal<>"") then
								clase="active"
							else
								clase=""
							end if%>
							<label for="" class="<%=clase%>">Total</label>
						</div>
					</div>	
				</div>
			</div><%
			if PRY_TipoMesa=2 then%>
				<h6>Beneficiarios/as Directos/as Gobierno</h6>
				<div class="row"><%
					if(LIN_Hombre) then%>
						<div class="col-sm-12 col-md-4 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-mars input-prefix"></i>													
									<input type="number" id="PRY_GobBenDirectosHombres" name="PRY_GobBenDirectosHombres" class="form-control" required="" value="<%=PRY_GobBenDirectosHombres%>">
									<span class="select-bar"></span><%
									if(PRY_GobBenDirectosHombres<>"") then
										clase="active"
									else
										clase=""
									end if%>
									<label for="PRY_GobBenDirectosHombres" class="<%=clase%>">Hombres</label>
								</div>
							</div>
						</div><%
					end if
					if(LIN_Mujer) then%>
						<div class="col-sm-12 col-md-4 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-venus input-prefix"></i>													
									<input type="number" id="PRY_GobBenDirectosMujeres" name="PRY_GobBenDirectosMujeres" class="form-control" required="" value="<%=PRY_GobBenDirectosMujeres%>">
									<span class="select-bar"></span><%
									if(PRY_GobBenDirectosMujeres<>"") then
										clase="active"
									else
										clase=""
									end if%>
									<label for="PRY_GobBenDirectosMujeres" class="<%=clase%>">Mujeres</label>
								</div>
							</div>
						</div><%
					end if%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-users input-prefix"></i>													
								<input type="number" id="PRY_GobBenDirectosTotal" name="PRY_GobBenDirectosTotal" class="form-control" readonly="" value="<%=PRY_GobBenDirectosTotal%>">
								<span class="select-bar"></span><%
								if(PRY_GobBenDirectosTotal<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="" class="<%=clase%>">Total</label>
							</div>
						</div>	
					</div>
				</div>
				<h6>Beneficiarios/as Indirectos/as Gobierno</h6>
				<div class="row"><%
					if(LIN_Hombre) then%>
						<div class="col-sm-12 col-md-4 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-mars input-prefix"></i>													
									<input type="number" id="PRY_GobBenIndirectosHombres" name="PRY_GobBenIndirectosHombres" class="form-control" required="" value="<%=PRY_GobBenIndirectosHombres%>">
									<span class="select-bar"></span><%
									if(PRY_GobBenIndirectosHombres<>"") then
										clase="active"
									else
										clase=""
									end if%>
									<label for="PRY_GobBenIndirectosHombres" class="<%=clase%>">Hombres</label>
								</div>
							</div>
						</div><%
					end if
					if(LIN_Mujer) then%>
						<div class="col-sm-12 col-md-4 col-lg-4">
							<div class="md-form input-with-post-icon">
								<div class="error-message">	
									<i class="fas fa-venus input-prefix"></i>													
									<input type="number" id="PRY_GobBenIndirectosMujeres" name="PRY_GobBenIndirectosMujeres" class="form-control" required="" value="<%=PRY_GobBenIndirectosMujeres%>">
									<span class="select-bar"></span><%
									if(PRY_GobBenIndirectosMujeres<>"") then
										clase="active"
									else
										clase=""
									end if%>
									<label for="PRY_GobBenIndirectosMujeres" class="<%=clase%>">Mujeres</label>
								</div>
							</div>
						</div><%
					end if%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-users input-prefix"></i>													
								<input type="number" id="PRY_GobBenIndirectosTotal" name="PRY_GobBenIndirectosTotal" class="form-control" readonly="" value="<%=PRY_GobBenIndirectosTotal%>">
								<span class="select-bar"></span><%
								if(PRY_GobBenIndirectosTotal<>"") then
									clase="active"
								else
									clase=""
								end if%>
								<label for="" class="<%=clase%>">Total</label>
							</div>
						</div>	
					</div>
				</div><%
			else%>
				<input type="hidden" id="PRY_GobBenDirectosHombres" name="PRY_GobBenDirectosHombres" value="0">
				<input type="hidden" id="PRY_GobBenDirectosMujeres" name="PRY_GobBenDirectosMujeres" value="0">
				<input type="hidden" id="PRY_GobBenIndirectosHombres" name="PRY_GobBenIndirectosHombres" value="0">
				<input type="hidden" id="PRY_GobBenIndirectosMujeres" name="PRY_GobBenIndirectosMujeres" value="0"><%
			end if%>
			
			<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
			<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
			<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
			<input type="hidden" id="Step" name="Step" value="2">
			<input type="hidden" id="PRY_Hito" value="3" name="PRY_Hito">					
		</form>
				 					
	<div class="row">
		<div class="footer"><%
			if mode="mod" then%>			
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s2" name="btn_frm11s2"><%=txtBoton%></button><%					
			else%>				
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>			
	</div>	
<script>	
	$(document).ready(function() {			
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);		
		var mode = '<%=mode%>'
		var titani = setInterval(function(){				
			$("h5").slideDown("slow",function(){
				$("h6").slideDown("slow",function(){
					clearInterval(titani)
				});
			})
		},2300);
		
		$(function () {
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})		
		});							
		
		$("#PRY_BenDirectosHombres, #PRY_BenDirectosMujeres, #PRY_SinBenIndirectosMujeres, #PRY_SinBenIndirectosHombres, #PRY_EmpBenDirectosHombres, #PRY_EmpBenDirectosMujeres, #PRY_EmpBenIndirectosHombres, #PRY_EmpBenIndirectosMujeres, #PRY_GobBenDirectosHombres, #PRY_GobBenDirectosMujeres, #PRY_GobBenIndirectosHombres, #PRY_GobBenIndirectosMujeres").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			suma();
		})
		
		suma();
		function suma(){
			$("#PRY_BenDirectosTotal").val(parseInt($("#PRY_BenDirectosHombres").val())+parseInt($("#PRY_BenDirectosMujeres").val()));
			if($("#PRY_BenDirectosTotal").val()>0){
				$("#PRY_BenDirectosTotal").next().next().addClass("active");
			}		
			$("#PRY_SinBenIndirectosTotal").val(parseInt($("#PRY_SinBenIndirectosMujeres").val())+parseInt($("#PRY_SinBenIndirectosHombres").val()));
			if($("#PRY_SinBenIndirectosTotal").val()>0){
				$("#PRY_SinBenIndirectosTotal").next().next().addClass("active");
			}		
			$("#PRY_EmpBenDirectosTotal").val(parseInt($("#PRY_EmpBenDirectosHombres").val())+parseInt($("#PRY_EmpBenDirectosMujeres").val()));
			if($("#PRY_EmpBenDirectosTotal").val()>0){
				$("#PRY_EmpBenDirectosTotal").next().next().addClass("active");
			}		
			$("#PRY_EmpBenIndirectosTotal").val(parseInt($("#PRY_EmpBenIndirectosHombres").val())+parseInt($("#PRY_EmpBenIndirectosMujeres").val()));
			if($("#PRY_EmpBenIndirectosTotal").val()>0){
				$("#PRY_EmpBenIndirectosTotal").next().next().addClass("active");
			}		
			$("#PRY_GobBenDirectosTotal").val(parseInt($("#PRY_GobBenDirectosHombres").val())+parseInt($("#PRY_GobBenDirectosMujeres").val()));
			if($("#PRY_GobBenDirectosTotal").val()>0){
				$("#PRY_GobBenDirectosTotal").next().next().addClass("active");
			}		
			$("#PRY_GobBenIndirectosTotal").val(parseInt($("#PRY_GobBenIndirectosHombres").val())+parseInt($("#PRY_GobBenIndirectosMujeres").val()));
			if($("#PRY_GobBenIndirectosTotal").val()>0){
				$("#PRY_GobBenIndirectosTotal").next().next().addClass("active");
			}		
		}
				
		$("#btn_frm11s2").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frm11s2");			
						
			if($("#frm11s2").valid()){
				
					$.ajax({
						type: 'POST',			
						url: $("#frm11s2").attr("action"),
						data: $("#frm11s2").serialize(),
						success: function(data) {								
							var param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Evaluación de proceso grabadas correctamente'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:3};
								$.ajax( {
									type:'POST',					
									url: '/mnu-11',
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
								});

							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude grabar los datos del proyecto',					
									text:param[1]
								});
							}
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude cargar el menú del proyecto'							
							});
						}
					});					
				
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})
		
	});
</script>