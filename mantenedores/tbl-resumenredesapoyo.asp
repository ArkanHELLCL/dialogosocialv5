<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3) then	'Ejecutor no puede ejecutar reportes		
	   response.Write("403/@/Perfil no autorizado")
	   response.End() 			   	
	end if		
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	set rs = cnn.Execute("exec spInformeMesasRedesApoyo_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spInformeMesasRedesApoyo_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataResumenRedesApoyo = "{""data"":["
	
	do While Not rs.EOF
		if cont>0 then
			dataResumenRedesApoyo = dataResumenRedesApoyo & ","
		end if

		dataResumenRedesApoyo = dataResumenRedesApoyo & "[""" & rs("PRY_Id") & """,""" & rs("EME_Nombre") & """,""" & rs("EME_Rol") & """,""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("REG_Id") & """,""" & rs("REG_Nombre") & """,""" & rs("PRY_Nombre") & """,""" & rs("PRY_MontoAdjudicado") & """,""" & rs("NumOrgSindicales") & """,""" & rs("NumOrgEmpresariales") & """,""" & rs("NumOrgGubernamentales") & """]"

		rs.movenext			
		cont=cont+1	
	loop
	dataResumenRedesApoyo=dataResumenRedesApoyo & "]}"
	
	response.write(dataResumenRedesApoyo)
%>