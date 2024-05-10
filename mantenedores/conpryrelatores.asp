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
		
	REL_Id = request("REL_Id")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if
	
	sql="[spRelatorProyecto_Listar] " & REL_Id
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
	    {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataRelPry = "{""data"":["
	do While Not rs.EOF		
		Acciones ="<i class='fas fa-trash-alt text-danger delpryrel' style='cursor:pointer' data-pry='" & rs("PRY_Id") & "' data-id='" & rs("RLP_Id") & "' title='Elimina relator de este proyecto'></i>"
		dataRelPry = dataRelPry & "[""" & rs("PRY_Id") & """,""" & rs("PRY_Nombre") & """,""" & rs("TRE_Descripcion") & """,""" & Acciones & """]"
		rs.movenext
		if not rs.eof then
			dataRelPry = dataRelPry & ","
		end if
	loop
	dataRelPry=dataRelPry & "],""state"":200}"
	
	response.write(dataRelPry)
%>