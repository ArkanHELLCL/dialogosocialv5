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
	
	set rs = cnn.Execute("exec spTipoTrabajador_Listar -1") 'todos
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spTipoTrabajador_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataTrabajador = "{""data"":["
	
	do While Not rs.EOF
		if cont>0 then
			dataTrabajador = dataTrabajador & ","
		end if

		dataTrabajador = dataTrabajador & "[""" & rs("TTR_Id") & """,""" & rs("TTR_Nombre") & """]"

		rs.movenext			
		cont=cont+1	
	loop
	dataTrabajador=dataTrabajador & "]}"
	
	response.write(dataTrabajador)
%>