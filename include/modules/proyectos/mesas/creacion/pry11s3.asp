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
		action="/mod-11-h0-s3"
		checkbox="required"
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
		mode="vis"
		modo=4
		disabled="readonly disabled"
	end if
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBoton="<i class='fas fa-forward'></i>"
		btnColor="btn-secondary"
		checkbox="disabled"
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
			PRY_Identificador=rs("PRY_Identificador")
			PRY_EncargadoProyecto=rs("PRY_EncargadoProyecto")
			PRY_EncargadoProyectoMail=rs("PRY_EncargadoProyectoMail")			
			PRY_EncargadoProyectoCelular=rs("PRY_EncargadoProyectoCelular")
			SEX_IdEncargadoProyecto=rs("SEX_IdEncargadoProyecto")
			
			PRY_EncargadoActividades=rs("PRY_EncargadoActividades")
			PRY_EncargadoActividadesMail=rs("PRY_EncargadoActividadesMail")
			PRY_EncargadoActividadesCelular=rs("PRY_EncargadoActividadesCelular")
			SEX_IdEncargadoActividades=rs("SEX_IdEncargadoActividades")
			
			
			EDU_IdEncargadoProyecto=rs("EDU_IdEncargadoProyecto")
			PRY_EncargadoProyectoCarrera=rs("PRY_EncargadoProyectoCarrera")

			EDU_IdEncargadoActividades=rs("EDU_IdEncargadoActividades")
			PRY_EncargadoActividadesCarrera=rs("PRY_EncargadoActividadesCarrera")

			PRY_Facilitador=rs("PRY_Facilitador")
			PRY_FacilitadorMail=rs("PRY_FacilitadorMail")
			PRY_FacilitadorCelular=rs("PRY_FacilitadorCelular")
			SEX_IdFacilitador=rs("SEX_IdFacilitador")
			PRY_FacilitadorCarrera=rs("PRY_FacilitadorCarrera")
			EDU_IdFacilitador=rs("EDU_IdFacilitador")
			PRY_FacilitidorForEsp=rs("PRY_FacilitidorForEsp")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
%>
<form role="form" action="<%=action%>" method="POST" name="frm11s3" id="frm11s3" class="needs-validation">
	<h5>Responsables del proyecto</h5>
	<h6>Coordinador/a de proyecto</h6>
	<div class="row align-items-center"> 
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_EncargadoProyecto" name="PRY_EncargadoProyecto" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyecto%>"><%
					else%>
						<input type="text" id="PRY_EncargadoProyecto" name="PRY_EncargadoProyecto" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyecto<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyecto" class="<%=lblClass%>">Nombre</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-envelope input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="email" id="PRY_EncargadoProyectoMail" name="PRY_EncargadoProyectoMail" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyectoMail%>"><%
					else%>
						<input type="email" id="PRY_EncargadoProyectoMail" name="PRY_EncargadoProyectoMail" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyectoMail<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyectoMail" class="<%=lblClass%>">Correo electrónico</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: left;">			
			<label for="SEX_IdEncargadoProyecto" class="radiolabel">Sexo</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdEncargadoProyecto=1) or (IsNULL(SEX_IdEncargadoProyecto)) then%>
					<input id="SEX_IdEncargadoProyectofemenino" type="radio" name="SEX_IdEncargadoProyecto" checked value="1" <%=checkbox%>><%
				else%>
					<input id="SEX_IdEncargadoProyectofemenino" type="radio" name="SEX_IdEncargadoProyecto" value="1" <%=checkbox%>><%
				end if%>
				<label for="SEX_IdEncargadoProyectofemenino">Femenino</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdEncargadoProyecto=2) then%>
					<input id="SEX_IdEncargadoProyectomasculino" type="radio" name="SEX_IdEncargadoProyecto" checked value="2" <%=checkbox%>><%
				else%>
					<input id="SEX_IdEncargadoProyectomasculino" type="radio" name="SEX_IdEncargadoProyecto" value="2" <%=checkbox%>><%
				end if%>
				<label for="SEX_IdEncargadoProyectomasculino">Masculino</label>
			</div>			
		</div>
	</div>	
	<div class="row" style="padding-bottom:30px;"> 				
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-mobile-alt input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="number" id="PRY_EncargadoProyectoCelular" name="PRY_EncargadoProyectoCelular" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyectoCelular%>"><%
					else%>
						<input type="number" id="PRY_EncargadoProyectoCelular" name="PRY_EncargadoProyectoCelular" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyectoCelular<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyectoCelular" class="<%=lblClass%>">Teléfono</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="EDU_IdEncargadoProyecto" id="EDU_IdEncargadoProyecto" class="validate select-text form-control" <%=disabled%>>
							<option value="" disabled selected></option><%													
							set rx = cnn.Execute("exec spEducacion_Listar")
							on error resume next					
							do While Not rx.eof
								if(EDU_IdEncargadoProyecto=rx("EDU_Id")) then%>
									<option value="<%=rx("EDU_Id")%>" selected><%=rx("EDU_Nombre")%></option><%
								else%>
									<option value="<%=rx("EDU_Id")%>"><%=rx("EDU_Nombre")%></option><%
								end if								
								rx.movenext						
							loop
							rx.Close%>
						</select>														
						<i class="fas fa-user-graduate input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Nivel Educacional</label>
					</div>
				</div>	
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-6">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_EncargadoProyectoCarrera" name="PRY_EncargadoProyectoCarrera" class="form-control" <%=disabled%> value="<%=PRY_EncargadoProyectoCarrera%>"><%
					else%>
						<input type="text" id="PRY_EncargadoProyectoCarrera" name="PRY_EncargadoProyectoCarrera" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_EncargadoProyectoCarrera<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_EncargadoProyectoCarrera" class="<%=lblClass%>">Nombre Carrera</label>									
				</div>
			</div>
		</div>
	</div>	
	
	<h6>Facilitador/a</h6>
	<div class="row align-items-center"> 		
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_Facilitador" name="PRY_Facilitador" class="form-control" <%=disabled%> value="<%=PRY_Facilitador%>"><%
					else%>
						<input type="text" id="PRY_Facilitador" name="PRY_Facilitador" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_Facilitador<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_Facilitador" class="<%=lblClass%>">Nombre</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-envelope input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>										
						<input type="email" id="PRY_FacilitadorMail" name="PRY_FacilitadorMail" class="form-control" <%=disabled%> value="<%=PRY_FacilitadorMail%>"><%
					else%>
						<input type="email" id="PRY_FacilitadorMail" name="PRY_FacilitadorMail" class="form-control" <%=disabled%> value="<%=%>"><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_FacilitadorMail<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_FacilitadorMail" class="<%=lblClass%>">Correo electrónico</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: left;">			
			<label for="SEX_IdFacilitador" class="radiolabel">Sexo</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdFacilitador=1) or (IsNULL(SEX_IdFacilitador)) then%>
					<input id="SEX_IdFacilitadorfemenino" type="radio" name="SEX_IdFacilitador" checked <%=checkbox%> value=1><%
				else%>
					<input id="SEX_IdFacilitadorfemenino" type="radio" name="SEX_IdFacilitador" <%=checkbox%> value=1><%
				end if%>
				<label for="SEX_IdFacilitadorfemenino">Femenino</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(SEX_IdFacilitador=2) then%>
					<input id="SEX_IdFacilitadormasculino" type="radio" name="SEX_IdFacilitador" checked <%=checkbox%> value="2"><%
				else%>
					<input id="SEX_IdFacilitadormasculino" type="radio" name="SEX_IdFacilitador" <%=checkbox%> value="2"><%
				end if%>
				<label for="SEX_IdFacilitadormasculino">Masculino</label>
			</div>			
		</div>
	</div>	
	<div class="row align-items-center" style="padding-bottom:30px;"> 				
		<div class="col-sm-12 col-md-2 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-mobile-alt input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="number" id="PRY_FacilitadorCelular" name="PRY_FacilitadorCelular" class="form-control" <%=disabled%> value="<%=PRY_FacilitadorCelular%>"><%
					else%>
						<input type="number" id="PRY_FacilitadorCelular" name="PRY_FacilitadorCelular" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_FacilitadorCelular<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_FacilitadorCelular" class="<%=lblClass%>">Teléfono</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<div class="select">
						<select name="EDU_IdFacilitador" id="EDU_IdFacilitador" class="validate select-text form-control" <%=disabled%>>
							<option value="" disabled selected></option><%													
							set rx = cnn.Execute("exec spEducacion_Listar")
							on error resume next					
							do While Not rx.eof
								if(EDU_IdFacilitador=rx("EDU_Id")) then%>
									<option value="<%=rx("EDU_Id")%>" selected><%=rx("EDU_Nombre")%></option><%
								else%>
									<option value="<%=rx("EDU_Id")%>"><%=rx("EDU_Nombre")%></option><%
								end if
								rx.movenext						
							loop
							rx.Close%>
						</select>														
						<i class="fas fa-user-graduate input-prefix"></i>
						<span class="select-highlight"></span>
						<span class="select-bar"></span>
						<label class="select-label <%=lblSelect%>">Nivel Educacional</label>
					</div>
				</div>	
			</div>
		</div>	
		<div class="col-sm-12 col-md-3 col-lg-3">
			<div class="md-form input-with-post-icon">
				<div class="error-message">								
					<i class="fas fa-user input-prefix"></i><%
					if(mode="mod" or mode="vis") then%>
						<input type="text" id="PRY_FacilitadorCarrera" name="PRY_FacilitadorCarrera" class="form-control" <%=disabled%> value="<%=PRY_FacilitadorCarrera%>"><%
					else%>
						<input type="text" id="PRY_FacilitadorCarrera" name="PRY_FacilitadorCarrera" class="form-control" <%=disabled%>><%
					end if%>
					<span class="select-bar"></span><%
					if PRY_FacilitadorCarrera<>"" then
						lblClass="active"
					end if%>
					<label for="PRY_FacilitadorCarrera" class="<%=lblClass%>">Nombre Carrera</label>									
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-lg-4" style="text-align: left;">			
			<label for="PRY_FacilitidorForEsp" class="radiolabel">Formación Especializada</label>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(PRY_FacilitidorForEsp=1) or (IsNULL(PRY_FacilitidorForEsp)) then%>
					<input id="PRY_FacilitidorForEspSI" type="radio" name="PRY_FacilitidorForEsp" checked value="1" <%=checkbox%>><%
				else%>
					<input id="PRY_FacilitidorForEspSI" type="radio" name="PRY_FacilitidorForEsp" value="1" <%=checkbox%>><%
				end if%>
				<label for="PRY_FacilitidorForEspSI">Si</label>
			</div>
			<div class="md-radio radio-lightBlue md-radio-inline"><%
				if(PRY_FacilitidorForEsp=2) then%>
					<input id="PRY_FacilitidorForEspNO" type="radio" name="PRY_FacilitidorForEsp" checked value="2" <%=checkbox%>><%
				else%>
					<input id="PRY_FacilitidorForEspNO" type="radio" name="PRY_FacilitidorForEsp" value="2" <%=checkbox%>><%
				end if%>
				<label for="PRY_FacilitidorForEspNO">No</label>
			</div>			
		</div>
	</div>

	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />	
	<input type="hidden" id="Step" name="Step" value="3" />	
</form>

<div class="row">		
	<div class="footer"><%
		if mode="mod" or mode="add" then%>		
			<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s3" name="btn_frm11s3"><%=txtBoton%></button><%
		else%>
			<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBoton%></button><%
		end if%>
	</div>		
</div>
	
<script>
	var relpryTable;
	var bb = String.fromCharCode(92) + String.fromCharCode(92);
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
								title: 'Responsables del proyecto grabados correctamente'
							});
							var modo = <%=modo%>;
							var PRY_Id = <%=PRY_Id%>;
							if(modo==1){
								PRY_Id=param[1];
								modo=2;
							}
							var data   = {modo:modo,PRY_Id:PRY_Id,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};
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
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}			
		});					
		
		$("#tbl-relpry").on("click",".delrel",function(){
			var RLP_Id = $(this).data("id");
			swalWithBootstrapButtons.fire({
				  title: '¿Estas seguro?',
				  text: "¿Deseas Eliminar este relator del proyecto?",
				  icon: 'warning',
				  showCancelButton: true,
				  confirmButtonColor: '#3085d6',
				  cancelButtonColor: '#d33',
				  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar!',
				  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
				}).then((result) => {
				  if (result.value) {				  
						$.ajax({
							type: 'POST',			
							url: '/eliminar-relator-proyecto',
							data: {RLP_Id:RLP_Id},
							success: function(data) {						
								param=data.split(sas);						
								if(param[0]=="200"){
									$("#frm11s3_1")[0].reset()
									relpryTable.ajax.reload();
									Toast.fire({
										icon: 'success',
										title: 'Relator eliminad del proyecto correctamente'
									});
								}else{
									Toast.fire({
										icon: 'error',
										title: param[1]
									});
								}
							}
						})
					}
				})
			
		})
		
	});
</script>