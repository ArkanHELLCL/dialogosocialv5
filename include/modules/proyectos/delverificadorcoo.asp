<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if	
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	COO_Id				= request("COO_Id")	
    COO_Tipo            = request("COO_Tipo")	
			
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	'Rescatando carpeta del proyecto
	sql="exec spProyectoCarpeta_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if len(COO_Id)>1 then
			yCOO_Id=""
			for i=0 to len(COO_Id)
				if(isnumeric(mid(COO_Id,i,1))) then
					yCOO_Id=yCOO_Id & mid(COO_Id,i,1)
				end if
			next
		else
			yCOO_Id=cint(COO_Id)
		end if
        subcarpeta=""
        if(COO_Tipo="TRA") then
            sp="spCoordinacionTrabajadores_Borrar"            
            subcarpeta="\verificadorcoordactorestra\t-"
        else
            if(COO_Tipo="EMP") then
                sp="spCoordinacionEmpleadores_Borrar"                
                subcarpeta="\verificadorcoordactoresemp\e-"
            else                
                if(rs("COO_Tipo")="GOB") then
                    sp="spCoordinacionGobierno_Borrar"
                    subcarpeta="\verificadorcoordactoresgob\g-"
                end if                
            end if
        end if                        
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & subcarpeta & yCOO_Id		
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
	
	'Cambiando a estado eliminado
	sql="exec " & sp & " " & PRY_Id & "," & COO_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f
	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	fs.DeleteFolder path

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe
	'response.end()%>	
	{"state": 200, "message": "Eliminación de carpeta correcta","data": null}	