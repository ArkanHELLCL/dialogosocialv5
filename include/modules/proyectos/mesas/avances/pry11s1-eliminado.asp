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
		action="/mod-11-h2-s1"
		columnsSIN="{data: ""GFS_Id""},{data: ""GFS_Nombre""},{data: ""GFS_Cargo""},{data: ""Sexo""}" 		
		columnsEMP="{data: ""GFE_Id""},{data: ""GFE_Nombre""},{data: ""GFE_Cargo""},{data: ""Sexo""}" 		
		columnsGOB="{data: ""GFG_Id""},{data: ""GFG_Nombre""},{data: ""GFG_Cargo""},{data: ""Sexo""}" 		
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
		columnsSIN="{data: ""GFS_Id""},{data: ""GFS_Nombre""},{data: ""GFS_Cargo""},{data: ""Sexo""}" 		
		columnsEMP="{data: ""GFE_Id""},{data: ""GFE_Nombre""},{data: ""GFE_Cargo""},{data: ""Sexo""}" 		
		columnsGOB="{data: ""GFG_Id""},{data: ""GFG_Nombre""},{data: ""GFG_Cargo""},{data: ""Sexo""}" 		
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
			PRY_TipoMesa=rs("PRY_TipoMesa")
			PRY_RelevanciaTematicaSindicato=rs("PRY_RelevanciaTematicaSindicato")
			PRY_ProblematicaAsociadaSindicato=rs("PRY_ProblematicaAsociadaSindicato")
			PRY_InformeInicialEstado=rs("PRY_InformeInicialEstado")			
			PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
			
			PRY_RelevanciaTematicaEmpresa=rs("PRY_RelevanciaTematicaEmpresa")
			PRY_ProblematicaAsociadaEmpresa=rs("PRY_ProblematicaAsociadaEmpresa")
			
			PRY_ProblematicaAsociadaGobierno=rs("PRY_ProblematicaAsociadaGobierno")
			PRY_RelevanciaTematicaGobierno=rs("PRY_RelevanciaTematicaGobierno")
			
			PRY_Estado=rs("PRY_Estado")
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
			
	rs.close
	response.write("200/@/")	
%>		
	<div class="row">
		<h5 style="padding-right: 15px;padding-left: 15px;padding-bottom:20px;">Grupos Focales</h5>
		
		<!--container-nav-->
		<div class="container-nav" style="margin-right: 15px;margin-left: 15px;">
			<div class="header">				
				<div class="content-nav">
					<a id="gob1-tab" href="#sintab1" class="active tab"><i class="fas fa-users"></i> Grupo Focal Sindicato 						
					</a>
					<a id="gob2-tab" href="#emptab2" class="tab"><i class="fas fa-industry"></i> Grupo Focal Empresa 						
					</a><%
					if PRY_TipoMesa=2 then		'Tripartita%>
						<a id="gob3-tab" href="#gobtab3" class="tab"><i class="fas fa-university"></i> Grupo Focal Gobierno 							
						</a><%
					end if%>
					<span class="yellow-bar"></span>				
					<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
						<div class="animated-icon1"><span></span><span></span><span></span></div>
					</button>
				</div>				
			</div>
			<div class="tab-content">
				<!--sintab1-->
				<div id="sintab1">
					<h5>Feedback</h5>
					<form role="form" action="" method="POST" name="frm11s1_1" id="frm11s1_1" class="needs-validation">
						<div class="row">
							<div class="col-sm-12 col-md-6 col-lg-6">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_RelevanciaTematicaSindicato" name="PRY_RelevanciaTematicaSindicato" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una relevancia"><%=PRY_RelevanciaTematicaSindicato%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_RelevanciaTematicaSindicato<>"") then
											clase="active"
										end if%>
										<label for="" class="<%=clase%>">Relevancia de la Temática focalizada</label>									
									</div>
								</div>
							</div>			
							<div class="col-sm-12 col-md-6 col-lg-6">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_ProblematicaAsociadaSindicato" name="PRY_ProblematicaAsociadaSindicato" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una problemática"><%=PRY_ProblematicaAsociadaSindicato%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_ProblematicaAsociadaSindicato<>"") then
											clase="active"
										end if%>
										<label for="PRY_ProblematicaAsociadaSindicato" class="<%=clase%>">Problemática asociadas a la Temática</label>									
									</div>
								</div>
							</div>			
						</div>
					</form>
					
					<h5>Prioridades</h5><%
					if(mode="mod") then%>
						<form role="form" action="" method="POST" name="frm11s1PRI_1" id="frm11s1PRI_1" class="needs-validation">
							<div class="row align-items-center">						
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-list-ol input-prefix"></i>													
											<input type="number" id="PRS_Prioridad" name="PRS_Prioridad" class="form-control" required="" value="" data-msg="Ingresa una prioridad">
											<span class="select-bar"></span>
											<label for="PRS_Prioridad" class="">Priorirdad</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-10 col-lg-10">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-comment input-prefix"></i>													
											<input type="text" id="PRS_Problematica" name="PRS_Problematica" class="form-control" required="" value="" data-msg="Debes ingresar una problemática">
											<span class="select-bar"></span>
											<label for="PRS_Problematica" class="">Problematica</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row align-items-center">
								<div class="col-sm-12 col-md-12 col-lg-12">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-comment input-prefix"></i>
											<input type="text" id="PRS_ExpectativaSolucion" name="PRS_ExpectativaSolucion" class="form-control" required="" value="" data-msg="Debes ingresar una expectativa">
											<span class="select-bar"></span>
											<label for="PRS_ExpectativaSolucion" class="">Expectativa de solución esperada</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row align-items-center" style="margin-bottom:20px">
								<div class="col-sm-12 col-md-10 col-lg-10">
									<div class="md-form">
										<div class="error-message">	
											<i class="fas fa-comment prefix"></i>
											<textarea id="PRS_Compromiso" name="PRS_Compromiso" class="md-textarea form-control" rows="5" required="" data-msg="Debes ingresar un compromiso"></textarea>
											<span class="select-bar"></span>
											<label for="PRS_Compromiso" class="">Compromiso</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s1_1" name="btn_frm11s1_1" style="float:right;"><i class="fas fa-plus"></i></button>
								</div>
							</div>
							<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">						
						</form><%
					end if%>
					
					<table id="tbl-sinprioridades" class="ts table table-striped table-bordered dataTable table-sm tbl-sinprioridades" data-id="sinprioridades" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">#</th>
								<th style="width:10px;">P</th>
								<th>Problemática</th>												
								<th>Expectativa de solución esperada</th>
								<th>Compromiso</th>
								<th>Bajar Verificador</th><%
								if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
									<th>Acciones</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody>
						</tbody>
					</table>
					
					<h5>Sindicatos</h5><%
					x=0
					set rz = cnn.execute("spProyGrupoFocalSindicato_Listar " & PRY_Id & ", -1")					
					on error resume next
					if cnn.Errors.Count > 0 then 
					   ErrMsg = cnn.Errors(0).description	   
					   cnn.close
					   response.Write("503/@/Error Conexión:" & ErrMsg)
					   response.End() 			   
					end if
					do while not rz.eof
						x=x+1
						SINREP_Id=rz("SIN_Id")
						SINREP_Nombre = rz("SIN_Nombre")
						existe=1
					
						if x>0 then%>				
							<h6 style="font-size: 1rem;margin-bottom:20px"><%=x%>.- <%=SINREP_Nombre%></h6><%							
						end if%>						
						<table id="tbl-repsind_<%=x%>" class="ts table table-striped table-bordered dataTable table-sm tbl-repsind" data-id="repsind" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th>Nombre</th>									
									<th>Cargo</th>
									<th>Sexo</th>
								</tr> 
							</thead>					
							<tbody><%
								set rs = cnn.execute("spGrupoFocalSindicato_Listar 1, " & PRY_Id & "," & rz("SIN_Id"))
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description
									'response.write ErrMsg & " strig= " & sq			
									cnn.close 			   
									Response.end()
								End If
								dataSindicales = "["
								do While Not rs.EOF									
									dataSindicales = dataSindicales & "{""GFS_Id"":""" & rs("GFS_Id") & """,""GFS_Nombre"":""" & rs("GFS_Nombre") & """,""GFS_Cargo"":""" & rs("GFS_Cargo") & """,""Sexo"":""" & rs("SEX_Descripcion") & """" 									

									dataSindicales = dataSindicales & "}"											
									rs.movenext
									if not rs.eof then
										dataSindicales = dataSindicales & ","
									end if									
								loop
								dataSindicales=dataSindicales & "]"
								dataSindicalesArray=dataSindicalesArray & dataSindicales & ","
								rs.close%>                	
							</tbody>
						</table><%
						rz.movenext
					loop
					MaxSin = x
					dataSindicalesArray = "[" & dataSindicalesArray & "]"%>
				</div>
				<!--sintab1-->				
				<!--emptab2-->
				<div id="emptab2">	<%'Organizaciones Empresariales%>
					<h5>Feedback</h5>
					<form role="form" action="" method="POST" name="frm11s1_2" id="frm11s1_2" class="needs-validation">
						<div class="row">
							<div class="col-sm-12 col-md-6 col-lg-6">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_RelevanciaTematicaEmpresa" name="PRY_RelevanciaTematicaEmpresa" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una relevancia"><%=PRY_RelevanciaTematicaEmpresa%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_RelevanciaTematicaEmpresa<>"") then
											clase="active"
										end if%>
										<label for="PRY_RelevanciaTematicaEmpresa" class="<%=clase%>">Relevancia de la Temática focalizada</label>									
									</div>
								</div>
							</div>			
							<div class="col-sm-12 col-md-6 col-lg-6">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>
											<textarea id="PRY_ProblematicaAsociadaEmpresa" name="PRY_ProblematicaAsociadaEmpresa" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una problemática"><%=PRY_ProblematicaAsociadaEmpresa%></textarea>
										<span class="select-bar"></span><%
										clase=""
										if(PRY_ProblematicaAsociadaEmpresa<>"") then
											clase="active"
										end if%>
										<label for="PRY_ProblematicaAsociadaEmpresa" class="<%=clase%>">Problemática asociadas a la Temática</label>									
									</div>
								</div>
							</div>			
						</div>
					</form>
					
					<h5>Prioridades</h5><%
					if(mode="mod") then%>
						<form role="form" action="" method="POST" name="frm11s1PRI_2" id="frm11s1PRI_2" class="needs-validation">
							<div class="row align-items-center">						
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-list-ol input-prefix"></i>													
											<input type="number" id="PRE_Prioridad" name="PRE_Prioridad" class="form-control" required="" value="" data-msg="Ingresa una prioridad">
											<span class="select-bar"></span>
											<label for="PRE_Prioridad" class="">Priorirdad</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-10 col-lg-10">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-comment input-prefix"></i>													
											<input type="text" id="PRE_Problematica" name="PRE_Problematica" class="form-control" required="" value="" data-msg="Debes ingresar una problematica">
											<span class="select-bar"></span>
											<label for="PRE_Problematica" class="">Problematica</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row align-items-center">
								<div class="col-sm-12 col-md-12 col-lg-12">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-comment input-prefix"></i>													
											<input type="text" id="PRE_ExpectativaSolucion" name="PRE_ExpectativaSolucion" class="form-control" required="" value="" data-msg="Debes ingresa una expectativa">
											<span class="select-bar"></span>
											<label for="PRE_ExpectativaSolucion" class="">Expectativa de solución esperada</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row align-items-center" style="margin-bottom:20px">
								<div class="col-sm-12 col-md-10 col-lg-10">
									<div class="md-form">
										<div class="error-message">	
											<i class="fas fa-comment prefix"></i>
											<textarea id="PRE_Compromiso" name="PRE_Compromiso" class="md-textarea form-control" rows="5" required="" data-msg="Debes ingresar un compromiso" data-msg="Debes ingresa un compromiso"></textarea>
											<span class="select-bar"></span>
											<label for="PRE_Compromiso" class="">Compromiso</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-2 col-lg-2">
									<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s1_2" name="btn_frm11s1_2" style="float:right;"><i class="fas fa-plus"></i></button>
								</div>
							</div>
							<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">						
						</form><%
					end if%>
					
					<table id="tbl-empprioridades" class="ts table table-striped table-bordered dataTable table-sm tbl-empprioridades" data-id="empprioridades" data-page="true" data-selected="true" data-keys="1"> 
						<thead> 
							<tr> 
								<th style="width:10px;">#</th>
								<th style="width:10px;">P</th>
								<th>Problemática</th>												
								<th>Expectativa de solución esperada</th>
								<th>Compromiso</th>
								<th>Bajar Verificador</th><%
								if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
									<th>Acciones</th><%
								end if%>
							</tr> 
						</thead>					
						<tbody>
						</tbody>
					</table>
					
					<h5>Empresas</h5><%
					
					x=0
					set rz = cnn.execute("spProyGrupoFocalEmpresa_Listar " & PRY_Id & ", -1")					
					on error resume next
					if cnn.Errors.Count > 0 then 
					   ErrMsg = cnn.Errors(0).description	   
					   cnn.close
					   response.Write("503/@/Error Conexión:" & ErrMsg)
					   response.End() 			   
					end if
					do while not rz.eof
						x=x+1
						EMPREP_Id=rz("EMP_Id")	
						EMPREP_Nombre = rz("EMP_Nombre")				
						existe=1
						
						if x>0 then%>				
							<h6 style="font-size: 1rem;margin-bottom:20px"><%=x%>.- <%=EMPREP_Nombre%></h6><%
						end if%>						
						<table id="tbl-repemp_<%=x%>" class="ts table table-striped table-bordered dataTable table-sm tbl-repemp" data-id="repemp" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th>Nombre</th>									
									<th>Cargo</th>
									<th>Sexo</th>
								</tr> 
							</thead>					
							<tbody><%
								set rs = cnn.execute("spGrupoFocalEmpresa_Listar 1, " & PRY_Id & "," & rz("EMP_Id"))
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description
									'response.write ErrMsg & " strig= " & sq			
									cnn.close 			   
									Response.end()
								End If
								dataEmpresariales = "["
								do While Not rs.EOF									
									dataEmpresariales = dataEmpresariales & "{""GFE_Id"":""" & rs("GFE_Id") & """,""GFE_Nombre"":""" & rs("GFE_Nombre") & """,""GFE_Cargo"":""" & rs("GFE_Cargo") & """,""Sexo"":""" & rs("SEX_Descripcion") & """" 									

									dataEmpresariales = dataEmpresariales & "}"											
									rs.movenext
									if not rs.eof then
										dataEmpresariales = dataEmpresariales & ","
									end if									
								loop
								dataEmpresariales=dataEmpresariales & "]"
								dataEmpresarialesArray=dataEmpresarialesArray & dataEmpresariales & ","
								rs.close%>                	
							</tbody>
						</table><%
						rz.movenext
					loop
					MaxEmp = x
					dataEmpresarialesArray = "[" & dataEmpresarialesArray & "]"%>
				</div>
				<!--emptab2--><%				
				if PRY_TipoMesa=2 then		'Tripartita%>
					<div id="gobtab3"><%'Organizaciones de gobierno%>
						<h5>Feedback</h5>
						<form role="form" action="" method="POST" name="frm11s1_3" id="frm11s1_3" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="PRY_RelevanciaTematicaGobierno" name="PRY_RelevanciaTematicaGobierno" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una relevancia"><%=PRY_RelevanciaTematicaGobierno%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(PRY_RelevanciaTematicaGobierno<>"") then
												clase="active"
											end if%>
											<label for="PRY_RelevanciaTematicaGobierno" class="<%=clase%>">Relevancia de la Temática focalizada</label>									
										</div>
									</div>
								</div>			
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form">
										<div class="error-message">								
											<i class="fas fa-comment prefix"></i>
												<textarea id="PRY_ProblematicaAsociadaGobierno" name="PRY_ProblematicaAsociadaGobierno" class="md-textarea form-control" <%=disabled%> rows="5" data-msg="Debes ingresar una problemática"><%=PRY_ProblematicaAsociadaGobierno%></textarea>
											<span class="select-bar"></span><%
											clase=""
											if(PRY_ProblematicaAsociadaGobierno<>"") then
												clase="active"
											end if%>
											<label for="PRY_ProblematicaAsociadaGobierno" class="<%=clase%>">Problemática asociadas a la Temática</label>									
										</div>
									</div>
								</div>			
							</div>
						</form>

						<h5>Prioridades</h5><%
						if(mode="mod") then%>
							<form role="form" action="" method="POST" name="frm11s1PRI_3" id="frm11s1PRI_3" class="needs-validation">
								<div class="row align-items-center">						
									<div class="col-sm-12 col-md-2 col-lg-2">
										<div class="md-form input-with-post-icon">
											<div class="error-message">	
												<i class="fas fa-list-ol input-prefix"></i>													
												<input type="number" id="PRG_Prioridad" name="PRG_Prioridad" class="form-control" required="" value="" data-msg="Ingresa una prioridad">
												<span class="select-bar"></span>
												<label for="PRG_Prioridad" class="">Priorirdad</label>
											</div>
										</div>
									</div>
									<div class="col-sm-12 col-md-10 col-lg-10">
										<div class="md-form input-with-post-icon">
											<div class="error-message">	
												<i class="fas fa-comment input-prefix"></i>													
												<input type="text" id="PRG_Problematica" name="PRG_Problematica" class="form-control" required="" value="" data-msg="Debes ingresar una problemática">
												<span class="select-bar"></span>
												<label for="PRG_Problematica" class="">Problematica</label>
											</div>
										</div>
									</div>
								</div>
								<div class="row align-items-center">
									<div class="col-sm-12 col-md-12 col-lg-12">
										<div class="md-form input-with-post-icon">
											<div class="error-message">	
												<i class="fas fa-comment input-prefix"></i>													
												<input type="text" id="PRG_ExpectativaSolucion" name="PRG_ExpectativaSolucion" class="form-control" required="" value="" data-msg="Debes ingresar una expectativa">
												<span class="select-bar"></span>
												<label for="PRG_ExpectativaSolucion" class="">Expectativa de solución esperada</label>
											</div>
										</div>
									</div>
								</div>
								<div class="row align-items-center" style="margin-bottom:20px">
									<div class="col-sm-12 col-md-10 col-lg-10">
										<div class="md-form">
											<div class="error-message">	
												<i class="fas fa-comment prefix"></i>
												<textarea id="PRG_Compromiso" name="PRG_Compromiso" class="md-textarea form-control" rows="5" required="" data-msg="Debes ingresar un compromiso" data-msg="Debes ingresa un compromiso"></textarea>
												<span class="select-bar"></span>
												<label for="PRG_Compromiso" class="">Compromiso</label>
											</div>
										</div>
									</div>
									<div class="col-sm-12 col-md-2 col-lg-2">
										<button type="button" class="btn btn-success btn-md waves-effect waves-dark" id="btn_frm11s1_3" name="btn_frm11s1_3" style="float:right;"><i class="fas fa-plus"></i></button>
									</div>
								</div>
								<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">						
							</form><%
						end if%>

						<table id="tbl-gobprioridades" class="ts table table-striped table-bordered dataTable table-sm tbl-gobprioridades" data-id="gobprioridades" data-page="true" data-selected="true" data-keys="1"> 
							<thead> 
								<tr> 
									<th style="width:10px;">#</th>
									<th style="width:10px;">P</th>
									<th>Problemática</th>												
									<th>Expectativa de solución esperada</th>
									<th>Compromiso</th>
									<th>Bajar Verificador</th><%
									if (PRY_InformeConsensosEstado=0 and PRY_Estado=1) and ((session("ds5_usrperfil")=3) or (session("ds5_usrperfil")=1)) then%>
										<th>Acciones</th><%
									end if%>
								</tr> 
							</thead>					
							<tbody>
							</tbody>
						</table>

						<h5>Servicios</h5><%
						
						x=0
						set rz = cnn.execute("spProyGrupoFocalServicio_Listar " & PRY_Id & ", -1")					
						on error resume next
						if cnn.Errors.Count > 0 then 
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close
						   response.Write("503/@/Error Conexión:" & ErrMsg)
						   response.End() 			   
						end if
						do while not rz.eof
							x=x+1
							GOBREP_Id=rz("SER_Id")	
							GOBREP_Nombre = rz("SER_Nombre")				
							existe=1														
														
							if x>0 then%>				
								<h6 style="font-size: 1rem;margin-bottom:20px"><%=x%>.- <%=GOBREP_Nombre%></h6><%
							end if%>							
							<table id="tbl-repgob_<%=x%>" class="ts table table-striped table-bordered dataTable table-sm tbl-repgob" data-id="repgob" data-page="true" data-selected="true" data-keys="1"> 
								<thead> 
									<tr> 
										<th style="width:10px;">#</th>
										<th>Nombre</th>										
										<th>Cargo</th>
										<th>Sexo</th>
									</tr> 
								</thead>					
								<tbody><%
									set rs = cnn.execute("spGrupoFocalGobierno_Listar 1, " & PRY_Id & "," & rz("SER_Id"))
									on error resume next
									if cnn.Errors.Count > 0 then 
										ErrMsg = cnn.Errors(0).description
										'response.write ErrMsg & " strig= " & sq			
										cnn.close 			   
										Response.end()
									End If
									dataGobierno = "["
									do While Not rs.EOF									
										dataGobierno = dataGobierno & "{""GFG_Id"":""" & rs("GFG_Id") & """,""GFG_Nombre"":""" & rs("GFG_Nombre") & """,""GFG_Cargo"":""" & rs("GFG_Cargo") & """,""Sexo"":""" & rs("SEX_Descripcion") & """" 									

										dataGobierno = dataGobierno & "}"											
										rs.movenext
										if not rs.eof then
											dataGobierno = dataGobierno & ","
										end if									
									loop
									dataGobierno=dataGobierno & "]"	
									dataGobiernoArray=dataGobiernoArray & dataGobierno & ","
									rs.close%>                	
								</tbody>
							</table><%
							rz.movenext
						loop
						MaxGob = x
						dataGobiernoArray = "[" & dataGobiernoArray & "]"%>
					</div><%
				else
					MaxGob = 0
					dataGobiernoArray = "[]"
				end if%>
				</div>
				<!--tab-content-->
		</div>
		<!--conatiner-nav-->
	</div>
	<div class="row">		
		<div class="footer">
			<form role="form" action="<%=action%>" method="POST" name="frm11s1" id="frm11s1" class="needs-validation"><%
				if mode="mod" then%>				
					<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm11s1" name="btn_frm11s1"><%=txtBoton%></button>
					<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
					<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
					<input type="hidden" id="LIN_Id" name="LIN_Id" value="<%=LIN_Id%>">
					<input type="hidden" id="Step" name="Step" value="1">
					<input type="hidden" id="PRY_Hito" value="2" name="PRY_Hito">
					<input type="hidden" id="PRY_TipoMesa" value="<%=PRY_TipoMesa%>" name="PRY_TipoMesa"><%
				else%>				
					<button type="button" class="btn <%=btnColorS%> btn-md waves-effect waves-dark" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
				end if%>
			</form>
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
		$(".content-nav").tabsmaterialize({menumovil:false},function(){});		
		
				
		var dataSindicalesArray = [];
		var tableSin;
		dataSindicalesArray = <%=dataSindicalesArray%>		
		
		for(i=1;i<=<%=MaxSin%>;i++){
			tableSin = '#tbl-repsind_' + i
			loadTableSindicales(dataSindicalesArray[i-1],tableSin);
        	$(tableSin).css('width','100%')
		}
		
		function loadTableSindicales(data,table) {			
			$(table).DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsSIN%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		var prioridadesSIN;
		loadTablePrioridadesSIN();
		
		function loadTablePrioridadesSIN(){			
			if($.fn.DataTable.isDataTable( "#tbl-sinprioridades")){				
				if(prioridadesSIN!=undefined){
					prioridadesSIN.destroy();
				}else{
					$('#tbl-sinprioridades').dataTable().fnClearTable();
					$('#tbl-sinprioridades').dataTable().fnDestroy();
				}
			}				
			prioridadesSIN = $("#tbl-sinprioridades").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/prioridades-sindicatos",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});	
			$('#tbl-sinprioridades').css('width','100%')
		}					
		
		$("#btn_frm11s1_1").click(function(){
			formValidate("#frm11s1PRI_1");
			if($("#frm11s1PRI_1").valid()){
				$.ajax({
					type: "POST",
					url: "/grabar-prioridades-sindicatos",
					data: $("#frm11s1PRI_1").serialize(),
					dataType:'json',
					success: function(data) {					
						if(data.state==200){						
							prioridadesSIN.ajax.reload();	
							$("#frm11s1PRI_2")[0].reset();
							Toast.fire({
								icon: 'success',
							  	title: 'Prioridad grabada correctamente'
							});
						}else{
						
						}
					}
				})																		
			}			
		})
		
		$("#pry-content").on("click",".delprisin",function(){
			var PRS_Id=$(this).data("prs");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
			  	text: "Con esta acción eliminarás la prioridad seleccionada!",
			  	icon: 'warning',
			  	showCancelButton: true,
			  	confirmButtonColor: '#3085d6',
			  	cancelButtonColor: '#d33',
			  	confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
			  	cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {					
					$.ajax({
						type: "POST",
						url: "/elimina-prioridades-sindicatos",
						data: {PRY_Id:<%=PRY_Id%>,PRS_Id:PRS_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								prioridadesSIN.ajax.reload();		
								Toast.fire({
									icon: 'success',
									title: 'Prioridad eliminada correctamente'
								});
							}else{

							}
						}
					})
			  	}
			})	
		})
		
		var dataEmpresarialesArray = [];
		var tableEmp;
		dataEmpresarialesArray = <%=dataEmpresarialesArray%>		
		
		for(i=1;i<=<%=MaxEmp%>;i++){
			tableEmp = '#tbl-repemp_' + i
			loadTableEmpresariales(dataEmpresarialesArray[i-1],tableEmp);
        	$(tableEmp).css('width','100%')
		}
		
		function loadTableEmpresariales(data,table) {				
			$(table).DataTable({				
				lengthMenu: [ 5,10,20 ],
				data:data,
				columnDefs: [ {
				  targets  : 'no-sort',
				  orderable: false,
				}],
				columns: [<%=columnsEMP%>],
				order: [
					[0, 'asc']
				]			
			});						
		}
		
		var prioridadesEMP;
		loadTablePrioridadesEMP();
		
		function loadTablePrioridadesEMP(){			
			if($.fn.DataTable.isDataTable( "#tbl-empprioridades")){				
				if(prioridadesEMP!=undefined){
					prioridadesEMP.destroy();
				}else{
					$('#tbl-empprioridades').dataTable().fnClearTable();
					$('#tbl-empprioridades').dataTable().fnDestroy();
				}
			}				
			prioridadesEMP = $("#tbl-empprioridades").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/prioridades-empresas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});	
			$('#tbl-empprioridades').css('width','100%')
		}					
		
		$("#btn_frm11s1_2").click(function(){
			formValidate("#frm11s1PRI_2");
			if($("#frm11s1PRI_2").valid()){
				$.ajax({
					type: "POST",
					url: "/grabar-prioridades-empresas",
					data: $("#frm11s1PRI_2").serialize(),
					dataType:'json',
					success: function(data) {					
						if(data.state==200){						
							prioridadesEMP.ajax.reload();	
							$("#frm11s1PRI_2")[0].reset();
							Toast.fire({
								icon: 'success',
							  	title: 'Prioridad grabada correctamente'
							});
						}else{
						
						}
					}
				})																		
			}			
		})
		
		$("#pry-content").on("click",".delpriemp",function(){
			var PRE_Id=$(this).data("pre");
			swalWithBootstrapButtons.fire({
				title: '¿Estas seguro?',
			  	text: "Con esta acción eliminarás la prioridad seleccionada!",
			  	icon: 'warning',
			  	showCancelButton: true,
			  	confirmButtonColor: '#3085d6',
			  	cancelButtonColor: '#d33',
			  	confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
			  	cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {					
					$.ajax({
						type: "POST",
						url: "/elimina-prioridades-empresas",
						data: {PRY_Id:<%=PRY_Id%>,PRE_Id:PRE_Id},
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								prioridadesEMP.ajax.reload();		
								Toast.fire({
									icon: 'success',
									title: 'Prioridad eliminada correctamente'
								});
							}else{

							}
						}
					})
			  	}
			})	
		})
				
		var TipoMesa = <%=PRY_TipoMesa%>;
		
		if(TipoMesa == 2){
			var dataGobiernoArray = [];
			var tableGob;
			dataGobiernoArray = <%=dataGobiernoArray%>		
			for(i=1;i<=<%=MaxGob%>;i++){
				tableGob = '#tbl-repgob_' + i
				loadTableGobierno(dataGobiernoArray[i-1],tableGob);
				$(tableGob).css('width','100%')
			}

			function loadTableGobierno(data,table) {		
				$(table).DataTable({				
					lengthMenu: [ 5,10,20 ],
					data:data,
					columnDefs: [ {
					  targets  : 'no-sort',
					  orderable: false,
					}],
					columns: [<%=columnsGOB%>],
					order: [
						[0, 'asc']
					]			
				});						
			}				
			
			var prioridadesGOB;
			loadTablePrioridadesGOB();

			function loadTablePrioridadesGOB(){			
				if($.fn.DataTable.isDataTable( "#tbl-gobprioridades")){				
					if(prioridadesGOB!=undefined){
						prioridadesGOB.destroy();
					}else{
						$('#tbl-gobprioridades').dataTable().fnClearTable();
						$('#tbl-gobprioridades').dataTable().fnDestroy();
					}
				}				
				prioridadesGOB = $("#tbl-gobprioridades").DataTable({
					lengthMenu: [ 5,10,20 ],
					ajax:{
						url:"/prioridades-gobierno",
						type:"POST",
						data:{PRY_Id:<%=PRY_Id%>}
					}
				});	
				$('#tbl-gobprioridades').css('width','100%')
			}					

			$("#btn_frm11s1_3").click(function(){
				formValidate("#frm11s1PRI_3");
				if($("#frm11s1PRI_3").valid()){
					$.ajax({
						type: "POST",
						url: "/grabar-prioridades-gobierno",
						data: $("#frm11s1PRI_3").serialize(),
						dataType:'json',
						success: function(data) {					
							if(data.state==200){						
								prioridadesGOB.ajax.reload();	
								$("#frm11s1PRI_3")[0].reset();
								Toast.fire({
									icon: 'success',
									title: 'Prioridad grabada correctamente'
								});
							}else{

							}
						}
					})																		
				}			
			})

			$("#pry-content").on("click",".delprigob",function(){
				var PRG_Id=$(this).data("prg");
				swalWithBootstrapButtons.fire({
					title: '¿Estas seguro?',
					text: "Con esta acción eliminarás la prioridad seleccionada!",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Eliminar!',
					cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
				}).then((result) => {
					if (result.value) {					
						$.ajax({
							type: "POST",
							url: "/elimina-prioridades-gobierno",
							data: {PRY_Id:<%=PRY_Id%>,PRG_Id:PRG_Id},
							dataType:'json',
							success: function(data) {					
								if(data.state==200){						
									prioridadesGOB.ajax.reload();		
									Toast.fire({
										icon: 'success',
										title: 'Prioridad eliminada correctamente'
									});
								}else{

								}
							}
						})
					}
				})	
			})			
		}
														
		$("#btn_frm11s1").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frm11s1_1");
			formValidate("#frm11s1_2");
			formValidate("#frm11s1_3");
			var valido = false
			
			if(TipoMesa==2){
				if($("#frm11s1_1").valid() && $("#frm11s1_2").valid() && $("#frm11s1_3").valid()){
					valido=true;
				}
			}else{
				if($("#frm11s1_1").valid() && $("#frm11s1_2").valid()){
					valido=true;
				}
			}
			
			if(valido){
				var valido=false;
				if(TipoMesa==2){
					if(dataSindicalesArray.length>0 && dataEmpresarialesArray.length>0 && dataGobiernoArray.length>0){
						valido=true;
					}
				}else{
					if(dataSindicalesArray.length>0 && dataEmpresarialesArray.length>0){
						valido=true;
					}
				}					
				if(valido){
					var valido=false;
					if(TipoMesa==2){
						if(prioridadesSIN.data().count()>0 && prioridadesEMP.data().count()>0 && prioridadesGOB.data().count()>0){
							valido=true;
						}
					}else{
						if(prioridadesSIN.data().count()>0 && prioridadesEMP.data().count()>0){
							valido=true;
						}
					}
										
					if(valido){						
						$.ajax({
							type: 'POST',			
							url: $("#frm11s1").attr("action"),
							data: $("#frm11s1, #frm11s1_1, #frm11s1_2, #frm11s1_3").serialize(),
							dataType:"json",
							success: function(data) {								
								if(data.state=="200"){
									Toast.fire({
									  icon: 'success',
									  title: 'Feedback y prioriddes grabados correctamente'
									});
									var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:2};							
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
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Datos faltantes',
							text:'Debes ingresar al menos una Prioridad por cada agrupación antes de avanzar'
						});
					}
				}else{
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Datos faltantes',
						text:'Debes ingresar al menos un Integrante por cada agrupación antes de avanzar'
					});
				}
			}else{
				Toast.fire({
					icon: 'error',
				  	title: 'Corrige los errores en todas las pestañas antes de grabar.'
				});
			}
		})

		$("#pry-content").on("click",".doverprs, .doverpre, .doverpgb",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var GRP_Id = $(this).data("id");
			var GRP_Tipo = $(this).data("tip");
			var PRY_Hito = $(this).data("hito")
		
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-verificadores-grupos',			
				data:{GRP_Id:GRP_Id,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',GRP_Tipo:GRP_Tipo},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de verificadores creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$(this).data("hito");
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,ENP_Id:GRP_Id};
							$.ajax({
								url: "/bajar-archivo",
								method: 'POST',
								data:data,
								xhrFields: {
									responseType: 'blob'
								},
								success: function (data) {
									var a = document.createElement('a');
									var url = window.URL.createObjectURL(data);
									a.href = url;
									a.download = INF_Arc;
									document.body.append(a);
									a.click();
									a.remove();
									window.URL.revokeObjectURL(url);
								}
							});			
						})
					}else{
						ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de verificadores.','','');	
				},
				complete: function(){																		
				}
			})
		})

	});
</script>