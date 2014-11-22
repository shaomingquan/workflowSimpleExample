<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.util.*,org.jbpm.api.*,org.jbpm.api.task.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css"  href="./bs/bootstrap.min.css"/><!-- 引入样式表 -->
<title>Insert title here</title>
</head>
<body>
<div class="row">
	<h1 class="col-md-offset-3"><b>you will send a good</b></h1>
</div>
<div class="row">
	<h3 style="color:gray" class="col-md-offset-3">your goods' states</h3>
</div>
<div class="row">
<dl class="dl-horizontal col-md-offset-3">
<%
	
	ProcessEngine processEngine = Configuration.getProcessEngine(); //获取jbpm流程引擎
	RepositoryService repositoryService = processEngine.getRepositoryService();//获取管理发布资源的所有方法
	ExecutionService executionService = processEngine.getExecutionService();//获取流程执行的所有方法
	TaskService taskService = processEngine.getTaskService();//获取有关任务的方法
	
	if(request.getParameter("good")!=null){//如果有请求发生
		
		NewDeployment d1 = repositoryService.createDeployment().addResourceFromClasspath("sunfeng.jpdl.xml");//用流程定义文件构建一个新的流程
		d1.deploy();//发布这个流程
		//下面同时启动这个流程
		List<ProcessDefinition> l = repositoryService.createProcessDefinitionQuery().list();//获取刚刚发布的流程
		String id = l.get(0).getId();//得到它的id
		ExecutionService executionService1 = processEngine.getExecutionService();
		//将信息放入一个map中
		Map map = new HashMap();
		map.put("owner", request.getParameter("owner"));
		map.put("addr", request.getParameter("addr"));
		map.put("payer", request.getParameter("payer"));
		map.put("tel", request.getParameter("tel"));
		map.put("good", request.getParameter("good"));

		executionService1.startProcessInstanceById(id, map);//启动流程，并且携带数据

		//得到当前任务并完成任务，任务根据decision的expression进入下一节点
		List<Task> taskList = taskService.findPersonalTasks("sender");
		String tId = taskList.get(taskList.size() - 1).getId();
		
		taskService.completeTask(tId);
	}
	
	//打印任务执行状态
	List<ProcessInstance> piList = executionService.createProcessInstanceQuery().list();
	for(ProcessInstance pd : piList){
%>
<dt>
ID.<%=pd.getId() %>
</dt>
<dd>
<%=pd.findActiveActivityNames() %>&nbsp;&nbsp;
<%=pd.getState() %>
</dd>
<% } %>
</dl>
</div>
<div class="row">
	<h3 style="color:gray" class="col-md-offset-3">fill the list add start</h3>
</div>
<!-- 表单 -->
<form class="form-horizontal" role="form" method="post">
  <div class="form-group">
    <label for="good" class="col-sm-3 control-label">good</label>
    <div class="col-sm-6">
      <input name="good" class="form-control" id="good" placeholder="good">
    </div>
  </div>
  <div class="form-group">
    <label for="tel" class="col-sm-3 control-label">tel</label>
    <div class="col-sm-6">
      <input name="tel" class="form-control" id="tel" placeholder="telephone">
    </div>
  </div>
  <div class="form-group">
    <label for="owner" class="col-sm-3 control-label">owner</label>
    <div class="col-sm-6">
      <input name="owner" class="form-control" id="owner" placeholder="owner">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-6">
      <label class="radio-inline">
  		<input type="radio" name="addr" value="out">outside province
	  </label>
	  <label class="radio-inline">
	    <input type="radio" name="addr" value="in">inside province
      </label>
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-6">
      <label class="radio-inline">
  		<input type="radio" name="payer" value="sender">sender pay
	  </label>
	  <label class="radio-inline">
	    <input type="radio" name="payer" value="receiver">receiver pay
      </label>
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-10">
      <button type="submit" class="btn btn-default">start</button>
    </div>
  </div>
</form>
</body>
</html>