<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							= request("PRY_Id")
	PRY_Identificador				= request("PRY_Identificador")		
	Step							= CInt(request("Step"))
	PRY_BenDirectosMujeres			 = request("PRY_BenDirectosMujeres")
	if PRY_BenDirectosMujeres="" then
		PRY_BenDirectosMujeres=0
	end if
	PRY_BenDirectosHombres 			 = request("PRY_BenDirectosHombres")
	if PRY_BenDirectosHombres="" then
		PRY_BenDirectosHombres=0
	end if
	PRY_SinBenIndirectosMujeres		 = request("PRY_SinBenIndirectosMujeres")
	if PRY_SinBenIndirectosMujeres="" then
		PRY_SinBenIndirectosMujeres=0
	end if
	PRY_EmpBenIndirectosMujeres	     = request("PRY_EmpBenIndirectosMujeres")
	if PRY_EmpBenIndirectosMujeres="" then
		PRY_EmpBenIndirectosMujeres=0
	end if
	PRY_EmpBenIndirectosHombres      = request("PRY_EmpBenIndirectosHombres")
	if PRY_EmpBenIndirectosHombres="" then
		PRY_EmpBenIndirectosHombres=0
	end if
	PRY_SinBenIndirectosHombres      = request("PRY_SinBenIndirectosHombres")			
	if PRY_SinBenIndirectosHombres="" then
		PRY_SinBenIndirectosHombres=0
	end if
	PRY_GobBenIndirectosHombres		= request("PRY_GobBenIndirectosHombres")
	if PRY_GobBenIndirectosHombres="" then
		PRY_GobBenIndirectosHombres=0
	end if
	PRY_GobBenIndirectosMujeres		= request("PRY_GobBenIndirectosMujeres")
	if PRY_GobBenIndirectosMujeres="" then
		PRY_GobBenIndirectosMujeres=0
	end if
	PRY_GobBenDirectosHombres		= request("PRY_GobBenDirectosHombres")
	if PRY_GobBenDirectosHombres="" then
		PRY_GobBenDirectosHombres=0
	end if
	PRY_GobBenDirectosMujeres		= request("PRY_GobBenDirectosMujeres")
	if PRY_GobBenDirectosMujeres="" then
		PRY_GobBenDirectosMujeres=0
	end if
	PRY_EmpBenDirectosHombres		= request("PRY_EmpBenDirectosHombres")
	if PRY_EmpBenDirectosHombres="" then
		PRY_EmpBenDirectosHombres=0
	end if
	PRY_EmpBenDirectosMujeres		= request("PRY_EmpBenDirectosMujeres")
	if PRY_EmpBenDirectosMujeres="" then
		PRY_EmpBenDirectosMujeres=0
	end if
	
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
		PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_InformeSistematizacionEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if		
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "'," & PRY_Step & "," & PRY_BenDirectosMujeres & "," & PRY_BenDirectosHombres & "," & PRY_SinBenIndirectosMujeres & "," & PRY_SinBenIndirectosHombres & "," & PRY_EmpBenIndirectosMujeres & "," & PRY_EmpBenIndirectosHombres & "," & PRY_GobBenIndirectosHombres & "," & PRY_GobBenIndirectosMujeres & "," & PRY_GobBenDirectosHombres & "," & PRY_GobBenDirectosMujeres & "," & PRY_EmpBenDirectosHombres & "," & PRY_EmpBenDirectosMujeres & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec [spPryInformeSistematizacionBeneficiarios_Modificar] " & datos 	
	
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