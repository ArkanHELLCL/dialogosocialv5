<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id							= request("PRY_Id")	
	PRY_Step						= request("PRY_Step")
	GRF_Id							= request("GRF_Id")
	GRF_Discapacidad				= request("GRF_Discapacidad")
	GRF_AccesoInternet 				= request("GRF_AccesoInternet")
	GRF_DispositivoElectronico 		= request("GRF_DispositivoElectronico")
	GRF_PuebloOriginario			= request("GRF_PuebloOriginario")
	GRF_PerteneceSindicato			= request("GRF_PerteneceSindicato")
	GRF_PermisoSindical				= request("GRF_PermisoSindical")
	GRF_DirigenteSindical			= request("GRF_DirigenteSindical")
	GRF_CursoSindical				= request("GRF_CursoSindical")
	GRF_CargoDirectivoOrganizacion	= request("GRF_CargoDirectivoOrganizacion")
	GRF_Porcentaje					= request("GRF_Porcentaje")
	GRF_Estado						= 1

	Step							 = CInt(request("Step"))

	if(GRF_Porcentaje="") then
		GRF_Porcentaje=0
	end if

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión:" & ErrMsg)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step=rs("PRY_Step")
		LFO_Id = rs("LFO_Id")		
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_CreacionProyectoEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if	

	sqlx = "spGruposFocalizacion_Modificar " & GRF_Id & "," & PRY_Id & "," & GRF_Discapacidad & "," & GRF_AccesoInternet & "," & GRF_DispositivoElectronico & "," & GRF_PuebloOriginario & "," & GRF_PerteneceSindicato & "," & GRF_PermisoSindical & "," & GRF_DirigenteSindical & "," & GRF_CursoSindical & "," & GRF_CargoDirectivoOrganizacion & "," & GRF_Estado & "," & GRF_Porcentaje & "," & PRY_Step & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	

	set rs=cnn.execute(sqlx)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   response.Write("503\\Error Conexión:" & ErrMsg & "-" & sqlx)	   
	   rs.close
	   cnn.close
	   response.end()			
	end if	
	response.write("200\\")		
	
	cnn.close
	set cnn = nothing
%>