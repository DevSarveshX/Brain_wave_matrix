<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Schedule Appointment</title>
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
    String patientId = request.getParameter("patient_id");
    String firstName = "";
    String lastName = "";

    if (patientId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            String sql = "SELECT first_name, last_name FROM Patient WHERE patient_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                firstName = rs.getString("first_name");
                lastName = rs.getString("last_name");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<div class="form-container">
    <h2>Schedule Appointment For <%=firstName%> <%=lastName%></h2>
    <form method="post" action="AddAppointment">
        <label>Patient ID:</label>
        <input type="text" name="patient_id" value="<%= patientId %>" readonly>

        <label>Patient Name:</label>
        <input type="text" value="<%= firstName %> <%= lastName %>" readonly>

        <label>Appointment Date & Time:</label>
        <input type="datetime-local" name="appointment_date" required>

        <label>Reason:</label>
        <input type="text" name="reason">

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
                        String staffId = staffRs.getString("staff_id");
                        String staffName = staffRs.getString("first_name") + " " + staffRs.getString("last_name");
            %>
                        <option value="<%= staffId %>"><%= staffName %></option>
            <%
                    }

                    staffRs.close();
                    staffStmt.close();
                    con.close();

                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <input type="hidden" name="status" value="Scheduled">

        <button type="submit" class="submit-btn">Add Appointment</button>
    </form>
</div>

    <jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
