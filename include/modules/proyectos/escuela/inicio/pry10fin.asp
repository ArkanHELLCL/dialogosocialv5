<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	'response.write("200/@/" & LIN_Id & "-" & mode & "-" & PRY_Id)
	
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
		action="/mod-10-h1-fin"		
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
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
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
	if(mode="mod") then%>
		<h5>Finalizar</h5>
		<h6>Cierre del hito Inicio</h6>
		<div style="padding-top:50px;"></div>
			<form role="form" action="<%=action%>" method="POST" name="frm10sfin" id="frm10sfin" class="needs-validation">
				<div class="row align-items-center">
					<div class="col-sm-6 col-md-6 col-lg-6" style="text-align:center;height:100%">
						<button type="button" class="btn btn-danger btn-lg" id="btn_frm10fin" name="btn_frm10fin" value="enviar"><i class="fas fa-door-open"></i> Cerrar Hito INICIO</button>
					</div>
					<div class="col-sm-6 col-md-6 col-lg-6">
						<blockquote>
							<p>
								Después de haber ingresado toda la información requerida en los pasos anteriores, es necesario cerrar la etapa "Inicio", con el fin de informar el paso al siguiente Hito y asi poder generar los informes pertinentes a esta etapa (Informe Inicial).
							</p>
							<p>
								Presionando el botón "Cerrar Hito INICIO", se cambiará el estado del proyecto actual y se enviará a los perfiles asociados el requerimiento en su nueva etapa.
							</p>
						</blockquote>                                		                                                                    
					</div>                               		                                    
				</div>
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
				<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">			
			</form>			
		</div><%
	else
		if(session("ds5_usrperfil"))=2 then
			perfil = "Revisor"
		end if
		if(session("ds5_usrperfil"))=4 then
			perfil="Auditor"
		end if
		if(session("ds5_usrperfil"))=5 then
			perfil="Administrativo"
		end if%>
		<h5>Finalizar</h5>
		<h6>Hito Inicio en proceso de cierre</h6>
		<div style="padding-top:50px;"></div>
			<form role="form" action="<%=action%>" method="POST" name="frm10sfin" id="frm10sfin" class="needs-validation">
				<div class="row align-items-center">					
					<div class="col-sm-12 col-md-2 col-lg-2">
						<i class="fas fa-info fa-9x text-primary"></i>
					</div>
					<div class="col-sm-12 col-md-10 col-lg-10">
						<blockquote>
							<p>
								Estimado <%=perfil%>, actualmente el informe INICIO se encuentra en proceso de cierre. En este período el ejecutor del proyecto podría enviarle algunas solicitudes de adecuaciones requeridas para completar el informe y asi proceder al cierre del mismo.
							</p>
							<p>
								Para revisar estas observaciones solo debe ingresar en el menú de Adecuaciones que se encuentra situado en la parte superior izquierda de esta pantalla.
							</p>
						</blockquote>                                		                                                                    
					</div>                               		                                    
				</div>
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
				<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">			
			</form>			
		</div><%
	end if%>
	
<script>
	$(document).ready(function() {	
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);		

		setInterval(function(){
			$("h5").slideDown("slow",function(){
				$("h6").slideDown("slow");
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
		
		$("#btn_frm10fin").click(function(){
			swalWithBootstrapButtons.fire({
			  title: 'Confirmación de Cierre de Hito INICIO',
			  text: '¿Estas seguro de querer cerrar del Hito "INICIO" para dar inicio al desarrollo del programa?',
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, cerrar Hito!',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No, aún no'
			}).then((result) => {
			  if (result.value) {			  					
				$.ajax({
					type: 'POST',			
					url: $("#frm10sfin").attr("action"),
					data: $("#frm10sfin").serialize(),
					dataType: "json",
					success: function(data) {												
						if(data.state=="200"){
							$("#frm10sfin")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Cierre del Hito Inicio realizado con éxito.'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>};
							$.ajax( {
								type:'POST',					
								url: '/mnu-10',
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
								title: 'Ups!, no pude grabar del cierre del Hito',					
								text:data.message
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
			  }
			})
		})
		
	});
</script>