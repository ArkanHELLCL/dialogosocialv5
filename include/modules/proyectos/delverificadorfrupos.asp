<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if	
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	GRP_Id				= request("GRP_Id")	
    GRP_Tipo            = request("GRP_Tipo")	
			
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
		if len(GRP_Id)>1 then
			yGRP_Id=""
			for i=0 to len(GRP_Id)
				if(isnumeric(mid(GRP_Id,i,1))) then
					yGRP_Id=yGRP_Id & mid(GRP_Id,i,1)
				end if
			next
		else
			yGRP_Id=cint(GRP_Id)
		end if
        subcarpeta=""
        if(GRP_Tipo="SIN") then
            sp="spPrioridadSindicato_Borrar"            
            subcarpeta="\verificadorsindicatogrp\s-"
        else
            if(GRP_Tipo="EMP") then
                sp="spPrioridadEmpresa_Borrar"                
                subcarpeta="\verificadorempresagrp\e-"
            else                
                if(rs("GRP_Tipo")="GOB") then
                    sp="spPrioridadGobierno_Borrar"
                    subcarpeta="\verificadorgobiernogrp\g-"
                end if                
            end if
        end if                        
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & subcarpeta & yGRP_Id		
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
	
	'Cambiando a estado eliminado
	sql="exec " & sp & " " & PRY_Id & "," & GRP_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
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