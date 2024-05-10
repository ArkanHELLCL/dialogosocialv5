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
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
				
	for i=1 to Request.Form("Id").Count
		if(Request.Form("Type")(i)="new") then								
			datos = "'" & Request.Form("RIN_RespuestaIncumplimiento")(i) & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"			
			
			sql="exec [spRespuestaIncumplimiento_Agregar]  " & datos
			set rs = cnn.Execute(sql)			
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description			
				cnn.close 			   
				response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
				response.End()
			End If
			if not rs.eof then
				RIN_Id = rs("RIN_Id")
			end if
						
			datos =	RIN_Id & "," & Request.Form("IPR_Id")(i) & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"			
			sql="exec [spRespuestaMultaIncumplimiento_Agregar]  " & datos 			
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
			datos = Request.Form("Id")(i) & ",'" & Request.Form("RIN_RespuestaIncumplimiento")(i) & "',1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
			
			sql="exec [spRespuestaIncumplimiento_Modificar]  " & datos 			
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