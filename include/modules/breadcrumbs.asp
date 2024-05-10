<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="session.min.inc" -->
<%=response.write("200/@/")%>
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

mnuarc=""
ruta_split = split(ruta,"/")
if(UBound(ruta_split)>=7) then
	PRY_Id=CInt(ruta_split(7))
	PRY_Hito=CInt(ruta_split(8))
	CRT_Step=CInt(ruta_split(9))
	'Proyectos nuevos totales
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs=cnn.execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.Write("503/@/Error Conexión:" & ErrMsg)		
		cnn.close 			   
		Response.end()
	End If
	if not rs.eof then
		LFO_Id=rs("LFO_Id")		
		mnuarc="/mnu-" & LFO_Id
	end if
end if

prynuevos=0
'Proyectos nuevos totales
sql="exec spUsuarioProyectoNuevo_Contar -1," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
set rs=cnn.execute(sql)
on error resume next
if cnn.Errors.Count > 0 then 
	ErrMsg = cnn.Errors(0).description
	 response.Write("503/@/Error Conexión:" & ErrMsg)			
	cnn.close 			   
	Response.end()
End If
if not rs.eof then
	prynuevos=rs("ProyectosNuevos")
end if

'response.write(mnuarc)
'response.write(ruta & "-" & PRY_Id & "-" & UBound(ruta_split))
xbread=replace(ruta,HostName,"")
recortaurl

xbread=mid(replace(xbread,"-"," "),2,len(xbread))

secciones = Split(xbread,"/")
largo = Ubound(secciones) + 1

menuBread = array("Bandeja de entrada","Bandeja otros proyectos","Bandeja de archivados","Bandeja administrativa","Bandeja ejecucion presupuestaria","Reportes","Mantenedores")
iconBread = array("<li data-url='/bandeja-de-entrada'><i class='fas fa-book'></i> Bandeja de entrada</li>","<li data-url='/bandeja-otros-proyectos'><i class='fas fa-book'></i> Bandeja otros proyectos</li>","<li data-url='/bandeja-de-archivados'><i class='fas fa-book'></i> Bandeja de archivados</li>","<li data-url='/bandeja-administrativa'><i class='fas fa-book'></i> Bandeja administrativa</li>","<li data-url='/bandeja-ejecucion-presupuestaria'><i class='fas fa-book'></i> Bandeja ejecución presupuestaria</li>","<li data-url='/reportes'><i class='fas fa-print'></i> Reportes</li>","<li data-url='/mantenedores'><i class='fas fa-server'></i> Mantenedores</li>")
perfBread = array("1,2,3,4","2","1,4","1,4,5","1,4,5","1,2,4,5","1,2,4")

largBread = 6

sub recortaurl	
	'Modificar
	pos2=InStr(xbread,"modificar")
	if (pos2>0 and not isnull(pos2)) then		
		xbread=mid(xbread,1,pos2+8)	
	else
		'Visualizar
		pos3=InStr(xbread,"visualizar")
		if (pos3>0 and not isnull(pos3)) then			
			xbread=mid(xbread,1,pos3+9)
		else
			'Agregar
			pos4=InStr(xbread,"agregar")
			if (pos4>0 and not isnull(pos4)) then
				xbread=mid(xbread,1,pos4+6)
			else

			end if
		end if 
	end if 				
end sub

%>
<div class="btn-toolbar" role="toolbar" style="float:left;" id="breadcrumbs">
	<nav aria-label="breadcrumb">
	  <ol class="breadcrumb"><%
	  	ismant=false
	  	for each x in secciones			
			cont=cont+1
			word = lcase(trim(x))
			word = replace(word,mid(word,1,1),ucase(mid(word,1,1)),1,1)
			if cont=2 then
				call menusistema(word,"")
			end if
			if cont>2 then%>
				<li class="breadcrumb-item active"></i> <%=word%></a></li><%
			end if
		next%>		
	  </ol>	  		
	</nav>
</div><%

function menusistema(word,active)%>
	<li class="breadcrumb-item sistema <%=active%>">
		<a href="#" data-url="/<%=replace(LCase(word)," ","-")%>"> <%=word%>
			<div class="content-sistema">
				<ul class="menusistema"><%
					for i=0 to largBread
						if(word<>menuBread(i)) then
							perfiles=Split(perfBread(i),",")							
							allowed=false
							for j=0 to UBound(perfiles)								
								if(CInt(perfiles(j))=session("ds5_usrperfil")) then
									allowed=true
									exit for
								end if
							next
							if(allowed) then
								response.write(iconBread(i))
							end if
						end if
					next%>					
				</ul>
			</div>		
		</a>
	</li><%
end function
%>