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
		action="/mod-11-h0-s2"
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
			
			PRY_InformeInicialFecha=rs("PRY_InformeInicialFecha")
			PRY_InformeConsensosFecha=rs("PRY_InformeConsensosFecha")
			PRY_InformeSistematizacionFecha=rs("PRY_InformeSistematizacionFecha")
			
			PRY_InformeInicialFechaOriginal=rs("PRY_InformeInicialFechaOriginal")
			PRY_InformeConsensosFechaOriginal=rs("PRY_InformeConsensosFechaOriginal")
			PRY_InformeSistematizacionFechaOriginal=rs("PRY_InformeSistematizacionFechaOriginal")

			PRY_FechaTramitacionContrato=rs("PRY_FechaTramitacionContrato")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		
		rs.close
		set rs = cnn.Execute("exec spLinea_Consultar " & LIN_Id)
		on error resume next
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if
		if not rs.eof then
			LIN_DiasCierreInformeParcial = rs("LIN_DiasCierreInformeParcial")
			LIN_DiasCierreInformeFinal	 = rs("LIN_DiasCierreInformeFinal")
			LIN_DiasCierreInformeParcial50Ejecucion = rs("LIN_DiasCierreInformeParcial50Ejecucion")
			LIN_DiasCierreInformeFinal100Ejecucion 	= rs("LIN_DiasCierreInformeFinal100Ejecucion")
		end if
		if LIN_DiasCierreInformeParcial="" or isNull(LIN_DiasCierreInformeParcial) then
			LIN_DiasCierreInformeParcial=0
		end if
		if LIN_DiasCierreInformeFinal="" or isNull(LIN_DiasCierreInformeFinal) then
			LIN_DiasCierreInformeFinal=0
		end if
		if LIN_DiasCierreInformeParcial50Ejecucion="" or isNull(LIN_DiasCierreInformeParcial50Ejecucion) then
			LIN_DiasCierreInformeParcial50Ejecucion=0
		end if
		if LIN_DiasCierreInformeFinal100Ejecucion="" or isNull(LIN_DiasCierreInformeFinal100Ejecucion) then
			LIN_DiasCierreInformeFinal100Ejecucion=0
		end if
	end if
	
	rs.close
	response.write("200/@/")	
%>
<form role="form" action="<%=action%>" method="POST" name="frm10s2" id="frm10s2" class="needs-validation">
	<h5>Fechas de Cierre</h5>
	<h6>Fechas de Cierre Informadas</h6>
	<div class="row" style="padding-bottom:40px;"> 
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_InformeInicialFecha<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_InformeInicialFecha" name="PRY_InformeInicialFecha" class="form-control <%=calendario%>" required readonly value="<%=PRY_InformeInicialFecha%>"><%
					else%>
						<input type="text" id="PRY_InformeInicialFecha" name="PRY_InformeInicialFecha" class="form-control" readonly value="<%=PRY_InformeInicialFecha%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_InformeInicialFecha" class="<%=lblClass%>">Fecha Cierre Informe Inicial</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_InformeConsensosFecha<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_InformeConsensosFecha" name="PRY_InformeConsensosFecha" class="form-control <%=calendario%>" required readonly value="<%=PRY_InformeConsensosFecha%>"><%
					else%>
						<input type="text" id="PRY_InformeConsensosFecha" name="PRY_InformeConsensosFecha" class="form-control" readonly value="<%=PRY_InformeConsensosFecha%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_InformeConsensosFecha" class="<%=lblClass%>">Fecha Cierre Informe Desarrollo (<%=LIN_DiasCierreInformeParcial%>)</label>									
				</div>
			</div>
		</div>			
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_InformeSistematizacionFecha<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_InformeSistematizacionFecha" name="PRY_InformeSistematizacionFecha" class="form-control <%=calendario%>" required readonly value="<%=PRY_InformeSistematizacionFecha%>"><%
					else%>
						<input type="text" id="PRY_InformeSistematizacionFecha" name="PRY_InformeSistematizacionFecha" class="form-control" readonly value="<%=PRY_InformeSistematizacionFecha%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_InformeSistematizacionFecha" class="<%=lblClass%>">Fecha Cierre Informe Final (<%=LIN_DiasCierreInformeFinal%>)</label>									
				</div>
			</div>
		</div>
	</div>	
	<h6>Fecha de Cierre Originales</h6>
	<div class="row" style="padding-bottom:40px;">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_InformeInicialFechaOriginal<>"") then
						lblClass="active"
					else
						lblClass=""
					end if%>
					<input type="text" id="PRY_InformeInicialFechaOriginal" name="PRY_InformeInicialFechaOriginal" class="form-control" readonly value="<%=PRY_InformeInicialFechaOriginal%>">
					<span class="select-bar"></span>
					<label for="PRY_InformeInicialFechaOriginal" class="<%=lblClass%>">Fecha Cierre Informe Inicial</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_InformeConsensosFechaOriginal<>"") then
						lblClass="active"
					else
						lblClass=""
					end if%>
					<input type="text" id="PRY_InformeConsensosFechaOriginal" name="PRY_InformeConsensosFechaOriginal" class="form-control" readonly value="<%=PRY_InformeConsensosFechaOriginal%>">
					<span class="select-bar"></span>
					<label for="PRY_InformeConsensosFechaOriginal" class="<%=lblClass%>">Fecha Fecha Cierre Informe Desarrollo</label>									
				</div>
			</div>
		</div>		
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_InformeSistematizacionFechaOriginal<>"") then
						lblClass="active"
					else
						lblClass=""
					end if%>
					<input type="text" id="PRY_InformeSistematizacionFechaOriginal" name="PRY_InformeSistematizacionFechaOriginal" class="form-control" readonly value="<%=PRY_InformeSistematizacionFechaOriginal%>">					
					<span class="select-bar"></span>
					<label for="PRY_InformeSistematizacionFechaOriginal" class="<%=lblClass%>">Fecha Cierre Informe Final</label>									
				</div>
			</div>
		</div>
	</div>
	<h6>Fecha Tramitación de Contratos</h6>
	<div class="row">
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-calendar input-prefix"></i><%
					if(PRY_FechaTramitacionContrato<>"") then
						lblClass="active"
					else
						lblClass=""
					end if
					if (PRY_CreacionProyectoEstado=1 and session("ds5_usrperfil")=1) or (PRY_CreacionProyectoEstado=0 and (session("ds5_usrperfil")=2 or session("ds5_usrperfil")=1) or session("ds5_usrperfil")=5) then%>
						<input type="text" id="PRY_FechaTramitacionContrato" name="PRY_FechaTramitacionContrato" class="form-control <%=calendario%>" readonly required value="<%=PRY_FechaTramitacionContrato%>"><%
					else%>
						<input type="text" id="PRY_FechaTramitacionContrato" name="PRY_FechaTramitacionContrato" class="form-control" readonly value="<%=PRY_FechaTramitacionContrato%>"><%
					end if%>
					<span class="select-bar"></span>
					<label for="PRY_FechaTramitacionContrato" class="<%=lblClass%>">Fecha Tramitación de Contrato</label>									
				</div>
			</div>
		</div>
	</div>
	
	
	<div class="row">		
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm10s2" name="btn_frm10s2"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />
	<input type="hidden" id="LIN_DiasCierreInformeParcial" name="LIN_DiasCierreInformeParcial" value="<%=LIN_DiasCierreInformeParcial%>" />
	<input type="hidden" id="LIN_DiasCierreInformeFinal" name="LIN_DiasCierreInformeFinal" value="<%=LIN_DiasCierreInformeFinal%>" />
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="Step" name="Step" value="2" />		
</form>
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	if ($(".calendario").val() ==  null){
		$(".calendario").datepicker().datepicker("setDate", new Date());
	}else{
		$(".calendario").datepicker();
	}		

	$("#PRY_InformeInicialFecha").change(function(){
		var fecha1 = new Date($('#PRY_InformeInicialFecha').val());
		var dias1 = parseInt($("#LIN_DiasCierreInformeParcial").val());		
				
		dias1 = dias1 + 1;		
		fecha1.setDate(fecha1.getDate() + dias1)		
		$("#PRY_InformeConsensosFecha").val(fecha1.getFullYear() + '-' + ( (fecha1.getMonth() + 1) < 10 ? ("0" + (fecha1.getMonth() + 1)) : (fecha1.getMonth() + 1) ) + '-' + (fecha1.getDate() < 10 ? ("0" + fecha1.getDate()) : fecha1.getDate()));
		
		$("#PRY_InformeConsensosFecha").siblings("label").addClass("active")
		
		
		var fecha2 = new Date($('#PRY_InformeInicialFecha').val());
		var dias2 = parseInt($("#LIN_DiasCierreInformeFinal").val());
		
		dias2 = dias2 + 1;		
		fecha2.setDate(fecha2.getDate() + dias2)
		$("#PRY_InformeSistematizacionFecha").val(fecha2.getFullYear() + '-' + ( (fecha2.getMonth() + 1) < 10 ? ("0" + (fecha2.getMonth() + 1)) : (fecha2.getMonth() + 1) ) + '-' + (fecha2.getDate() < 10 ? ("0" + fecha2.getDate()) : fecha2.getDate()));
		
		$("#PRY_InformeSistematizacionFecha").siblings("label").addClass("active")
				
	});
	
	$("#PRY_InformeInicialFecha").change(function(){		
		if($("#PRY_InformeInicialFechaOriginal").val()==""){
			$("#PRY_InformeInicialFechaOriginal").val($("#PRY_InformeInicialFecha").val());
			$("#PRY_InformeInicialFechaOriginal").siblings("label").addClass("active");
		}
	});	
	$("#PRY_InformeInicialFecha").change(function(){		
		if($("#PRY_InformeConsensosFechaOriginal").val()==""){
			$("#PRY_InformeConsensosFechaOriginal").val($("#PRY_InformeConsensosFecha").val());
			$("#PRY_InformeConsensosFechaOriginal").siblings("label").addClass("active");
		}
	});		
	$("#PRY_InformeInicialFecha").change(function(){		
		if($("#PRY_InformeSistematizacionFechaOriginal").val()==""){
			$("#PRY_InformeSistematizacionFechaOriginal").val($("#PRY_InformeSistematizacionFecha").val());
			$("#PRY_InformeSistematizacionFechaOriginal").siblings("label").addClass("active");
		}
	});
	
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
		$("#btn_frm10s2").click(function(){
			formValidate("#frm10s2")
			if($("#frm10s2").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm10s2").attr("action"),
					data: $("#frm10s2").serialize(),
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