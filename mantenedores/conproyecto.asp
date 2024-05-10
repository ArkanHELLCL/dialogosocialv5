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
		
	PRY_Id=request("PRY_Id")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if
	
	sql="spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
	    {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataProyecto = "{""data"":["
	if(rs.eof) then
		dataProyecto=dataProyecto & "],""state"":100,""message"":""Proyecto no existe en la base de datos.""}"
	else
		do While Not rs.EOF		
			dataProyecto = dataProyecto & "[""" & rs("PRY_Id") & """,""" & rs("PRY_Nombre") & """,""" & rs("PRY_Estado") & """]"
			rs.movenext
			if not rs.eof then
				dataProyecto = dataProyecto & ","
			end if
		loop	
		dataProyecto=dataProyecto & "],""state"":200}"
	end if
	
	response.write(dataProyecto)
%>