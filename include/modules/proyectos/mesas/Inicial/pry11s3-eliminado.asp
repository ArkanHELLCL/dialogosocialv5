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
		mode="vis"
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"
		action="/mod-11-h1-s3"
		checkbox="required"
	end if
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
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
	end if
			
	anio=year(date())
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
		if(mode="vis") then
			lblSelect = "active"
		end if		
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End()
		end if
		if not rs.eof then
			PRY_Estado=rs("PRY_Estado")
			PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")
			PRY_Identificador=rs("PRY_Identificador")
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")
			PRY_IdenProblematicaTematicaComunes=rs("PRY_IdenProblematicaTematicaComunes")
			PRY_IdenProblematicaTematicaPriorizadas=rs("PRY_IdenProblematicaTematicaPriorizadas")
			PRY_PrincipalesHallazgosDiagnostico=rs("PRY_PrincipalesHallazgosDiagnostico")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if		
	
	rs.close
	response.write("200/@/")%>

	<h5>Análisis Diagnóstico Socio Laboral de la Tématica</h5>
	<h6>1. Identificación de problemática y/o temática comunes entre los distintos sectores</h6>
	<form role="form" action="<%=action%>" method="POST" name="frm11s3" id="frm11s3" class="needs-validation">
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_IdenProblematicaTematicaComunes" name="PRY_IdenProblematicaTematicaComunes" class="md-textarea form-control" rows="3" <%=disabled%>><%=PRY_IdenProblematicaTematicaComunes%></textarea>
						<span class="select-bar"></span><%
						if(PRY_IdenProblematicaTematicaComunes<>"") then
							clase="active"
						else
							clase=""
						end if%>
						<label for="PRY_IdenProblematicaTematicaComunes" class="<%=clase%>">Problemáticas comunes</label>
					</div>
				</div>
			</div>
		</div>
		<h6>2. Identificación de problemática y/o temática priorizadas solo por un sector</h6>
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_IdenProblematicaTematicaPriorizadas" name="PRY_IdenProblematicaTematicaPriorizadas" class="md-textarea form-control" rows="3" <%=disabled%>><%=PRY_IdenProblematicaTematicaPriorizadas%></textarea>
						<span class="select-bar"></span><%
						if(PRY_IdenProblematicaTematicaPriorizadas<>"") then
							clase="active"
						else
							clase=""
						end if%>
						<label for="PRY_IdenProblematicaTematicaPriorizadas" class="<%=clase%>">Problemáticas priorizadas</label>
					</div>
				</div>
			</div>
		</div>		
		<h6>3. Principales hallazgos del proceso de diagnóstico en relación al análisis de las expectativas planteadas por todos los sectores.</h6>
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				<div class="md-form">
					<div class="error-message">					
						<i class="fas fa-comment prefix"></i>
						<textarea id="PRY_PrincipalesHallazgosDiagnostico" name="PRY_PrincipalesHallazgosDiagnostico" class="md-textarea form-control" rows="3" <%=disabled%>><%=PRY_PrincipalesHallazgosDiagnostico%></textarea>
						<span class="select-bar"></span><%
						if(PRY_PrincipalesHallazgosDiagnostico<>"") then
							clase="active"
						else
							clase=""
						end if%>
						<label for="PRY_PrincipalesHallazgosDiagnostico" class="<%=clase%>">Principales hallazgos</label>
					</div>
				</div>
			</div>
		</div>
		<div class="row">		
			<div class="footer"><%
				if mode="mod" then%>				
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s3" name="btn_frm11s3"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="3">
					<input type="hidden" id="PRY_Hito" value="1" name="PRY_Hito"><%
				else%>				
					<button type="button" class="btn <%=btnColorA%> btn-md waves-effect waves-dark" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
					<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
				end if%>
			</div>			
		</div>						
	</form>
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
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
		var tables = $.fn.dataTable.fnTables(true);
		$(tables).each(function () {
			$(this).dataTable().fnDestroy();				
		});	
		porejecutarTable = $('#tbl-porejecutar').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		ejecutadasTable = $('#tbl-ejecutadas').DataTable({
			lengthMenu: [ 5,10,20 ],
		});
		
		$("#btn_frm11s3").click(function(){
			formValidate("#frm11s3")
			if($("#frm11s3").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);
				$.ajax({
					type: 'POST',			
					url: $("#frm11s3").attr("action"),
					data: $("#frm11s3").serialize(),
					success: function(data) {						
						param=data.split(bb);						
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Análisis grabados correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:1};
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
								title: 'Ups!, no pude grabar los datos del proyecto'								
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
		});		
	});
</script>