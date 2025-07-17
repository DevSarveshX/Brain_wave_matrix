<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String appointmentIdParam = request.getParameter("appointment_id");
    int appointmentId = 0;
    if(appointmentIdParam != null) {
        appointmentId = Integer.parseInt(appointmentIdParam);
    }

    int patientId = 0;
    int staffId = 0;
    String patientName = "";
    String staffName = "";

    if(appointmentId > 0){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            String sql = "SELECT a.patient_id, a.staff_id, " +
                         "p.first_name AS patient_first, p.last_name AS patient_last, " +
                         "s.first_name AS staff_first, s.last_name AS staff_last " +
                         "FROM Appointment a " +
                         "LEFT JOIN Patient p ON a.patient_id = p.patient_id " +
                         "LEFT JOIN Staff s ON a.staff_id = s.staff_id " +
                         "WHERE a.appointment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                patientId = rs.getInt("patient_id");
                staffId = rs.getInt("staff_id");
                patientName = rs.getString("patient_first") + " " + rs.getString("patient_last");
                staffName = (rs.getString("staff_first") != null) ? 
                            rs.getString("staff_first") + " " + rs.getString("staff_last") : "Not Assigned";
            }
            rs.close(); ps.close(); con.close();
        } catch(Exception e){
            e.printStackTrace();
        }
    }

        // If form submitted
    String method = request.getMethod();
    if("POST".equalsIgnoreCase(method)){
        String diagnosis = request.getParameter("diagnosis");
        String treatment = request.getParameter("treatment");
        String prescriptions = request.getParameter("prescriptions");
        String notes = request.getParameter("notes");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            // Insert into EHR
            String insertSql = "INSERT INTO EHR (patient_id, staff_id, visit_date, diagnosis, treatment, prescriptions, notes) " +
                               "VALUES (?, ?, NOW(), ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(insertSql);
            ps.setInt(1, patientId);
            if(staffId > 0) ps.setInt(2, staffId); else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setString(3, diagnosis);
            ps.setString(4, treatment);
            ps.setString(5, prescriptions);
            ps.setString(6, notes);
            ps.executeUpdate();
            ps.close();

            // Update appointment status to 'Completed'
            String updateSql = "UPDATE Appointment SET status = 'Completed' WHERE appointment_id = ?";
            PreparedStatement ps2 = con.prepareStatement(updateSql);
            ps2.setInt(1, appointmentId);
            ps2.executeUpdate();
            ps2.close();

            con.close();

            response.sendRedirect("ViewAppointments.jsp"); // redirect after insert & update
            return;

        } catch(Exception e){
            e.printStackTrace();
        }
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complete Appointment - Add EHR</title>
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
        input[type="text"], textarea {
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

<div class="form-container">
    <h2>Complete Appointment</h2>
    <form method="post">
        <label>Patient:</label>
        <input type="text" value="<%= patientName %>" readonly>

        <label>Staff:</label>
        <input type="text" value="<%= staffName %>" readonly>

        <label>Diagnosis:</label>
        <textarea name="diagnosis" required></textarea>

        <label>Treatment:</label>
        <textarea name="treatment" required></textarea>

        <label>Prescriptions:</label>
        <textarea name="prescriptions"></textarea>

        <label>Notes:</label>
        <textarea name="notes"></textarea>

        <button type="submit" class="submit-btn">Save Record</button>
    </form>
</div>

<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
