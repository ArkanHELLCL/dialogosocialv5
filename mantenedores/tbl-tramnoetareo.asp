<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
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
	
	set rs = cnn.Execute("exec [spTramoEtario_Listar] -1") 'todos
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spTramoEtario_Listar]")
		cnn.close 		
		response.end
	End If	
	cont=0
	dataEtareo = "{""data"":["
	
	do While Not rs.EOF
		if cont>0 then
			dataEtareo = dataEtareo & ","
		end if

		dataEtareo = dataEtareo & "[""" & rs("TRE_Id") & """,""" & rs("TRE_Descripcion") & """,""" & rs("TRE_EdadDesde") & """,""" & rs("TRE_EdadHasta") & """,""" & rs("TRE_Estado") & """]"

		rs.movenext			
		cont=cont+1	
	loop
	dataEtareo=dataEtareo & "]}"
	
	response.write(dataEtareo)
%>