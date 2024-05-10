<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec spModuloLinea_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spModuloLinea_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataModulos = "{""data"":["
	do While Not rs.EOF	
		if rs("TEM_Estado")=1 then
			estado = "Activado"
		else
			estado = "Desactivado"
		end if
		if rs("TEM_Id")<>"" then
			if(cont>0) then
				dataModulos = dataModulos & ","
			end if
			dataModulos = dataModulos & "[""" & rs("LIN_Id") & """,""" & rs("LIN_Nombre") & """,""" & rs("MOD_Id") & """,""" & rs("MOD_Nombre") & """,""" & rs("PER_Id") & """,""" & rs("PER_Nombre") & """,""" & rs("TEM_Id") & """,""" & rs("TEM_Nombre") & """,""" & rs("TEM_Horas") & """,""" & estado & """]"
		end if
		rs.movenext
		cont=cont+1
	loop
	dataModulos=dataModulos & "]}"
	
	response.write(dataModulos)
%>