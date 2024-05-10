<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
<head>
</head>
<!-- #INCLUDE FILE="session.min.inc" -->
<style>	
	h1 {
		display: block;
		font-size: 12pt;		
		margin-bottom: 0px;
		margin-left: 0;
		margin-right: 0;
		font-weight: bold;
		padding: 0;
		margin: 0;
	}
	h4 {
		display: block;
		font-size: 12pt;
		margin-top: 0px;
		margin-bottom: 1.33em;
		margin-left: 0;
		margin-right: 0;		
		font-weight: bold;
		padding-top: 10px;
	}
	h5 {
		display: block;
		font-size: 10pt;
		margin-top: 0px;
		margin-bottom: .7em;
		margin-left: 0;
		margin-right: 0;
		font-weight: bold;
	}	
	table {     
		font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;		
		width: 100%; 
		text-align: left;    
		border-collapse: collapse; 
	}

	th {     
		font-size: 10pt;
		font-weight: bold;
		padding: 2px;		
		background-color: #b9c9fe;    	
	}

	td { 
		font-size: 10px;
		padding: 2px;		
		background-color: #e8edff;     		
    	color: #669;    		
	}		
</style>
<%
PRY_Id		= request("PRY_Id")
MasterPage	= "Informe_Inicial"

set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 			   
	response.end()
End If

if int(PRY_Id)>0 and PRY_Id<>"" then
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.end()
	End If
			
	if not rs.eof then
		'PRY_Id							 = rs("PRY_Id")
		PRY_Identificador		         = rs("PRY_Identificador")
		PRY_Estado                       = rs("PRY_Estado")
		USR_IdRevisor			         = setNULL(rs("USR_IdRevisor"))
		USR_NombreRevisor		         = rs("USR_NombreRevisor")
		USR_ApellidoRevisor		         = rs("USR_ApellidoRevisor")
		USR_MailRevisor					 = rs("USR_MailRevisor")
		USR_TelefonoRevisor				 = rs("USR_TelefonoRevisor")
		USR_DireccionRevisor			 = rs("USR_DireccionRevisor")
		USR_NombreInstitucionRevisor	 = rs("USR_NombreInstitucionRevisor")					
		USR_IdEjecutor			         = setNULL(rs("USR_IdEjecutor"))
		USR_NombreEjecutor		         = rs("USR_NombreEjecutor")
		USR_ApellidoEjecutor	         = rs("USR_ApellidoEjecutor")
		USR_MailEjecutor				 = rs("USR_MailEjecutor")
		USR_TelefonoEjecutor			 = rs("USR_TelefonoEjecutor")
		USR_DireccionEjecutor			 = rs("USR_DireccionEjecutor")
		USR_NombreInstitucionEjecutor	 = rs("USR_NombreInstitucionEjecutor")										
		LIN_Id				             = setNULL(rs("LIN_Id"))
		LIN_Nombre 	                     = rs("LIN_Nombre")
		LFO_Id                           = setNULL(rs("LFO_Id"))
		LFO_Nombre                       = rs("LFO_Nombre")									
		COM_Id 			                 = setNULL(rs("COM_Id"))
		COM_Nombre			             = rs("COM_Nombre")
		REG_Id					         = rs("REG_Id")
		REG_Nombre				         = rs("REG_Nombre")
		PRY_Nombre		                 = rs("PRY_Nombre")
		PRY_AnioProyecto	             = rs("PRY_AnioProyecto")
		PRY_DireccionEjecucion           = rs("PRY_DireccionEjecucion")
		PRY_MontoAdjudicado              = rs("PRY_MontoAdjudicado")													
		PRY_EncargadoProyecto            = rs("PRY_EncargadoProyecto")
		PRY_EncargadoProyectoMail        = rs("PRY_EncargadoProyectoMail")	
		PRY_EncargadoProyectoCelular     = rs("PRY_EncargadoProyectoCelular")	
		PRY_EncargadoActividades         = rs("PRY_EncargadoActividades")
		PRY_EncargadoActividadesMail     = rs("PRY_EncargadoActividadesMail")
		PRY_EncargadoActividadesCelular  = rs("PRY_EncargadoActividadesCelular")
		SEX_IdEncargadoActividades	     = rs("SEX_IdEncargadoActividades")						
		SEX_IdEncargadoProyecto          = rs("SEX_IdEncargadoProyecto")
		PRY_UsuarioEdit					 = rs("PRY_UsuarioEdit")												
		PRY_FechaEdit					 = rs("PRY_FechaEdit")
		PRY_AccionEdit					 = rs("PRY_AccionEdit")
		PRY_InformeInicioFecha			 = rs("PRY_InformeInicioFecha")
		PRY_InformeInicioEstado			 = rs("PRY_InformeInicioEstado")
		PRY_InformeInicioFechaEnvio		 = rs("PRY_InformeInicioFechaEnvio")
		PRY_InformeParcialFecha			 = rs("PRY_InformeParcialFecha")
		PRY_InformeParcialEstado		 = rs("PRY_InformeParcialEstado")
		PRY_InformeParcialFechaEnvio	 = rs("PRY_InformeParcialFechaEnvio")
		PRY_InformeDesarrolloFecha		 = rs("PRY_InformeDesarrolloFecha")
		PRY_InformeDesarrolloEstado		 = rs("PRY_InformeDesarrolloEstado")
		PRY_InformeDesarrolloFechaEnvio	 = rs("PRY_InformeDesarrolloFechaEnvio")
		PRY_InformeFinalFecha			 = rs("PRY_InformeFinalFecha")
		PRY_InformeFinalEstado			 = rs("PRY_InformeFinalEstado")
		PRY_InformeFinalFechaEnvio		 = rs("PRY_InformeFinalFechaEnvio")
		PRY_Step						 = rs("PRY_Step")		
		PRY_CreacionProyectoEstado		 = rs("PRY_CreacionProyectoEstado")			
		PRY_CreacionProyectoFechaEnvio	 = rs("PRY_CreacionProyectoFechaEnvio")
		'Inicio
		PRY_CantPostuHombre				 = rs("PRY_CantPostuHombre")
		PRY_CantPostuMujer				 = rs("PRY_CantPostuMujer")	
											
		PRY_LanzamientoFecha			 = rs("PRY_LanzamientoFecha")	
		PRY_LanzamientoHora				 = rs("PRY_LanzamientoHora")	
		COM_IdLanzamiento				 = setNULL(rs("COM_IdLanzamiento"))
		PRY_LanzamientoDireccion		 = rs("PRY_LanzamientoDireccion")	
		PRY_CierreFecha					 = rs("PRY_CierreFecha")	
		PRY_CierreHora					 = rs("PRY_CierreHora")	
		COM_IdCierre					 = setNULL(rs("COM_IdCierre"))
		PRY_CierreDireccion				 = rs("PRY_CierreDireccion")
		PRY_HorasPedagogicasMin			 = rs("PRY_HorasPedagogicasMin")	
		LIN_AgregaTematica 				 = rs("LIN_AgregaTematica")
		PRY_Carpeta						 = rs("PRY_Carpeta")
		
		PRY_EmpresaEjecutora			 = rs("PRY_EmpresaEjecutora")
		PRY_Metodologia					 = rs("PRY_Metodologia")
		PRY_EncargadoProyecto			 = rs("PRY_EncargadoProyecto")
		PRY_EncargadoProyectoMail		 = rs("PRY_EncargadoProyectoMail")
		PRY_EncargadoProyectoCelular	 = rs("PRY_EncargadoProyectoCelular")
		SEX_IdEncargadoProyecto			 = rs("SEX_IdEncargadoProyecto")
		PRY_EncargadoActividades		 = rs("PRY_EncargadoActividades")
		PRY_EncargadoActividadesMail	 = rs("PRY_EncargadoActividadesMail")
		PRY_EncargadoActividadesCelular  = rs("PRY_EncargadoActividadesCelular")
		SEX_IdEncargadoActividades		 = rs("SEX_IdEncargadoActividades")
		LIN_Hombre						 = rs("LIN_Hombre")
		LIN_Mujer						 = rs("LIN_Mujer")		
						
		MET_IdLanzamiento=rs("MET_IdLanzamiento")
		MET_DescripcionLanzamiento=rs("MET_DescripcionLanzamiento")
		MET_IdCierre=rs("MET_IdCierre")
		MET_DescripcionCierre=rs("MET_DescripcionCierre")
		PRY_UrlLanzamiento=rs("PRY_UrlLanzamiento")
		PRY_UrlCierre=rs("PRY_UrlCierre")
		MET_DescripcionPRY=rs("MET_Descripcion")
		MET_Id=rs("MET_Id")
	else
		Response.Redirect("/reingresa-tus-credenciales")	
	end if
	rs.Close
	if PRY_InformeInicioEstado=0 then		'Solo si el hito INICIO esta cerrado
		response.Write("1")
		response.End()	
	end if
	if PRY_Estado=0 then
		Estado="Desactivado"				
	end if
	if PRY_Estado=1 then
		Estado="Activado"
	end if
	
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

		if(rs("Edad")>=18 and rs("Edad")<=25) then	'18-25
			PRY_Tramo1825=PRY_Tramo1825+1
		end if
		if(rs("Edad")>=26 and rs("Edad")<=35) then	'26-35
			PRY_Tramo2635=PRY_Tramo2635+1
		end if
		if(rs("Edad")>=36 and rs("Edad")<=45) then	'36-45
			PRY_Tramo3645=PRY_Tramo3645+1
		end if
		if(rs("Edad")>=46 and rs("Edad")<=55) then	'46-55
			PRY_Tramo4655=PRY_Tramo4655+1
		end if
		if(rs("Edad")>=56 and rs("Edad")<=65) then	'56-65
			PRY_Tramo5665=PRY_Tramo5665+1
		end if
		if(rs("Edad")>=66) then						'66 y mas
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
	
	sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503/@/Error Conexión 4:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	PRY_HorasPedagogicasTot1=0
	PRY_HorasPedagogicasTot2=0
	do while not rs.eof		
		if(rs("MET_Id")=1) then
			PRY_HorasPedagogicasTot1=PRY_HorasPedagogicasTot1+CInt(rs("CANT_PLNSesion"))
		end if
		if(rs("MET_Id")=2) then
			PRY_HorasPedagogicasTot2=PRY_HorasPedagogicasTot2+CInt(rs("CANT_PLNSesion"))
		end if
		rs.movenext
	loop	 	
	rs.close
	
	PorTot1=FormatNumber((PRY_HorasPedagogicasTot1/PRY_HorasPedagogicasMin)*100,2)
	PorTot2=FormatNumber((PRY_HorasPedagogicasTot2/PRY_HorasPedagogicasMin)*100,2)
else
	response.end()
end if		
%>
	<body>
		<div class="container">        	
            <div id="contenido">
				<h4>Responsables del proyecto</h4>
				<h5>Coordinador/a de proyecto</h5>
				<table border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Correo electrónico</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_EncargadoProyecto%></td>
                    <td width="50%"><%=PRY_EncargadoProyectoMail%></td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Teléfono</th>
                    <th scope="col" width="50%">Sexo</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_EncargadoProyectoCelular%></td>
                    <td width="50%"><%
						if(SEX_IdEncargadoProyecto=1) then
							response.Write("Femenino")
						else
							response.Write("Masculino")
						end if
					%></td>
                  </tr>
                </table>
				
				<h5>Encargado/a de actividades</h5>
				<table  border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Correo electrónico</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_EncargadoActividades%></td>
                    <td width="50%"><%=PRY_EncargadoActividadesMail%></td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Teléfono</th>
                    <th scope="col" width="50%">Sexo</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_EncargadoActividadesCelular%></td>
                    <td width="50%"><%
						if(SEX_IdEncargadoActividades=1) then
							response.Write("Femenino")
						else
							response.Write("Masculino")
						end if
					%></td>
                  </tr>
                </table>
			
    	        <h4>Postulaciones</h4> 
				
                <table  border="0">
                    <tr><%
						if LIN_Hombre then%>
                        	<th scope="col">Total de Hombres</th>
							<th scope="col">% del Hombres</th><%
						end if
						if LIN_Mujer then%>
                        	<th scope="col">Total de Mujeres</th>
							<th scope="col">% de Mujeres</th><%
						end if%>
                        <th scope="col">Total</th>
                    </tr>				
                    <tr><%
						if LIN_Hombre then%>
                        	<td><%=PRY_CantInscriHombre%></td>
							<td><%=PRY_PorInscriHombre%></td><%
						end if
						if LIN_Mujer then%>	
                        	<td><%=PRY_CantInscriMujer%></td>
							<td><%=PRY_PorInscriMujer%></td><%
						end if%>
                        <td><%=TotalInscri%></td>
                    </tr>
              	</table>     
				
              	<table  border="0">
					<tr>
						<td colspan="6"><h5>Cantidad de extranjeros/as</h5></td>
					</tr>
                    <tr>						
						<th colspan="3">Total de Extranjeros/as</th>                        
						<th colspan="3">% de Extranjeros/as</th>						
                    </tr>					
                    <tr>
						<td colspan="3"><%=PRY_CantidadExtranjeros%></td>                    	
						<td colspan="3"><%=PRY_PorExtranjeros%></td>												
                    </tr>					
					
					<tr>
						<td colspan="6"><h5>Cantidad de discapacitados/as</h5></td>
					</tr>
					<tr>
                        <th colspan="3">Total de Discapacitados/as</th>
						<th colspan="3">% de Discapacitados/as</th>						
                    </tr>
                    <tr>
                    	<td colspan="3"><%=PRY_CantidadDiscapacidad%></td>
						<td colspan="3"><%=PRY_PorDiscapacidad%></td>												
                    </tr>
					
					<tr>
						<td colspan="6"><h5>Cantidad por tramo etáreo</h5></td>						
					</tr>
					<tr>
                        <th>Total 18-25</th>
						<th>%</th>
						<th>Total 26-35</th>
						<th>%</th>
						<th>Total 36-45</th>
						<th>%</th>
                    </tr>
                    <tr>
                    	<td><%=PRY_Tramo1825%></td>
						<td><%=PRY_PorTramo1825%></td>
						<td><%=PRY_Tramo2635%></td>
						<td><%=PRY_PorTramo2635%></td>
						<td><%=PRY_Tramo3645%></td>
						<td><%=PRY_PorTramo3645%></td>						
                    </tr>					
					<tr>
                        <th>Total 46-55</th>
						<th>%</th>
						<th>Total 56-65</th>
						<th>%</th>
						<th>Total 66 y más</th>
						<th>%</th>
                    </tr>
                    <tr>
                    	<td><%=PRY_Tramo4655%></td>
						<td><%=PRY_PorTramo4655%></td>
						<td><%=PRY_Tramo5665%></td>
						<td><%=PRY_PorTramo5665%></td>
						<td><%=PRY_Tramo66mas%></td>
						<td><%=PRY_PorTramo66mas%></td>						
                    </tr>
					
					<tr>
						<td colspan="6"><h5>Cantidad de dirigentes/as sindicales</h5></td>						
					</tr>
					<tr>
                        <th colspan="3">Total de Dirigentes/as</th>
						<th colspan="3">% de Dirigentes/as</th>						
                    </tr>
                    <tr>
                    	<td colspan="3"><%=PRY_CantidadDirigente%></td>
						<td colspan="3"><%=PRY_PorDirigente%></td>												
                    </tr>
              	</table>				
			  
				<h4>Planificación Ejecución</h4>
				<h5>Resumen</h5><%
				sql="exec spTotalHorasSesiones_Calcular " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				set rs = cnn.Execute(sql)		
				on error resume next
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión:" & sql)
				   response.End() 			   
				end if		
				sqlx="exec spPlanificacionResumen_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
				set rs = cnn.Execute(sqlx)
				on error resume next
				if cnn.Errors.Count > 0 then 		
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión:" & sqlx)
				   response.End() 			   
				end if
				if not rs.EOF then
					TotalModulos=rs("ModuloCant")
					TotalPerspectivas=rs("PerspectivasCant")
					TotalTematicas=rs("TematicasCant")
					ModuloHoras=rs("ModuloHoras")
					FechaInicio=rs("FechaInicio")
					FechaFin=rs("FechaFin")		
					Horas_Pedagogicas=rs("Horas_Pedagogicas")				
				end if
				if(IsNULL(ModuloHoras)) then
					ModuloHoras=0
				end if
				if(IsNULL(Horas_Pedagogicas)) then
					Horas_Pedagogicas=0
				end if
				if(IsNULL(FechaInicio)) then
					FechaInicio="Sin inicio"
				end if
				if(IsNULL(FechaFin)) then
					FechaFin="Sin fin"
				end if
				sqly="exec spPlanificacionSesiones_Total " & PRY_Id & ",'" & PRY_Identificador & "'"
				set rs = cnn.Execute(sqly)
				on error resume next
				if cnn.Errors.Count > 0 then 		
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión:" & sqly)
				   response.End() 			   
				end if
				if not rs.EOF then
					TotalPlantilla=rs("TotalPlantilla")
					TotalPlanificado=rs("TotalPlanificado")
				end if%>
				<table border="0"> 
					<thead>				
						<tr>
							<th rowspan="1" scope="row" style="text-align: center;vertical-align: middle;"></th>
							<th style="text-align: center;vertical-align: middle;">Cursos</th>
							<th style="text-align: center;vertical-align: middle;">Perspectivas</th>
							<th style="text-align: center;vertical-align: middle;">Módulos (<%=TotalPlantilla%>)</th>
							<th style="text-align: center;vertical-align: middle;">Total Horas</th>
							<th style="text-align: center;vertical-align: middle;">Horas Pedagógicas (<%=PRY_HorasPedagogicasMin%>)</th>
							<th style="text-align: center;vertical-align: middle;">Fecha Inicio</th>
							<th style="text-align: center;vertical-align: middle;">Fecha Término</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>Totales</th>
							<td><%=TotalModulos%></td>
							<td><%=TotalPerspectivas%></td>
							<td><%=TotalTematicas%></td>
							<td><%=ModuloHoras%></td>
							<td><%=Horas_Pedagogicas%></td>
							<td><%=FechaInicio%></td>
							<td><%=FechaFin%></td>
						</tr>
					</tbody>					
				</table>
				<h5>Detalle</h5>
				<table border="0"><%
					set rs = cnn.Execute("exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'")		
					on error resume next
					if cnn.Errors.Count > 0 then 		
					   ErrMsg = cnn.Errors(0).description	   
					   cnn.close
					   response.Write("503/@/Error Conexión:" & ErrMsg)
					   response.End() 			   
					end if
					MOD_Id=0
					PER_Id=0
					TEM_Id=0
					corr=0
					sw=0
					Modulo=1
					TemPen = 0
					do while not rs.eof                                	
						if MOD_Id<>rs("MOD_Id") then 'Cambio de Modulo - Nueva tabla							
							if MOD_id<>0 then	'No es el primero
								Modulo=Modulo+1%>
										</tr>
									</tbody>
								</table><%
							end if%>
							<h5><%=rs("MOD_Nombre")%></h5>
							<table width="100%" style="margin-top:20px;"> 
								<thead> 							
									<tr>
										<td style="text-align: center;vertical-align: middle;">Perspectiva</td>
										<td style="text-align: center;vertical-align: middle;">Módulo</td>   													
										<td style="text-align: center;vertical-align: middle;">Minutos Panificados</td>
										<td style="text-align: center;vertical-align: middle;">Max H.Ped. (M.Reales)</td>
										<td style="text-align: center;vertical-align: middle;">Diferencia</td>
									</tr>
								</thead>
								<tbody>
									<tr><%																			
						end if
						if PER_Id<>rs("PER_Id") then	'Cambio de perspectiva
							if PER_Id<>0 then		'No es el primero
									sw=1%>
									</tr>
									<tr><%
							end if
							if rs("TematicaProyecto")=1 then
								set rs2 = cnn.Execute("exec spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & rs("PER_Id"))	
								on error resume next
								if cnn.Errors.Count > 0 then 					
								   ErrMsg = cnn.Errors(0).description	   
								   cnn.close
								   response.Write("503/@/Error Conexión:" & ErrMsg)
								   response.End() 			   
								end if
							else
								set rs2 = cnn.Execute("exec spTematica_Listar " & rs("PER_Id") & ",1")	'Solo las tematicas activas
								on error resume next
								if cnn.Errors.Count > 0 then 					
								   ErrMsg = cnn.Errors(0).description	   
								   cnn.close
								   response.Write("503/@/Error Conexión:" & ErrMsg)
								   response.End() 			   
								end if	
							end if

							TEM_Tot=0
							do while not rs2.eof
								TEM_Tot=TEM_Tot+1
								rs2.movenext
							loop%>                             			
							<th rowspan="<%=TEM_Tot%>" scope="row" style="text-align: center;vertical-align: middle;" id="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></th><%
						end if	
						'Busqueda de tematicas planificadas
						set rsx = cnn.Execute("exec spTotalHorasTematica_Calcular " & rs("TEM_Id") & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
						on error resume next
						if cnn.Errors.Count > 0 then 					
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close
						   response.Write("503/@/Error Conexión:" & ErrMsg)
						   response.End() 			   
						end if						
						Diferencia=round((rs("TEM_Horas")*45),2) * -1
						TotalMinutosPlanificados=0

						if not rsx.eof then	
							TotalMinutosPlanificados=rsx("TotalMinutosPlanificados")
							Diferencia=rsx("TotalMinutosPlanificados")-rsx("TotalMinutosTematica")
							if Diferencia>=0 then

							else
								TemPen = TemPen + 1								
							end if
						else
							TemPen = TemPen + 1							
						end if
						'Busqueda de tematicas planificadas

						if TEM_Id<>rs("TEM_Id") then
							sesion=1
							if TEM_Id<>0 and PER_Id=rs("PER_Id") then%>
								</tr>
								<tr><%
							end if%>
							<th rowspan="1" scope="row" style="text-align: center;vertical-align: middle;font-size: 12px;font-weight: initial;" id="<%=TEM_Id%>"><%=rs("TEM_Nombre")%></th><%
						end if%>													                                                    
						<td><%=TotalMinutosPlanificados%></td>
						<td><%response.write(round((rs("TEM_Horas")*45),2)) %></td>
						<td><%=Diferencia%></td><%

						MOD_Id=rs("MOD_Id")
						PER_Id=rs("PER_Id")
						TEM_Id=rs("TEM_Id")
						corr=corr+1									
						rs.movenext
					loop%>
					</tr>
					</tbody>
				</table>
				
		
				<h4>Actividades</h4>
				<h5>Actividad de Lanzamiento y/o Inauguración</h5>
				<table border="0">
					<tr>
						<th scope="col">Fecha</th>
						<th scope="col">Hora</th>
						<th scope="col">Metodología</th>
						<%if(MET_IdLanzamiento=1 or MET_IdLanzamiento=3) then%>
							<th scope="col">URL</th>
						<%end if%>
						<%if(MET_IdLanzamiento=2 or MET_IdLanzamiento=3) then%>
							<th scope="col">Dirección</th>
						<%end if%>						
					</tr>
					<tr>
						<td><%=PRY_LanzamientoFecha%></td>
						<td><%=PRY_LanzamientoHora%></td>
						<td><%=MET_DescripcionLanzamiento%></td>
						<%if(MET_IdLanzamiento=1 or MET_IdLanzamiento=3) then%>
							<td scope="col"><%=PRY_UrlLanzamiento%></td>
						<%end if%>
						<%if(MET_IdLanzamiento=2 or MET_IdLanzamiento=3) then%>
							<td scope="col"><%=PRY_LanzamientoDireccion%></td>
						<%end if%>
					</tr>
				</table>              
				
				<h5>Actividad de Cierre y/o Finalización</h5>
				<table  border="0">
					<tr>
						<th scope="col">Fecha</th>
						<th scope="col">Hora</th>
						<th scope="col">Metodología</th>
						<%if(MET_IdCierre=1 or MET_IdCierre=3) then%>
							<th scope="col">URL</th>
						<%end if%>
						<%if(MET_IdCierre=2 or MET_IdCierre=3) then%>
							<th scope="col">Dirección</th>
						<%end if%>	
					</tr>
					<tr>
						<td><%=PRY_CierreFecha%></td>
						<td><%=PRY_CierreHora%></td>
						<td><%=MET_DescripcionCierre%></td>
						<%if(MET_IdCierre=1 or MET_IdCierre=3) then%>
							<td><%=PRY_UrlCierre%></td>
						<%end if%>
						<%if(MET_IdCierre=2 or MET_IdCierre=3) then%>
							<td><%=PRY_CierreDireccion%></td>
						<%end if%>	
					</tr>
				</table>  

				<h4>Metodología</h4>
				<h5>Descripción</h5>
				<table  border="0">
					<tr>
						<th scope="col" colspan="3">Descripción</th>
					</tr>
					<tr>
						<td colspan="3"><%=PRY_Metodologia%></td>				
					</tr>
					<tr>
						<th scope="col" colspan="3">Modalidad del curso</th>
					</tr>
					<tr>
						<th scope="col">Modalidad del curso</th>
						<%if(MET_Id)<>3 then%>
							<th scope="col" colspan="2">% de horas <%=MET_Descripcion%></th>
						<%else
							sql="exec spMetodologia_Consultar 1"
							set rs = cnn.Execute(sql)		
							on error resume next
							if cnn.Errors.Count > 0 then 
							   ErrMsg = cnn.Errors(0).description	   
							   cnn.close
							   response.Write("503/@/Error Conexión:" & sql)
							   response.End() 			   
							end if		
							if not rs.eof then
								MET_Descripcion=rs("MET_Descripcion")
							end if%>
							<th scope="col">% de horas <%=MET_Descripcion%></th><%
							sql="exec spMetodologia_Consultar 2"
							set rs = cnn.Execute(sql)		
							on error resume next
							if cnn.Errors.Count > 0 then 
							   ErrMsg = cnn.Errors(0).description	   
							   cnn.close
							   response.Write("503/@/Error Conexión:" & sql)
							   response.End() 			   
							end if		
							if not rs.eof then
								MET_Descripcion=rs("MET_Descripcion")
							end if%>
							<th scope="col">% de horas <%=MET_Descripcion%></th>
						<%end if%>
					</tr>					
					<tr>
						<td><%=MET_DescripcionPRY%></td>
						<%if(MET_Id)<>3 then%>
							<td scope="col" colspan="2">100</td>
						<%else%>
							<td scope="col"><%=PorTot1%></td>
							<td scope="col"><%=PorTot2%></td>
						<%end if%>
					</tr>
				</table>  		
		
        	</div>           	
        </div>
	</body>
</html>