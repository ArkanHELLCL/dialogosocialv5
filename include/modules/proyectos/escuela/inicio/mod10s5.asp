<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id					= request("PRY_Id")
	PRY_Identificador		= request("PRY_Identificador")
	
	PRY_LanzamientoFecha 	= request("PRY_LanzamientoFecha")
	PRY_LanzamientoHora 	= request("PRY_LanzamientoHora")
	PRY_LanzamientoDireccion= LimpiarUrl(request("PRY_LanzamientoDireccion"))
	PRY_CierreFecha 		= request("PRY_CierreFecha")
	PRY_CierreHora 			= request("PRY_CierreHora")
	PRY_CierreDireccion 	= LimpiarUrl(request("PRY_CierreDireccion"))
	MET_IdLanzamiento		= request("MET_IdLanzamiento")
	MET_IdCierre			= request("MET_IdCierre")
	PRY_UrlLanzamiento		= LimpiarUrl(request("PRY_UrlLanzamiento"))
	PRY_UrlCierre			= LimpiarUrl(request("PRY_UrlCierre"))
	PRY_ClaseCierreFecha	= request("PRY_ClaseCierreFecha")
	PRY_ClaseCierreHora		= request("PRY_ClaseCierreHora")
	MET_IdClaseCierre		= request("MET_IdClaseCierre")
	PRY_ClaseCierreDireccion= LimpiarUrl(request("PRY_ClaseCierreDireccion"))
	PRY_UrlClaseCierre		= LimpiarUrl(request("PRY_UrlClaseCierre"))
	PRY_LanzamientoHoraFin  = request("PRY_LanzamientoHoraFin")
	PRY_ClaseCierreHoraFin	= request("PRY_ClaseCierreHoraFin")
	PRY_CierreHoraFin 		= request("PRY_CierreHoraFin")
	Step					= CInt(request("Step"))
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
	
	xsql = "exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(xsql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión 2:" & ErrMsg & "-" & xsql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step=rs("PRY_Step")
		LFO_Id = rs("LFO_Id")
				
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_InformeInicioEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if		 
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_LanzamientoFecha & "','" & PRY_LanzamientoHora & "','" & PRY_LanzamientoDireccion & "','" & PRY_CierreFecha & "','" & PRY_CierreHora & "','" & PRY_CierreDireccion & "'," & PRY_Step & "," & MET_IdLanzamiento & "," & MET_IdCierre & ",'" & PRY_UrlLanzamiento & "','" & PRY_UrlCierre & "','" & PRY_ClaseCierreFecha & "','" & PRY_ClaseCierreHora & "'," & MET_IdClaseCierre & ",'" & PRY_ClaseCierreDireccion & "','" & PRY_UrlClaseCierre & "','" & PRY_LanzamientoHoraFin & "','" & PRY_ClaseCierreHoraFin & "','" & PRY_CierreHoraFin & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec [spProyecto_ActividadesModificar] " & datos 	
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	if not rs.eof then		
		response.write("200\\")		
	end if
	
%>