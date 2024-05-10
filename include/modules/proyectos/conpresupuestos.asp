<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PRE_Id=request("PRE_Id")
	mode=request("mode")
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
		
	set rs=cnn.execute("spPresupuesto_Consultar " & PRE_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataPresupuestos = "{""data"":["
	portot=0
	portotcan=0
	do While Not rs.EOF		
		dataPresupuestos = dataPresupuestos  & "[""" & rs("PRE_Id") & """,""" & rs("PRE_NumCuota") & """,""" & rs("PRE_PorcentajeMonto") & """,""" & rs("PRE_MontoCuota") & """,""" & rs("PRE_EstadoCuota") & """,""" & rs("PRE_MontoFactura") & """,""" & rs("PRE_FechaFactura") & """,""" & rs("PRE_NumFactura") & """,""" & rs("PRE_FechaPagoCuota") & """,""" & rs("PRE_FechaVenCuota") & """,""" & rs("PRE_GlosaFactura") & """]"
				
		rs.movenext
		if not rs.eof then
			dataPresupuestos = dataPresupuestos & ","
		end if
	loop
	dataPresupuestos=dataPresupuestos & "]}"
	rs.close
	
	response.write(dataPresupuestos)
%>