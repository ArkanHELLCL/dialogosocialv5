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
MasterPage	= "Informe_Sistematizacion"

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
		USR_IdRevisor			         = rs("USR_IdRevisor")
		USR_NombreRevisor		         = rs("USR_NombreRevisor")
		USR_ApellidoRevisor		         = rs("USR_ApellidoRevisor")
		USR_MailRevisor					 = rs("USR_MailRevisor")
		USR_TelefonoRevisor				 = rs("USR_TelefonoRevisor")
		USR_DireccionRevisor			 = rs("USR_DireccionRevisor")
		USR_NombreInstitucionRevisor	 = rs("USR_NombreInstitucionRevisor")					
		USR_IdEjecutor			         = rs("USR_IdEjecutor")
		USR_NombreEjecutor		         = rs("USR_NombreEjecutor")
		USR_ApellidoEjecutor	         = rs("USR_ApellidoEjecutor")
		USR_MailEjecutor				 = rs("USR_MailEjecutor")
		USR_TelefonoEjecutor			 = rs("USR_TelefonoEjecutor")
		USR_DireccionEjecutor			 = rs("USR_DireccionEjecutor")
		USR_NombreInstitucionEjecutor	 = rs("USR_NombreInstitucionEjecutor")										
		LIN_Id				             = rs("LIN_Id")
		LIN_Nombre 	                     = rs("LIN_Nombre")
		LFO_Id                           = rs("LFO_Id")
		LFO_Nombre                       = rs("LFO_Nombre")									
		COM_Id 			                 = rs("COM_Id")
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
		COM_IdLanzamiento				 = rs("COM_IdLanzamiento")
		PRY_LanzamientoDireccion		 = rs("PRY_LanzamientoDireccion")	
		PRY_CierreFecha					 = rs("PRY_CierreFecha")	
		PRY_CierreHora					 = rs("PRY_CierreHora")	
		COM_IdCierre					 = rs("COM_IdCierre")
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
		PRY_Justificacion				 = rs("PRY_Justificacion")
		
		'Sistematizacion
		PRY_SituacionInicial			 = rs("PRY_SituacionInicial")
		NIV_IdPropuesto                  = rs("NIV_IdPropuesto")
		NIV_NombrePropuesto				 = rs("NIV_NombrePropuesto")
		NIV_IdLogrado			         = rs("NIV_IdLogrado")
		NIV_NombreLogrado				 = rs("NIV_NombreLogrado")
		PRY_DescripcionNivel			 = rs("PRY_DescripcionNivel")
		PRY_BenDirectosMujeres			 = rs("PRY_BenDirectosMujeres")
		PRY_BenDirectosHombres 			 = rs("PRY_BenDirectosHombres")
		PRY_SinBenIndirectosMujeres		 = rs("PRY_SinBenIndirectosMujeres")
		PRY_EmpBenIndirectosMujeres	     = rs("PRY_EmpBenIndirectosMujeres")
		PRY_EmpBenIndirectosHombres      = rs("PRY_EmpBenIndirectosHombres")
		PRY_SinBenIndirectosHombres      = rs("PRY_SinBenIndirectosHombres")
		PRY_SisFacilitadores             = rs("PRY_SisFacilitadores")			
		PRY_SisObstaculizadores          = rs("PRY_SisObstaculizadores")			
		PRY_PrincipalesAcuerdos          = rs("PRY_PrincipalesAcuerdos")			
		PRY_Desafios         			 = rs("PRY_Desafios")			
		PRY_Sugerencias     			 = rs("PRY_Sugerencias")
		PRY_TipoMesa					 = rs("PRY_TipoMesa")
		
		PRY_GobBenIndirectosHombres		= rs("PRY_GobBenIndirectosHombres")
		PRY_GobBenIndirectosMujeres		= rs("PRY_GobBenIndirectosMujeres")
		PRY_GobBenDirectosHombres		= rs("PRY_GobBenDirectosHombres")
		PRY_GobBenDirectosMujeres		= rs("PRY_GobBenDirectosMujeres")
		PRY_EmpBenDirectosHombres		= rs("PRY_EmpBenDirectosHombres")
		PRY_EmpBenDirectosMujeres		= rs("PRY_EmpBenDirectosMujeres")
		
	else
		response.end	
	end if
	rs.Close
	if PRY_InformeSistematizacionEstado=0 then		'Solo si el hito CREACION esta cerrado
		response.Write("1")
		response.End()	
	end if
	if PRY_Estado=0 then
		Estado="Desactivado"				
	end if
	if PRY_Estado=1 then
		Estado="Activado"
	end if		
else
	response.end
end if		
%>
	<body>
		<div class="container" style="padding:0;margin:0;">        	
            <div id="contenido" style="padding:0;margin:0;">    	    	
				
				<h4>Nivel</h4>
				
				 <table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr> 							
							<th>Nivel Propuesto</th>							
						<th>Nivel Logrado</th>
							<th>Descripción</th>
						</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=NIV_NombrePropuesto%></td>							
							<td><%=NIV_NombreLogrado%></td>							
							<td><%=PRY_DescripcionNivel%></td>							
						</tr>							                       
				 </tbody>
				</table>	
				
				<h4>Beneficiarios</h4>
				
				 <table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
						<th colspan="3"  style="text-align:center;">Beneficiarios Directos Sindicales</th>
					</tr>
					<tr> 							
							<th>Hombres</th>							
							<th>Mujeres</th>
							<th>Total</th>
					</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=PRY_BenDirectosHombres%></td>							
							<td><%=PRY_BenDirectosMujeres%></td>							
							<td><%=PRY_BenDirectosHombres+PRY_BenDirectosMujeres%></td>							
						</tr>							                       
					</tbody>
				</table>	
				
				<table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
						<th colspan="3"  style="text-align:center;">Beneficiarios Indirectos Sindicales</th>
						</tr>
						<tr> 							
							<th>Hombres</th>							
							<th>Mujeres</th>
							<th>Total</th>
						</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=PRY_SinBenIndirectosHombres%></td>							
							<td><%=PRY_SinBenIndirectosMujeres%></td>							
							<td><%=PRY_SinBenIndirectosHombres+PRY_SinBenIndirectosMujeres%></td>							
						</tr>							                       
					</tbody>
				</table>	
				
				<table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
						<th colspan="3"  style="text-align:center;">Beneficiarios Directos Empresas</th>
						</tr>
						<tr> 							
							<th>Hombres</th>							
							<th>Mujeres</th>
							<th>Total</th>
						</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=PRY_EmpBenDirectosHombres%></td>							
							<td><%=PRY_EmpBenDirectosMujeres%></td>							
							<td><%=PRY_EmpBenDirectosHombres+PRY_EmpBenDirectosMujeres%></td>							
						</tr>							                       
					</tbody>
				</table>	
				
				<table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
						<th colspan="3"  style="text-align:center;">Beneficiarios Indirectos Empresas</th>
						</tr>
						<tr> 							
							<th>Hombres</th>							
							<th>Mujeres</th>
							<th>Total</th>
						</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=PRY_EmpBenIndirectosHombres%></td>							
							<td><%=PRY_EmpBenIndirectosMujeres%></td>							
							<td><%=PRY_EmpBenIndirectosHombres+PRY_EmpBenIndirectosMujeres%></td>							
						</tr>							                       
					</tbody>
				</table>	
				
				<%if PRY_TipoMesa=2 then%>
				<table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
						<th colspan="3"  style="text-align:center;">Beneficiarios Directos Gobierno</th>
						</tr>
						<tr> 							
							<th>Hombres</th>							
							<th>Mujeres</th>
							<th>Total</th>
						</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=PRY_GobBenDirectosHombres%></td>							
							<td><%=PRY_GobBenDirectosMujeres%></td>							
							<td><%=PRY_GobBenDirectosHombres+PRY_GobBenDirectosMujeres%></td>							
						</tr>							                       
					</tbody>
				</table>	
				
				<table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
						<th colspan="3"  style="text-align:center;">Beneficiarios Indirectos Gobierno</th>
						</tr>
						<tr> 							
							<th>Hombres</th>							
							<th>Mujeres</th>
							<th>Total</th>
						</tr> 
					</thead> 
					<tbody>
						<tr class="">								
							<td><%=PRY_GobBenIndirectosHombres%></td>							
							<td><%=PRY_GobBenIndirectosMujeres%></td>							
							<td><%=PRY_GobBenIndirectosHombres+PRY_GobBenIndirectosMujeres%></td>							
						</tr>							                       
					</tbody>
				</table>	
				<%end if%>
				
				
				<h4>Representantes Sindicato</h4><%			
				
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
				
				<h4>Representantes Empresa</h4><%		
				
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
				
				<h4>Representantes Gobierno</h4><%
				
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
												
				<h4>Facilitadores y Obstaculizadores</h4>
				
				 <table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>
							<th>&nbsp;</th> 							
							<th>Descripción</th>							
						</tr> 
					</thead> 
					<tbody>
						<tr class="">
							<th>Facilitadores</th>
							<td><%=PRY_SisFacilitadores%></td>
						</tr>
						<tr class="">
							<th>Obstaculizadors</th>								
							<td><%=PRY_SisObstaculizadores%></td>							
						</tr>							                       
					</tbody>
				</table>	
				
				<h4>Acuerdos y/o Concluciones</h4>
				
				 <table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>							
							<th>Principales Acuerdos y/o Conclusiones</th>							
						</tr> 
					</thead> 
					<tbody>
						<tr class="">
							<td><%=PRY_PrincipalesAcuerdos%></td>
						</tr>											                       
					</tbody>
				</table>	
				
				<h4>Desafíos y Continuidad</h4>
				
				 <table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>							
							<th>Desafíos y Continuidad</th>							
						</tr> 
					</thead> 
					<tbody>
						<tr class="">
							<td><%=PRY_Desafios%></td>
						</tr>											                       
					</tbody>
				</table>	
				
				<h4>Sugerencias</h4>
				
				 <table id="tbl-mesatrabajadores" class="ts"> 
					<thead> 
						<tr>							
							<th>Desafíos y Continuidad</th>							
						</tr> 
					</thead> 
					<tbody>
						<tr class="">
							<td><%=PRY_Sugerencias%></td>
						</tr>											                       
					</tbody>
				</table>	
				
			</div>
		</div>
            	
	</body>
</html>