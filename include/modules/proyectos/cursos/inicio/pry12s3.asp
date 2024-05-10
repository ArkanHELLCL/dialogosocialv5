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
		action="/mod-12-h1-s3"
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
	end if	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.write("mode-" & mode)
	'response.end
%>
<form role="form" action="<%=action%>" method="POST" name="frm12s3" id="frm12s3" class="needs-validation">
	<h5>Postulación</h5>		
	<h6>Cantidad de matriculados/as</h6>
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
	
	<div class="row">
		<div class="footer"><%
			if mode="mod" or mode="add" then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect waves-dark" id="btn_frm12s3" name="btn_frm12s3"><%=txtBoton%></button><%
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
		}
	
		$("#btn_frm12s3").click(function(){
			formValidate("#frm12s3")
			if($("#frm12s3").valid()){
				if(parseInt($("#TotalInscri").val())==0 || $("#TotalInscri").val()==""){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'No existen alumnos/as matriculados/as.',						
						text:'Debes ingresarlos/as antes de poder pasar al siguiente paso.'
					});	
				}else{
								
					var bb = String.fromCharCode(92) + String.fromCharCode(92);
					$.ajax({
						type: 'POST',			
						url: $("#frm12s3").attr("action"),
						data: $("#frm12s3").serialize(),
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
									url: '/mnu-12',
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
			}
		})
	});
</script>