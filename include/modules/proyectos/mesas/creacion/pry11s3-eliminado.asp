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
		action="/mod-11-h0-s3"
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		mode="vis"
		modo=4
		disabled="readonly disabled"
		'response.write(mode & "-" & session("ds5_usrperfil"))
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
			
			PRY_FechaTramitacionContrato=rs("PRY_FechaTramitacionContrato")
            PRY_FechaGruposFocales=rs("PRY_FechaGruposFocales")
            PRY_FechaReunionActoresMesa=rs("PRY_FechaReunionActoresMesa")
            PRY_FechaSeminarioResultados=rs("PRY_FechaSeminarioResultados")

		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
		rs.close		
	end if
	
	rs.close
	response.write("200/@/")	
%>
<form role="form" action="<%=action%>" method="POST" name="frm10s3" id="frm10s3" class="needs-validation">
	<h5>Fechas Relevantes</h5>	
	<div class="row" style="padding-bottom:40px;"> 
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_FechaTramitacionContrato<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_FechaTramitacionContrato" name="PRY_FechaTramitacionContrato" class="form-control <%=calendario%>" required readonly value="<%=PRY_FechaTramitacionContrato%>" data-msg-required="Debes ingresar una fecha"><%
					else%>
						<input type="text" id="PRY_FechaTramitacionContrato" name="PRY_FechaTramitacionContrato" class="form-control" readonly value="<%=PRY_FechaTramitacionContrato%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_FechaTramitacionContrato" class="<%=lblClass%>">Fecha Tramitación Contrato</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_FechaGruposFocales<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_FechaGruposFocales" name="PRY_FechaGruposFocales" class="form-control <%=calendario%>" required readonly value="<%=PRY_FechaGruposFocales%>" data-msg-required="Debes ingresar una fecha"><%
					else%>
						<input type="text" id="PRY_FechaGruposFocales" name="PRY_FechaGruposFocales" class="form-control" readonly value="<%=PRY_FechaGruposFocales%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_FechaGruposFocales" class="<%=lblClass%>">Fecha Grupos Focales</label>									
				</div>
			</div>
		</div>			
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_FechaReunionActoresMesa<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_FechaReunionActoresMesa" name="PRY_FechaReunionActoresMesa" class="form-control <%=calendario%>" required readonly value="<%=PRY_FechaReunionActoresMesa%>" data-msg-required="Debes ingresar una fecha"><%
					else%>
						<input type="text" id="PRY_FechaReunionActoresMesa" name="PRY_FechaReunionActoresMesa" class="form-control" readonly value="<%=PRY_FechaReunionActoresMesa%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_FechaReunionActoresMesa" class="<%=lblClass%>">Fecha Reunión Actores Mesa</label>									
				</div>
			</div>
		</div>	
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_FechaSeminarioResultados<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_FechaSeminarioResultados" name="PRY_FechaSeminarioResultados" class="form-control <%=calendario%>" required readonly value="<%=PRY_FechaSeminarioResultados%>" data-msg-required="Debes ingresar una fecha"><%
					else%>
						<input type="text" id="PRY_FechaSeminarioResultados" name="PRY_FechaSeminarioResultados" class="form-control" readonly value="<%=PRY_FechaSeminarioResultados%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_FechaSeminarioResultados" class="<%=lblClass%>">Fecha Seminario Resultado</label>									
				</div>
			</div>
		</div>		
	</div>	
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s3" name="btn_frm10s3"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="Step" name="Step" value="3" />		
</form>
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	if ($(".calendario").val() ==  null){
		$(".calendario").datepicker().datepicker("setDate", new Date());
	}else{
		$(".calendario").datepicker();
	}
	
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
	$(document).ready(function() {						
		$("#btn_frm10s3").click(function(){
			formValidate("#frm10s3")
			if($("#frm10s3").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm10s3").attr("action"),
					data: $("#frm10s3").serialize(),
					success: function(data) {					
						param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Fechas de Cierre grabadas correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
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
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})
	});
</script>