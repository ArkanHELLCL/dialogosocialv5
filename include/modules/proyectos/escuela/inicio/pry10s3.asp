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
		action="/mod-10-h1-s3"

		columns="{data: ""GFM_Id""},{data: ""NAC_Nombre""},{data: ""SEX_Descripcion""},{data: ""EDU_Nombre""},{data: ""TDI_Nombre""},{data: ""RUB_Nombre""},{data: ""TTR_Nombre""},{data: ""TRE_Descripcion""}"
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
			LIN_Hombre=rs("LIN_Hombre")
			LIN_Mujer=rs("LIN_Mujer")
			PRY_CantPostuHombre=rs("PRY_CantPostuHombre")
			PRY_CantPostuMujer=rs("PRY_CantPostuMujer")
			
			Total = PRY_CantPostuMujer + PRY_CantPostuHombre
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if
		
		'Primer tab
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
		end if
		if(GRF_Id="") then
			GRF_Id=0
		end if
		if(GRF_Porcentaje="" or IsNULL(GRF_Porcentaje)) then
			GRF_Porcentaje=0
		end if
		if(GRF_Discapacidad=1) then
			GRF_DiscCHK = "checked"
		else
			GRF_DiscCHK = ""
		end if
		if(GRF_AccesoInternet=1) then
			GRF_AccCHK = "checked"
		else
			GRF_AccCHK = ""
		end if
		if(GRF_DispositivoElectronico=1) then
			GRF_DispCHK = "checked"
		else
			GRF_DispCHK = ""
		end if
		if(GRF_PuebloOriginario=1) then
			GRF_PuebloCHK = "checked"
		else
			GRF_PuebloCHK = ""
		end if
		if(GRF_PerteneceSindicato=1) then
			GRF_SindCHK = "checked"
		else
			GRF_SindCHK = ""
		end if
		if(GRF_PermisoSindical=1) then
			GRF_PermCHK = "checked"
		else
			GRF_PermCHK = ""
		end if
		if(GRF_DirigenteSindical=1) then
			GRF_DirgCHK = "checked"
		else
			GRF_DirgCHK = ""
		end if
		if(GRF_CursoSindical=1) then
			GRF_CursoCHK = "checked"
		else
			GRF_CursoCHK = ""
		end if
		if(GRF_CargoDirectivoOrganizacion=1) then
			GRF_CargoCHK = "checked"
		else
			GRF_CargoCHK = ""
		end if
		
		sqlz = "spGruposFocalesconFiltros2016_Listar " & PRY_Id
		set rz = cnn.Execute(sqlz)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg & "-" & sqlz)
		   response.End() 			   
		end if
		if not rz.eof then
			TotalAlumnosFiltrados = rz("TotalAlumnosFiltrados")
			TotalAlumnos = rz("TotalAlumnos")
			PorcentajeMax = rz("PorcentajeMax")
		end if
		if(PorcentajeMax="") then
			PorcentajeMax=0
		end if
		if(TotalAlumnosFiltrados="") then
			TotalAlumnosFiltrados=0
		end if		
		
		'Segundo tab
		set rx = cnn.Execute("Select year(GETDATE()) as Anio, month(GETDATE()) as Mes, day(GETDATE()) as Dia")
		AnioHoy = rx("Anio")
		MesHoy = rx("Mes")
		DiaHoy = rx("Dia")
		
		FechaHoy = AnioHoy & "/" & MesHoy & "/" & DiaHoy
		
		set rs = cnn.Execute("exec [spAlumnoProyectoPostulacion_Listar] " & PRY_Id)
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			cnn.close 			   
			response.Write("503/@/Error Conexión: [spAlumnoProyectoPostulacion_Listar]")
	   		response.End()
		End If
		TotalInscri=0
		PRY_CantInscriMujer=0
		PRY_CantInscriHombre=0
		PRY_CantidadDiscapacidad=0
		PRY_PorInscriHombre=0
		PRY_CantidadExtranjeros=0
		PRY_PorExtranjeros=0
		PRY_PorDiscapacidad=0
		PRY_Tramo1825=0
		PRY_Tramo2635=0
		PRY_Tramo3645=0
		PRY_Tramo4655=0
		PRY_Tramo5665=0
		PRY_Tramo66mas=0		
		PRY_PorTramo1825=0
		PRY_PorTramo2635=0
		PRY_PorTramo3645=0
		PRY_PorTramo4655=0
		PRY_PorTramo5665=0
		PRY_PorTramo66mas=0
		PRY_CantidadDirigente=0
		PRY_PorDirigente=0
		do While Not rs.EOF 
			TotalInscri=TotalInscri+1
			if rs("SEX_Id")=1 then	'Mujer
				PRY_CantInscriMujer=PRY_CantInscriMujer+1
			else
				PRY_CantInscriHombre=PRY_CantInscriHombre+1
			end if
			if rs("NAC_Id")<>1 then
				PRY_CantidadExtranjeros=PRY_CantidadExtranjeros+1			
			end if
			if rs("TDI_Id")<>"" then
				PRY_CantidadDiscapacidad=PRY_CantidadDiscapacidad+1			
			end if
			ALU_FechaNacimiento = replace(rs("ALU_FechaNacimiento"),"-","/")
			if( not IsDate(ALU_FechaNacimiento)) then							
				ALU_FechaNacimiento = substr("ALU_FechaNacimiento",9,2) & "/" & substr("ALU_FechaNacimiento",6,2) & "/" & substr("ALU_FechaNacimiento",1,4)
			end if
			
			Edad = DateDiff("yyyy",ALU_FechaNacimiento,FechaHoy)
			
			if(Edad>=18 and Edad<=25) then	'18-25
				PRY_Tramo1825=PRY_Tramo1825+1
			end if
			if(Edad>=26 and Edad<=35) then	'26-35
				PRY_Tramo2635=PRY_Tramo2635+1
			end if
			if(Edad>=36 and Edad<=45) then	'36-45
				PRY_Tramo3645=PRY_Tramo3645+1
			end if
			if(Edad>=46 and Edad<=55) then	'46-55
				PRY_Tramo4655=PRY_Tramo4655+1
			end if
			if(Edad>=56 and Edad<=65) then	'56-65
				PRY_Tramo5665=PRY_Tramo5665+1
			end if
			if(Edad>=66) then						'66 y mas
				PRY_Tramo66mas=PRY_Tramo66mas+1
			end if
			if(rs("ALU_DirigenteSindical")=1) then
				PRY_CantidadDirigente=PRY_CantidadDirigente+1
			end if
			rs.movenext
		loop
		PRY_PorInscriHombre=(PRY_CantInscriHombre*100)/TotalInscri
		if(PRY_PorInscriHombre<100) and (PRY_PorInscriHombre>0) then
			PRY_PorInscriHombre=FormatNumber(PRY_PorInscriHombre,2)
		end if		
		PRY_PorInscriMujer=(PRY_CantInscriMujer*100)/TotalInscri
		if(PRY_PorInscriMujer<100) and (PRY_PorInscriMujer>0) then
			PRY_PorInscriMujer=FormatNumber(PRY_PorInscriMujer)
		end if
		PRY_PorExtranjeros=(PRY_CantidadExtranjeros*100)/TotalInscri
		if(PRY_PorExtranjeros<100) and (PRY_PorExtranjeros>0) then
			PRY_PorExtranjeros=FormatNumber(PRY_PorExtranjeros)
		end if		
		PRY_PorDiscapacidad=(PRY_CantidadDiscapacidad*100)/TotalInscri
		if(PRY_PorDiscapacidad<100) and (PRY_PorDiscapacidad>0) then
			PRY_PorDiscapacidad=FormatNumber(PRY_PorDiscapacidad)
		end if		
		PRY_PorTramo1825=(PRY_Tramo1825*100)/TotalInscri
		if(PRY_PorTramo1825<100) and (PRY_PorTramo1825>0) then
			PRY_PorTramo1825=FormatNumber(PRY_PorTramo1825,2)
		end if				
		PRY_PorTramo2635=(PRY_Tramo2635*100)/TotalInscri
		if(PRY_PorTramo2635<100) and (PRY_PorTramo2635>0) then
			PRY_PorTramo2635=FormatNumber(PRY_PorTramo2635,2)
		end if		
		PRY_PorTramo3645=(PRY_Tramo3645*100)/TotalInscri
		if(PRY_PorTramo3645<100) and (PRY_PorTramo3645>0) then
			PRY_PorTramo3645=FormatNumber(PRY_PorTramo3645,2)
		end if		
		PRY_PorTramo4655=(PRY_Tramo4655*100)/TotalInscri
		if(PRY_PorTramo4655<100) and (PRY_PorTramo4655>0) then
			PRY_PorTramo4655=FormatNumber(PRY_PorTramo4655,2)
		end if		
		PRY_PorTramo5665=(PRY_Tramo5665*100)/TotalInscri
		if(PRY_PorTramo5665<100) and (PRY_PorTramo5665>0) then
			PRY_PorTramo5665=FormatNumber(PRY_PorTramo5665,2)
		end if		
		PRY_PorTramo66mas=(PRY_Tramo66mas*100)/TotalInscri
		if(PRY_PorTramo66mas<100) and (PRY_PorTramo66mas>0) then
			PRY_PorTramo66mas=FormatNumber(PRY_PorTramo66mas,2)
		end if	
		PRY_PorDirigente=(PRY_CantidadDirigente*100)/TotalInscri
		if(PRY_PorDirigente<100) and (PRY_PorDirigente>0) then
			PRY_PorDirigente=FormatNumber(PRY_PorDirigente,2)
		end if

		if(TotalAlumnos="") then
			TotalAlumnos=TotalInscri
		end if
		'PorcentajeFil = round((TotalAlumnosFiltrados*100)/TotalAlumnos,0)
		PorcentajeFil = round((TotalAlumnosFiltrados/TotalAlumnos)*100,0)
	end if	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.write("mode-" & mode)
	'response.end
%>
<div class="row">
	<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Focalización de Beneficiarios</h5>
	
	<!--container-nav-->
	<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
		<div class="header">				
			<div class="content-nav">
				<a id="grpfoc-tab" href="#grpfoctab1" class="active tab"><i class="fas fa-users"></i> Grupos Focales					
				</a>
				<a id="estadis-tab" href="#estadistab1" class="active tab"><i class="fas fa-users"></i> Estadísticas						
				</a>
				<span class="yellow-bar"></span>
			</div>
		</div>
		<div class="tab-content">
			<div id="grpfoctab1">
				<h5 style="padding-top:20px">Grupos Focales</h5>
				<h6 style="padding-top:10px">Porcentaje mínimo a cumplir : <%=GRF_Porcentaje%>%</h6>
				<div class="row" style="padding-bottom:40px;padding-top:40px;"><%
					if(GRF_DiscCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_Discapacidad" class="switch__input" <%=GRF_DiscCHK%> disabled readonly>
								<label for="GRF_Discapacidad" class="switch__label">Discapacidad</label>
							</div>
						</div><%
					end if
					if(GRF_AccCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_AccesoInternet" class="switch__input" <%=GRF_AccCHK%> disabled readonly>
								<label for="GRF_AccesoInternet" class="switch__label">Acceso a Internet</label>
							</div>
						</div><%
					end if
					if(GRF_PuebloCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_PuebloOriginario" class="switch__input" <%=GRF_PuebloCHK%> disabled readonly>
								<label for="GRF_PuebloOriginario" class="switch__label">Pueblo Originario</label>
							</div>
						</div><%
					end if
					if(GRF_SindCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_PerteneceSindicato" class="switch__input" <%=GRF_SindCHK%> disabled readonly>
								<label for="GRF_PerteneceSindicato" class="switch__label">Pertenece Sindicato</label>
							</div>
						</div><%
					end if
					if(GRF_PermCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_PermisoSindical" class="switch__input" <%=GRF_PermCHK%> disabled readonly>
								<label for="GRF_PermisoSindical" class="switch__label">Permiso Sindical</label>
							</div>
						</div><%
					end if
					if(GRF_DirgCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_DirigenteSindical" class="switch__input" <%=GRF_DirgCHK%> disabled readonly>
								<label for="GRF_DirigenteSindical" class="switch__label">Dirigente Sindical</label>
							</div>
						</div><%
					end if%>
				</div>
				<div class="row"><%
					if(GRF_CursoCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_CursoSindical" class="switch__input" <%=GRF_CursoCHK%> disabled readonly>
								<label for="GRF_CursoSindical" class="switch__label">Curso Sindical</label>
							</div>
						</div><%
					end if
					if(GRF_CargoCHK<>"") then%>
						<div class="col-sm-12 col-md-6 col-lg-2">
							<div class="switch">
								<input type="checkbox" id="GRF_CargoDirectivoOrganizacion" class="switch__input" <%=GRF_CargoCHK%> disabled readonly>
								<label for="GRF_CargoDirectivoOrganizacion" class="switch__label">Cargo Directivo</label>
							</div>
						</div><%
					end if%>					
				</div>
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
									<th>Tramo Etario</th>
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
									dataGrpMultiSelect = dataGrpMultiSelect & "{""GFM_Id"":""" & rs("GFM_Id") & """,""NAC_Nombre"":""" & rs("NAC_Nombre") & """,""SEX_Descripcion"":""" & rs("SEX_Descripcion") & """,""EDU_Nombre"":""" & rs("EDU_Nombre") & """,""TDI_Nombre"":""" & rs("TDI_Nombre") & """,""RUB_Nombre"":""" & rs("RUB_Nombre") & """,""TTR_Nombre"":""" & rs("TTR_Nombre") & """,""TRE_Descripcion"":""" & rs("TRE_Descripcion") & """"
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
				<h5>Porcentaje de Alumnos que cumplen los filtros</h5>
				<div class="row">
					<div class="col-sm-12 col-md-6 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<i class="fas fa-hashtag input-prefix"></i>											
								<input type="number" id="TotalAlumnosFiltrados" name="TotalAlumnosFiltrados" class="form-control" value="<%=TotalAlumnosFiltrados%>" readonly>
								<span class="select-bar"></span><%
								if(TotalAlumnosFiltrados<>"") then%>
									<label for="TotalAlumnosFiltrados" class="active">Total Filtrado</label><%
								else%>
									<label for="TotalAlumnosFiltrados">Total Alumnos Filtrados</label><%
								end if%>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<i class="fas fa-hashtag input-prefix"></i>											
								<input type="number" id="TotalAlumnos" name="TotalAlumnos" class="form-control" value="<%=TotalAlumnos%>" readonly>
								<span class="select-bar"></span><%
								if(TotalAlumnos<>"") then%>
									<label for="TotalAlumnos" class="active">Total Alumnos</label><%
								else%>
									<label for="TotalAlumnos">Total Alumnos</label><%
								end if%>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<i class="fas fa-percentage input-prefix"></i>											
								<input type="number" id="PorcentajeMax" name="PorcentajeMax" class="form-control" value="<%=PorcentajeMax%>" readonly>
								<span class="select-bar"></span><%
								if(PorcentajeMax<>"") then%>
									<label for="PorcentajeMax" class="active">Porcentanje minimo exigido</label><%
								else%>
									<label for="PorcentajeMax">Porcentanje minimo exigido</label><%
								end if%>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-3">
						<div class="md-form input-with-post-icon">
							<div class="error-message">
								<i class="fas fa-percentage input-prefix"></i>											
								<input type="number" id="PorcentajeFil" name="PorcentajeFil" class="form-control" value="<%=PorcentajeFil%>" readonly>
								<span class="select-bar"></span><%
								if(PorcentajeFil<>"") then%>
									<label for="PorcentajeFil" class="active">Porcentanje filtrado</label><%
								else%>
									<label for="PorcentajeFil">Porcentanje filtrado</label><%
								end if%>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="estadistab1">
				<h5 style="padding-top:20px">Postulaciones</h5>
				<h6 style="padding-top:10px">Cantidad de matriculados/as</h6>
				<div class="row"><%
					if LIN_Hombre then%>
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-male input-prefix"></i><%
									if(PRY_CantInscriHombre<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_CantInscriHombre" name="PRY_CantInscriHombre" class="form-control" readonly disabled value="<%=PRY_CantInscriHombre%>">
									<span class="select-bar"></span>
									<label for="PRY_CantInscriHombre" class="<%=lblClass%>">Total de Hombres</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-percentage input-prefix"></i><%
									if(PRY_PorInscriHombre<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_PorInscriHombre" name="PRY_PorInscriHombre" class="form-control" readonly disabled value="<%=PRY_PorInscriHombre%>">
									<span class="select-bar"></span>
									<label for="PRY_PorInscriHombre" class="<%=lblClass%>">% de Hombres</label>
								</div>
							</div>
						</div><%
					end if
					if LIN_Mujer then%>
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-female input-prefix"></i><%
									if(PRY_CantInscriMujer<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_CantInscriMujer" name="PRY_CantInscriMujer" class="form-control" readonly disabled value="<%=PRY_CantInscriMujer%>">
									<span class="select-bar"></span>
									<label for="PRY_CantInscriMujer" class="<%=lblClass%>">Total de Mujeres</label>
								</div>
							</div>
						</div>
						<div class="col-sm-12 col-md-2 col-lg-2">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-percentage input-prefix"></i><%
									if(PRY_PorInscriMujer<>"") then
										lblClass="active"
									else
										lblClass=""
									end if%>
									<input type="text" id="PRY_PorInscriMujer" name="PRY_PorInscriMujer" class="form-control" readonly disabled value="<%=PRY_PorInscriMujer%>">
									<span class="select-bar"></span>
									<label for="PRY_PorInscriMujer" class="<%=lblClass%>">% de Mujeres</label>
								</div>
							</div>
						</div><%
					end if%>
					<div class="col-sm-12 col-md-4 col-lg-4">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-plus input-prefix"></i><%
								if(TotalInscri<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="TotalInscri" name="TotalInscri" class="form-control" readonly value="<%=TotalInscri%>">
								<span class="select-bar"></span>
								<label for="TotalInscri" class="<%=lblClass%>">Total</label>
							</div>
						</div>
					</div>
				</div>	
				
				<h6>Cantidad de extranjeros/as</h6>
				<div class="row">
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-globe-americas input-prefix"></i><%
								if(PRY_CantidadExtranjeros<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_CantidadExtranjeros" name="PRY_CantidadExtranjeros" class="form-control" readonly value="<%=PRY_CantidadExtranjeros%>">
								<span class="select-bar"></span>
								<label for="PRY_CantidadExtranjeros" class="<%=lblClass%>">Total de Extranjeros/as</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorExtranjeros<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorExtranjeros" name="PRY_PorExtranjeros" class="form-control" readonly value="<%=PRY_PorExtranjeros%>">
								<span class="select-bar"></span>
								<label for="PRY_PorExtranjeros" class="<%=lblClass%>">% de Extranjeros/as</label>
							</div>
						</div>
					</div>
				</div>
				
				<h6>Cantidad de discapacitados/as</h6>
				<div class="row">
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-wheelchair input-prefix"></i><%
								if(PRY_CantidadDiscapacidad<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_CantidadDiscapacidad" name="PRY_CantidadDiscapacidad" class="form-control" readonly value="<%=PRY_CantidadDiscapacidad%>">
								<span class="select-bar"></span>
								<label for="PRY_CantidadDiscapacidad" class="<%=lblClass%>">Total de Discapacitados/as</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorDiscapacidad<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorDiscapacidad" name="PRY_PorDiscapacidad" class="form-control" readonly value="<%=PRY_PorDiscapacidad%>">
								<span class="select-bar"></span>
								<label for="PRY_PorDiscapacidad" class="<%=lblClass%>">% de Discapacitados/as</label>
							</div>
						</div>
					</div>
				</div>
				
				<h6>Cantidad por tramo etáreo</h6>
				<div class="row">
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-birthday-cake input-prefix"></i><%
								if(PRY_Tramo1825<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_Tramo1825" name="PRY_Tramo1825" class="form-control" readonly value="<%=PRY_Tramo1825%>">
								<span class="select-bar"></span>
								<label for="PRY_Tramo1825" class="<%=lblClass%>">Total 18-25</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorTramo1825<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorTramo1825" name="PRY_PorTramo1825" class="form-control" readonly value="<%=PRY_PorTramo1825%>">
								<span class="select-bar"></span>
								<label for="PRY_PorTramo1825" class="<%=lblClass%>">%</label>
							</div>
						</div>
					</div>		
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-birthday-cake input-prefix"></i><%
								if(PRY_Tramo2635<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_Tramo2635" name="PRY_Tramo2635" class="form-control" readonly value="<%=PRY_Tramo2635%>">
								<span class="select-bar"></span>
								<label for="PRY_Tramo2635" class="<%=lblClass%>">Total 26-35</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorTramo2635<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorTramo2635" name="PRY_PorTramo2635" class="form-control" readonly value="<%=PRY_PorTramo2635%>">
								<span class="select-bar"></span>
								<label for="PRY_PorTramo2635" class="<%=lblClass%>">%</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-birthday-cake input-prefix"></i><%
								if(PRY_Tramo3645<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_Tramo3645" name="PRY_Tramo3645" class="form-control" readonly value="<%=PRY_Tramo3645%>">
								<span class="select-bar"></span>
								<label for="PRY_Tramo3645" class="<%=lblClass%>">Total 36-45</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorTramo3645<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorTramo3645" name="PRY_PorTramo3645" class="form-control" readonly value="<%=PRY_PorTramo3645%>">
								<span class="select-bar"></span>
								<label for="PRY_PorTramo3645" class="<%=lblClass%>">%</label>
							</div>
						</div>
					</div>				
				</div>
				
				<div class="row">
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-birthday-cake input-prefix"></i><%
								if(PRY_Tramo4655<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_Tramo4655" name="PRY_Tramo4655" class="form-control" readonly value="<%=PRY_Tramo4655%>">
								<span class="select-bar"></span>
								<label for="PRY_Tramo4655" class="<%=lblClass%>">Total 46-55</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorTramo4655<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorTramo4655" name="PRY_PorTramo4655" class="form-control" readonly value="<%=PRY_PorTramo4655%>">
								<span class="select-bar"></span>
								<label for="PRY_PorTramo4655" class="<%=lblClass%>">%</label>
							</div>
						</div>
					</div>		
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-birthday-cake input-prefix"></i><%
								if(PRY_Tramo5665<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_Tramo5665" name="PRY_Tramo5665" class="form-control" readonly value="<%=PRY_Tramo5665%>">
								<span class="select-bar"></span>
								<label for="PRY_Tramo5665" class="<%=lblClass%>">Total 56-65</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorTramo5665<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorTramo5665" name="PRY_PorTramo5665" class="form-control" readonly value="<%=PRY_PorTramo5665%>">
								<span class="select-bar"></span>
								<label for="PRY_PorTramo5665" class="<%=lblClass%>">%</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-birthday-cake input-prefix"></i><%
								if(PRY_Tramo66mas<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_Tramo66mas" name="PRY_Tramo66mas" class="form-control" readonly value="<%=PRY_Tramo66mas%>">
								<span class="select-bar"></span>
								<label for="PRY_Tramo66mas" class="<%=lblClass%>">Total 66 y más</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorTramo66mas<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorTramo66mas" name="PRY_PorTramo66mas" class="form-control" readonly value="<%=PRY_PorTramo66mas%>">
								<span class="select-bar"></span>
								<label for="PRY_PorTramo66mas" class="<%=lblClass%>">%</label>
							</div>
						</div>
					</div>
				</div>
				
				<h6>Cantidad de dirigentes/as sindicales</h6>
				<div class="row">
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-users input-prefix"></i><%
								if(PRY_CantidadDirigente<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_CantidadDirigente" name="PRY_CantidadDirigente" class="form-control" readonly value="<%=PRY_CantidadDirigente%>">
								<span class="select-bar"></span>
								<label for="PRY_CantidadDirigente" class="<%=lblClass%>">Total de Dirigentes/as</label>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-6">
						<div class="md-form input-with-post-icon">
							<div class="error-message">	
								<i class="fas fa-percentage input-prefix"></i><%
								if(PRY_PorDirigente<>"") then
									lblClass="active"
								else
									lblClass=""
								end if%>
								<input type="text" id="PRY_PorDirigente" name="PRY_PorDirigente" class="form-control" readonly value="<%=PRY_PorDirigente%>">
								<span class="select-bar"></span>
								<label for="PRY_PorDirigente" class="<%=lblClass%>">% de Dirigentes/as</label>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>			
</div>

<form role="form" action="<%=action%>" method="POST" name="frm10s3" id="frm10s3" class="needs-validation">	
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
	$(document).ready(function() {	
		$(".content-nav").tabsmaterialize({menumovil:false},function(){});

		var grpmulselTable;
		var dataGrpMultiSelect = <%=dataGrpMultiSelect%>;		
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

		$("#PRY_CantPostuHombre, #PRY_CantPostuMujer").change(function(e){
			e.preventDefault();
			var ch=$("#PRY_CantPostuHombre").val();
			var cm=$("#PRY_CantPostuMujer").val()
			if(ch=="" || ch==undefined){
				ch=0;
			}
			if(cm=="" || cm==undefined){
				cm=0;
			}
			$("#Total").val(parseInt(ch) + parseInt(cm))
			$("#Total").siblings("label").addClass("active");
		})
		if(parseInt($("#TotalInscri").val())==0 || $("#TotalInscri").val()==""){
			Toast.fire({
			  icon: 'warning',
			  title: 'No existen alumnos/as matriculados/as.'			  
			});
			$("#TotalAlumnos").addClass("is-invalid");
			$("#TotalAlumnos").removeClass("is-valid");
			$("#TotalAlumnos").next("span").addClass("is-invalid");
			$("#TotalAlumnos").next("span").removeClass("is-valid");
			$("#TotalAlumnos").val("0");		
		}else{
			$("#TotalAlumnos").val($("#TotalInscri").val())
			$("#TotalAlumnos").next().next().addClass("active")
		}
		
		if(parseInt($("#TotalAlumnos").val())==0 || $("#TotalAlumnos").val()==""){
			$("#TotalAlumnos").addClass("is-invalid");
			$("#TotalAlumnos").removeClass("is-valid");
			$("#TotalAlumnos").next("span").addClass("is-invalid");
			$("#TotalAlumnos").next("span").removeClass("is-valid");
		}else{
			$("#TotalAlumnos").addClass("is-valid");
			$("#TotalAlumnos").removeClass("is-invalid");
			$("#TotalAlumnos").next("span").addClass("is-valid");
			$("#TotalAlumnos").next("span").removeClass("is-invalid");			
		}		

		if(parseInt($("#PorcentajeFil").val())>=parseInt($("#PorcentajeMax").val())){
			$("#PorcentajeFil").addClass("is-valid");
			$("#PorcentajeFil").removeClass("is-invalid");
			$("#PorcentajeFil").next("span").addClass("is-valid");
			$("#PorcentajeFil").next("span").removeClass("is-invalid");
		}else{
			$("#PorcentajeFil").addClass("is-invalid");
			$("#PorcentajeFil").removeClass("is-valid");
			$("#PorcentajeFil").next("span").addClass("is-invalid");
			$("#PorcentajeFil").next("span").removeClass("is-valid");
		}

		$("#btn_frm10s3").click(function(){
			const noCumple = (parseInt(document.getElementById("PorcentajeFil").value) < parseInt(document.getElementById("PorcentajeMax").value)) ? true : false;
			const noExiste = (parseInt(document.getElementById("TotalInscri").value)==0 || document.getElementById("TotalInscri").value=="") ? true : false;
			const Obligatorio = false;			

			formValidate("#frm10s3")
			if($("#frm10s3").valid()){
				if(noExiste){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'No existen alumnos/as matriculados/as.',						
						text:'Debes ingresarlos/as antes de poder pasar al siguiente paso.'
					});	
				}else{
					if(noCumple && Obligatorio){
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'No existen alumnos/as que cumplan las condiciones',						
							text:'Debes ingresarlos/as antes de poder pasar al siguiente paso.'
						});	
					}else{
						if(noCumple && !Obligatorio){
							swalWithBootstrapButtons.fire({
								icon:'warning',								
								title: 'Actualmente no existen alumnos/as que cumplan las condiciones mínimas exigidas',
								text:'¿Deseas continuar de todas formas?',
								showCancelButton: true,
								confirmButtonColor: '#3085d6',
								cancelButtonColor: '#d33',
								confirmButtonText: '<i class="fas fa-thumbs-up"></i> Continuar',
								cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
							}).then((result) => {
								if (result.value) {
									//Generar mensaje y envio de correo a revisores y administradores de esta exepción									
									NextStep();
								}
							});
						}else{
							if(!noCumple && !Obligatorio){
								NextStep();
							}
						};						
					}
				}
			}
		})

		function NextStep(){
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
						title: 'Postulación grabada exitosamente.'
						});
						var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:1};							
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
		}
	});
</script>