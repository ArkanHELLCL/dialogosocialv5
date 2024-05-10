<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")	
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") then
		modo=4
		mode="vis"
	end if		
		
	REL_Rut = request("REL_Rut")	
	REL_Rut = replace(replace(REL_Rut,"-",""),".","")		
	
	if(REL_Rut="") then
		REL_Rut="0"
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
	
	sql="[spRelatorxRUT_Consultar] '" & REL_Rut & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRelatorxRUT_Consultar : " & sql)
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataRelator = "{""data"":["
	do While Not rs.EOF
		REL_AdjuntoX=""		
				
		dataRelator = dataRelator & "[""" & rs("REL_Rut") & """,""" & rs("REL_Nombres") & """,""" & rs("REL_Paterno") & """,""" & rs("REL_Materno") & """,""" & rs("EDU_Id") & """,""" & REL_AdjuntoX & """,""" & rs("REL_Estado") & """,""" & rs("REL_NombreCarrera") & """,""" & rs("REL_Id") & """]"

		rs.movenext
		if not rs.eof then
			dataRelator = dataRelator & ","
		end if
	loop
	dataRelator=dataRelator & "]}"
	
	response.write(dataRelator)
%>