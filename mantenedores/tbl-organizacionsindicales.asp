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
	
	set rs = cnn.Execute("exec spInformeMesasSindicales_Listar")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spInformeMesasSindicales_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataOrganizacionesSindicales = "{""data"":["
	
	Rep=""
	x=0
	NumRepresentantes=1
	do While Not rs.EOF
		x=x+1		
		
		NumRepresentantes	 = rs("NumRepresentantes")
		NumMaxRepresentante = rs("NumMaxRepresentante")
				
		if(x <= NumRepresentantes) then
			Rep=Rep & """,""" & rs("NombreRepresentante")
			if(x = NumRepresentantes) then
				for i=1 to (NumMaxRepresentante-x)
					Rep=Rep & """,""" & "-"
				next
				x = 0
				'response.write(Rep & """" & "<br>")
				if cont>0 then
					dataOrganizacionesSindicales = dataOrganizacionesSindicales & ","
				end if
				dataOrganizacionesSindicales = dataOrganizacionesSindicales & "[""" & rs("PRY_Id") & """,""" & rs("PRY_EmpresaEjecutora") & """,""" & rs("LFO_Id") & """,""" & rs("LFO_Nombre") & """,""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & rs("REG_Id") & """,""" & rs("REG_Nombre") & """,""" & rs("PRY_Nombre") & """,""" & rs("SIN_Id") & """,""" & rs("SIN_Nombre") & """,""" & rs("ACE_Id") & """,""" & rs("ACE_Nombre") & """,""" & rs("TOR_Id") & """,""" & rs("TOR_Nombre") & """,""" & rs("RUB_Id") & """,""" & rs("RUB_Nombre") & """,""" & rs("RSU") & """,""" & rs("SIN_Mail") & """,""" & rs("SIN_Telefono") & """,""" & rs("NumRepresentantes") & Rep & """]"
				
				Rep=""
				cont=cont+1	
			end if
		end if
		
		rs.movenext			
		
	loop
	dataOrganizacionesSindicales=dataOrganizacionesSindicales & "]}"
	
	
	response.write(dataOrganizacionesSindicales)
%>