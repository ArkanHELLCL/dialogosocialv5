<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<!-- #INCLUDE FILE="include\template\functions.inc" -->
<%					
	LFO_Id = request("LFO_Id")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
    cnn.open session("DSN_DialogoSocialv5")
	
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	if isEmpty(session("ds5_usrid")) or isNull(session("ds5_usrid")) then
		response.Write("500//Error Parámetros no válidos")
		response.end()
	end if				
	
	response.write("200//")%>
	<select name="LIN_Id-<%=LFO_Id%>" id="LIN_Id-<%=LFO_Id%>" class="validate select-text form-control" required>
		<option value="" disabled selected></option><%
		set rs = cnn.Execute("exec spLinea_Listar " & LFO_Id & ", 1")
		on error resume next					
		do While Not rs.eof%>
			<option value="<%=rs("LIN_Id")%>"><%=rs("LIN_Nombre")%></option><%			
			rs.movenext						
		loop
		rs.Close	
		cnn.Close%>
	</select>
	<i class="fas fa-user input-prefix"></i>
	<span class="select-highlight"></span>
	<span class="select-bar"></span>
	<label class="select-label">Linea</label>
