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
	
	set rs = cnn.Execute("exec spCiviles_Listar -1") 'todos
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spCiviles_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataCiviles = "{""data"":["
	
	do While Not rs.EOF
		if cont>0 then
			dataCiviles = dataCiviles & ","
		end if

		dataCiviles = dataCiviles & "[""" & rs("CIV_Id") & """,""" & rs("CIV_Nombre") & """,""" & rs("CIV_Rol") & """,""" & rs("RUB_Nombre") & """]"

		rs.movenext			
		cont=cont+1	
	loop
	dataCiviles=dataCiviles & "]}"
	
	response.write(dataCiviles)
%>