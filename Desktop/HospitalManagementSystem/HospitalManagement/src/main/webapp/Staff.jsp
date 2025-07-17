<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in and is Admin
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("Admin")) {
%>
    <h2 style="color:red; text-align:center; margin-top:50px;">Access Denied: You are not authorized to view this page.</h2>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff List</title>
    <style>
        body {
            font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            margin:0;
        }
        h2 {
            text-align:center;
            color:#0f8b8d;
            margin-top:20px;
        }
        .add-btn {
            display:inline-block;  
            width:150px;
            margin:10px 10px;     
            padding:10px 20px;
            background-color:#0f8b8d;
            color:white;
            text-align:center;
            text-decoration:none;
            border-radius:5px;
            font-size:16px;
}

        .add-btn:hover {
            background-color:#136c72;
        }
        table {
            width:90%;
            margin:20px auto;
            border-collapse:collapse;
            background:#fff;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
            border-radius:8px;
            overflow:hidden;
        }
        th, td {
            padding:10px;
            text-align:center;
            font-size:14px;
        }
        th {
            background-color:#0f8b8d;
            color:white;
            font-size:16px;
        }
        tr:nth-child(even) {background:#f2f9f9;}
        tr:hover {background:#d0efef;}
        .action-btn {
            padding:5px 10px;
            margin:2px;
            background-color:#0f8b8d;
            color:white;
            text-decoration:none;
            border-radius:4px;
            font-size:13px;
        }
        .action-btn:hover { background-color:#136c72; }
        
        .btn-container {
    text-align:center;
    margin-top:10px;
}

    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>
<h2>Staff List</h2>

<div class="btn-container">
    <a class="add-btn" href="AddStaff.jsp">Add Staff</a>
    <a class="add-btn" href="ViewShifts.jsp">All Shifts</a>
</div>


<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

        String sql = "SELECT * FROM Staff";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);

        boolean hasRecords = false;
%>
<table>
    <tr>
        <th>ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Role</th>
        <th>Specialization</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Hire Date</th>
        <th>Salary</th>
        <th>Actions</th>
    </tr>
<%
    while(rs.next()) {
        hasRecords = true;
%>
    <tr>
        <td><%= rs.getInt("staff_id") %></td>
        <td><%= rs.getString("first_name") %></td>
        <td><%= rs.getString("last_name") %></td>
        <td><%= rs.getString("role") %></td>
        <td><%= rs.getString("specialization") %></td>
        <td><%= rs.getString("phone") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getDate("hire_date") %></td>
        <td><%= rs.getBigDecimal("salary") %></td>
        <td>
            <a class="action-btn" href="UpdateStaff.jsp?staff_id=<%= rs.getInt("staff_id") %>">Update</a>
            <a class="action-btn" href="UpdateUser.jsp?staff_id=<%= rs.getInt("staff_id") %>">Change Credentials</a>
            <a class="action-btn" href="StaffShift.jsp?staff_id=<%= rs.getInt("staff_id") %>">Shift</a>
        </td>
    </tr>
<% } %>
<% if(!hasRecords) { %>
    <tr><td colspan="10">No staff records found.</td></tr>
<% } %>
</table>
<%
    rs.close();
    st.close();
    con.close();
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
