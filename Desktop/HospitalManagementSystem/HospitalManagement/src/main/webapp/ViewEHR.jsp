<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Electronic Health Records</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            color: #333;
        }
        h2 {
            text-align: center;
            color: #0f8b8d;
            margin-top: 20px;
        }
        .top-actions {
            text-align: center;
            margin: 10px;
        }
        .top-btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #0f8b8d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 15px;
            margin: 5px;
            transition: background-color 0.3s;
        }
        .top-btn:hover {
            background-color: #136c72;
        }
        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 10px 12px;
            text-align: center;
            font-size: 14px;
        }
        th {
            background-color: #0f8b8d;
            color: white;
            font-size: 16px;
        }
        tr:nth-child(even) {
            background-color: #f2f9f9;
        }
        tr:hover {
            background-color: #d0efef;
        }
        .action-btn {
            display: inline-block;
            padding: 6px 12px;
            margin: 2px;
            background-color: #0f8b8d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 13px;
            transition: background-color 0.3s;
        }
        .action-btn:hover {
            background-color: #136c72;
        }
    </style>
</head>
<body>

<jsp:include page="Header.jsp"></jsp:include>

<h2>Electronic Health Records</h2>

<div class="top-actions">
    <a class="top-btn" href="ViewBills.jsp">View Bills</a>
</div>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

        String sql = "SELECT e.*, p.first_name, p.last_name, s.first_name AS staff_first, s.last_name AS staff_last " +
                     "FROM EHR e " +
                     "LEFT JOIN Patient p ON e.patient_id = p.patient_id " +
                     "LEFT JOIN Staff s ON e.staff_id = s.staff_id";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);
%>

<table>
    <tr>
        <th>ID</th>
        <th>Patient</th>
        <th>Staff</th>
        <th>Visit Date</th>
        <th>Diagnosis</th>
        <th>Treatment</th>
        <th>Prescriptions</th>
        <th>Notes</th>
        <th>Action</th>
    </tr>

<%
    boolean hasRecords = false;
    while(rs.next()) {
        hasRecords = true;
        String patientName = rs.getString("first_name") + " " + rs.getString("last_name");
        String staffName = (rs.getString("staff_first") != null)
                          ? rs.getString("staff_first") + " " + rs.getString("staff_last")
                          : "Not Assigned";
%>
    <tr>
        <td><%= rs.getInt("ehr_id") %></td>
        <td><%= patientName %></td>
        <td><%= staffName %></td>
        <td><%= rs.getString("visit_date") %></td>
        <td><%= rs.getString("diagnosis") %></td>
        <td><%= rs.getString("treatment") %></td>
        <td><%= rs.getString("prescriptions") %></td>
        <td><%= rs.getString("notes") %></td>
        <td>
            <a class="action-btn" href="UpdateEHR.jsp?ehr_id=<%= rs.getInt("ehr_id") %>">Update</a>
            <a class="action-btn" href="Biiling.jsp?ehr_id=<%= rs.getInt("ehr_id") %>">Generate Bill</a>
        </td>
    </tr>
<% } %>

<% if(!hasRecords) { %>
    <tr>
        <td colspan="9">No EHR records found.</td>
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
