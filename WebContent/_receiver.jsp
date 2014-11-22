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
	ProcessEngine processEngine = Configuration.getProcessEngine(); //获取jbpm流程引擎
	TaskService taskService = processEngine.getTaskService(); //获取有关任务的方法
	
	
	String action = null; //action字段
	String tId = null;//Id字段
	if((action = request.getParameter("action")) != null){//如果url携带action字段
		tId = request.getParameter("id");//得到任务id
		if("pass".equals(action)){//如果是action是pass，下一节点
			taskService.completeTask(tId,"to ifReceiverPay");
		}else if("back".equals(action)){//如果action是back，回驳
			taskService.completeTask(tId,"back send");
		}
		response.sendRedirect("_receiver.jsp");
	}
	
	List<Task> taskList = taskService.findPersonalTasks("receiver");//打印任务详细列表，提供确认和驳回操作
	
%>
<h1 class="col-md-offset-1">welcome receiver</h1>
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
			<td colspan="2">Operation</td>
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
	      <td><a href="_receiver.jsp?action=pass&id=<%=task.getId() %>">i received</a></td>
	      <td><a href="_receiver.jsp?action=back&id=<%=task.getId() %>">i haven't received</a></td>
	    </tr>
<%
	}
%>
</table>
</body>
</html>