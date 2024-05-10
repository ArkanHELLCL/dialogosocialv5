<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	DIN_Id							= request("DIN_Id")		
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
	
	datos = DIN_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"			

	sql="exec [spDocumentoIncumplimiento_Eliminar]  " & datos
	set rs = cnn.Execute(sql)			
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
		response.End()
	End If		
	response.write("200\\")		
%>