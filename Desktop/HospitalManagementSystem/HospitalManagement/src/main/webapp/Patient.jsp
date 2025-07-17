<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String firstName = "";

    if(username == null) {
        response.sendRedirect("Login.jsp");
        return;
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            String sql = "SELECT s.first_name FROM User u JOIN Staff s ON u.staff_id = s.staff_id WHERE u.username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                firstName = rs.getString("first_name");
            }

            rs.close();
            ps.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Patient Information</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            color: #333;
        }

        header {
            background-color: #0f8b8d;
            padding: 20px 0;
            text-align: center;
            color: white;
        }

        header h2 {
            margin: 0;
            font-size: 32px;
        }
        
        .top-right {
            text-align: right;
            padding: 10px 20px;
            font-size: 18px;
        }

        nav {
            display: flex;
            justify-content: center;
            background-color: #0f8b8d;
        }

        nav a {
            text-decoration: none;
            color: white;
            font-size: 20px;
            padding: 14px 25px;
            display: inline-block;
            transition: background-color 0.3s;
        }

        nav a:hover {
            background-color: #136c72;
        }

        .add-btn {
            display: inline-block;
            margin: 10px auto;
            padding: 10px 20px;
            background-color: #0f8b8d;
            color: white;
            text-decoration: none;
            font-size: 18px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .add-btn:hover {
            background-color: #136c72;
        }

        .action-btn {
            display: inline-block;
            padding: 5px 10px;
            background-color: #0f8b8d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .action-btn:hover {
            background-color: #136c72;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        th {
            background-color: #0f8b8d;
            color: white;
            font-size: 18px;
        }

        tr:nth-child(even) {
            background-color: #f2f9f9;
        }

        tr:hover {
            background-color: #d0efef;
        }

        td {
            font-size: 16px;
        }

        main {
            text-align: center;
            margin-top: 20px;
        }

        main p {
            font-size: 20px;
        }
    </style>
</head>
<body>
    <div class="top-right">
        Welcome <%= firstName %>
    </div>
<header>
    <h2>WELCOME TO SARVESH'S HOSPITAL</h2>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="ViewAppointments.jsp">Appointments</a>
    <a href="ViewEHR.jsp">EHR</a>
    <a href="Inventory.jsp">Inventory</a>
    <a href="Staff.jsp">Staff</a>
    <a href="Logout">Logout</a>
</nav>

<div style="text-align: center;">
    <a href="AddPatient.jsp" class="add-btn">Add Patient</a>
</div>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

    String qry="select * from Patient";
    Statement st=con.createStatement();
    ResultSet rs=st.executeQuery(qry);
    
    boolean hasRecords = false;
%>

<table>
    <tr>
        <th>ID</th>
        <th>FIRST NAME</th>
        <th>LAST NAME</th>
        <th>DATE OF BIRTH</th>
        <th>GENDER</th>
        <th>PHONE</th>
        <th>EMAIL</th>
        <th>ADDRESS</th>
        <th>EMERGENCY CONTACT</th>
        <th>DATE REGISTERED</th>
        <th>UPDATE</th>
        <th>ADD APPOINTMENT</th>
    </tr>

   <%
        while(rs.next()) {
            hasRecords = true;
            String patientId = rs.getString("patient_id");
   %>
    <tr>
        <td><%= patientId %></td>
        <td><%= rs.getString("first_name") %></td>
        <td><%= rs.getString("last_name") %></td>
        <td><%= rs.getString("date_of_birth") %></td>
        <td><%= rs.getString("gender") %></td>
        <td><%= rs.getString("phone") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("address") %></td>
        <td><%= rs.getString("emergency_contact") %></td>
        <td><%= rs.getString("date_registered") %></td>
        <td>
            <a class="action-btn" href="UpdatePatient.jsp?patient_id=<%= patientId %>">Update</a>
        </td>
        <td>
            <a class="action-btn" href="Appointment.jsp?patient_id=<%= patientId %>">Add Appointment</a>
        </td>
    </tr>
    <% } %>

    <% if (!hasRecords) { %>
    <tr>
        <td class="no-records" colspan="13">No Patient records found.</td>
    </tr>
    <% } %>
</table>

<main>
    <p>Your health is our priority. Navigate using the menu above.</p>
</main>

</body>
</html>
