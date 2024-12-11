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
		action="/mod-14-h4-s1"
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
			LIN_Mujer("LIN_Mujer")			
			PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")
			PRY_Estado=rs("PRY_Estado")
			
			PRY_SisFacilitadores=rs("PRY_SisFacilitadores")
			PRY_SisObstaculizadores=rs("PRY_SisObstaculizadores")			
			PRY_PrincipalesAcuerdos=rs("PRY_PrincipalesAcuerdos")
			PRY_Desafios=rs("PRY_Desafios")
			PRY_Sugerencias=rs("PRY_Sugerencias")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
			
	rs.close
	response.write("200/@/")%>
	
	<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Sugerencias</h5>		
	<!--container-nav-->
	<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
		<div class="header">
			<div class="content-nav"><%
				if LFO_Id=99 then%>
					<a id="eva1-tab" href="#facilitadorestab1" class="active tab"><i class="fas fa-comment"></i> Facilitadores 					
					</a>
					<a id="eva2-tab" href="#acuerdostab2" class="tab"><i class="fas fa-comment"></i> Acuerdos/Conclusiones 					
					</a>
					<a id="eva3-tab" href="#desafiostab3" class="tab"><i class="fas fa-comment"></i> Desafíos y Continuidad 					
					</a><%
				end if%>
				<a id="eva4-tab" href="#sugerenciastab4" class="tab"><i class="fas fa-comment"></i> Sugerencias					
				</a>					
				<span class="yellow-bar"></span>					
			</div>				
		</div>
		<div class="tab-content"><%
			if LFO_Id=99 then%>
				<div id="facilitadorestab1">
					<form role="form" name="frm14s1_1" id="frm14s1_1" class="needs-validation">
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_SisFacilitadores" name="PRY_SisFacilitadores" class="md-textarea form-control" <%=disabled%> rows="7"><%=PRY_SisFacilitadores%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_SisFacilitadores<>"") then
											clase="active"
										end if%>
										<label for="PRY_SisFacilitadores" class="<%=clase%>">Facilitadores</label>									
									</div>
								</div>
							</div>
						</div>																														
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_SisObstaculizadores" name="PRY_SisObstaculizadores" class="md-textarea form-control" <%=disabled%> rows="7"><%=PRY_SisObstaculizadores%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_SisObstaculizadores<>"") then
											clase="active"
										end if%>
										<label for="PRY_SisObstaculizadores" class="<%=clase%>">Obstaculizadores</label>									
									</div>
								</div>
							</div>
						</div>
						<!--<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
						<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
						<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
						<input type="hidden" id="Step" name="Step" value="1">
						<input type="hidden" id="PRY_Hito" value="3" name="PRY_Hito">-->
					</form>
				</div>
				<div id="acuerdostab2">
					<form role="form" name="frm14s1_2" id="frm14s1_2" class="needs-validation">
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_PrincipalesAcuerdos" name="PRY_PrincipalesAcuerdos" class="md-textarea form-control" <%=disabled%> rows="7"><%=PRY_PrincipalesAcuerdos%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_PrincipalesAcuerdos<>"") then
											clase="active"
										end if%>
										<label for="PRY_PrincipalesAcuerdos" class="<%=clase%>">Acuerdos/Conclusiones</label>									
									</div>
								</div>
							</div>
						</div>					
					</form>
				</div>
				<div id="desafiostab3">
					<form role="form" name="frm14s1_3" id="frm14s1_3" class="needs-validation">
						<div class="row">
							<div class="col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_Desafios" name="PRY_Desafios" class="md-textarea form-control" <%=disabled%> rows="7"><%=PRY_Desafios%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_Desafios<>"") then
											clase="active"
										end if%>
										<label for="PRY_Desafios" class="<%=clase%>">Desafíos y Continuidad</label>									
									</div>
								</div>
							</div>
						</div>					
					</form>
				</div><%
			end if%>
			<div id="sugerenciastab4">
				<form role="form" name="frm14s1_4" id="frm14s1_4" class="needs-validation">
					<div class="row">
						<div class="col-sm-12 col-md-12 col-lg-12">
							<div class="md-form">
								<div class="error-message">								
									<i class="fas fa-comment prefix"></i>
										<textarea id="PRY_Sugerencias" name="PRY_Sugerencias" class="md-textarea form-control" <%=disabled%> rows="7"><%=PRY_Sugerencias%></textarea>
									<span class="select-bar"></span><%
									clase=""
									if(PRY_Sugerencias<>"") then
										clase="active"
									end if%>
									<label for="PRY_Sugerencias" class="<%=clase%>">Sugerencias</label>									
								</div>
							</div>
						</div>
					</div>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="1">
					<input type="hidden" id="PRY_Hito" value="4" name="PRY_Hito">					
				</form>
			</div>
		</div>
	</div>
				 					
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>			
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm14s1" name="btn_frm14s1"><%=txtBoton%></button><%					
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
		$(".content-nav").tabsmaterialize({menumovil:false},function(){});
		$("#btn_frm14s1").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			<%if LFO_Id=99 then%>
				formValidate("#frm14s1_1");			
				formValidate("#frm14s1_2");
				formValidate("#frm14s1_3");
			<%end if%>
			formValidate("#frm14s1_4");
			<%if LFO_Id=99 then%>
				var frm1=false;
				var frm2=false;
				var frm3=false;
			<%end if%>
			var frm4=false;
			<%if LFO_Id=99 then%>
				if($("#frm14s1_1").valid()){
					$("#eva1-tab i.fas").css("color","#00c851");
					frm1=true;
				}else{
					$("#eva1-tab i.fas").css("color","#f44336");
				}
				if($("#frm14s1_2").valid()){
					$("#eva2-tab i.fas").css("color","#00c851");
					frm2=true;
				}else{
					$("#eva2-tab i.fas").css("color","#f44336");
				}
				if($("#frm14s1_3").valid()){
					$("#eva3-tab i.fas").css("color","#00c851");
					frm3=true;
				}else{
					$("#eva3-tab i.fas").css("color","#f44336");
				}
			<%end if%>
			if($("#frm14s1_4").valid()){
				$("#eva4-tab i.fas").css("color","#00c851");				
				frm4=true;
			}else{
				$("#eva4-tab i.fas").css("color","#f44336");
			}

			//if(frm1 && frm2 && frm3 && frm4){
			if(frm4){
				<%if LFO_Id=99 then%>
					var data1 = $("#frm14s1_1").serializeArray();
					var data2 = $("#frm14s1_2").serializeArray();
					var data3 = $("#frm14s1_3").serializeArray();
				<%end if%>
				var data4 = $("#frm14s1_4").serializeArray();

				//var data = data1.concat(data2,data3,data4);
				var data = data4;
				$.ajax({
					type: 'POST',			
					url: '/mod-14-h4-s1',
					data: data,
					success: function(data) {								
						var param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
								icon: 'success',
								title: 'Evaluación grabada correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:4};
							$.ajax( {
								type:'POST',					
								url: '/mnu-14',
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
					title: 'Existen campos con error o faltantes, corrige y vuelve a intentar'
				});
			}			
		})
		
	});
</script>