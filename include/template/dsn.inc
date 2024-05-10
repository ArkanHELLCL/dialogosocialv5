<%
'--------------------------------------------------------------------
' Archivo de Conexion a Base de Datos  DSN.INC
'
'--------------------------------------------------------------------
'---- Servidor ?----
'---- Base de Datos WorkFlow----

Const DSN_DialogoSocialv5 = "Provider=SQLNCLI11;Trusted_Connection=yes;DATABASE=DialogoSocial;Server=REDBULL-SRV\SQLDES;"
'Const DSN_DialogoSocialv5 = "Provider=SQLNCLI11;Trusted_Connection=yes;DATABASE=DialogoSocial;Server=KENOBI-SRV;"
session("DSN_DialogoSocialv5") = DSN_DialogoSocialv5
%>
