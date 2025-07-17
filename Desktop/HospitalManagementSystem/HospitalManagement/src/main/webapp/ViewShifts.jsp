<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Staff Shifts</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            margin:0;
        }
        h2 {
            text-align:center;
            color:#0f8b8d;
            margin-top:20px;
        }
        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background:#fff;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
            border-radius:8px;
            overflow:hidden;
        }
        th, td {
            padding:10px;
            text-align:center;
            font-size:13px;
        }
        th {
            background-color:#0f8b8d;
            color:white;
            font-size:14px;
        }
        tr:nth-child(even) { background:#f2f9f9; }
        tr:hover { background:#d0efef; }
        .back-btn {
            display: block;
            width: 160px;
            margin: 10px auto;
            padding: 10px 20px;
            background-color: #0f8b8d;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            font-size: 15px;
        }
        .back-btn:hover { background-color: #136c72; }
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>

<h2>All Staff Shifts</h2>

<a class="back-btn" href="Staff.jsp">Back to Staff List</a>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

        String sql = "SELECT s.staff_id, s.first_name, s.last_name, s.role, s.specialization, " +
                     "s.phone, s.email, s.hire_date, s.salary, sc.shift " +
                     "FROM Staff s LEFT JOIN StaffSchedule sc ON s.staff_id = sc.staff_id";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);

        boolean hasRecords = false;
%>

<table>
    <tr>
        <th>Staff ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Role</th>
        <th>Specialization</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Hire Date</th>
        <th>Salary</th>
        <th>Shift</th>
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
        <td><%= rs.getString("specialization") != null ? rs.getString("specialization") : "-" %></td>
        <td><%= rs.getString("phone") != null ? rs.getString("phone") : "-" %></td>
        <td><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
        <td><%= rs.getDate("hire_date") %></td>
        <td><%= rs.getBigDecimal("salary") %></td>
        <td><%= rs.getString("shift") != null ? rs.getString("shift") : "Not Assigned" %></td>
    </tr>
<% } %>
<% if(!hasRecords) { %>
    <tr><td colspan="10">No staff shift records found.</td></tr>
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
