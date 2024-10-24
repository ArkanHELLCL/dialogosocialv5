<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%response.write("200/@/")
	tpo=request("tpo")
	if(tpo="") then
		tpo=0
	end if
	titulo="Mis Proyectos"
	gradiente="blue-gradient"
	PRY_Estado=1
	url="/tbl-proyectos"
	color="white-text"
	if(tpo=2) then	
		PRY_Estado=9
		titulo="Proyectos Archivados"
		gradiente="aqua-gradient"
		color="darkblue-text"
	end if
		
	if tpo=1 and session("ds5_usrperfil")=2 then
		url="/tbl-proyectos"
		titulo="Otros Proyectos"
		gradiente="aqua-gradient"
		color="darkblue-text"
	end if		
%>
<div class="row container-header">

</div>
<div class="row container-body mCustomScrollbar">
	<!--container-nav-->
	<div class="container-nav">
		<div class="header">				
			<div class="content-nav"><%				
				set cnn = Server.CreateObject("ADODB.Connection")
				on error resume next	
				cnn.open session("DSN_DialogoSocialv5")
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión:" & ErrMsg)
				   response.End() 			   
				end if			
				
				sql="exec spLineaFormativa_Listar 1"
				if session("ds5_usrperfil")=3 then	'Ejecutor
					dim lineas(5)
					existe=false
					sql="exec [spProyectoLineaEjecutor_Consultar] " & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				end if
				set rs = cnn.Execute(sql)
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Ejecucion:" & ErrMsg)
				   response.End() 			   
				end if
				cont=1
				prynuevos=0
				do while not rs.eof
					if session("ds5_usrperfil")=3 then
						lineas(cont)=rs("LFO_Id")
					end if
					if cont=1 then
						active="active"
					else
						active=""
					end if
					'Proyectos nuevos por linea
					sql="exec spUsuarioProyectoNuevo_Contar " & rs("LFO_Id") & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"					
					set rx=cnn.execute(sql)
					on error resume next					
					if not rx.eof then
						prynuevos=rx("ProyectosNuevos")
					end if										
					cont=cont+1%>
					<a id="tab<%=rs("LFO_Id")%>-tab" href="#tab<%=rs("LFO_Id")%>" class="<%=active%> tab"><i class="fas fa-book" data-lin="<%=rs("LFO_Id")%>"></i> <%=UCAse(rs("LFO_Nombre"))%><%
					if prynuevos>0 then%>
						<span class="badge right red"><%=prynuevos%></span><%
					end if%>
					</a><%
					rs.movenext
				loop%>
				<span class="yellow-bar"></span>				
				<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
					<div class="animated-icon1"><span></span><span></span><span></span></div>
				</button>
			</div>				
		</div>
	
		<!--tab-content-->
		<div class="tab-content"><%
			cont=0
			for each x in lineas
				if x=10 then
					existe=true
					cont=cont+1
				end if				
			next
			if existe or session("ds5_usrperfil")<>3 then%>
				<!--tab10-->
				<div id="tab10" data-lin="10">

					<!--wrapper-editor-->
					<div class="wrapper-editor">						
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
							<!-- Table with panel -->					
							<div class="card card-cascade narrower">
								<!--Card image-->
								<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
									<div><%
										if (session("ds5_usrperfil")=1 and tpo<>2) or (session("ds5_usrperfil")=2 and tpo=0) then%>
											<button class="btn btn-success btn-rounded btn-sm waves-effect buttonAdd" title="Crear un nuevo proyecto" type="button" data-url="" data-toggle="tooltip" data-id="10">Agregar<i class="fas fa-plus ml-1"></i></button><%
										end if%>										
									</div>
									<a href="" class="<%=color%> mx-3"><i class="fas fa-book"></i> <%=titulo%></a>
									<div><%
										if session("ds5_usrperfil")=1 and tpo<>2 then%>
											<button class="btn btn-danger btn-rounded buttonArchive btn-sm waves-effect" data-toggle="tooltip" title="Archivar proyecto">Archivar<i class="fas fa-archive ml-1"></i></button><%
										else
											if session("ds5_usrperfil")=1 and tpo=2 then%>
												<button class="btn btn-primary btn-rounded buttonUnArchive btn-sm waves-effect" data-toggle="tooltip" title="Desarchivar proyecto">Desarchivar<i class="fas fa-box-open ml-1"></i></button><%
											end if
										end if%>
										<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="escuela">Exportar<i class="fas fa-download ml-1"></i></button>
									</div>
								</div>
								<!--/Card image-->
								<div class="px-4">
									<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-1">
										<!--Table-->										
										<table id="tbl-escuela" class="ts table table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="escuela">
											<thead>
												<tr>													
													<th>#</th>
													<th>Empresa Ejecutora</th>
													<th>P.M.</th>
													<th>P.A.</th>
													<th>#</th>
													<th>L.Formativa</th>
													
													<th>#</th>
													<th>Línea</th>
													<th>L.M.</th>
													<th>Reg.</th> 
													<th>Año</th>
													<th>Inicio</th>
													<th>A</th>
													<th>Informe Inicio Fecha Aceptado</th>
													<th>Desarrollo</th>
													<th>A</th>
													<th>Informe Desarrollo Fecha Aceptado</th>													
													<th>Final</th>
													<th>A</th>
													<th>Informe Final Fecha Aceptado</th>	
													<th>Hito</th>
													<th>Estado</th>
													<th>Región</th>
													<th>Comuna</th>							
													<th>Nombre Revisor</th>
													<th>Apellido Revisor</th>
													<th>Mail Revisor</th>
													<th>Telefono Revisor</th>
													<th>Direccion Revisor</th>							
													<th>Nombre Ejecutor</th>
													<th>Apellido Ejecutor</th>
													<th>Mail Ejecutor</th>
													<th>Telefono Ejecutor</th>
													<th>Direccion Ejecutor</th>
													<th>Nombre Institucion Ejecutor</th>
													<th>Sexo Ejecutor</th>
													
													<th>Encargado Proyecto</th>
													<th>Encargado Proyecto Mail</th>
													<th>Encargado Proyecto Celular</th>
													<th>Sexo Encargado Proyecto</th>
													<th>Encargado Actividades</th>
													<th>Encargado Actividades Mail</th>
													<th>Encargado Actividades Celular</th>
													<th>Sexo Encargado Actividades</th>
													<th>Informe Inicio FechaEnvio</th>				
													<th>Informe Final Fecha Envio</th>
													<th>Creacion Proyecto Fecha Envio</th>	
													<th>Informe Inicio Aceptado</th>			
													<th>Informe Desarrollo Aceptado</th>	
													<th>Informe Final Aceptado</th>													
													<th>Direccion de Lanzamiento</th>			
													<th>Fecha de Lanzamiento</th>	
													<th>Hora de Lanzamiento</th>			
													<th>Direccion de Cierre</th>			
													<th>Fecha de Cierre</th>	
													<th>Hora de Cierre</th>
													
													<th>Dias para vencimiento Inf.Inicial</th>
													<th>Dias para vencimiento Inf.Desarrollo</th>
													<th>Dias para vencimiento Inf.Final</th>													
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>

									</div>
								</div>
							</div>
							<!-- Table with panel -->		
						</div>	  
					</div>
					<!--wrapper-editor-->

				</div>
				<!--tab10--><%
			end if
			existe=false
			for each x in lineas
				if x=11 then
					existe=true
					cont=cont+1
				end if
			next
			if existe or session("ds5_usrperfil")<>3 then%>
				<!--tab11-->
				<div id="tab11" data-lin="11">

					<!--wrapper-editor-->
					<div class="wrapper-editor">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
							<!-- Table with panel -->					
							<div class="card card-cascade narrower">
								<!--Card image-->
								<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
									<div><%
										if session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and tpo<>1) then%>
											<button class="btn btn-success btn-rounded btn-sm waves-effect buttonAdd" title="Crear un nuevo proyecto" type="button" data-url="" data-toggle="tooltip" data-id="11" id="tagid_11">Agregar<i class="fas fa-plus ml-1"></i></button><%
										end if%>										
									</div>
									<a href="" class="white-text mx-3"><i class="fas fa-book"></i> <%=titulo%></a>
									<div><%
										if session("ds5_usrperfil")=1 then%>
											<button class="btn btn-danger btn-rounded buttonArchive btn-sm waves-effect" data-toggle="tooltip" title="Archivar proyecto">Archivar<i class="fas fa-archive ml-1"></i></button><%
										end if%>
										<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="mesa">Exportar<i class="fas fa-download ml-1"></i></button>
									</div>
								</div>
								<!--/Card image-->
								<div class="px-4">
									<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-1">
										<!--Table-->
										<table id="tbl-mesa" class="ts table table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="mesa">
											<thead>
												<tr>								
													<tr>													
													<th>#</th>
													<th>Empresa Ejecutora</th>
													<th>P.M.</th>
													<th>P.A.</th>
													<th>#</th>
													<th>L.Formativa</th>
													
													<th>#</th>
													<th>Línea</th>
													<th>L.M.</th>
													<th>Reg.</th> 
													<th>Año</th>
													<th>Inicial</th>
													<th>A</th>
													<th>Informe Inicial Fecha Aceptado</th>
													<th>Avances</th>
													<th>A</th>
													<th>Informe Avances Fecha Aceptado</th>													
													<th>Final</th>
													<th>A</th>
													<th>Informe Final Fecha Aceptado</th>	
													<th>Hito</th>
													<th>Estado</th>
													<th>Región</th>
													<th>Comuna</th>							
													<th>Nombre Revisor</th>
													<th>Apellido Revisor</th>
													<th>Mail Revisor</th>
													<th>Telefono Revisor</th>
													<th>Direccion Revisor</th>							
													<th>Nombre Ejecutor</th>
													<th>Apellido Ejecutor</th>
													<th>Mail Ejecutor</th>
													<th>Telefono Ejecutor</th>
													<th>Direccion Ejecutor</th>
													<th>Nombre Institucion Ejecutor</th>
													<th>Sexo Ejecutor</th>
													
													<th>Encargado Proyecto</th>
													<th>Encargado Proyecto Mail</th>
													<th>Encargado Proyecto Celular</th>
													<th>Sexo Encargado Proyecto</th>
													<th>Encargado Actividades</th>
													<th>Encargado Actividades Mail</th>
													<th>Encargado Actividades Celular</th>
													<th>Sexo Encargado Actividades</th>
													<th>Informe Inicial Fecha Envio</th>		
													<th>Informe Avances Fecha Envio</th>
													<th>Creacion Proyecto Fecha Envio</th>	
													<th>Informe Inicial Aceptado</th>			
													<th>Informe Avances Aceptado</th>	
													<th>Informe Final Aceptado</th>													
													<th>Direccion de Lanzamiento</th>			
													<th>Fecha de Lanzamiento</th>	
													<th>Hora de Lanzamiento</th>			
													<th>Direccion de Cierre</th>			
													<th>Fecha de Cierre</th>	
													<th>Hora de Cierre</th>
													
													<th>Dias para vencimiento Inf.Inicial</th>
													<th>Dias para vencimiento Inf.Avances</th>
													<th>Dias para vencimiento Inf.Final</th>													
												</tr>		
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- Table with panel -->		
						</div>	  
					</div>
					<!--wrapper-editor-->

				</div>
				<!--tab11--><%
			end if
			existe=false
			for each x in lineas
				if x=12 then
					existe=true
					cont=cont+1
				end if
			next
			if existe or session("ds5_usrperfil")<>3 then%>
				<!--tab12-->
				<div id="tab12" data-lin="12">

					<!--wrapper-editor-->
					<div class="wrapper-editor">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
							<!-- Table with panel -->					
							<div class="card card-cascade narrower">
								<!--Card image-->
								<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
									<div><%
										if session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and tpo<>1) then%>
											<button class="btn btn-success btn-rounded btn-sm waves-effect buttonAdd" title="Crear un nuevo proyecto" type="button" data-url="" data-toggle="tooltip" data-id="12">Agregar<i class="fas fa-plus ml-1"></i></button><%
										end if%>										
									</div>
									<a href="" class="white-text mx-3"><i class="fas fa-book"></i> <%=titulo%></a>
									<div><%
										if session("ds5_usrperfil")=1 then%>
											<button class="btn btn-danger btn-rounded buttonArchive btn-sm waves-effect" data-toggle="tooltip" title="Archivar proyecto">Archivar<i class="fas fa-archive ml-1"></i></button><%
										end if%>
										<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="curso">Exportar<i class="fas fa-download ml-1"></i></button>
									</div>
								</div>
								<!--/Card image-->
								<div class="px-4">
									<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-1">
										<!--Table-->
										<table id="tbl-curso" class="ts table table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="curso">
											<thead>
												<tr>								
													<th>#</th>
													<th>Empresa Ejecutora</th>
													<th>P.M.</th>
													<th>P.A.</th>
													<th>#</th>
													<th>L.Formativa</th>
													
													<th>#</th>
													<th>Línea</th>
													<th>L.M.</th>
													<th>Reg.</th> 
													<th>Año</th>
													<th>Inicio</th>
													<th>A</th>
													<th>Informe Inicio Fecha Aceptado</th>
													<th>Desarrollo</th>
													<th>A</th>
													<th>Informe Desarrollo Fecha Aceptado</th>													
													<th>Final</th>
													<th>A</th>
													<th>Informe Final Fecha Aceptado</th>	
													<th>Hito</th>
													<th>Estado</th>
													<th>Región</th>
													<th>Comuna</th>							
													<th>Nombre Revisor</th>
													<th>Apellido Revisor</th>
													<th>Mail Revisor</th>
													<th>Telefono Revisor</th>
													<th>Direccion Revisor</th>							
													<th>Nombre Ejecutor</th>
													<th>Apellido Ejecutor</th>
													<th>Mail Ejecutor</th>
													<th>Telefono Ejecutor</th>
													<th>Direccion Ejecutor</th>
													<th>Nombre Institucion Ejecutor</th>
													<th>Sexo Ejecutor</th>
													
													<th>Encargado Proyecto</th>
													<th>Encargado Proyecto Mail</th>
													<th>Encargado Proyecto Celular</th>
													<th>Sexo Encargado Proyecto</th>
													<th>Encargado Actividades</th>
													<th>Encargado Actividades Mail</th>
													<th>Encargado Actividades Celular</th>
													<th>Sexo Encargado Actividades</th>
													<th>Informe Inicio FechaEnvio</th>				
													<th>Informe Final Fecha Envio</th>
													<th>Creacion Proyecto Fecha Envio</th>	
													<th>Informe Inicio Aceptado</th>			
													<th>Informe Desarrollo Aceptado</th>	
													<th>Informe Final Aceptado</th>	
													<th>Direccion de Lanzamiento</th>			
													<th>Fecha de Lanzamiento</th>	
													<th>Hora de Lanzamiento</th>			
													<th>Direccion de Cierre</th>			
													<th>Fecha de Cierre</th>	
													<th>Hora de Cierre</th>
													
													<th>Dias para vencimiento Inf.Inicial</th>
													<th>Dias para vencimiento Inf.Desarrollo</th>
													<th>Dias para vencimiento Inf.Final</th>			
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- Table with panel -->		
						</div>	  
					</div>
					<!--wrapper-editor-->
				</div>
				<!--tab12--><%
			end if

			existe=false
			for each x in lineas
				if x=13 then
					existe=true
					cont=cont+1
				end if
			next
			if existe or session("ds5_usrperfil")<>3 then%>
				<!--tab12-->
				<div id="tab13" data-lin="13">

					<!--wrapper-editor-->
					<div class="wrapper-editor">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
							<!-- Table with panel -->					
							<div class="card card-cascade narrower">
								<!--Card image-->
								<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
									<div><%
										if session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and tpo<>1) then%>
											<button class="btn btn-success btn-rounded btn-sm waves-effect buttonAdd" title="Crear un nuevo proyecto" type="button" data-url="" data-toggle="tooltip" data-id="13">Agregar<i class="fas fa-plus ml-1"></i></button><%
										end if%>										
									</div>
									<a href="" class="white-text mx-3"><i class="fas fa-book"></i> <%=titulo%></a>
									<div><%
										if session("ds5_usrperfil")=1 then%>
											<button class="btn btn-danger btn-rounded buttonArchive btn-sm waves-effect" data-toggle="tooltip" title="Archivar proyecto">Archivar<i class="fas fa-archive ml-1"></i></button><%
										end if%>
										<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="recuperacion">Exportar<i class="fas fa-download ml-1"></i></button>
									</div>
								</div>
								<!--/Card image-->
								<div class="px-4">
									<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-1">
										<!--Table-->
										<table id="tbl-recuperacion" class="ts table table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="recuperacion">
											<thead>
												<tr>								
													<th>#</th>
													<th>Empresa Ejecutora</th>
													<th>P.M.</th>
													<th>P.A.</th>
													<th>#</th>
													<th>L.Formativa</th>
													
													<th>#</th>
													<th>Línea</th>
													<th>L.M.</th>
													<th>Reg.</th> 
													<th>Año</th>
													<th>Inicio</th>
													<th>A</th>
													<th>Informe Inicio Fecha Aceptado</th>
													<th>Avances</th>
													<th>A</th>
													<th>Informe Avances Fecha Aceptado</th>													
													<th>Final</th>
													<th>A</th>
													<th>Informe Final Fecha Aceptado</th>	
													<th>Hito</th>
													<th>Estado</th>
													<th>Región</th>
													<th>Comuna</th>							
													<th>Nombre Revisor</th>
													<th>Apellido Revisor</th>
													<th>Mail Revisor</th>
													<th>Telefono Revisor</th>
													<th>Direccion Revisor</th>							
													<th>Nombre Ejecutor</th>
													<th>Apellido Ejecutor</th>
													<th>Mail Ejecutor</th>
													<th>Telefono Ejecutor</th>
													<th>Direccion Ejecutor</th>
													<th>Nombre Institucion Ejecutor</th>
													<th>Sexo Ejecutor</th>
													
													<th>Encargado Proyecto</th>
													<th>Encargado Proyecto Mail</th>
													<th>Encargado Proyecto Celular</th>
													<th>Sexo Encargado Proyecto</th>
													<th>Encargado Actividades</th>
													<th>Encargado Actividades Mail</th>
													<th>Encargado Actividades Celular</th>
													<th>Sexo Encargado Actividades</th>
													<th>Informe Inicio FechaEnvio</th>				
													<th>Informe Final Fecha Envio</th>
													<th>Creacion Proyecto Fecha Envio</th>	
													<th>Informe Inicio Aceptado</th>			
													<th>Informe Desarrollo Aceptado</th>	
													<th>Informe Final Aceptado</th>	
													<th>Direccion de Lanzamiento</th>			
													<th>Fecha de Lanzamiento</th>	
													<th>Hora de Lanzamiento</th>			
													<th>Direccion de Cierre</th>			
													<th>Fecha de Cierre</th>	
													<th>Hora de Cierre</th>
													
													<th>Dias para vencimiento Inf.Inicial</th>
													<th>Dias para vencimiento Inf.Desarrollo</th>
													<th>Dias para vencimiento Inf.Final</th>			
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- Table with panel -->		
						</div>	  
					</div>
					<!--wrapper-editor-->
				</div>
				<!--tab12--><%
			end if
			
			if cont=0 and session("ds5_usrperfil")=3 then%>
				Aún no tienes proyectos asignados<%
			end if%>
		</div>
		<!--tab-content-->
	</div>
	<!--container-nav-->	
</div>
<!--container-body-->

<%if session("ds5_usrperfil")=1 or (session("ds5_usrperfil")=2 and tpo<>1) then%>
<!-- Formulario para crear un nuevo proyecto -->
<div class="modal fade in modalAdd" id="modalAdd-10" tabindex="-1" role="dialog" aria-labelledby="modalAdd-10Label" aria-hidden="true" data-id="10">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-edit"></i> Ingresa una linea para escuela</div>				
      		</div>
			<form role="form" action="" method="POST" name="frmseleclinea-10" id="frmseleclinea-10" class="needs-validation">
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select" id="creaLinea-10">
										
									</div>
								</div>
							</div>
						</div>								
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" class="btn btn-primary btn-md waves-effect" id="btn_crealinea-10" name="btn_crealinea-10"><i class="fas fa-plus"></i> Crear</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Formulario para crear un nuevo proyecto -->

<!-- Formulario para crear un nuevo proyecto mesas-->
<div class="modal fade in modalAdd" id="modalAdd-11" tabindex="-1" role="dialog" aria-labelledby="modalAdd-11Label" aria-hidden="true" data-id="11">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-edit"></i> Ingresa una linea para mesas</div>				
      		</div>
			<form role="form" action="" method="POST" name="frmseleclinea-11" id="frmseleclinea-11" class="needs-validation">
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select" id="creaLinea-11">
										
									</div>
								</div>
							</div>
						</div>								
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" class="btn btn-primary btn-md waves-effect" id="btn_crealinea-11" name="btn_crealinea-11"><i class="fas fa-plus"></i> Crear</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Formulario para crear un nuevo proyecto mesas-->

<!-- Formulario para crear un nuevo proyecto cursos-->
<div class="modal fade in modalAdd" id="modalAdd-12" tabindex="-1" role="dialog" aria-labelledby="modalAdd-12Label" aria-hidden="true" data-id="12">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-edit"></i> Ingresa una linea para cursos</div>				
      		</div>
			<form role="form" action="" method="POST" name="frmseleclinea-12" id="frmseleclinea-12" class="needs-validation">
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select" id="creaLinea-12">
										
									</div>
								</div>
							</div>
						</div>								
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" class="btn btn-primary btn-md waves-effect" id="btn_crealinea-12" name="btn_crealinea-12"><i class="fas fa-plus"></i> Crear</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Formulario para crear un nuevo proyecto cursos-->

<!-- Formulario para crear un nuevo proyecto recuperación-->
<div class="modal fade in modalAdd" id="modalAdd-13" tabindex="-1" role="dialog" aria-labelledby="modalAdd-13Label" aria-hidden="true" data-id="13">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-edit"></i> Ingresa una linea para recuperación</div>				
      		</div>
			<form role="form" action="" method="POST" name="frmseleclinea-13" id="frmseleclinea-13" class="needs-validation">
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">									
									<div class="select" id="creaLinea-13">
										
									</div>
								</div>
							</div>
						</div>								
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" class="btn btn-primary btn-md waves-effect" id="btn_crealinea-13" name="btn_crealinea-13"><i class="fas fa-plus"></i> Crear</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- Formulario para crear un nuevo proyecto mesas-->
<%End if%>

<script>
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	var LFO_Id=0, LIN_Id=0;
	$(document).ready(function() {
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);				
		$(".mCustomScrollbar").mCustomScrollbar({
			theme:scrollTheme,
			advanced:{
				autoExpandHorizontalScroll:true,
				updateOnContentResize:true,
				autoExpandVerticalScroll:true,
				scrollbarPosition:"outside"
			},
		});	
		$(".content-nav").tabsmaterialize({},function(){
			var LIN_Id = $(this.toString()).data("lin");
			
			if(LIN_Id==10){
				if ( ! $.fn.DataTable.isDataTable( '#tbl-escuela' ) ) {
				 	tableEscuelas(LIN_Id)					
				}else{
					escuelaTable.ajax.reload();
				}
			}
			if(LIN_Id==11){
				if ( ! $.fn.DataTable.isDataTable( '#tbl-mesa' ) ) {
				 	tableMesas(LIN_Id)					
				}else{
					mesasTable.ajax.reload();
				}
			}
			if(LIN_Id==12){
				if ( ! $.fn.DataTable.isDataTable( '#tbl-curso' ) ) {
				 	tableCursos(LIN_Id)					
				}else{
					cursosTable.ajax.reload();
				}
			}
			if(LIN_Id==13){
				if ( ! $.fn.DataTable.isDataTable( '#tbl-recuperacion' ) ) {
				 	tableRecuperacion(LIN_Id)					
				}else{
					recuperacionTable.ajax.reload();
				}
			}
		});		
		$(".buttonAdd").click(function(){
			LFO_Id=$(this).data("id");
			$("#modalAdd-" + LFO_Id).modal("show");			
		})
		$(".modalAdd").on('shown.bs.modal', function(){	
			var LFO_Id=$(this).data("id");
			$.ajax( {
				type:'POST',					
				url: '/listar-linea',
				data: {LFO_Id:LFO_Id},
				success: function ( data ) {
					param = data.split("//")
					if(param[0]==200){						
						$("#creaLinea-" + LFO_Id).html(param[1]);
						formValidate("#frmseleclinea-" + LFO_Id);
						
						$("#btn_crealinea-" + LFO_Id).click(function(){							
							if($("#frmseleclinea-" + LFO_Id).valid()){
								LIN_Id = $("#LIN_Id-" + LFO_Id).val();
								$("#modalAdd-" + LFO_Id).modal("hide");								
							}
						});
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
								
				}
			});		
		});
		$(".modalAdd").on('hidden.bs.modal', function(){			
			if(LIN_Id!=0){				
				var objeto={key1:LIN_Id};
				var url='/bandeja-de-entrada/agregar';				
				cargacomponente(url,objeto);
				window.history.replaceState(null, "", "/home"+url+"/"+LIN_Id);
				cargabreadcrumb("/breadcrumbs","");								
			}
		});								
				
		//Escuela
		var escuelaTable;
		function tableEscuelas(LIN_Id){			
			var tables = $.fn.dataTable.fnTables(true);			
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			escuelaTable = $('#tbl-escuela').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"<%=url%>",					
					type:"POST",
					dataSrc:function(json){					
						return json.data;					
					},
					data:{tpo:<%=tpo%>,LFO_Id:LIN_Id}					
				},	
				columnDefs: [{
					"targets": [ 4,5,8,10,13,16,19,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58 ],
					"visible": false,
					"searchable": false
					},{
					"targets": [0,2,3,6,9,12,15,18],"width":"20px"
					}
				],
				autoWidth: false,				
				order:[0,"desc"],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					var estIni = $(aData)[47];
					var estPar = $(aData)[48];
					var estFin = $(aData)[49];					
					
					var dvIni = parseInt($(aData)[56]);
					var dvPar = parseInt($(aData)[57]);
					var dvFin = parseInt($(aData)[58]);					
					
					if(estIni=="No Aceptado" || estIni=="En Curso"){
						if(dvIni>5){
							$(nRow).find("td").eq(7).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvIni<=5 && dvIni>=0){
								if($(nRow).find("td").eq(7).html()!=""){
									$(nRow).find("td").eq(7).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvIni<0){
									$(nRow).find("td").eq(7).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(7).css("background", "rgba(91, 192, 222, .3)");
					}
					
					if(estPar=="No Aceptado" || estPar=="En Curso"){
						if(dvPar>5){
							$(nRow).find("td").eq(9).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvPar<=5 && dvPar>=0){
								if($(nRow).find("td").eq(9).html()!=""){
									$(nRow).find("td").eq(9).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvPar<0){
									$(nRow).find("td").eq(9).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(9).css("background", "rgba(91, 192, 222, .3)");
					}
					
					if(estFin=="No Aceptado" || estPar=="En Curso"){
						if(dvFin>5){
							$(nRow).find("td").eq(11).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvFin<=5 && dvFin>=0){
								if($(nRow).find("td").eq(11).html()!=""){
									$(nRow).find("td").eq(11).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvFin<0){
									$(nRow).find("td").eq(11).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(11).css("background", "rgba(91, 192, 222, .3)");
					}
										
					$(nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();

						var PRY_Id=$(this).find("td")[0].innerText;
						var LIN_Id=$(this).find("td")[4].innerText;
						$.ajax( {
							type:'POST',					
							url: '/bandeja-de-entrada/modificar',
							data: {key2:PRY_Id,key1:LIN_Id},
							success: function ( data ) {
								param = data.split(sas)
								if(param[0]==200){						
									$("#contenbody").html(param[1]);
									var href = window.location.href;
									var newhref = href.substr(href.indexOf("/home")+6,href.length);
									var href_split = newhref.split("/")

									href_split[1]="modificar";
									href_split[2]=LIN_Id;
									href_split[3]=PRY_Id;
									var newurl="/home"
									$.each(href_split, function(i,e){
										newurl=newurl + "/" + e
									});
									window.history.replaceState(null, "", newurl);
									cargabreadcrumb("/breadcrumbs","");
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){

							}
						});	
					});
				}
			});
		}
		
		//Mesas
		var mesasTable;
		function tableMesas(LIN_Id){			
			var tables = $.fn.dataTable.fnTables(true);			
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			mesasTable = $('#tbl-mesa').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"<%=url%>",					
					type:"POST",
					dataSrc:function(json){					
						return json.data;					
					},
					data:{tpo:<%=tpo%>,LFO_Id:LIN_Id}					
				},	
				columnDefs: [{
					"targets": [ 4,5,8,10,13,16,19,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58 ],
					"visible": false,
					"searchable": false
					},{
					"targets": [0,2,3,6,9,12,15,18],"width":"20px"
					}
				],
				autoWidth: false,				
				order:[0,"desc"],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					var estIni = $(aData)[47];
					var estPar = $(aData)[48];
					var estFin = $(aData)[49];					
					
					var dvIni = parseInt($(aData)[56]);
					var dvPar = parseInt($(aData)[57]);
					var dvFin = parseInt($(aData)[58]);					
					
					if(estIni=="No Aceptado" || estIni=="En Curso"){
						if(dvIni>5){
							$(nRow).find("td").eq(7).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvIni<=5 && dvIni>=0){
								if($(nRow).find("td").eq(7).html()!=""){
									$(nRow).find("td").eq(7).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvIni<0){
									$(nRow).find("td").eq(7).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(7).css("background", "rgba(91, 192, 222, .3)");
					}
					
					if(estPar=="No Aceptado" || estPar=="En Curso"){
						if(dvPar>5){
							$(nRow).find("td").eq(9).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvPar<=5 && dvPar>=0){
								if($(nRow).find("td").eq(9).html()!=""){
									$(nRow).find("td").eq(9).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvPar<0){
									$(nRow).find("td").eq(9).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(9).css("background", "rgba(91, 192, 222, .3)");
					}
					
					if(estFin=="No Aceptado" || estPar=="En Curso"){
						if(dvFin>5){
							$(nRow).find("td").eq(11).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvFin<=5 && dvFin>=0){
								if($(nRow).find("td").eq(11).html()!=""){
									$(nRow).find("td").eq(11).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvFin<0){
									$(nRow).find("td").eq(11).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(11).css("background", "rgba(91, 192, 222, .3)");
					}
										
					$(nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();

						var PRY_Id=$(this).find("td")[0].innerText;
						var LIN_Id=$(this).find("td")[4].innerText;
						$.ajax( {
							type:'POST',					
							url: '/bandeja-de-entrada/modificar',
							data: {key2:PRY_Id,key1:LIN_Id},
							success: function ( data ) {
								param = data.split(sas)
								if(param[0]==200){						
									$("#contenbody").html(param[1]);
									var href = window.location.href;
									var newhref = href.substr(href.indexOf("/home")+6,href.length);
									var href_split = newhref.split("/")

									href_split[1]="modificar";
									href_split[2]=LIN_Id;
									href_split[3]=PRY_Id;
									var newurl="/home"
									$.each(href_split, function(i,e){
										newurl=newurl + "/" + e
									});
									window.history.replaceState(null, "", newurl);
									cargabreadcrumb("/breadcrumbs","");
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){

							}
						});	
					});
				}
			});
		}
		
		//Cursos
		var cursosTable;
		function tableCursos(LIN_Id){			
			var tables = $.fn.dataTable.fnTables(true);			
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			cursosTable = $('#tbl-curso').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"<%=url%>",					
					type:"POST",
					dataSrc:function(json){					
						return json.data;					
					},
					data:{tpo:<%=tpo%>,LFO_Id:LIN_Id}					
				},	
				columnDefs: [{					
					"targets": [ 4,5,8,10,13,14,15,16,19,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58 ],
					"visible": false,
					"searchable": false
					},{
					"targets": [0,2,3,6,9,12,15,18],"width":"20px"
					}
				],
				autoWidth: false,				
				order:[0,"desc"],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					var estIni = $(aData)[47];
					var estPar = $(aData)[48];
					var estFin = $(aData)[49];					
					
					var dvIni = parseInt($(aData)[56]);
					var dvPar = parseInt($(aData)[57]);
					var dvFin = parseInt($(aData)[58]);					
					
					if(estIni=="No Aceptado" || estIni=="En Curso"){
						if(dvIni>5){
							$(nRow).find("td").eq(7).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvIni<=5 && dvIni>=0){
								if($(nRow).find("td").eq(7).html()!=""){
									$(nRow).find("td").eq(7).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvIni<0){
									$(nRow).find("td").eq(7).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(7).css("background", "rgba(91, 192, 222, .3)");
					}										
					
					if(estFin=="No Aceptado" || estPar=="En Curso"){
						if(dvFin>5){
							$(nRow).find("td").eq(9).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvFin<=5 && dvFin>=0){
								if($(nRow).find("td").eq(9).html()!=""){
									$(nRow).find("td").eq(9).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvFin<0){
									$(nRow).find("td").eq(9).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(9).css("background", "rgba(91, 192, 222, .3)");
					}
										
					$(nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();

						var PRY_Id=$(this).find("td")[0].innerText;
						var LIN_Id=$(this).find("td")[4].innerText;
						$.ajax( {
							type:'POST',					
							url: '/bandeja-de-entrada/modificar',
							data: {key2:PRY_Id,key1:LIN_Id},
							success: function ( data ) {
								param = data.split(sas)
								if(param[0]==200){						
									$("#contenbody").html(param[1]);
									var href = window.location.href;
									var newhref = href.substr(href.indexOf("/home")+6,href.length);
									var href_split = newhref.split("/")

									href_split[1]="modificar";
									href_split[2]=LIN_Id;
									href_split[3]=PRY_Id;
									var newurl="/home"
									$.each(href_split, function(i,e){
										newurl=newurl + "/" + e
									});
									window.history.replaceState(null, "", newurl);
									cargabreadcrumb("/breadcrumbs","");
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){

							}
						});	
					});
				}
			});
		}
		
		//Recuperacion
		var recuperacionTable;
		function tableRecuperacion(LIN_Id){			
			var tables = $.fn.dataTable.fnTables(true);			
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			recuperacionTable = $('#tbl-recuperacion').DataTable({
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"<%=url%>",					
					type:"POST",
					dataSrc:function(json){					
						return json.data;					
					},
					data:{tpo:<%=tpo%>,LFO_Id:LIN_Id}					
				},	
				columnDefs: [{
					"targets": [ 4,5,8,10,13,16,19,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58 ],
					"visible": false,
					"searchable": false
					},{
					"targets": [0,2,3,6,9,12,15,18],"width":"20px"
					}
				],
				autoWidth: false,				
				order:[0,"desc"],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {					
					var estIni = $(aData)[47];
					var estPar = $(aData)[48];
					var estFin = $(aData)[49];					
					
					var dvIni = parseInt($(aData)[56]);
					var dvPar = parseInt($(aData)[57]);
					var dvFin = parseInt($(aData)[58]);					
					
					if(estIni=="No Aceptado" || estIni=="En Curso"){
						if(dvIni>5){
							$(nRow).find("td").eq(7).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvIni<=5 && dvIni>=0){
								if($(nRow).find("td").eq(7).html()!=""){
									$(nRow).find("td").eq(7).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvIni<0){
									$(nRow).find("td").eq(7).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(7).css("background", "rgba(91, 192, 222, .3)");
					}
					
					if(estPar=="No Aceptado" || estPar=="En Curso"){
						if(dvPar>5){
							$(nRow).find("td").eq(9).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvPar<=5 && dvPar>=0){
								if($(nRow).find("td").eq(9).html()!=""){
									$(nRow).find("td").eq(9).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvPar<0){
									$(nRow).find("td").eq(9).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(9).css("background", "rgba(91, 192, 222, .3)");
					}
					
					if(estFin=="No Aceptado" || estPar=="En Curso"){
						if(dvFin>5){
							$(nRow).find("td").eq(11).css("background", "rgba(217, 83, 79, .3)");
						}else{
							if(dvFin<=5 && dvFin>=0){
								if($(nRow).find("td").eq(11).html()!=""){
									$(nRow).find("td").eq(11).css("background", "rgba(240, 173, 78, .3)");
								}
							}else{
								if(dvFin<0){
									$(nRow).find("td").eq(11).css("background", "rgba(92, 184, 92, .3)");									
								}
							}
						}
					}else{					
						$(nRow).find("td").eq(11).css("background", "rgba(91, 192, 222, .3)");
					}
										
					$(nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();

						var PRY_Id=$(this).find("td")[0].innerText;
						var LIN_Id=$(this).find("td")[4].innerText;
						$.ajax( {
							type:'POST',					
							url: '/bandeja-de-entrada/modificar',
							data: {key2:PRY_Id,key1:LIN_Id},
							success: function ( data ) {
								param = data.split(sas)
								if(param[0]==200){						
									$("#contenbody").html(param[1]);
									var href = window.location.href;
									var newhref = href.substr(href.indexOf("/home")+6,href.length);
									var href_split = newhref.split("/")

									href_split[1]="modificar";
									href_split[2]=LIN_Id;
									href_split[3]=PRY_Id;
									var newurl="/home"
									$.each(href_split, function(i,e){
										newurl=newurl + "/" + e
									});
									window.history.replaceState(null, "", newurl);
									cargabreadcrumb("/breadcrumbs","");
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){

							}
						});	
					});
				}
			});
		}

		$(".buttonExport").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var idTable = $(this).data("id")

			const inputValue=idTable + '.csv';
			const { value: csvFilename } = swalWithBootstrapButtons.fire({
				icon:'info',
				title: 'Ingresa el nombre del archivo',
				input: 'text',
				inputValue: inputValue,
				showCancelButton: true,
				confirmButtonText: '<i class="fas fa-sync-alt"></i> Generar',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
				inputValidator: (value) => {
				if (!value) {
				  return 'Debes escribir un nombre de archivo!';
				}
			  }
			}).then((result) => {
				if(result.value){				
					$('#tbl-'+idTable).exporttocsv({
						fileName  : result.value,
						separator : ';',
						table	  : 'dt'
					});				
				}

			});							
		});		
		
		$(".buttonArchive").click(function(e){
			e.preventDefault();
			e.stopPropagation();
			swalWithBootstrapButtons.fire({
				icon:'info',
				title: 'Ingresa el motivo del archivado del(los) proyecto(s)',
				input: 'textarea',
				inputValue: "",
				showCancelButton: true,
				confirmButtonText: '<i class="fas fa-check"></i> Seleccionar Proyectos',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
				inputValidator: (value) => {
				if (!value) {
				  return 'Debes escribir un motivo para archivar este(os) proyecto(s)';
				}
			  }
			}).then((result) => {
				if(result.value){				
					ajax_icon_handling('load','Generando listado de proyectos...','','');
					$.ajax({
						type: 'POST',								
						url:'/listar-proyectos',					
						success: function(data) {
							var param=data.split(sas);
							var jus=result.value;
							if(param[0]=="200"){				
								ajax_icon_handling(true,'Listado de Proyectos creado.','',param[1]);
								$(".swal2-popup").css("width","60rem");
								var listproyectos=$("#tbl-listproyectos").DataTable({
									columnDefs: [ {
										targets: 0,
										data: null,
										defaultContent: '',
										orderable: false,
										className: 'select-checkbox',
										width:"50px"
									} ],
									select: {
										style:    'multi',
										selector: 'td:first-child'

									},
									order: [[ 1, 'desc' ]],
									lengthMenu: [ 5,10,20 ]								
								});

								$("#btn_cancelapry").click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									Swal.close();
								});
								$("#btn_archivapry").click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									if(listproyectos.rows(".selected").data().length>0){									
										ajax_icon_handling('load','Archivando proyecto(s)...','','');
										listproyectos.rows(".selected").data().each(function(i){										
											$.ajax({
												type: 'POST',								
												url:'/archivar-proyecto',
												data:{PRY_Id:i[1],MEN_Texto:jus},
												success: function(data) {
													var param=data.split(sas);
													if(param=200){

													}
												}											
											});										
										});
										ajax_icon_handling(true,'Proyecto(s) Archivado(s).','','');
										var pryarc = setInterval(function(){													
											Swal.close();
											clearInterval(pryarc)																				
										},1300);
										escuelaTable.ajax.reload();
										mesasTable.ajax.reload();
										cursosTable.ajax.reload();										
									}else{									
										shake($('#btn_archivapry'));									
									}								

								});
							}else{
								ajax_icon_handling(false,'No fue posible crear el listado de proyectos.','','');
							}						
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){				
							ajax_icon_handling(false,'No fue posible crear el listado de proyectos.','','');	
						},
						complete: function(){																		
						}
					})		
				}

			});							
		});		
				
		$(".buttonUnArchive").click(function(e){
			e.preventDefault();
			e.stopPropagation();
			swalWithBootstrapButtons.fire({
				icon:'info',
				title: 'Ingresa el motivo del desarchivado del(los) proyecto(s)',
				input: 'textarea',
				inputValue: "",
				showCancelButton: true,
				confirmButtonText: '<i class="fas fa-check"></i> Seleccionar Proyectos',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
				inputValidator: (value) => {
				if (!value) {
				  return 'Debes escribir un motivo para desarchivar este(os) proyecto(s)';
				}
			  }
			}).then((result) => {
				if(result.value){				
					ajax_icon_handling('load','Generando listado de proyectos...','','');
					$.ajax({
						type: 'POST',								
						url:'/listar-proyectos-archivados',					
						success: function(data) {
							var param=data.split(sas);
							var jus=result.value;
							if(param[0]=="200"){				
								ajax_icon_handling(true,'Listado de Proyectos creado.','',param[1]);
								$(".swal2-popup").css("width","60rem");
								var listproyectos=$("#tbl-listproyectos").DataTable({
									columnDefs: [ {
										targets: 0,
										data: null,
										defaultContent: '',
										orderable: false,
										className: 'select-checkbox',
										width:"50px"
									} ],
									select: {
										/*style:    'os',*/
										style:    'multi',
										selector: 'td:first-child'
									},
									order: [[ 1, 'desc' ]],
									lengthMenu: [ 5,10,20 ]								
								});

								$("#btn_cancelapry").click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									Swal.close();
								});
								$("#btn_desarchivapry").click(function(e){
									e.preventDefault();
									e.stopImmediatePropagation();
									e.stopPropagation();

									if(listproyectos.rows(".selected").data().length>0){									
										ajax_icon_handling('load','Desarchivando proyecto(s)...','','');
										listproyectos.rows(".selected").data().each(function(i){										
											$.ajax({
												type: 'POST',								
												url:'/desarchivar-proyecto',
												data:{PRY_Id:i[1],MEN_Texto:jus},
												success: function(data) {
													var param=data.split(sas);
													if(param=200){

													}
												}											
											});
										})
										ajax_icon_handling(true,'Proyecto(s) desarchivado(s).','','');
										var pryarc = setInterval(function(){													
											Swal.close();
											clearInterval(pryarc)																				
										},1300);
										var url="/bandeja-de-archivados";
										cargacomponente(url,"");
										window.history.replaceState(null, "", "/home"+url);	
										cargabreadcrumb("/breadcrumbs","");
									}else{									
										shake($('#btn_archivapry'));									
									}								

								});
							}else{
								ajax_icon_handling(false,'No fue posible crear el listado de proyectos.','','');
							}						
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){				
							ajax_icon_handling(false,'No fue posible crear el listado de proyectos.','','');	
						},
						complete: function(){																		
						}
					})		
				}

			});		
		});
			
	});		
</script>