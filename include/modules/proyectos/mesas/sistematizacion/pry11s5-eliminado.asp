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
		action="/mod-11-h3-s5"
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
			
			PRY_PrincipalesAcuerdos=rs("PRY_PrincipalesAcuerdos")			
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
			
	rs.close
	response.write("200/@/")%>
	
	<h5>Acuerdos/Conclusiones</h5>
	<form role="form" action="<%=action%>" method="POST" name="frm11s5" id="frm11s5" class="needs-validation">
		<div class="row">
			<div class="col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">								
						<i class="fas fa-comment prefix"></i>
							<textarea id="PRY_PrincipalesAcuerdos" name="PRY_PrincipalesAcuerdos" class="md-textarea form-control" <%=disabled%> rows="15"><%=PRY_PrincipalesAcuerdos%></textarea>
						<span class="select-bar"></span><%
						clase=""
						if(PRY_PrincipalesAcuerdos<>"") then
							clase="active"
						end if%>
						<label for="" class="<%=clase%>">Principales Acuerdos y/o Conclusiones</label>									
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
		<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
		<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
		<input type="hidden" id="Step" name="Step" value="5">
		<input type="hidden" id="PRY_Hito" value="3" name="PRY_Hito">					
	</form>
	<div class="row">		
		<div class="footer"><%
			if mode="mod" then%>			
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s5" name="btn_frm11s5"><%=txtBoton%></button><%					
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
								
		$("#btn_frm11s5").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frm11s5");						
			if($("#frm11s5").valid()){
				
					$.ajax({
						type: 'POST',			
						url: $("#frm11s5").attr("action"),
						data: $("#frm11s5").serialize(),
						success: function(data) {								
							var param=data.split(bb)
							if(param[0]=="200"){
								Toast.fire({
								  icon: 'success',
								  title: 'Acuerdos/Conclusiones grabados correctamente'
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