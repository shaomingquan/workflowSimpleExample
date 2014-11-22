<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.util.*,org.jbpm.api.*,org.jbpm.api.task.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css"  href="./bs/bootstrap.min.css"/>
<title>Insert title here</title>
</head>

<body>
<% 
	ProcessEngine processEngine = Configuration.getProcessEngine();
	TaskService taskService = processEngine.getTaskService();
	
	String action = null;
	String tId = null;
	//工作人员模式，提供pass功能表示他的任务结束，进入下一阶段
	if((action = request.getParameter("action")) != null){
		tId = request.getParameter("id");
		taskService.completeTask(tId);
		response.sendRedirect("customService.jsp");
	}
	
	List<Task> taskList = taskService.findPersonalTasks("customService");//打印任务列表以及详细信息，提供pass功能
	
%>
<h1 class="col-md-offset-1">welcome customSsrevice</h1>
<h2 color="gray" class="col-md-offset-3">do the follow check</h2>
<table class="table table-striped">
	<thead>
		<tr>
			<td>ID</td>
			<td>Name</td>
			<td>Good</td>
			<td>Tel</td>
			<td>Owner</td>
			<td>Addr</td>
			<td>Payer</td>
			<td>Operation</td>
		</tr>
	</thead>
	<tbody>
<%
	for (Task task : taskList) {
		tId = task.getId();
%>
	    <tr>
	      <td><%=tId %></td>
	      <td><%=task.getName() %></td>
	      <td><%=taskService.getVariable(tId, "good") %></td>
	      <td><%=taskService.getVariable(tId, "tel") %></td>
	      <td><%=taskService.getVariable(tId, "owner") %></td>
	      <td><%=taskService.getVariable(tId, "addr") %></td>
	      <td><%=taskService.getVariable(tId, "payer") %></td>
	      <td><a href="customService.jsp?action=pass&id=<%=task.getId() %>">finish user feedback</a></td>
	    </tr>
<%
	}
%>
</table>
</body>
</html>