<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Appointment</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            color: #333;
        }
        .form-container {
            width: 500px;
            max-width: 90%;
            background-color: #fff;
            margin: 30px auto;
            padding: 20px 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .form-container h2 {
            text-align: center;
            color: #0f8b8d;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="datetime-local"],
        select {
            width: 100%;
            padding: 8px 10px;
            margin-top: 4px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        .submit-btn {
            width: 100%;
            margin-top: 20px;
            background-color: #0f8b8d;
            color: white;
            border: none;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .submit-btn:hover {
            background-color: #136c72;
        }
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>

<%
    String appointmentId = request.getParameter("appointment_id");
    String patientName = "";
    String staffId = "";
    String appointmentDate = "";
    String reason = "";
    String status = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

        String sql = "SELECT a.*, p.first_name AS patient_first, p.last_name AS patient_last "
                   + "FROM Appointment a "
                   + "LEFT JOIN Patient p ON a.patient_id = p.patient_id "
                   + "WHERE appointment_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, appointmentId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            patientName = rs.getString("patient_first") + " " + rs.getString("patient_last");
            staffId = rs.getString("staff_id");
            appointmentDate = rs.getString("appointment_date");
            reason = rs.getString("reason");
            status = rs.getString("status");
        }
        rs.close();
        ps.close();
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<div class="form-container">
    <h2>Update Appointment</h2>
    <form method="post" action="UpdateAppointment">
        <input type="hidden" name="appointment_id" value="<%= appointmentId %>">

        <label>Patient Name:</label>
        <input type="text" value="<%= patientName %>" readonly>

        <label>Appointment Date & Time:</label>
        <input type="datetime-local" name="appointment_date" value="<%= appointmentDate.replace(" ","T") %>" required>

        <label>Reason:</label>
        <input type="text" name="reason" value="<%= reason %>">

        <label>Select Staff:</label>
        <select name="staff_id">
            <option value="">--Select--</option>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

                    String staffSql = "SELECT staff_id, first_name, last_name FROM Staff";
                    Statement staffStmt = con.createStatement();
                    ResultSet staffRs = staffStmt.executeQuery(staffSql);

                    while (staffRs.next()) {
                        String sId = staffRs.getString("staff_id");
                        String sName = staffRs.getString("first_name") + " " + staffRs.getString("last_name");
                        String selected = (sId.equals(staffId)) ? "selected" : "";
            %>
                        <option value="<%= sId %>" <%= selected %>><%= sName %></option>
            <%
                    }
                    staffRs.close();
                    staffStmt.close();
                    con.close();
                } catch(Exception e) { e.printStackTrace(); }
            %>
        </select>

        <label>Status:</label>
        <select name="status" required>
            <option value="Scheduled" <%= "Scheduled".equals(status) ? "selected" : "" %>>Scheduled</option>
            <option value="Completed" <%= "Completed".equals(status) ? "selected" : "" %>>Completed</option>
            <option value="Cancelled" <%= "Cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
        </select>

        <button type="submit" class="submit-btn">Update Appointment</button>
    </form>
</div>

<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
