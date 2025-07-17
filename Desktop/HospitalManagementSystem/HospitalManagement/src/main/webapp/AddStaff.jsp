<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String message="";
    boolean isPost="POST".equalsIgnoreCase(request.getMethod());
    if(isPost){
        String first_name=request.getParameter("first_name");
        String last_name=request.getParameter("last_name");
        String role=request.getParameter("role");
        String specialization=request.getParameter("specialization");
        String phone=request.getParameter("phone");
        String email=request.getParameter("email");
        String hire_date=request.getParameter("hire_date");
        String salary=request.getParameter("salary");

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");
            String sql="INSERT INTO Staff(first_name,last_name,role,specialization,phone,email,hire_date,salary) VALUES(?,?,?,?,?,?,?,?)";
            PreparedStatement ps=con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
            ps.setString(1,first_name); ps.setString(2,last_name); ps.setString(3,role);
            ps.setString(4,specialization); ps.setString(5,phone); ps.setString(6,email);
            ps.setString(7,hire_date); ps.setBigDecimal(8,new java.math.BigDecimal(salary));
            int inserted=ps.executeUpdate();
            if(inserted>0){
                ResultSet keys=ps.getGeneratedKeys();
                if(keys.next()){
                    int newStaffId=keys.getInt(1);
                    response.sendRedirect("AddUser.jsp?staff_id="+newStaffId);
                    return;
                }
            } else { message="Failed to insert staff."; }
            ps.close(); con.close();
        }catch(Exception e){ e.printStackTrace(); message="Error: "+e.getMessage(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
<title>Add Staff</title>
<style>
    body{ font-family:Segoe UI; background:linear-gradient(135deg,#d9f1ff,#f0fff4);}
    .form-box{width:400px; margin:30px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.2);}
    h2{text-align:center; color:#0f8b8d;}
    label{display:block; margin:10px 0 5px;}
    input,select{width:100%; padding:8px; border:1px solid #ccc; border-radius:4px;}
    button{width:100%; background:#0f8b8d; color:white; padding:10px; margin-top:10px; border:none; border-radius:4px;}
    button:hover{background:#136c72;}
    .message{color:red; text-align:center;}
</style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
<div class="form-box">
<h2>Add Staff</h2>
<% if(!message.isEmpty()){ %><div class="message"><%=message%></div><% } %>
<form method="post">
    <label>First Name:</label><input name="first_name" required>
    <label>Last Name:</label><input name="last_name" required>
    <label>Role:</label>
    <select name="role" required>
        <option>Doctor</option><option>Nurse</option><option>Receptionist</option><option>Admin</option><option>Pharmacist</option><option>Lab Technician</option>
    </select>
    <label>Specialization:</label><input name="specialization">
    <label>Phone:</label><input name="phone">
    <label>Email:</label><input name="email">
    <label>Hire Date:</label><input type="date" name="hire_date" required>
    <label>Salary:</label><input name="salary" required>
    <button type="submit">Next</button>
</form>
</div>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
