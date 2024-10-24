<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							 		= request("PRY_Id")
	PRY_Identificador				 		= request("PRY_Identificador")	
	PRY_IdenProblematicaTematicaComunes 	= LimpiarUrl(request("PRY_IdenProblematicaTematicaComunes"))
	PRY_IdenProblematicaTematicaPriorizadas = LimpiarUrl(request("PRY_IdenProblematicaTematicaPriorizadas"))
	PRY_PrincipalesHallazgosDiagnostico		= LimpiarUrl(request("PRY_PrincipalesHallazgosDiagnostico"))
	Step							 		= CInt(request("Step"))
	
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_InformeFinalEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if		
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "'," & PRY_Step & ",'" & PRY_IdenProblematicaTematicaComunes & "','" & PRY_IdenProblematicaTematicaPriorizadas & "','" & PRY_PrincipalesHallazgosDiagnostico & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec [spProyectoAnalisisMesas_Modificar] " & datos 	
	
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