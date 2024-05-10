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
MasterPage	= "Informe_Final"

set cnn = Server.CreateObject("ADODB.Connection")
cnn.open session("DSN_DialogoSocialv5")
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description			
	cnn.close 			   
	Response.end
End If

if int(PRY_Id)>0 and PRY_Id<>"" then
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		Response.end
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
		
		PRY_ObsCumplimientosPropuestos	 = rs("PRY_ObsCumplimientosPropuestos")
	  	PRY_ObsCumplimientosFechas		 = rs("PRY_ObsCumplimientosFechas")				
		PRY_ObsEjecucion				 = rs("PRY_ObsEjecucion")
		PRY_ObsGeneral					 = rs("PRY_ObsGeneral")
		
		PRY_EmpresaEjecutora			 = rs("PRY_EmpresaEjecutora")
		
		LIN_Hombre=rs("LIN_Hombre")
		LIN_Mujer=rs("LIN_Mujer")
		LFO_Calif=rs("LFO_Calif")
		LIN_PorcentajeMaxAsistenciaDesercion=rs("LIN_PorcentajeMaxAsistenciaDesercion")
		LIN_PorcentajeMaxAsistenciaReprobacion=rs("LIN_PorcentajeMaxAsistenciaReprobacion")
		LIN_Id=rs("LIN_Id")
		
		
	else
		Response.end
	end if
	rs.Close
	TotMujeres=0
	TotHombres=0
	TotMDesertores=0
	TotMEgresados=0
	TotMReprobados=0
	TotHDesertores=0
	TotHEgresados=0
	TotHReprobados=0
	TotMInscritos=0
	TotHInscritos=0
	TotHMatriculados=0
	TotMMatriculados=0
	TotMBeneficiarios=0
	TotHBeneficiarios=0
	Total=0
	Promedios=0

	sql="exec spCobertura_Listar " & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" & session("ds5_usrtoken") & "'"
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	End If
	'0 Matriculado
	'1 Beneficiario
	'2 Inscritos
	'3 Aprobados
	'4 Reprobado por Asistencia
	'5 Reprobado por notas 5
	'6 Desertado (Manual y Automatico)
	do While Not rs.EOF 
    	if(rs("sex_id")=1) then
      		
			if(rs("EST_Estado")=0) then        
        		TotMMatriculados=TotMMatriculados+rs("Total")        
      		else
				if(rs("EST_Estado")=1) then        
					TotMBeneficiarios=TotMBeneficiarios+rs("Total")        
				else
					if(rs("EST_Estado")=2) then        
						TotMInscritos=TotMInscritos+rs("Total")        
					else
						if(rs("EST_Estado")=3) then        
							TotMEgresados=TotMEgresados+rs("Total")        
						else
							if(rs("EST_Estado")=4 or rs("EST_Estado")=5) then
								TotMReprobados=TotMReprobados+rs("Total")        
							else
								if(rs("EST_Estado")=6) then
									TotMDesertores=TotMDesertores+rs("Total")        
								else
								end if
							end if
						end if
					end if
				end if
			end if
			'TotMujeres=TotMujeres+rs("Total")			
    	else      		
			if(rs("EST_Estado")=0) then        
        		TotHMatriculados=TotHMatriculados+rs("Total")        
      		else
				if(rs("EST_Estado")=1) then        
					TotHBeneficiarios=TotHBeneficiarios+rs("Total")        
				else
					if(rs("EST_Estado")=2) then        
						TotHInscritos=TotHInscritos+rs("Total")        
					else
						if(rs("EST_Estado")=3) then        
							TotHEgresados=TotHEgresados+rs("Total")        
						else
							if(rs("EST_Estado")=4 or rs("EST_Estado")=5) then
								TotHReprobados=TotHReprobados+rs("Total")        
							else
								if(rs("EST_Estado")=6) then
									TotHDesertores=TotHDesertores+rs("Total")        
								else
								end if
							end if
						end if
					end if
				end if
			end if
			'TotHombres=TotHombres+rs("Total")			
		end if
    	rs.MoveNext
  	loop  
  	rs.Close
	TotMujeres=TotMMatriculados
	TotHombres=TotHMatriculados
  	Total=TotMujeres+TotHombres
	
	
	sql="exec spPlanificacion_Listar " & PRY_Id & ",'" & PRY_Identificador & "'"
			
	set rs3 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	End If
	TotSes=0
	do while not rs3.eof		
		TotSes=TotSes+1
		rs3.movenext
	loop
	rs3.close
	
	TotMRIna=0
	TotHRIna=0
	TotRIna=0
	
	TotMRNot=0
	TotHRNot=0
	TotRNot=0
	
	TotAlu=0
  	set rs = cnn.Execute("exec spAlumnoProyecto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description	   
		cnn.close
		response.Write("503/@/Error Conexión:" & ErrMsg)
		response.End()
	End If
	do While Not rs.EOF 
		TotAlu=TotAlu+1
		sw=0
				
		desertado=false		
		if(rs("EST_Estado")=6) then
			desertado=true
		end if
		
  		if(not desertado) then
			sexo=ucase(trim(rs("SEX_Descripcion")))			
			TotAsis=round(rs("TotalHorasAsistidas"),1)
			
			'if por>=50 and por<=64 then
			if TotAsis>=50 and TotAsis<=64.9 then
				sw=1
				if (sexo="FEMENINO") then
					TotMRIna=TotMRina+1
				else
					TotHRIna=TotHRina+1				
				end if
				TotRIna=TotRina+1					
			end if
		
			if(sw=0) then
				'Notas por alumno de este proyecto
				sql="exec spNota_PromedioConsultar " & rs("ALU_Rut") & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" &  session("ds5_usrtoken") & "'"
				set rs3 = cnn.Execute(sql)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description
					'response.write ErrMsg & " strig= " & sql
					cnn.close 			   
					Response.Redirect("/reingresa-tus-credenciales")
				End If									
				if not rs3.eof then										
					ProNot=CDbl(rs3("NOT_Promedio"))
				else
					ProNot=0
				end if	

				if (ProNot<4) then
					if (sexo="FEMENINO") then
						TotMRNot=TotMRNot+1
					else
						TotHRNot=TotHRNot+1				
					end if
					TotRNot=TotRNot+1
				end if		
			end if
		end if
  		rs.movenext
	loop
else
	Response.end
end if
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

%>
	<body>
		<div class="container">        	
            <div id="contenido">
    	        <h4>Cobertura del Programa</h4>				
                <table  border="0">              	              	
					<thead>
					<tr><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <th scope="col" style="text-align: center;vertical-align: middle;"  >Alumnos/as</th>
						  <th scope="col" style="text-align: center;vertical-align: middle;"  >Hombres</th>
						  <th scope="col" style="text-align: center;vertical-align: middle;"  >Mujeres</th>
						  <th scope="col" style="text-align: center;vertical-align: middle;"  >Total</th><%
					  else
						  if(LIN_Hombre and not LIN_Mujer) then%>
							<th scope="col" style="text-align: center;vertical-align: middle;"  >Alumnos</th>					  
							<th scope="col" style="text-align: center;vertical-align: middle;"  >Total</th><%
						  else
							if(not LIN_Hombre and LIN_Mujer) then%>
								<th scope="col" style="text-align: center;vertical-align: middle;"  >Alumnas</th>					  
								<th scope="col" style="text-align: center;vertical-align: middle;"  >Total</th><%
							else%>
								<th scope="col" style="text-align: center;vertical-align: middle;"  >Sin definir</th>					  
								<th scope="col" style="text-align: center;vertical-align: middle;"  >Total</th><%
							end if
						  end if
					  end if%>
					</tr>
					</thead>
					<tbody>
					<tr>
					  <th scope="row">Matriculados/as</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(TotHMatriculados)%></td>
						  <td style="text-align: center;"><%=response.write(TotMMatriculados)%></td><%
					  end if%>
					  <td style="text-align: center;"><%=response.write(TotHMatriculados+TotMMatriculados)%></td>
					</tr>
					<tr>
					  <th scope="row">Beneficiarios/as</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(TotHBeneficiarios)%></td>
						  <td style="text-align: center;"><%=response.write(TotMBeneficiarios)%></td><%
					  end if%>
					  <td style="text-align: center;"><%=response.write(TotHBeneficiarios+TotMBeneficiarios)%></td>
					</tr>
					<tr>
					  <th scope="row">Inscritos/as</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(TotHInscritos)%></td>
						  <td style="text-align: center;"><%=response.write(TotMInscritos)%></td><%
					  end if%>
					  <td style="text-align: center;"><%=response.write(TotHInscritos+TotMInscritos)%></td>
					</tr>
					<tr>
					  <th scope="row">Desertores/as</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(TotHDesertores)%></td>
						  <td style="text-align: center;"><%=response.write(TotMDesertores)%></td><%
					  end if%>
					  <td style="text-align: center;"><%=response.write(TotHDesertores+TotMDesertores)%></td>
					</tr>
					<tr>
					  <th scope="row">Egresados/as</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(TotHEgresados)%></td>
						  <td style="text-align: center;"><%=response.write(TotMEgresados)%></td><%
					  end if%>
					  <td style="text-align: center;"><%=response.write(TotHEgresados+TotMEgresados)%></td>
					</tr>
					<tr>
					  <th scope="row">Reprobados/as</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(TotHReprobados)%></td>
						  <td style="text-align: center;"><%=response.write(TotMReprobados)%></td><%
					  end if%>
					  <td style="text-align: center;"><%=response.write(TotHReprobados+TotMReprobados)%></td>
					</tr>


					<tr>
					  <th scope="row">Promedios</th><%
					  if(LIN_Hombre and LIN_Mujer) then%>
						  <td style="text-align: center;"><%=response.write(round(((TotHombres*100)/Total),1) & "%")%></td>
						  <td style="text-align: center;"><%=response.write(round(((TotMujeres*100)/Total),1) & "%")%></td><%
					  end if%>
					  <td style="text-align: center;">100%</td>
					</tr>
				   </tbody>                
           		</table>
			  
				
				<h4>Causas de Deserciones</h4>
            	<h5>Causas, razones y cantidad de deserciones</h5>
               	<table border="0"> 
					<thead>
						<tr>
						  <th rowspan="2" style="text-align: center;vertical-align: middle;" scope="row" >Causa</th>
						  <td rowspan="2" style="text-align: center;vertical-align: middle;">Razón</td><%
						  if(LIN_Hombre and LIN_Mujer) then%>
							<td colspan="3" style="text-align: center;vertical-align: middle;">Cantidad de Alumnos/as</td><%
						  else
							if(LIN_Mujer and not LIN_Hombre) then%>
								<td colspan="3" style="text-align: center;vertical-align: middle;">Cantidad de Alumnas</td><%
							else
								if(not LIN_Mujer and LIN_Hombre) then%>
									<td colspan="3" style="text-align: center;vertical-align: middle;">Cantidad de Alumnos</td><%
								else%>
									<td colspan="3" style="text-align: center;vertical-align: middle;">No definido</td><%
								end if
							end if
						  end if%>
						</tr>
						<tr><%
						  if(LIN_Hombre and LIN_Mujer) then%>
							<td  style="text-align: center;vertical-align: middle;">Hombres</td>
							<td style="text-align: center;vertical-align: middle;">Mujeres</td><%
						  end if%>						  
						  <td style="text-align: center;vertical-align: middle;">Total</td>
						</tr>
					</thead>
					<tbody><%
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
								<td style="text-align: center;vertical-align: middle;font-weight: bold;"><%=rs("Masculino")+rs("Femenino")%></td>
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
								<td><% response.write(rsx("ALU_Nombre") & " ")%><% response.write(rsx("ALU_ApellidoPaterno"))%></td>
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
				
				<h4>Cumplimientos</h4>				
                <table  border="0">              		
					<tr>
					  <th scope="col" style="text-align: center;vertical-align: middle;">¿Se cumplieron los objetivos propuestos?</th>
					  <th scope="col" style="text-align: center;vertical-align: middle;">¿Se cumplieron las fechas propuestas?</th>
					</tr>

					<tr>
					  <td style="text-align: center;">
						<%=PRY_ObsCumplimientosPropuestos%>
					  </td>
					  <td style="text-align: center;">
						<%=PRY_ObsCumplimientosFechas%>
					  </td>
					</tr>
              	</table>   
				
				<h4>Evaluación del Programa</h4><%
					set rs = cnn.Execute("exec spPlanificacionPlantilla_Listar " & PRY_Id & ",'" & PRY_Identificador & "'")
					on error resume next			
					if cnn.Errors.Count > 0 then 
					   ErrMsg = cnn.Errors(0).description	   
					   cnn.close					   
					   response.End() 			   
					end if
					MOD_Id=0
					PER_Id=0
					TEM_Id=0								
					corr=0
					sw=0
					Modulo=1
					do while not rs.eof

						if MOD_Id<>rs("MOD_Id") then 'Cambio de Modulo - Nueva tabla
							if MOD_id<>0 then	'No es el primero
								Modulo=Modulo+1%>
									
								</tbody>
							</table><%
							end if%>
							<h5><%=rs("MOD_Nombre")%><h5>
							<table cellspacing="0" border="0">
								<thead> 												
									<tr>													
										<th style="text-align: center;vertical-align: middle;">Perspectiva</th>
										<th style="text-align: center;vertical-align: middle;">Módulo</th>                                                    
										<th style="text-align: center;vertical-align: middle;">Pertinencia</th>
										<th style="text-align: center;vertical-align: middle;">Metodología</th>
										<th style="text-align: center;vertical-align: middle;">Observación</th>										
									</tr>
								</thead>
								<tbody>
									<tr><%
						else%>
							<tr><%
						end if

						'Busqueda de tematicas planificadas
						sqlz="exec spTotalHorasTematica_Calcular " & rs("TEM_Id") & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
						set rsx = cnn.Execute(sqlz)
						on error resume next			
						if cnn.Errors.Count > 0 then 
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close						   
						   response.End() 			   
						end if
						dif=round((rs("TEM_Horas")*45),2) * -1
						if not rsx.eof then
							dif = rsx("TotalMinutosTematica") - rsx("TotalMinutosPlanificados")
							if(dif<0) then
								dif="(0)"
							else
								dif="(" & dif & ")"
							end if						
						end if
						'response.write(sqlx)
						'Busqueda de tematicas planificadas

						if PER_Id<>rs("PER_Id") then	'Cambio de perspectiva%>					                                    			
							<th rowspan="<%=rs("CANT_PER_Id")%>" scope="row" style="text-align: center;vertical-align: middle;" id="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></th><%
						end if

						if TEM_Id<>rs("TEM_Id") then%>										
							<td rowspan="<%=rs("CANT_TEM_Id")%>" style="text-align: center;vertical-align: middle;font-size: 12px;font-weight: initial;" id="<%=rs("TEM_Id")%>"><%=rs("TEM_Nombre")%></td><%
						end if								
						'Buscando las observaciones por tematica
						set rs9 = cnn.Execute("exec spTematicaFeedback_Consultar " & rs("TEM_Id") & "," & PRY_Id)
						on error resume next			
						if cnn.Errors.Count > 0 then 
						   ErrMsg = cnn.Errors(0).description	   
						   cnn.close						   
						   response.End() 			   
						end if
						if not rs9.eof then
							TEF_Pertinencia = rs9("TEF_Pertinencia")
							'TEF_Metodologia = rs9("TEF_Metodologia")							
							MET_Descripcion = rs9("MET_Descripcion")
						else
							TEF_Pertinencia = 99
							'TEF_Metodologia = 0		
							MET_Descripcion=""
						end if%>
							<td style="text-align: center;vertical-align: middle;"><%
								if TEF_Pertinencia=0 then%>
									No pertinente<%
								else
									if TEF_Pertinencia=1 then%>
										Pertinente<%
									else
										if TEF_Pertinencia=2 then%>
											Muy pertinente<%														
										else%>
											-<%
										end if
									end if
								end if%>								
							</td>
							<td style="text-align: center;vertical-align: middle;">
								<%=MET_Descripcion%>
							</td>
							<td style="text-align: center;vertical-align: middle;"><%=rs9("TEF_Observaciones")%></td>							
						</tr><%
						MOD_Id=rs("MOD_Id")
						PER_Id=rs("PER_Id")
						TEM_Id=rs("TEM_Id")
						corr=corr+1									
						rs.movenext
					loop%>							
						</tbody>
					</table>
				
				<h4>Observaciones</h4>				
                <table  border="0">
              		<thead>
					<tr>
					  <th scope="col" style="text-align: center;vertical-align: middle;width:50%">¿Que Módulos y Metodologías provocaron mayor interés en los estudiantes?</th>
					  <th scope="col" style="text-align: center;vertical-align: middle;width:50%">Observaciones Generales</th>
					</tr>
					</thead>
					<tr>
					  <td style="width:50%;text-align: center;vertical-align: middle;">
						<%=PRY_ObsEjecucion%>	  
					  </td>
					  <td style="width:50%;text-align: center;vertical-align: middle;">
						<%=PRY_ObsGeneral%>
					  </td>
					</tr>
              	</table>   
                    														
        	</div>           	
        </div>
	</body>
</html>