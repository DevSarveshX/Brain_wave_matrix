<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Bills</title>
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

<h2>Billing Records</h2>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

        String sql = "SELECT b.*, p.first_name AS patient_first, p.last_name AS patient_last, " +
                     "s.first_name AS staff_first, s.last_name AS staff_last " +
                     "FROM Billing b " +
                     "LEFT JOIN Appointment a ON b.appointment_id = a.appointment_id " +
                     "LEFT JOIN Patient p ON b.patient_id = p.patient_id " +
                     "LEFT JOIN Staff s ON a.staff_id = s.staff_id";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);
%>

<table>
    <tr>
        <th>Bill ID</th>
        <th>Patient</th>
        <th>Staff</th>
        <th>Amount</th>
        <th>Paid</th>
        <th>Payment Method</th>
        <th>Bill Date</th>
        <th>Action</th>
    </tr>

<%
    boolean hasRecords = false;
    while(rs.next()) {
        hasRecords = true;
        String patientName = rs.getString("patient_first") + " " + rs.getString("patient_last");
        String staffName = (rs.getString("staff_first") != null)
                          ? rs.getString("staff_first") + " " + rs.getString("staff_last")
                          : "Not Assigned";
        String paidStatus = rs.getInt("paid") == 1 ? "Yes" : "No";
%>
    <tr>
        <td><%= rs.getInt("bill_id") %></td>
        <td><%= patientName %></td>
        <td><%= staffName %></td>
        <td>₹ <%= rs.getBigDecimal("amount") %></td>
        <td><%= paidStatus %></td>
        <td><%= rs.getString("payment_method") %></td>
        <td><%= rs.getTimestamp("bill_date") %></td>
        <td>
            <a class="action-btn" href="PrintBill.jsp?bill_id=<%= rs.getInt("bill_id") %>">Print Bill</a>
        </td>
    </tr>
<% } %>

<% if(!hasRecords) { %>
    <tr>
        <td colspan="8">No billing records found.</td>
    </tr>
<% } %>

</table>

<%
    rs.close();
    st.close();
    con.close();
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
    }
%>

<jsp:include page="Footer.jsp"></jsp:include>

</body>
</html>
