<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String patientIdParam = request.getParameter("patient_id");
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());
    String message = "";

    if(patientIdParam != null && !patientIdParam.isEmpty()) {
        int patient_id = Integer.parseInt(patientIdParam);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

        if(isPost) {
            String first_name = request.getParameter("first_name");
            String last_name = request.getParameter("last_name");
            String date_of_birth = request.getParameter("date_of_birth");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String emergency_contact = request.getParameter("emergency_contact");

            String updateSql = "UPDATE Patient SET first_name=?, last_name=?, date_of_birth=?, gender=?, phone=?, email=?, address=?, emergency_contact=? WHERE patient_id=?";
            PreparedStatement ps = con.prepareStatement(updateSql);
            ps.setString(1, first_name);
            ps.setString(2, last_name);
            ps.setString(3, date_of_birth);
            ps.setString(4, gender);
            ps.setString(5, phone);
            ps.setString(6, email);
            ps.setString(7, address);
            ps.setString(8, emergency_contact);
            ps.setInt(9, patient_id);

            int updated = ps.executeUpdate();
            ps.close();

            if(updated > 0) {
                response.sendRedirect("Patient.jsp"); // go back to list
                return;
            } else {
                message = "Failed to update patient.";
            }
        }

        // Fetch current patient data
        String sql = "SELECT * FROM Patient WHERE patient_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, patient_id);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Patient</title>
    <style>
        body { margin:0; font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #d9f1ff, #f0fff4);}
        h2 { text-align:center; color:#0f8b8d; margin-top:20px;}
        form { width:60%; margin:20px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);}
        label { display:block; margin:10px 0 5px; color:#333;}
        input[type="text"], input[type="date"], select, textarea {
            width:100%; padding:8px; margin-bottom:10px; border:1px solid #ccc; border-radius:4px;
        }
        button { background-color:#0f8b8d; color:white; padding:10px 20px; border:none; border-radius:4px; font-size:16px;}
        button:hover { background-color:#136c72;}
        .message { text-align:center; color:green; margin-bottom:10px; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
<h2>Update Patient Information</h2>
<% if(!message.isEmpty()) { %>
    <div class="message"><%= message %></div>
<% } %>
<form method="post">
    <label>First Name:</label>
    <input type="text" name="first_name" value="<%= rs.getString("first_name") %>" required>

    <label>Last Name:</label>
    <input type="text" name="last_name" value="<%= rs.getString("last_name") %>" required>

    <label>Date of Birth:</label>
    <input type="date" name="date_of_birth" value="<%= rs.getString("date_of_birth") %>" required>

    <label>Gender:</label>
    <select name="gender" required>
        <option value="Male" <%= "Male".equals(rs.getString("gender")) ? "selected" : "" %>>Male</option>
        <option value="Female" <%= "Female".equals(rs.getString("gender")) ? "selected" : "" %>>Female</option>
        <option value="Other" <%= "Other".equals(rs.getString("gender")) ? "selected" : "" %>>Other</option>
    </select>

    <label>Phone:</label>
    <input type="text" name="phone" value="<%= rs.getString("phone") %>" required>

    <label>Email:</label>
    <input type="text" name="email" value="<%= rs.getString("email") %>">

    <label>Address:</label>
    <textarea name="address"><%= rs.getString("address") %></textarea>

    <label>Emergency Contact:</label>
    <input type="text" name="emergency_contact" value="<%= rs.getString("emergency_contact") %>">

    <button type="submit">Update Patient</button>
</form>
    <jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
<%
        } else {
            out.println("<p style='color:red;text-align:center;'>Patient not found.</p>");
        }
        rs.close();
        ps.close();
        con.close();
    } else {
        out.println("<p style='color:red;text-align:center;'>Invalid patient ID.</p>");
    }
%>
