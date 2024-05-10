<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PRY_Id	= request("PRY_Id")
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503/@/Error Conexión:" & ErrMsg)
		cnn.close
		response.End() 	
	End If
	if not rs.eof then
		LFO_Id=rs("LFO_Id")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
	end if
			
	set rs2 = cnn.Execute("exec [spDocumentoMultaIncumplimiento_Listar]  " & PRY_Id & ",1 ,-1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description		
		cnn.close 		
		response.end
	End If
		
	dataIncDocEmvios = "{""data"":["
	do while not rs2.eof
		if cont>=1 then
			dataIncDocEmvios = dataIncDocEmvios & ","				
		end if
		cont = cont + 1
		deldoc=" <i class='fas fa-trash text-danger deldocenv' data-din='" & rs2("DIN_Id") & "'></i>"
		
		if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=5) then			
			dataIncDocEmvios = dataIncDocEmvios & "[""" & rs2("IPR_Id") & """,""" & rs2("TDG_Nombre") & """,""" & rs2("DIN_NumDocumento") & """,""" & rs2("DIN_FechaEnvio") & """,""" & rs2("DMI_UsuarioEdit") & """,""" & deldoc & """]"
		else
			dataIncDocEmvios = dataIncDocEmvios & "[""" & rs2("IPR_Id") & """,""" & rs2("TDG_Nombre") & """,""" & rs2("DIN_NumDocumento") & """,""" & rs2("DIN_FechaEnvio") & """,""" & rs2("DMI_UsuarioEdit") & """]"
		end if
		
		
		rs2.movenext
	loop
	rs2.Close
	cnn.Close
	dataIncDocEmvios=dataIncDocEmvios & "]}"		
	
	response.write(dataIncDocEmvios)%>		