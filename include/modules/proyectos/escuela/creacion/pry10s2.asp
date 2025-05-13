<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")	
	
	disabled=""
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
		action="/mod-10-h0-s2"
		columns="{data: ""GFM_Id""},{data: ""NAC_Nombre""},{data: ""SEX_Descripcion""},{data: ""EDU_Nombre""},{data: ""TDI_Nombre""},{data: ""RUB_Nombre""},{data: ""TTR_Nombre""},{data: ""TRE_Descripcion""},{className: 'delgrpmulsel',orderable: false,data: ""Del""}"
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
		columns="{data: ""GFM_Id""},{data: ""NAC_Nombre""},{data: ""SEX_Descripcion""},{data: ""EDU_Nombre""},{data: ""TDI_Nombre""},{data: ""RUB_Nombre""},{data: ""TTR_Nombre""},{data: ""TRE_Descripcion""}"
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
			PRY_InformeInicioFecha=rs("PRY_InformeInicioFecha")
			PRY_InformeParcialFecha=rs("PRY_InformeParcialFecha")
			PRY_InformeFinalFecha=rs("PRY_InformeFinalFecha")
			PRY_InformeInicioFechaOriginal=rs("PRY_InformeInicioFechaOriginal")
			PRY_InformeParcialFechaOriginal=rs("PRY_InformeParcialFechaOriginal")
			PRY_InformeFinalFechaOriginal=rs("PRY_InformeFinalFechaOriginal")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		rs.close

		sqly = "spGruposFocalizacionxProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sqly)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg & "-" & sqly)
		   response.End() 			   
		end if
		if not rs.eof then
			GRF_Id 							= rs("GRF_Id")
			GRF_Porcentaje					= rs("GRF_Porcentaje")
			GRF_Discapacidad				= rs("GRF_Discapacidad")
			GRF_AccesoInternet 				= rs("GRF_AccesoInternet")
			GRF_DispositivoElectronico 		= rs("GRF_DispositivoElectronico")
			GRF_PuebloOriginario			= rs("GRF_PuebloOriginario")
			GRF_PerteneceSindicato			= rs("GRF_PerteneceSindicato")
			GRF_PermisoSindical				= rs("GRF_PermisoSindical")
			GRF_DirigenteSindical			= rs("GRF_DirigenteSindical")
			GRF_CursoSindical				= rs("GRF_CursoSindical")
			GRF_CargoDirectivoOrganizacion	= rs("GRF_CargoDirectivoOrganizacion")
		else
			'Se agrega nuevo registro en blanco cuando no existe
			GRF_Discapacidad				= 0
			GRF_AccesoInternet 				= 0
			GRF_DispositivoElectronico 		= 0
			GRF_PuebloOriginario			= 0
			GRF_PerteneceSindicato			= 0
			GRF_PermisoSindical				= 0
			GRF_DirigenteSindical			= 0
			GRF_CursoSindical				= 0
			GRF_CargoDirectivoOrganizacion	= 0
			GRF_Porcentaje					= "NULL"

			sqlx = "spGruposFocalizacion_Agregar " & PRY_Id & "," & GRF_Discapacidad & "," & GRF_AccesoInternet & "," & GRF_DispositivoElectronico & "," & GRF_PuebloOriginario & "," & GRF_PerteneceSindicato & "," & GRF_PermisoSindical & "," & GRF_DirigenteSindical & "," & GRF_CursoSindical & "," & GRF_CargoDirectivoOrganizacion & "," & GRF_Porcentaje & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

			set rs = cnn.Execute(sqlx)
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description	   
				cnn.close
				response.Write("503/@/Error Conexión:" & ErrMsg & "-" & sqlx)
				response.End() 			   
			end if
			if not rs.eof then
				GRF_Id = rs("GRF_Id")
			else
				GRF_Id = 0
			end if
		end if
		if(GRF_Discapacidad=1) then
			GRF_DiscCHK = "checked "
		else
			GRF_DiscCHK = ""
		end if
		if(GRF_AccesoInternet=1) then
			GRF_AccCHK = "checked "
		else
			GRF_AccCHK = ""
		end if
		if(GRF_DispositivoElectronico=1) then
			GRF_DispCHK = "checked "
		else
			GRF_DispCHK = ""
		end if
		if(GRF_PuebloOriginario=1) then
			GRF_PuebloCHK = "checked "
		else
			GRF_PuebloCHK = ""
		end if
		if(GRF_PerteneceSindicato=1) then
			GRF_SindCHK = "checked "
		else
			GRF_SindCHK = ""
		end if
		if(GRF_PermisoSindical=1) then
			GRF_PermCHK = "checked "
		else
			GRF_PermCHK = ""
		end if
		if(GRF_DirigenteSindical=1) then
			GRF_DirgCHK = "checked "
		else
			GRF_DirgCHK = ""
		end if
		if(GRF_CursoSindical=1) then
			GRF_CursoCHK = "checked "
		else
			GRF_CursoCHK = ""
		end if
		if(GRF_CargoDirectivoOrganizacion=1) then
			GRF_CargoCHK = "checked "
		else
			GRF_CargoCHK = ""
		end if
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
%>
<form role="form" action="<%=action%>" method="POST" name="frm10s2" id="frm10s2" class="needs-validation">
	<h5>Focalización de Beneficiarios</h5>
	<h6>Seleción de grupos focales (Si/No)</h6>
	<div class="row" style="padding-bottom:40px;padding-top:40px;">		
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_Discapacidad" class="switch__input" <%=GRF_DiscCHK%> <%=disabled%>>
				<label for="GRF_Discapacidad" class="switch__label">Discapacidad</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_AccesoInternet" class="switch__input" <%=GRF_AccCHK%> <%=disabled%>>
				<label for="GRF_AccesoInternet" class="switch__label">Acceso a Internet</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_PuebloOriginario" class="switch__input" <%=GRF_PuebloCHK%> <%=disabled%>>
				<label for="GRF_PuebloOriginario" class="switch__label">Pueblo Originario</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_PerteneceSindicato" class="switch__input" <%=GRF_SindCHK%> <%=disabled%>>
				<label for="GRF_PerteneceSindicato" class="switch__label">Pertenece Sindicato</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_PermisoSindical" class="switch__input" <%=GRF_PermCHK%> <%=disabled%>>
				<label for="GRF_PermisoSindical" class="switch__label">Permiso Sindical</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_DirigenteSindical" class="switch__input" <%=GRF_DirgCHK%> <%=disabled%>>
				<label for="GRF_DirigenteSindical" class="switch__label">Dirigente Sindical</label>
			</div>
		</div>
	</div>
	<div class="row">				
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_CursoSindical" class="switch__input" <%=GRF_CursoCHK%> <%=disabled%>>
				<label for="GRF_CursoSindical" class="switch__label">Curso Sindical</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="switch">
				<input type="checkbox" id="GRF_CargoDirectivoOrganizacion" class="switch__input" <%=GRF_CargoCHK%> <%=disabled%>>
				<label for="GRF_CargoDirectivoOrganizacion" class="switch__label">Cargo Directivo</label>
			</div>
		</div>
		<div class="col-sm-12 col-md-6 col-lg-6">
		</div>
		<div class="col-sm-12 col-md-6 col-lg-2">
			<div class="md-form input-with-post-icon">
				<div class="error-message">
					<i class="fas fa-percentage input-prefix"></i>											
					<input type="number" id="GRF_Porcentaje" name="GRF_Porcentaje" class="form-control" value="<%=GRF_Porcentaje%>" min="0" max="100" <%=disabled%>>
					<span class="select-bar"></span><%
					if(GRF_Porcentaje<>"") then%>
						<label for="GRF_Porcentaje" class="active">Porcentaje</label><%
					else%>
						<label for="GRF_Porcentaje">Porcentaje</label><%
					end if%>
				</div>
			</div>
		</div>
	</div>
	<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>" />
	<input type="hidden" id="LIN_DiasCierreInformeParcial" name="LIN_DiasCierreInformeParcial" value="<%=LIN_DiasCierreInformeParcial%>" />
	<input type="hidden" id="LIN_DiasCierreInformeFinal" name="LIN_DiasCierreInformeFinal" value="<%=LIN_DiasCierreInformeFinal%>" />
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	<input type="hidden" id="GRF_Id" name="GRF_Id" value="<%=GRF_Id%>" />
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>" />
	<input type="hidden" id="Step" name="Step" value="2" />	
</form><%
if(mode="mod") then%>
	<form role="form" method="POST" action="/agregar-grupo-focal-multiseleccion" name="frm10s2_1" id="frm10s2_1" class="needs-validation">
		<h6>Incorporar Grupos (Multiselección)</h6>
		<div class="row">
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="NAC_Id" id="NAC_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todas</option><%
								set rs = cnn.Execute("exec spNacionalidad_Listar")
								on error resume next					
								do While Not rs.eof%>
									<option value="<%=rs("NAC_Id")%>"><%=rs("NAC_Nombre")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>
							<i class="fas fa-globe-americas input-prefix"></i>											
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Nacionalidad</label>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="SEX_Id" id="SEX_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todos</option><%
								set rs = cnn.Execute("exec spSexo_listar")
								on error resume next					
								do While Not rs.eof%>																			
									<option value="<%=rs("SEX_Id")%>"><%=rs("SEX_Descripcion")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>									
							<i class="fas fa-venus-mars input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Sexo</label>
						</div>
					</div>	
				</div>
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="EDU_Id" id="EDU_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todos</option><%
								set rs = cnn.Execute("exec spEducacion_Listar")
								on error resume next					
								do While Not rs.eof%>
									<option value="<%=rs("EDU_Id")%>"><%=rs("EDU_Nombre")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>														
							<i class="fas fa-user-graduate input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Nivel Educacional</label>
						</div>
					</div>	
				</div>
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="TDI_Id" id="TDI_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todas</option><%													
								set rs = cnn.Execute("exec [spTipoDiscapacidad_Listar] 1")
								on error resume next					
								do While Not rs.eof%>
									<option value="<%=rs("TDI_Id")%>"><%=rs("TDI_Nombre")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>																
							<i class="fas fa-wheelchair input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Tipo Discapacidad</label>
						</div>
					</div>	
				</div>
			</div>
			<div class="col-sm-12 col-md-4 col-lg-4">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="RUB_Id" id="RUB_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todos</option><%													
								set rs = cnn.Execute("spRubro_Listar 1")
								on error resume next
								do While Not rs.eof%>
									<option value="<%=rs("RUB_Id")%>"><%=rs("RUB_Nombre")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>															
							<i class="fas fa-shapes input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Rubro</label>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="padding-bottom:40px;">
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="TTR_Id" id="TTR_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todos</option><%													
								set rs = cnn.Execute("spTipoTrabajador_Listar 1")
								on error resume next					
								do While Not rs.eof%>
									<option value="<%=rs("TTR_Id")%>"><%=rs("TTR_Nombre")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>															
							<i class="fas fa-briefcase input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Tipo de Trabajador</label>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-2 col-lg-2">
				<div class="md-form input-with-post-icon">
					<div class="error-message">
						<div class="select">
							<select name="TRE_Id" id="TRE_Id" class="validate select-text form-control">
								<option value="NULL" selected>Todos</option><%													
								set rs = cnn.Execute("[spTramoEtario_Listar] 1")
								on error resume next					
								do While Not rs.eof%>
									<option value="<%=rs("TRE_Id")%>"><%=rs("TRE_Descripcion")%></option><%
									rs.movenext						
								loop
								rs.Close%>
							</select>															
							<i class="fas fa-briefcase input-prefix"></i>
							<span class="select-highlight"></span>
							<span class="select-bar"></span>
							<label class="select-label <%=lblSelect%>">Tramo Etario</label>
						</div>
					</div>
				</div>
			</div>
			<div class="col align-self-end">
				<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm10s2_1" name="btn_frm10s2_1" style="float: right;"><i class="fas fa-plus"></i></button>
			</div>
		</div>
		<input type="hidden" id="GRF_Id" name="GRF_Id" value="<%=GRF_Id%>" />
		<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />
	</form><%
end if%>

<h6>Grupos incorporados (Multiselección)</h6>
<div class="row" style="padding-top:20px">		
	<div class="col-12">
		<table id="tbl-grpmulsel" class="ts table table-striped table-bordered dataTable table-sm" data-id="grpmulsel" data-page="true" data-selected="true" data-keys="1"> 
			<thead> 
				<tr> 
					<th style="width:10px;">Id</th>
					<th>Nacionalidad</th>
					<th>Sexo</th>
					<th>Educación</th>
					<th>Discapacidad</th>
					<th>Rubro</th>
					<th>Trabajador</th>
					<th>Tramo Etario</th><%
					if(mode="mod") then%>
						<th>Eliminar</th><%
					end if%>
				</tr> 
			</thead>					
			<tbody> 
			<%
				sq = "exec [spGruposFocalizacionMultiseleccion_Listar] " & GRF_Id 
				set rs=cnn.execute(sq)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
					'response.write ErrMsg & "-" & sq
					cnn.close 			   
					Response.end()
				End If
				dataGrpMultiSelect = "["
				do While Not rs.EOF
					discapacidad = rs("TDI_Nombre")
					if(GRF_Discapacidad=1 and (discapacidad="" or isnull(discapacidad) or discapacidad="Ninguna")) then
						discapacidad="Todas"
					else
					end if
					
					if(mode="mod") then
						dataGrpMultiSelect = dataGrpMultiSelect & "{""GFM_Id"":""" & rs("GFM_Id") & """,""NAC_Nombre"":""" & rs("NAC_Nombre") & """,""SEX_Descripcion"":""" & rs("SEX_Descripcion") & """,""EDU_Nombre"":""" & rs("EDU_Nombre") & """,""TDI_Nombre"":""" & discapacidad & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""TTR_Nombre"":""" & rs("TTR_Nombre") & """,""TRE_Descripcion"":""" & rs("TRE_Descripcion") & """,""Del"":""<i class='fas fa-trash-alt text-danger' data-GFM='" & rs("GFM_Id") & "' data-pry='" & PRY_Id & "' data-grf='" & rs("GRF_Id") & "'></i>"""
					else
						dataGrpMultiSelect = dataGrpMultiSelect & "{""GFM_Id"":""" & rs("GFM_Id") & """,""NAC_Nombre"":""" & rs("NAC_Nombre") & """,""SEX_Descripcion"":""" & rs("SEX_Descripcion") & """,""EDU_Nombre"":""" & rs("EDU_Nombre") & """,""TDI_Nombre"":""" & rs("TDI_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""TTR_Nombre"":""" & rs("TTR_Nombre") & """,""TRE_Descripcion"":""" & rs("TRE_Descripcion") & """"
					end if
					dataGrpMultiSelect = dataGrpMultiSelect & "}"											
					rs.movenext
					if not rs.eof then
						dataGrpMultiSelect = dataGrpMultiSelect & ","
					end if
				loop
				dataGrpMultiSelect=dataGrpMultiSelect & "]"								
				rs.close											
			%>                	
			</tbody>
		</table>
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
	
<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var bb = String.fromCharCode(92) + String.fromCharCode(92);	

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
		var grpmulselTable;
		var dataGrpMultiSelect = <%=dataGrpMultiSelect%>
		loadTableGrpFocalMulti(dataGrpMultiSelect);
        $('#tbl-grpmulsel').css('width','100%')
		
		function loadTableGrpFocalMulti(data) {
			grpmulselTable = $('#tbl-grpmulsel').DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columns%>],
				order: [
					[0, 'asc']
				]			
			});						
		}		

		$("#btn_frm10s2").click(function(){
			formValidate("#frm10s2")
			if($("#frm10s2").valid()){
				var bb = String.fromCharCode(92) + String.fromCharCode(92);				
				if($("#GRF_Discapacidad").is(":checked")){
					var GRF_Discapacidad = 1
				}else{
					var GRF_Discapacidad = 0
				}
				if($("#GRF_AccesoInternet").is(":checked")){
					var GRF_AccesoInternet = 1
				}else{
					var GRF_AccesoInternet = 0
				}				
				var GRF_DispositivoElectronico = 0				
				if($("#GRF_PuebloOriginario").is(":checked")){
					var GRF_PuebloOriginario = 1
				}else{
					var GRF_PuebloOriginario = 0
				}
				if($("#GRF_PerteneceSindicato").is(":checked")){
					var GRF_PerteneceSindicato = 1
				}else{
					var GRF_PerteneceSindicato = 0
				}
				if($("#GRF_PermisoSindical").is(":checked")){
					var GRF_PermisoSindical = 1
				}else{
					var GRF_PermisoSindical = 0
				}
				if($("#GRF_DirigenteSindical").is(":checked")){
					var GRF_DirigenteSindical = 1
				}else{
					var GRF_DirigenteSindical = 0
				}
				if($("#GRF_CursoSindical").is(":checked")){
					var GRF_CursoSindical = 1
				}else{
					var GRF_CursoSindical = 0
				}
				if($("#GRF_CargoDirectivoOrganizacion").is(":checked")){
					var GRF_CargoDirectivoOrganizacion = 1
				}else{
					var GRF_CargoDirectivoOrganizacion = 0
				}
				$.ajax({
					type: 'POST',			
					url: $("#frm10s2").attr("action"),
					data: $("#frm10s2").serialize() + "&GRF_Discapacidad=" + GRF_Discapacidad + "&GRF_AccesoInternet=" + GRF_AccesoInternet + "&GRF_DispositivoElectronico=" + GRF_DispositivoElectronico + "&GRF_PuebloOriginario=" + GRF_PuebloOriginario + "&GRF_PerteneceSindicato=" + GRF_PerteneceSindicato + "&GRF_PermisoSindical=" + GRF_PermisoSindical + "&GRF_DirigenteSindical=" + GRF_DirigenteSindical + "&GRF_CursoSindical=" + GRF_CursoSindical + "&GRF_CargoDirectivoOrganizacion=" + GRF_CargoDirectivoOrganizacion,
					success: function(data) {
						param=data.split(bb)
						if(param[0]=="200"){
							Toast.fire({
							  icon: 'success',
							  title: 'Grupos focales grabados correctamente'
							});
							var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:0};							
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

		$("#btn_frm10s2_1").click(function(){
			var validate = false;
			formValidate("#frm10s2_1")
			if($("#frm10s2_1").valid()){
				$('#frm10s2_1  *').filter(':input.select-text').each(function(i,e){
					console.log($(e)[0].id, $(e).val())
					if($(e).val()!='NULL'){
						validate=true;
						return false;
					}
				});
				if(validate){
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm10s2_1").attr("action"),
						data: $("#frm10s2_1").serialize(),
						success: function(data) {
							param=data.split(bb)
							grpmulselTable.clear().draw();
							grpmulselTable.rows.add(jQuery.parseJSON(param[1])).draw();
							if(param[0]=="200"){
								$("#frm10s2_1")[0].reset();
								Toast.fire({
								icon: 'success',
								title: 'Grupo focal multiselección grabado correctamente'
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
						title: 'Debes seleccionar al menos una opción para grabar el registro'
					});
				}
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})

		$("#pry-content").on("click",".delgrpmulsel",function(e){
			e.preventDefault();
			e.stopPropagation();
			var GFM_Id = $(this).find("i").data("gfm");	
			var GRF_Id = $(this).find("i").data("grf");	
			var PRY_Id = $(this).find("i").data("pry");
			var PRY_Identificador = $("#PRY_Identificador").val();
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará el grupo focal seleccionado",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
			}).then((result) => {
			  if (result.value) {			
					$.ajax({
						type: 'POST',			
						url: '/elimina-grupo-focal-multiseleccion',
						data: {PRY_Id:PRY_Id, GFM_Id:GFM_Id, GRF_Id:GRF_Id, PRY_Identificador:PRY_Identificador},
						success: function(data) {					
							param=data.split(bb);							
							if(param[0]=="200"){
								grpmulselTable.clear().draw();
								grpmulselTable.rows.add(jQuery.parseJSON(param[1])).draw();
								Toast.fire({
								  icon: 'success',
								  title: 'Grupo focal eliminado correctamente'
								});							
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'ERROR!',
									text:'No se pudo eliminar la acción seleccionada.'
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

		$("#GRF_Discapacidad").on("change", function(e){
			e.preventDefault();
			e.stopPropagation();
			if($("#GRF_Discapacidad").is(":checked")){				
				$($("#TDI_Id").parent().parent().parent().parent()).show("slow");
			}else{
				$($("#TDI_Id").parent().parent().parent().parent()).hide("slow");
			}			
		})

		if($("#GRF_Discapacidad").is(":checked")){			
			$($("#TDI_Id").parent().parent().parent().parent()).show("slow");
		}else{
			$($("#TDI_Id").parent().parent().parent().parent()).hide("slow");
		}
	});
</script>