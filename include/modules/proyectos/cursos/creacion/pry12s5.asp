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
		action="/mod-12-h0-s5"
		columns="{data: ""OER_Id""},{data: ""OER_ObjetivoEspRelacionado""},{className: 'delobjesp',orderable: false,data: ""Del""}"				
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		mode="vis"
		modo=4
		disabled="readonly disabled"				
	end if	
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		columns="{data: ""OER_Id""},{data: ""OER_ObjetivoEspRelacionado""}"
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
			PRY_FundamentacionCriterioFocalizacion=rs("PRY_FundamentacionCriterioFocalizacion")
			LIN_AgregaTematica=rs("LIN_AgregaTematica")
			PRY_EnfoquePedagogico=rs("PRY_EnfoquePedagogico")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		Step=4
		if(LIN_AgregaTematica) then
			Step=5
		end if
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end%>	
	<form role="form" action="<%=action%>" method="POST" name="frm12s5" id="frm12s5" class="needs-validation">
		<h5>Criterios de Focalización</h5>
		<h6>Fundamentación de criterio de focalización</h6>
		<div class="row"> 
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_FundamentacionCriterioFocalizacion" name="PRY_FundamentacionCriterioFocalizacion" class="md-textarea form-control" rows="6" <%=disabled%> data-msg="Debes ingresar una fundamentación de criterio de focalización"><%=PRY_FundamentacionCriterioFocalizacion%></textarea>
						<span class="select-bar"></span><%
						if(PRY_FundamentacionCriterioFocalizacion<>"") then%>
							<label for="PRY_FundamentacionCriterioFocalizacion" class="active">Fundamentación de criterio de focalización</label><%
						else%>
							<label for="PRY_FundamentacionCriterioFocalizacion" class="">Fundamentación de criterio de focalización</label><%
						end if%>
						
					</div>
				</div>
			</div>	
		</div>
		<h6>Enfoque pedagógico</h6>
		<div class="row"> 
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_EnfoquePedagogico" name="PRY_EnfoquePedagogico" class="md-textarea form-control" rows="6" <%=disabled%> data-msg="Debes ingresar un enfoque pedagógico"><%=PRY_EnfoquePedagogico %></textarea>
						<span class="select-bar"></span><%
						if(PRY_EnfoquePedagogico <>"") then%>
							<label for="PRY_EnfoquePedagogico" class="active">Enfoque pedagógico</label><%
						else%>
							<label for="PRY_EnfoquePedagogico" class="">Enfoque pedagógico</label><%
						end if%>
						
					</div>
				</div>
			</div>	
		</div>
		<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
		<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
		<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
		<input type="hidden" id="Step" name="Step" value="<%=Step%>" />		
	</form>	
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>				
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s5" name="btn_frm12s5"><%=txtBoton%></button><%	
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
		
		$("#btn_frm12s5").click(function(){
							
			formValidate("#frm12s5")
			if($("#frm12s5").valid()){
				/*if(objrelTable.data().count()<3){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Debes ingresar al menos 3 objetivos relacionados antes de avanzar'							
					});
				}else{*/
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm12s5").attr("action"),
						data: $("#frm12s5").serialize(),
						success: function(data) {					
							param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Criterios de Focalización grabados correctamente'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
								$.ajax( {
									type:'POST',					
									url: '/mnu-12',
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
												text:param[1]
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
				/*}*/
			}
		})
	});
</script>