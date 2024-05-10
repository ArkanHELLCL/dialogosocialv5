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
		calendario="calendario"
		action="/mod-13-h0-fin"
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
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end%>
	<h5>Finalizar</h5>
	<h6>Cierre del hito Creación</h6>
	<div style="padding-top:50px;"></div>
		<form role="form" action="<%=action%>" method="POST" name="frm13sfin" id="frm13sfin" class="needs-validation">
			<div class="row align-items-center">
				<div class="col-sm-6 col-md-6 col-lg-6" style="text-align:center;height:100%">
					<button type="button" class="btn btn-danger btn-lg" id="btn_frm10fin" name="btn_frm10fin" value="enviar">Cerrar Creación de Proyecto</button>
				</div>
				<div class="col-sm-6 col-md-6 col-lg-6">
					<blockquote>
						<p>
							Después de haber ingresado toda la información requerida en los pasos anteriores, es necesario cerrar la etapa "Creación de Proyecto", con el fin de que quede disponible para todos los usuarios asociados en item "Personalización" y asi dar inicio a la ejecución del programa.
						</p>
						<p>
							Presionando el botón "Cerrar Creación de Proyecto", se cambiará el estado del proyecto actual y se enviará a los perfiles asociados el requerimiento ya creado.
						</p>
					</blockquote>                                		                                                                    
				</div>                               		                                    
			</div>
			<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
			<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">			
			</form>			
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
		
		$("#btn_frm10fin").click(function(){
			swalWithBootstrapButtons.fire({
			  title: 'Confirmación de Cierre',
			  text: '¿Estás seguro de querer cerrar la etapa de "Creación de Proyecto" para dar inicio a la ejecución del programa?',
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
					url: $("#frm13sfin").attr("action"),
					data: $("#frm13sfin").serialize(),
					success: function(data) {					
						param=data.split(bb);						
						if(param[0]=="200"){
							$("#frm13sfin")[0].reset();
							Toast.fire({
							  icon: 'success',
							  title: 'Cierre del Hito Creación realizado con éxito.'
							});
							//Creación del informe
							wrk_informes('/prt-informecreacionrecuperacion','informecreacionrecuperacion.pdf',<%=PRY_Id%>,'<%=PRY_Identificador%>','/mnu-13',<%=session("ds5_usrid")%>,'<%=session("ds5_usrtoken")%>');

							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>};
							$.ajax( {
								type:'POST',					
								url: '/mnu-13',
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
			  }
			})
		})
		
	});
</script>