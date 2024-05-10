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
MasterPage	= "Informe_Parcial"

set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 			   
	response.end()
End If

if int(PRY_Id)>0 and PRY_Id<>"" then
	set rs = cnn.Execute("exec spFecha_Obtener")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.end()
	End If
	if not rs.eof then
		dia=trim(rs("dia"))
		if len(dia)=1 then
			dia="0" & dia
		end if
		mes=trim(rs("mes"))
		if len(mes)=1 then
			mes="0" & mes
		end if		
		ano=trim(rs("año"))
		FechaHoySQL = ano & "-" & mes & "-" & dia				
		hoy=cdate(FechaHoySQL)
	end if

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
		
		PRY_Facilitadores				 = rs("PRY_Facilitadores")
		PRY_Obstaculizadores			 = rs("PRY_Obstaculizadores")
		PRY_MecMitigacion				 = rs("PRY_MecMitigacion")
		
		PRY_EmpresaEjecutora			 = rs("PRY_EmpresaEjecutora")
		
		LIN_Hombre						 = rs("LIN_Hombre")
		LIN_Mujer						 = rs("LIN_Mujer")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		
	else
		response.end()	
	end if
	rs.Close
			
	sql="exec  spAlumnoProyecto_DesercionInfo " & PRY_Id  & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	End If
	if not rs.eof then
		FechaPrimeraDesercionsplit = split(mid(rs("FechaPrimeraDesercion"),1,10),"-")
		FechaPrimeraDesercion = FechaPrimeraDesercionsplit(2) & "-" & FechaPrimeraDesercionsplit(1) & "-" & FechaPrimeraDesercionsplit(0)	'año mes dia'
	else
		FechaPrimeraDesercion = ""	
	end if
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotaxlEstado] " & PRY_Id & ",0," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_TotalEstado=0
	if not rs.eof then
		ALU_TotalEstado=rs("ALU_TotalEstado")
	end if
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotalSinAsistencia] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_CeroAsistencia=0
	if not rs.eof then
		ALU_CeroAsistencia=rs("ALU_CeroAsistencia")
	end if
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_Total50oMasAsistencia] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_50maspor=0
	Do While not rs.eof
		if(CInt(rs("PLN_PorTotalHorasAsistidas"))>=50) then
			ALU_50maspor=ALU_50maspor+1
		end if
		rs.movenext
	loop
	rs.close
	
	set rs = cnn.Execute("exec [spAlumnoProyecto_TotalDesertadosManual] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	ALU_DesetadosManual=0
	if not rs.eof then
		ALU_DesetadosManual=rs("ALU_DesetadosManual")
	end if			
	rs.close
	
	set rw = cnn.Execute("exec [spAlumnoProyecto_TotalesPorSesion] " & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")
	on error resume next
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	
else
	response.end()
end if		
%>
	<body>
		<div class="container">        	
            <div id="contenido">
    	        <h4>Causas de Deserciones</h4>
            	<h5>Causas, razones y cantidad de deserciones</h5>
               	<table border="0"> 
					
						<tr>
						  <th rowspan="2" style="text-align: center;vertical-align: middle;" scope="row" >Causa</th>
						  <th rowspan="2" style="text-align: center;vertical-align: middle;">Razón</th><%
						  if(LIN_Hombre and LIN_Mujer) then%>
							<th colspan="3" style="text-align: center;vertical-align: middle;">Cantidad de Alumnos/as</th><%
						  else
							if(LIN_Mujer and not LIN_Hombre) then%>
								<th colspan="3" style="text-align: center;vertical-align: middle;">Cantidad de Alumnas</th><%
							else
								if(not LIN_Mujer and LIN_Hombre) then%>
									<th colspan="3" style="text-align: center;vertical-align: middle;">Cantidad de Alumnos</th><%
								else%>
									<th colspan="3" style="text-align: center;vertical-align: middle;">No definido</th><%
								end if
							end if
						  end if%>
						</tr>
						<tr><%
						  if(LIN_Hombre and LIN_Mujer) then%>
							<th style="text-align: center;vertical-align: middle;">Hombres</th>
							<th style="text-align: center;vertical-align: middle;">Mujeres</th><%
						  end if%>						  
						  <th style="text-align: center;vertical-align: middle;" colspan="3">Total</th>
						</tr><%
						sql = "exec spAlumnoProyecto_DesercionResumen " & PRY_Id  & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
						set rs = cnn.Execute(sql)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close
							response.Write("503/@/Error Conexión:" & ErrMsg)
							response.End()
						End If
						do while not rs.eof%>
							<tr><%
								if(CDE_InfoCausaId<>rs("CDE_InfoCausaId")) then%>
									<th rowspan="<%=rs("RazonesxCausa")%>" scope="row" style="text-align: center;vertical-align: middle;"><%=trim(rs("CDE_InfoCausaDesercion"))%></th><%
								end if%>					
								<td><%=trim(rs("RDE_InfoRazonDesercion"))%></td><%
								if(LIN_Hombre and LIN_Mujer) then%>
									<td style="text-align: center;vertical-align: middle;"><%=rs("Masculino")%></td>
									<td style="text-align: center;vertical-align: middle;"><%=rs("Femenino")%></td><%
								end if%>
								<td style="text-align: center;vertical-align: middle;font-weight: bold;" colspan="3"><%=rs("Masculino")+rs("Femenino")%></td>
							</tr><%
							CDE_InfoCausaId=rs("CDE_InfoCausaId")
							rs.movenext		
						loop
						rs.close%>
					</tbody>
				</table>
				<h5>Observaciones sobre las deserciones</h5>
				<table border="0"> 
					<thead>
						<tr><%
						 	if(LIN_Hombre and LIN_Mujer) then%>
								<th style="text-align: center;vertical-align: middle;">Alumno/a</th><%						
						  	else
								if(LIN_Hombre and not LIN_Mujer) then%>
									<th style="text-align: center;vertical-align: middle;">Alumno</th><%
								else
									if(not LIN_Hombre and LIN_Mujer) then%>
										<th style="text-align: center;vertical-align: middle;">Alumna</th><%
									else%>
										<th style="text-align: center;vertical-align: middle;">No definido</th><%
									end if
								end if
						  end if%>
						  <th style="text-align: center;vertical-align: middle;">Causa</th>
						  <td style="text-align: center;vertical-align: middle;">Razón</td>
						  <td style="text-align: center;vertical-align: middle;">Observación</td>
						</tr>
					</thead>
					<tbody><%					
					sql = "exec spAlumnoProyecto_Listar " & PRY_Id
					set rsx = cnn.Execute(sql)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description	   
						cnn.close
						response.Write("503/@/Error Conexión:" & ErrMsg)
						response.End()
					End If
					do while not rsx.eof							
						if rsx("EST_Estado")=6 and rsx("EST_InfoEstadoAcademico")<>99 then%>
							<tr>
								<td><% response.write(rsx("ALU_Nombre") & " ")%><% response.write(rsx("ALU_Apellido"))%></td>
								<td><%=rsx("CDE_InfoCausaDesercion")%></td>
								<td><%=rsx("RDE_InfoRazonDesercion")%></td>							
								<td><%=rsx("EST_InfoObservaciones")%></td>
							</tr><%
						end if
						rsx.movenext
					loop%>
					</tbody>
				</table>				
				<h5>Primera Deserción</h5>
                <table border="0">
                  <tr>
                    <th scope="row">Fecha</th>
                    <td><%=FechaPrimeraDesercion%></td>
                  </tr>
                </table>
                
              	<h4>Nuevas Deserciones e Incorporaciones</h4>
				<h5>Deserciones (Posteriores a la fecha de cierre del informe Inicio)</h5>
				<table width="100%" border="0"> 
					<thead>				
						<tr> 
							<th>#</th>
							<th>Nombre</th>
							<th>Sexo</th> 
							<th>Rut</th>
						</tr> 
					</thead>
					<tbody><%
						sql = "exec spAlumnoProyecto_DesercionResumen_PorFechaCierreInforme " & PRY_Id  & ",1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 
						set rs = cnn.Execute(sql)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close
							response.Write("503/@/Error Conexión:" & ErrMsg)
							response.End()
						End If
						do while not rs.eof	
							x=x+1%>
							<tr>
								<td><% response.write(x)%></td>
								<td><% response.write(rs("ALU_Nombre") & " " & rs("ALU_ApellidoPaterno")) %></td>                      	                  	
								<td><%=rs("Sex_Descripcion")%></td> 
								<td><% response.write(rs("ALU_Rut") & rs("ALU_Dv"))%></td>
							</tr><%
							rs.movenext				
						loop
						rs.close%>
					</tbody>

				</table>	                
				<h5>Incorporaciones (Posteriores a la fecha de cierre del informe Inicio)</h5>                
                <table border="0"> 
					<thead>
						<tr>
							<th>#</th>
							<th>Nombre</th>
							<th>Sexo</th>
							<th>Rut</th>
							<th>Estado</th>
						</tr>
					</thead><%					
					sql = "exec spAlumnoProyecto_IncorporacionResumen_PorFechaCierreInforme " & PRY_Id & ",1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
					set rsx = cnn.Execute(sql)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description	   
						cnn.close
						response.Write("503/@/Error Conexión:" & ErrMsg)
						response.End()
					End If
					do while not rsx.eof				
						x=x+1%>
						<tr>
							<td><% response.write(x)%></td>
							<td><% response.write(rsx("ALU_Nombre") & " " & rsx("ALU_APellidoPaterno")) %></td>                      	                  	
							<td><%=rsx("Sex_Descripcion")%></td> 
							<td><% response.write(rsx("ALU_Rut") & "-" & rsx("ALU_Dv"))%></td>
							<td><%=rsx("TES_Descripcion")%>
						</tr><%
						rsx.movenext
					loop%>
                </table>
                
				<h4>Planificación</h4>                     
				<h5>Por ejecutar</h5>				
                <table border="0">
					<thead>				
						<tr> 
							<th>#</th>                            
							<th>Tématicas</th>
							<th>Relator</th>
							<th>Fecha</th>
						</tr> 
					</thead>
					<tbody><%
						sql = "exec spPlanificacionPorRealizar_Listar " & PRY_Id  & ",'" & PRY_Identificador & "'" 
						set rs = cnn.Execute(sql)
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description	   
							cnn.close
							response.Write("503/@/Error Conexión:" & ErrMsg)
							response.End()
						End If
						do while not rs.eof	
							x=x+1%>
							<tr>
								<td><%response.Write(x)%></td>
								<td><%=rs("TEM_Nombre")%></td>
								<td><%=rs("PLN_NombreDocente")%></td>
								<td><%=rs("PLN_Fecha")%></td>
							</tr><%
							rs.movenext				
						loop
						rs.close%>
					</tbody>
                </table> 							
				<h5>Ejecutada</h5>				
                <table border="0">  
					<thead>
						<tr>
							<th>#</th>                            
							<th>Tématicas</th>
							<th>Relator</th>
							<th>Fecha</th>
						</tr>
					</thead><%					
					sql = "exec spPlanificacionRealizada_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
					set rsx = cnn.Execute(sql)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description	   
						cnn.close
						response.Write("503/@/Error Conexión:" & ErrMsg)
						response.End()
					End If
					x=0
					do while not rsx.eof				
						x=x+1%>
						<tr>
							<td><%response.Write(x)%></td>
							<td><%=rsx("TEM_Nombre")%></td>
							<td><%=rsx("PLN_NombreDocente")%></td>
							<td><%=rsx("PLN_Fecha")%></td>
						</tr><%
						rsx.movenext
					loop%>	
                </table> 
                				
				
				<h4>Seguimiento Ejecución</h4>
                <table border="0">              	
					<tr>
					  <th scope="row" style="border: 1px solid #e8edff;">Facilitadores</th>
					  <td style="border: 1px solid #b9c9fe;"><%=PRY_Facilitadores%></td>
					</tr>
					<tr>
					  <th scope="row" style="border: 1px solid #e8edff;">Obstaculizadores</th>
					  <td style="border: 1px solid #b9c9fe;"><%=PRY_Obstaculizadores%></td>
					</tr>
					<tr>
					  <th scope="row" style="border: 1px solid #e8edff;">Mecanismos de mitigación</th>
					  <td style="border: 1px solid #b9c9fe;"><%=PRY_MecMitigacion%></td>
					</tr>
              	</table>                       	
                
              	<h4>Informe de Asistencia</h4>
				<h5>Estadísticas Generales</h5>
				
				<table> 
					<thead>				
						<tr> 
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Matriculados</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Beneficiarios con 0% asistencia</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Beneficiarios con 50% o más de asistencia</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Benefeciarios desertados manualmente</th>					
						</tr> 
					</thead>
					<tbody>
						<tr>
							<td><%=ALU_TotalEstado%></td>
							<td><%=ALU_CeroAsistencia%></td>
							<td><%=ALU_50maspor%></td>
							<td><%=ALU_DesetadosManual%></td>
						</tr>
					</tbody>
				</table>
				<h5>Estadísticas por sesión</h5>
				<table> 
					<thead>				
						<tr> 
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Sesión</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Alumnos Presentes</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Alumnos Ausentes</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">N° Alumnos justificados</th>									
						</tr> 
					</thead>
					<tbody><%				
						do while not rw.eof%>
							<tr>
								<td><%=rw("PLN_Sesion")%></td>
								<td><%=rw("ALU_Asistieron")%></td>
								<td><%=rw("ALU_Ausentes")%></td>
								<td><%=rw("ALU_Justificados")%></td>								
							</tr><%
							rw.movenext
						loop%>				
					</tbody>

				</table>
			</div>
			<h5>Detalle de inasistencias</h5><%
				set rs = cnn.Execute("exec spFecha_Obtener")
				on error resume next
				cnn.open session("DSN_DialogoSocialv5")
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close				   
				   response.End() 			   
				end if
				if not rs.eof then
					dia=trim(rs("dia"))
					if len(dia)=1 then
						dia="0" & dia
					end if
					mes=trim(rs("mes"))
					if len(mes)=1 then
						mes="0" & mes
					end if		
					ano=trim(rs("año"))
					FechaHoySQL = ano & "-" & mes & "-" & dia				
					hoy=cdate(FechaHoySQL)
				end if

				sql="exec spAlumnoProyectos_Listar " & PRY_Id
				set rs = cnn.Execute(sql)
				on error resume next
				cnn.open session("DSN_DialogoSocialv5")
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close				   
				   response.End() 			   
				end if

				dim alumnos(100)
				'dim aluest(100)
				dim alunom(100)
				dim aludv(100)
				dim alusex(100)
				TotAlu=0
				do while not rs.eof
					alumnos(TotAlu)=rs("ALU_Rut")
					'aluest(TotAlu)=rs("ALU_InfoEstadoAcademico")
					alunom(TotAlu)=rs("ALU_ApellidoPaterno") & " " & rs("ALU_Nombre")
					aludv(TotAlu)=rs("ALU_Dv")
					alusex(TotAlu)=rs("SEX_Descripcion")
					TotAlu=TotAlu+1
					rs.movenext			
				loop
				rs.close

				sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
				set rs3 = cnn.Execute(sql)
				on error resume next
				cnn.open session("DSN_DialogoSocialv5")
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503//Error Conexión:" & ErrMsg)
				   response.End() 			   
				end if

				dim sesiones(100)
				dim sesnom(100)
				dim sesfec(100)
				dim sesasi(100)
				TotSes=0
				do while not rs3.eof
					sesiones(TotSes)= rs3("PLN_Sesion")
					sesnom(TotSes)=rs3("TEM_Nombre")
					sesfec(TotSes)=rs3("PLN_Fecha")
					sesasi(TotSes)=false
					TotSes=TotSes+1
					rs3.movenext
				loop%>
                <table border="0">              	
					<thead>				
						<tr> 
							<th scope="col" style="text-align: center;vertical-align: middle;">Sesión</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">Alumno</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">Fecha</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">Justificación</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">Medio de Verificación</th>
							<th scope="col" style="text-align: center;vertical-align: middle;">Adecuación</th>
						</tr> 
					</thead>
					<tbody><%
						dim fs,f	
						set fs=Server.CreateObject("Scripting.FileSystemObject")
						for i=0 to TotAlu-1
							sql="exec spAsistenciaRut_Listar " & PRY_Id & ",'" & PRY_Identificador & "'" & "," & alumnos(i) & ",-1"
							set rs2 = cnn.Execute(sql)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								response.Write("503//Error Conexión:" & ErrMsg & " - " & sql)
								cnn.close 			   
								Response.end()
							End If
							p=0
							q=0
							do while not rs2.eof
								sqlz="exec [spAdecuaciones_BuscarJustificacion] " & PRY_Id & "," & alumnos(i) & "," & rs2("PLN_Sesion") & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
								set rsx = cnn.Execute(sqlz)
								on error resume next
								if cnn.Errors.Count > 0 then 
									ErrMsg = cnn.Errors(0).description	
									response.Write("503//Error Conexión:" & ErrMsg & " - " & sqlz)
									cnn.close 			   
									Response.end()
								End If
								if not rsx.eof then
									ADE_Id = rsx("ADE_Id")
								end if
								
								path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\adecuaciones\ade-" & ADE_Id & "\"
								archivos=0
								If fs.FolderExists(path) = true Then
									Set carpeta = fs.getfolder(path)
									Set ficheros = carpeta.Files
									For Each archivo In ficheros
										archivos = archivos + 1
									Next
								else
									archivos = 0
								end if
								if(archivos>0) then			
									arc="SI"
								else			
									arc="NO"
								end if

								p=q																									
								for k=0 to TotSes-1																
									q=q+1								
									if sesiones(k)=rs2("PLN_Sesion") then									
										sesasi(k)=true
										if rs2("Asi_Asistio")<>1 then	

											if datediff("d",cdate(trim(sesfec(k))),hoy)>0 then
												response.Write("<tr>")	
												response.Write("<td style=""text-align: center;"">" & rs2("PLN_Sesion") & "</td>")
												response.Write("<td style=""text-align: center;"">" & FormatNumber(alumnos(i),0) & "-" & aludv(i) & "</td>")										
												response.Write("<td style=""text-align: center;"">" & sesfec(k) & "</td>")										

												if rs2("ASI_Justifica") then
													response.Write("<td style=""text-align: center;"">SI</td>")%>										
													<td style="text-align: center;"><%=arc%></td><%
													response.write("<td style=""text-align: center;"">" & ADE_Id & "</td>")
												else									
													response.Write("<td style=""text-align: center;"">NO</td>")
													response.Write("<td style=""text-align: center;"">NO</td>")
													response.write("<td style=""text-align: center;"">-</td>")
												end if										
												response.Write("</tr>")																				
											end if
										end if
										exit for								
									end if											
								next								
								rs2.movenext							
							loop						
							for k=0 to TotSes-1
								'response.write(sesiones(k) & "/" & sesasi(k) & "<br/>")
								if (not sesasi(k)) then
									if datediff("d",cdate(trim(sesfec(k))),hoy)>0 then
										response.Write("<tr>")
										response.Write("<td style=""text-align: center;"">" & sesiones(k) & "</td>")								
										response.Write("<td style=""text-align: center;"">" & FormatNumber(alumnos(i),0) & "-" & aludv(i) & "</td>")								
										response.Write("<td style=""text-align: center;"">" & sesfec(k) & "</td>")								
										response.Write("<td style=""text-align: center;"">NO</td>")
										response.Write("<td style=""text-align: center;"">No</td>")	
										response.write("<td style=""text-align: center;"">-</td>")
										response.Write("</tr>")	
									end if
								end if
							next
							for k=0 to TotSes-1
								sesasi(k)=false
							next
						next%>
					</tbody>
            	</table>
				
        	</div>           	
        </div>
	</body>
</html>