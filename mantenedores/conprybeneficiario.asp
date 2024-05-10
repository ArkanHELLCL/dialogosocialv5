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
		
	Rut = replace(request("ALU_Rut"),"-","")
	if(Rut<>"" and not IsNull(Rut)) then
		ALU_Rut = mid(Rut,1,len(Rut)-1)
	else
		ALU_Rut = 0
	end if
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if
	
	sql="spProyectosxAlumno_Listar " & ALU_Rut
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
	    {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		cnn.close 		
		response.end
	End If	
	cont=1	
	
	dataBenPry = "{""data"":["
	do While Not rs.EOF		
		set ry = cnn.Execute("exec spEstadosAlumnoProyecto_Listar " & rs("ALU_Rut") & "," & rs("PRY_Id"))
		on error resume next
		if cnn.Errors.Count > 0 then 
			ErrMsg = cnn.Errors(0).description
			'response.write("Error AlumnoProyecto")			
		End If
		Acciones ="<i class='fas fa-trash-alt text-danger delpryben' style='cursor:pointer' data-pry='" & rs("PRY_Id") & "' title='Elimina alumno de este proyecto'></i>"
		dataBenPry = dataBenPry & "[""" & rs("PRY_Id") & """,""" & rs("PRY_Nombre") & """,""" & Acciones & """]"
		rs.movenext
		if not rs.eof then
			dataBenPry = dataBenPry & ","
		end if
	loop
	dataBenPry=dataBenPry & "],""state"":200}"
	
	response.write(dataBenPry)
%>