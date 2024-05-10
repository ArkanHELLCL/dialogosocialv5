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
	
	PRY_Id = Request("PRY_Id")
	Rut = replace(Request("ALU_Rut"),"-","")
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
	
	sqy="spProyectosxAlumno_Listar " & ALU_Rut
	set ry = cnn.Execute(sqy)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		cnn.close 		
		response.end
	End If
	
	contPRY=0
	do While Not ry.EOF		
		contPRY=contPRY+1
		ry.movenext
	loop
		
	'Eliminar asociacion del proyecto
	sqx="[spBeneficiarioProyecto_Eliminar] " & ALU_Rut & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rx = cnn.Execute(sqx)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		cnn.close 		
		response.end
	End If
	contPRY=contPRY-1%>
	{"state": 200, "message": "Asociación al proyecto eliminada exitosamente","data": null,"contPRY":<%=contPRY%>}<%
%>