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
	REL_Id = Request("REL_Id")
	TRE_Id = Request("TRE_Id")
	
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
	if not rs.eof then
		if(rs("PRY_Estado")<>1) then%>
			{"state": 110, "message": "Proyecto debe estar en estado activo","data": null}<%
			response.end
		else
			'Identifiando si tiene otros proyectos asociados
			sqy="[spRelatorProyecto_Listar] " & REL_Id
			set ry = cnn.Execute(sqy)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description%>
	    		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
				cnn.close 		
				response.end
			End If
			Proyecto=false
			contPRY=0
			do While Not ry.EOF		
				if(rs("PRY_Id")=ry("PRY_Id")) then
					Proyecto=true				
				end if
				contPRY=contPRY+1
				ry.movenext
			loop
			if(Proyecto) then%>
				{"state": 100, "message": "El reletor ya esta asociado a este proyecto","data": null}<%
				response.end
			else
				'Agregar asociacion del proyecto
				sqx="[spRelatorProyecto_Agregar] " & REL_Id & "," & PRY_Id & "," & TRE_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				set rx = cnn.Execute(sqx)
				on error resume next
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description%>
	    			{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
					cnn.close 		
					response.end
				End If
				contPRY=contPRY+1
			end if
		end if
	else%>
		{"state": 100, "message": "Proyecto seleccionado no existe","data": null}<%
		response.end
	end if%>
	{"state": 200, "message": "Asociación al proyecto exitosa","data": null,"contPRY":<%=contPRY%>}<%
%>