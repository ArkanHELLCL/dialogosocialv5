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
		
	set rs = cnn.Execute("exec spEmpresa_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spEmpresa_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataEmpresas = "{""data"":["
	do While Not rs.EOF								
		dataEmpresas = dataEmpresas & "[""" & rs("EMP_Id") & """,""" & rs("EMP_Rol") & """,""" & rs("EMP_Nombre") & """,""" & rs("RUB_Nombre") & """,""" & rs("EMP_NumTrabajadores") & """,""" & rs("EMP_NumHombres") & """,""" & rs("EMP_NumMujeres") & """]"
		
		rs.movenext
		if not rs.eof then
			dataEmpresas = dataEmpresas & ","
		end if
	loop
	dataEmpresas=dataEmpresas & "]}"
	
	response.write(dataEmpresas )
%>