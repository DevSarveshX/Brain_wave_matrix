<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointments</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            color: #333;
        }

        .top-actions {
            text-align: center;
            margin-top: 20px;
        }

        .filter-btn {
            display: inline-block;
            padding: 8px 15px;
            background-color: #0f8b8d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 16px;
            margin: 5px;
            transition: background-color 0.3s;
        }

        .filter-btn:hover {
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

        .action-btn {
            display: inline-block;
            padding: 5px 10px;
            margin: 2px;
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

        h2 {
            text-align: center;
            color: #0f8b8d;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<jsp:include page="Header.jsp"></jsp:include>

<h2>Appointments</h2>

<div class="top-actions">
    <a class="filter-btn" href="ViewAppointments.jsp">Today's Appointments</a>
    <a class="filter-btn" href="ViewAppointments.jsp?show=all">Show All Appointments</a>
</div>

<%
    try {
        String show = request.getParameter("show");
        boolean showAll = "all".equals(show);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

        String sql;
        if(showAll) {
            sql = "SELECT a.appointment_id, a.patient_id, a.staff_id, a.appointment_date, a.reason, a.status, "
                + "p.first_name AS patient_first, p.last_name AS patient_last, "
                + "s.first_name AS staff_first, s.last_name AS staff_last "
                + "FROM Appointment a "
                + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                + "LEFT JOIN Staff s ON a.staff_id = s.staff_id";
        } else {
            sql = "SELECT a.appointment_id, a.patient_id, a.staff_id, a.appointment_date, a.reason, a.status, "
                + "p.first_name AS patient_first, p.last_name AS patient_last, "
                + "s.first_name AS staff_first, s.last_name AS staff_last "
                + "FROM Appointment a "
                + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                + "LEFT JOIN Staff s ON a.staff_id = s.staff_id "
                + "WHERE DATE(a.appointment_date) = CURDATE()";
        }

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);
%>

<table>
    <tr>
        <th>ID</th>
        <th>Patient</th>
        <th>Staff</th>
        <th>Date & Time</th>
        <th>Reason</th>
        <th>Status</th>
        <th colspan="<%= showAll ? "1" : "2" %>">Actions</th>
    </tr>

    <%
        boolean hasRecords = false;
        while(rs.next()) {
            hasRecords = true;
            String staffName = (rs.getString("staff_first") != null)
                    ? rs.getString("staff_first") + " " + rs.getString("staff_last")
                    : "Not Assigned";
    %>
    <tr>
        <td><%= rs.getInt("appointment_id") %></td>
        <td><%= rs.getString("patient_first") %> <%= rs.getString("patient_last") %></td>
        <td><%= staffName %></td>
        <td><%= rs.getString("appointment_date") %></td>
        <td><%= rs.getString("reason") %></td>
        <td><%= rs.getString("status") %></td>
        <td>
            <a class="action-btn" href="UpdateAppoitment.jsp?appointment_id=<%= rs.getInt("appointment_id") %>">Update</a>
            <% if(!showAll) { %>
                <a class="action-btn" href="EHR.jsp?appointment_id=<%= rs.getInt("appointment_id") %>">Complete Appointment</a>
            <% } %>
        </td>
    </tr>
    <% } %>

    <% if(!hasRecords) { %>
    <tr>
        <td colspan="8">No Appointments found.</td>
    </tr>
    <% } %>
</table>

<%
    rs.close();
    st.close();
    con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<jsp:include page="Footer.jsp"></jsp:include>

</body>
</html>
