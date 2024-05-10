<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then	'Ejecutor, Auditor
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							= request("PRY_Id")		
	TDG_Id							= request("TDG_Id")	
	DIN_NumDocumento				= request("DIN_NumDocumento")
	IPR_Id							= request("IPR_Id")
	Fecha							= request("FechaRec")
	DIN_AplicaDesestimaMulta		= request("DIN_AplicaDesestimaMultaRec")
	IPR_MontoAplicadoRec			= request("IPR_MontoAplicadoRec")
	
	if(IPR_MontoAplicadoRec="") then
		IPR_MontoAplicadoRec=0
	end if
	
	if(DIN_AplicaDesestimaMulta="") then
		DIN_AplicaDesestimaMultaRec=0
	else
		DIN_AplicaDesestimaMultaRec=1
	end if
	
	if(TDG_Id=1 or TDG_Id=7 or TDG_Id=8) then		
		DIN_FechaTotalTramitacion=""
	else
		DIN_FechaTotalTramitacion = Fecha		
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
	
	set rs = cnn.Execute("SELECT CONVERT(VARCHAR(10), getdate(),111) AS DATE;")
	on error resume next
	if Not rs.eof then
		DIN_FechaEnvio=replace(rs("date"),"/","-")
	end if
	
	datos = TDG_Id & ",2," & DIN_AplicaDesestimaMultaRec & ",'" & DIN_NumDocumento & "','" & DIN_FechaEnvio & "','" & DIN_FechaTotalTramitacion & "'," & IPR_MontoAplicadoRec & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec [spDocumentoIncumplimiento_Agregar]  " & datos
	set rs = cnn.Execute(sql)			
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
		response.End()
	End If
	if not rs.eof then
		DIN_Id = rs("DIN_Id")
	end if

	datos = DIN_Id & "," & IPR_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"		
	
	sql="exec [spDocumentoMultaIncumplimiento_Agregar]  " & datos 			
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