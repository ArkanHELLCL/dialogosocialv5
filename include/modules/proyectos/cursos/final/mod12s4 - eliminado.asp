<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							 = request("PRY_Id")
	PRY_Identificador				 = request("PRY_Identificador")		
	Step							 = CInt(request("Step"))
	
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
				
	for i=1 to Request.Form("Id").Count
		if(Request.Form("Type")(i)="new") then		
			datos =  PRY_Id & ",'" & PRY_Identificador & "'," & PRY_Step & "," & Request.Form("Id")(i) & ",'" & LimpiarUrl(Request.Form("TEF_Observaciones")(i)) & "'," & Request.Form("TEF_Pertinencia")(i) & "," &  Request.Form("MET_Id")(i) & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"			
			sql="exec spTematicaFeedback_Agregar  " & datos 			
			set rs = cnn.Execute(sql)			
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description			
				cnn.close 			   
				response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
				response.End()
			End If
		end if
		if(Request.Form("Type")(i)="old") then		
			datos = Request.Form("Id")(i) & "," & PRY_Id & ",'" & LimpiarUrl(Request.Form("TEF_Observaciones")(i)) & "'," & Request.Form("TEF_Pertinencia")(i) & "," & Request.Form("MET_Id")(i) & "," & PRY_Step & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"			
			sql="exec spTematicaFeedback_Modificar  " & datos 			
			set rs = cnn.Execute(sql)			
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description			
				cnn.close 			   
				response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
				response.End()
			End If
		end if				
	next						
	response.write("200\\")		
%>