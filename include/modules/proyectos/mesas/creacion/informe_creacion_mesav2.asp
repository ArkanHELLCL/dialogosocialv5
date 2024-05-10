<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
<head>
<!-- #INCLUDE file="session.min.inc" -->
</head>
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
MasterPage	= "Informe_Creacion"

set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 			   
	response.end
End If

if int(PRY_Id)>0 and PRY_Id<>"" then
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.end
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
		
		PRY_EmpresaEjecutora			 = rs("PRY_EmpresaEjecutora")
		
		PRY_InformeInicialEstado         = rs("PRY_InformeInicialEstado")
		PRY_InformeConsensosEstado       = rs("PRY_InformeConsensosEstado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		PRY_InformeInicialFecha			 = rs("PRY_InformeInicialFecha")
		PRY_InformeConsensosFecha		 = rs("PRY_InformeConsensosFecha")
		PRY_InformeSistematizacionFecha	 = rs("PRY_InformeSistematizacionFecha")
		PRY_TipoMesa					 = rs("PRY_TipoMesa")
		PRY_InformeInicialFechaOriginal	 = rs("PRY_InformeInicialFechaOriginal")
        PRY_InformeConsensosFechaOriginal= rs("PRY_InformeConsensosFechaOriginal")
		PRY_InformeSistematizacionFechaOriginal = rs("PRY_InformeSistematizacionFechaOriginal")
		
		if PRY_TipoMesa=1 then
			PRY_TipoMesaDescripcion="Mesa Bipartita"
		end if
		if PRY_TipoMesa=2 then
			PRY_TipoMesaDescripcion="Mesa Tripartita"
		end if
		
		PRY_IdLicitacion				 = rs("PRY_IdLicitacion")
		PRY_NombreLicitacion			 = rs("PRY_NombreLicitacion")
		FON_Nombre						 = rs("FON_Nombre")
		PRY_Carpeta						 = rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		
	else
		response.end	
	end if
	rs.Close
	if PRY_CreacionProyectoEstado=0 then		'Solo si el hito CREACION esta cerrado
		response.Write("1")
		response.End()	
	end if
	if PRY_Estado=0 then
		Estado="Desactivado"				
	end if
	if PRY_Estado=1 then
		Estado="Activado"
	end if
	
	set rs = cnn.Execute("exec spAlumnoProyecto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close 			   
		response.end
	End If
	TotalInscri=0
	PRY_CantInscriMujer=0
	PRY_CantInscriHombre=0
	do While Not rs.EOF 
		TotalInscri=TotalInscri+1
		if rs("SEX_Id")=1 then	'Mujer
			PRY_CantInscriMujer=PRY_CantInscriMujer+1
		else
			PRY_CantInscriHombre=PRY_CantInscriHombre+1
		end if
		rs.movenext
	loop
else
	response.end
end if		
%>
	<body>
		<div class="container">        	
            <div id="contenido">
    	    	<h4>Personalización</h4>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Año</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=PRY_Nombre%></td>
                    <td width="50%"><%=PRY_AnioProyecto%></td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Región</th>
                    <th scope="col" width="50%">Comuna</th>
                  </tr>
                  <tr>
                    <td width="50%"><%=REG_Nombre%></td>
                    <td width="50%"><%=COM_Nombre%></td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col">Dirección</th>
                  </tr>
                  <tr>
                    <td><%=PRY_DireccionEjecucion%></td>
                  </tr>
                </table>
				<table  border="0">
                  <tr>
                    <th scope="col">Empresa Ejecutora</th>
                  </tr>
                  <tr>
                    <td><%=PRY_EmpresaEjecutora%></td>
                  </tr>
                </table>                
				<table  border="0">
                  <tr>
                    <th scope="col" width="50%">Encargado/a de plataforma</th>
                    <th scope="col" width="50%">Revisor</th>
                  </tr>
                  <tr>
                    <td width="50%"><%response.Write(USR_NombreEjecutor & " " & USR_ApellidoEjecutor)%></td>
                    <td width="50%"><%response.Write(USR_NombreRevisor & " " & USR_ApellidoRevisor)%></td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
				  	<th scope="col" width="33%">Tipo de Mesa</th>
                    <th scope="col" width="33%">Horas Pedagógicas Mínimas</th>
                    <th scope="col" width="33%">Monto</th>
                  </tr>
                  <tr>				  	
				  	<td width="33%"><%=PRY_TipoMesaDescripcion%></td>
                    <td width="33%"><%=PRY_HorasPedagogicasMin%></td>
                    <td width="33%"><%=PRY_MontoAdjudicado%></td>
                  </tr>
                </table>
				<table  border="0">
                  <tr>
                    <th scope="col" width="20%">Id Licitación</th>
                    <th scope="col" width="30%">Nombre Licitación</th>
					<th scope="col" width="50%">Ítem Presupuestario</th>
                  </tr>
                  <tr>
                    <td width="20%"><%=PRY_IdLicitacion%></td>
                    <td width="30%"><%=PRY_NombreLicitacion%></td>
					<td width="50%"><%=FON_Nombre%></td>
                  </tr>				  				  
                </table>
                
                <h4>Fechas de Cierre</h4>
				<h5>Fechas de Cierre Informadas</h5>
                <table  border="0">
                  <tr>
                    <th scope="col" width="33%">Fecha Cierre Informe Inicial</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Consenso</th>
					<th scope="col" width="33%">Fecha Cierre Informe Sistematización</th>
                  </tr>
                  <tr>
                    <td width="33%"><%=PRY_InformeInicialFecha%></td>
                    <td width="33%"><%=PRY_InformeConsensosFecha%></td>
					<td width="33%"><%=PRY_InformeSistematizacionFecha%></td>
                  </tr>
                </table>
				<h5>Fecha de Cierre Originales</h5>
				<table  border="0">
                  <tr>
                    <th scope="col" width="33%">Fecha Cierre Informe Inicial</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Consenso</th>
					<th scope="col" width="33%">Fecha Cierre Informe Sistematización</th>
                  </tr>
                  <tr>
                    <td width="33%"><%=PRY_InformeInicialFechaOriginal%></td>
                    <td width="33%"><%=PRY_InformeConsensosFechaOriginal%></td>
					<td width="33%"><%=PRY_InformeSistematizacionFechaOriginal%></td>
                  </tr>
                </table>           
                
                <h4>Responsables del Proyecto</h4>
				<h5>Coordinador/a de proyecto</h5>
                <table  border="0">
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
                
                <h4>Redes de Apoyo</h4>
				<h5>Sindicatos</h5>
                <table> 
                    <thead> 
                        <tr>                             
                            <th>Sindicato</th>
                            <th class="filter-select filter-exact" data-placeholder="Afiliación">Afiliación Central</th> 
                            <th  class="filter-select filter-exact" data-placeholder="Rubro">Rubro</th>
                        </tr> 
                    </thead>                     
                    <tbody> 
                    <%                                                                    
                        set rs=cnn.execute("spPatrocinio_Listar " & PRY_Id)
                        on error resume next
                        if cnn.Errors.Count > 0 then 
                            ErrMsg = cnn.Errors(0).description
                            'response.write ErrMsg & " strig= " & sq			
                            cnn.close 			   
                            response.end
                        End If
                        do while not rs.eof %>
                            <tr>                                
                                <td><%=rs("SIN_Nombre")%></td>                      	                  	
                                <td><%=rs("ACE_Nombre")%></td> 
                                <td><%=rs("RUB_Nombre")%></td>
                            </tr><%
                            rs.movenext
                        loop											
                        rs.close											
                    %>                	
                    </tbody>
                </table>
				<h5>Empresas</h5>
                <table> 
                    <thead> 
                        <tr>                                                         
                            <th>Empresa</th> 
                            <th>Rubro</th>
                        </tr> 
                    </thead>                     
                    <tbody> 
                    <%                                                                    
                        set rs=cnn.execute("spPatrocinioEmpresa_Listar " & PRY_Id)
                        on error resume next
                        if cnn.Errors.Count > 0 then 
                            ErrMsg = cnn.Errors(0).description
                            'response.write ErrMsg & " strig= " & sq			
                            cnn.close 			   
                            response.end
                        End If
                        do while not rs.eof %>
                            <tr>                                
                                <td><%=rs("Emp_Nombre")%></td>                      	                  	                                
                                <td><%=rs("RUB_Nombre")%></td>
                            </tr><%
                            rs.movenext
                        loop											
                        rs.close											
                    %>                	
                    </tbody>
                </table><%
				if PRY_TipoMesa=2 then%>
					<h5>Gobierno</h5>
					<table> 
						<thead> 
							<tr>                             
								<th>Servicio</th>
								<th>Ministerio</th> 								
							</tr> 
						</thead>                     
						<tbody> 
						<%                                                                    
							set rs=cnn.execute("spPatrocinioGobierno_Listar " & PRY_Id)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   
								response.end
							End If
							do while not rs.eof %>
								<tr>                                
									<td><%=rs("SER_Nombre")%></td>                      	                  	
									<td><%=rs("GOB_Nombre")%></td> 									
								</tr><%
								rs.movenext
							loop											
							rs.close											
						%>                	
						</tbody>
					</table><%
				end if%>
				
				
				<h4>Representantes</h4>
				<h5>Sindicato</h5><%				
				set rz=cnn.execute("spProyectoSindicato_Listar " & PRY_Id & ", -1")
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
				   'response.write ErrMsg & " strig= " & sq			
					cnn.close 			   
					response.end
				End If
				required="required"
				existe=0
				SINREP_Id=0
				x=0				
				do while not rz.eof
					x=x+1
					SINREP_Id=rz("SIN_Id")					
					existe=1
					
					set rs = cnn.Execute("exec spSindicato_Consultar " & SINREP_Id)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   
						response.end
					End If
					if not rs.eof then
						Rut				     = rs("SIN_Rut")
						SIN_Dv			     = rs("SIN_Dv")
						SIN_Nombre		     = rs("SIN_Nombre")
						SIN_Direccion	     = rs("SIN_Direccion")
						SIN_Telefono	     = rs("SIN_Telefono")
						ACE_Id			     = setNULL(rs("ACE_Id"))
						SIN_Mail		     = rs("SIN_Mail")
						Estado			     = rs("SIN_Estado")
						RUB_Id               = setNULL(rs("RUB_Id"))
						RUB_Nombre           = rs("RUB_Nombre")
						SIN_DirPaginaWeb     = rs("SIN_DirPaginaWeb")
						SIN_NombrePresidente = rs("SIN_NombrePresidente")
						SIN_NumAsociados     = rs("SIN_NumAsociados")
						SIN_NumMujeres       = rs("SIN_NumMujeres")
						SIN_NumHombres       = rs("SIN_NumHombres")
						TOR_Id               = rs("TOR_Id")
						TOR_Nombre			 = rs("TOR_Nombre")
					end if
					rs.Close
					if Estado=1 then
						SIN_Estado="Activado"
					else
						SIN_Estado="Desactivado"
					end if
					SIN_Rut=Rut & SIN_Dv
					if x>0 then%>				
						<h5 style="margin-top: 0px; margin-bottom: 16px;">Sindicato N° <%=x%></h5><%					
					end if%>
										
					<table id="tbl-repsindicato" class="ts"> 
						<thead> 
							<tr> 
								<th width="230">Sindicato</th>
								<th width="80">Rut</th>
								<th width="80">T</th>
								<th width="80">H</th>
								<th width="80">M</th>
								<th width="100">Tipo</th>
								<th width="300">Rama</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td width="230"><%=SIN_Nombre%></td>
								<td width="80"><%=SIN_Rut%></td>
								<td width="80"><%=SIN_NumAsociados%></td>
								<td width="80"><%=SIN_NumHombres%></td>
								<td width="80"><%=SIN_NumMujeres%></td>
								<td width="100"><%=TOR_Nombre%></td>
								<td width="300"><%=RUB_Nombre%></td>
							</tr>
						</tbody>
					</table>																															

					<table id="tbl-repsindicato" class="ts"> 
						<thead> 
							<tr> 							
								<th>Nombre</th>
								<th>Apellido Paterno</th>
								<th>Apellido Materno</th>
								<th>Rut</th>
								<th>Cargo</th>
								<th>Sexo</th>
								<th>Correo</th>
								<th>Teléfono</th>
							</tr> 
						</thead> 						
						<tbody> <%                                
							set rx=cnn.execute("spRepProyectoSindicato_Listar 1," & PRY_Id & "," & rz("SIN_Id"))
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
							   'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   
								response.end
							End If                                           
							'rx.movefirst
							do while not rx.eof%>																			
								<tr class="modrepsin">									
									<td><%=rx("RPS_Nombre")%></td>                      	                  	
									<td><%=rx("RPS_ApellidoPaterno")%></td> 
									<td><%=rx("RPS_ApellidoMaterno")%></td>
									<td><% response.write(rx("RPS_Rut") & rx("RPS_DV"))%></td>
									<td><%=rx("RPS_Cargo")%></td>
									<td><%
										if rx("SEX_Id")=1 then%>
											F<%
										end if
										if rx("SEX_Id")=2 then%>
											M<%
										end if%>
									</td>
									<td><%=rx("RPS_Mail")%></td>
									<td><%=rx("RPS_Telefono")%></td>
								</tr><%
								rx.movenext
							loop											
							rx.close%>                                      
						</tbody>
					</table>
					<div style="padding-top: 15px;border-bottom: 1px solid #ddd;margin-bottom: 15px;"></div>  <%					
					rz.movenext
				loop%>								
				<h5>Empresa</h5><%				
				set rz=cnn.execute("spProyectoEmpresa_Listar " & PRY_Id & ", -1")
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
				   'response.write ErrMsg & " strig= " & sq			
					cnn.close 			   
					response.end
				End If
				required="required"
				existe=0
				EMPREP_Id=0
				x=0									
				do while not rz.eof
					EMPREP_Id=rz("EMP_Id")						
					existe=1	
					x=x+1
					set rs = cnn.Execute("exec spEmpresa_Consultar " & EMPREP_Id)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   						
						response.end
					End If
					if not rs.eof then
						EMP_Rol			     = rs("EMP_Rol")						
						EMP_Nombre		     = rs("EMP_Nombre")						
						Estado			     = rs("EMP_Estado")
						RUB_Id               = setNULL(rs("RUB_Id"))
						RUB_Nombre           = rs("RUB_Nombre")												
						EMP_NumTrabajadores  = rs("EMP_NumTrabajadores")
						EMP_NumMujeres       = rs("EMP_NumMujeres")
						EMP_NumHombres       = rs("EMP_NumHombres")						
					end if
					rs.Close
					if Estado=1 then
						EMP_Estado="Activado"
					else
						EMP_Estado="Desactivado"
					end if
					if x>0 then%>				
						<h5 style="margin-top: 0px; margin-bottom: 16px;">Empresa N° <%=x%></h5><%					
					end if%>
				
					<table id="tbl-repempresa" class="ts"> 
						<thead> 
							<tr> 																
								<th width="280">Empresa</th>
								<th width="80">Rol</th>
								<th width="80">T</th>
								<th width="80">H</th>
								<th width="80">M</th>								
								<th width="350">Rama</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td width="280"><%=EMP_Nombre%></td>
								<td width="80"><%=EMP_Rut%></td>
								<td width="80"><%=EMP_NumTrabajadores%></td>
								<td width="80"><%=EMP_NumHombres%></td>
								<td width="80"><%=EMP_NumMujeres%></td>							
								<td width="350"><%=RUB_Nombre%></td>
							</tr>
						</tbody>
					</table>																															

					<table id="tbl-repempresa" class="ts"> 
						<thead> 
							<tr> 							
								<th>Nombre</th>
								<th>Apellido Paterno</th>
								<th>Apellido Materno</th>
								<th>Rut</th>
								<th>Cargo</th>
								<th>Sexo</th>
								<th>Correo</th>
								<th>Teléfono</th>
							</tr> 
						</thead> 						
						<tbody> <%                                
							set rx=cnn.execute("spRepProyectoEmpresa_Listar 1," & PRY_Id & "," & EMPREP_Id) 
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
							   'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   
								response.end
							End If
							do while not rx.eof%>																			
								<tr class="modrepemp">									
									<td><%=rx("RPE_Nombre")%></td>                      	                  	
									<td><%=rx("RPE_ApellidoPaterno")%></td> 
									<td><%=rx("RPE_ApellidoMaterno")%></td>
									<td><% response.write(rx("RPE_Rut") & rx("RPE_DV"))%></td>
									<td><%=rx("RPE_Cargo")%></td>
									<td><%
										if rx("SEX_Id")=1 then%>
											F<%
										end if
										if rx("SEX_Id")=2 then%>
											M<%
										end if%>
									</td>
									<td><%=rx("RPE_Mail")%></td>
									<td><%=rx("RPE_Telefono")%></td>
								</tr><%
								rx.movenext
							loop											
							rx.close%>                          
						</tbody>
					</table>
					<div style="padding-top: 15px;border-bottom: 1px solid #ddd;margin-bottom: 15px;"></div><%
					rz.movenext
				loop
				
				if PRY_TipoMesa=2 then%>
				
				<h5>Gobierno</h5><%				
				set rz=cnn.execute("spProyectoServicio_Listar " & PRY_Id & ", -1")
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
				   'response.write ErrMsg & " strig= " & sq			
					cnn.close 			   
					response.end
				End If				
				existe=0				
				x=0					
				do while not rz.eof
					SER_Id=rz("SER_Id")						
					existe=1	
					x=x+1
					set rs = cnn.Execute("exec spServicio_Consultar " & SER_Id & ",-1")
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   						
						response.end
					End If
					if not rs.eof then
						GOB_Id=rs("GOB_Id")
						GOB_Rut=rs("GOB_Rut")
						SER_Id=rs("SER_Id")
						SER_Nombre=rs("SER_Nombre")		
						GOB_NombreInstitucion=rs("GOB_NombreInstitucion")
					end if
					rs.Close			
					
					set rs = cnn.Execute("exec spJustificacionGobSer_Consultar -1, " & SER_Id & "," & PRY_Id)
					on error resume next
					if cnn.Errors.Count > 0 then 
						ErrMsg = cnn.Errors(0).description
						'response.write ErrMsg & " strig= " & sq			
						cnn.close 			   						
						response.end
					End If
					if not rs.eof then
						JGS_Justificacion=rs("JGS_Justificacion")
					end if
					rs.Close			
					
					if x>0 then%>				
						<h5 style="margin-top: 0px; margin-bottom: 16px;">Servicio N° <%=x%></h5><%					
					end if%>
				
					<table id="tbl-repgobierno" class="ts"> 
						<thead> 
							<tr> 																		
								<th width="300">Ministerio</th>
								<th width="50">Rut</th>
								<th width="300">Servicio</th>																
								<th width="300">Justificación</th>																
							</tr>
						</thead>
						<tbody>
							<tr>
								<td width="300"><%=GOB_NombreInstitucion%></td>
								<td width="50"><%=GOB_Rut%></td>
								<td width="300"><%=SER_Nombre%></td>
								<td width="300"><%=PRY_Justificacion%></td>
							</tr>
						</tbody>
					</table>

					<table id="tbl-repgobierno" class="ts"> 
						<thead>
							<tr>							
								<th>Nombre</th>
								<th>Apellido Paterno</th>
								<th>Apellido Materno</th>
								<th>Rut</th>
								<th>Cargo</th>
								<th>Sexo</th>
								<th>Correo</th>
								<th>Teléfono</th>										
							</tr>
						</thead>
						<tbody><%										
							set rx = cnn.Execute("exec spRepProyectoGobierno_Listar -1, " & PRY_Id & "," & SER_Id)
							on error resume next
							if cnn.Errors.Count > 0 then 
								ErrMsg = cnn.Errors(0).description
								'response.write ErrMsg & " strig= " & sq			
								cnn.close 			   						
								response.end
							End If
							do while not rx.eof%>																			
								<tr class="modrepgob">									
									<td><%=rx("RPG_Nombre")%></td>                      	                  	
									<td><%=rx("RPG_ApellidoPaterno")%></td> 
									<td><%=rx("RPG_ApellidoMaterno")%></td>
									<td><% response.write(rx("RPG_Rut") & rx("RPG_DV"))%></td>
									<td><%=rx("RPG_Cargo")%></td>
									<td><%
										if rx("SEX_Id")=1 then%>
											F<%
										end if
										if rx("SEX_Id")=2 then%>
											M<%
										end if%>
									</td>
									<td><%=rx("RPG_Mail")%></td>
									<td><%=rx("RPG_Telefono")%></td>
								</tr><%
								rx.movenext
							loop											
							rx.close%>                  
						</tbody>
					</table>
					<div style="padding-top: 15px;border-bottom: 1px solid #ddd;margin-bottom: 15px;"></div><%
					rz.movenext
				loop
				
				end if%>
				
				<%if LIN_AgregaTematica then%>
				<h4>Módulos Adicionales.</h4>
				<table id="tbl-cursosadicionales" class="ts"> 
					<thead>
						<tr>							
							<th>Id</th>
							<th>Id</th>
							<th>Curso Adicional</th>
						</tr>
					</thead>
					<tbody><%
						set rs=cnn.execute("exec spTematicaProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "',-1")
						on error resume next
						if cnn.Errors.Count > 0 then 
							ErrMsg = cnn.Errors(0).description
							'response.write ErrMsg & " strig= " & sq			
							cnn.close 			   
							response.end
						End If
						do while not rs.eof %>
							<tr>
								<td><%=rs("TPR_Id")%></td> 
								<td><%=rs("PPR_Id")%></td> 
								<td><%=rs("TPR_Nombre")%></td>
							</tr><%
							rs.movenext
						loop
						rs.close%>
                  	</tbody>
				</table>
				<%end if%>
            </div>    
        </div>
            	
	</body>
</html>