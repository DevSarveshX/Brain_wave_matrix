<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%
    String staffIdParam = request.getParameter("staff_id");
    String message = "";
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    if (staffIdParam != null && !staffIdParam.isEmpty()) {
        int staff_id = Integer.parseInt(staffIdParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            if (isPost) {
                String username = request.getParameter("username");
                String newPassword = request.getParameter("new_password");
                String role = request.getParameter("role");

                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    // Update with new password
                    
                    String updateSql = "UPDATE User SET username=?, password_hash=?, role=? WHERE staff_id=?";
                    PreparedStatement psUpdate = con.prepareStatement(updateSql);
                    psUpdate.setString(1, username);
                    psUpdate.setString(2, newPassword);
                    psUpdate.setString(3, role);
                    psUpdate.setInt(4, staff_id);

                    int updated = psUpdate.executeUpdate();
                    psUpdate.close();

                    if (updated > 0) {
                        response.sendRedirect("Staff.jsp");
                        return;
                    } else {
                        message = "Failed to update user.";
                    }
                } else {
                    // Update without changing password
                    String updateSql = "UPDATE User SET username=?, role=? WHERE staff_id=?";
                    PreparedStatement psUpdate = con.prepareStatement(updateSql);
                    psUpdate.setString(1, username);
                    psUpdate.setString(2, role);
                    psUpdate.setInt(3, staff_id);

                    int updated = psUpdate.executeUpdate();
                    psUpdate.close();

                    if (updated > 0) {
                        response.sendRedirect("Staff.jsp");
                        return;
                    } else {
                        message = "Failed to update user.";
                    }
                }
            }

            // Fetch existing user data by staff_id
            String sql = "SELECT * FROM User WHERE staff_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, staff_id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update User</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
        }
        h2 {
            text-align: center;
            color: #0f8b8d;
            margin-top: 20px;
        }
        form {
            width: 50%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 10px;
        }
        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            margin-top: 15px;
            background-color: #0f8b8d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
        }
        button:hover {
            background-color: #136c72;
        }
        .message { text-align: center; color: red; margin-top: 10px; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
    <h2>Update User</h2>
    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <form method="post">
        <label>Username:</label>
        <input type="text" name="username" value="<%= rs.getString("username") %>" required>

        <label>New Password: (leave blank to keep current password)</label>
        <input type="password" name="new_password">

        <label>Role:</label>
        <select name="role" required>
            <option value="Admin" <%= "Admin".equals(rs.getString("role")) ? "selected" : "" %>>Admin</option>
            <option value="Doctor" <%= "Doctor".equals(rs.getString("role")) ? "selected" : "" %>>Doctor</option>
            <option value="Nurse" <%= "Nurse".equals(rs.getString("role")) ? "selected" : "" %>>Nurse</option>
            <option value="Receptionist" <%= "Receptionist".equals(rs.getString("role")) ? "selected" : "" %>>Receptionist</option>
            <option value="Pharmacist" <%= "Pharmacist".equals(rs.getString("role")) ? "selected" : "" %>>Pharmacist</option>
            <option value="Lab Technician" <%= "Lab Technician".equals(rs.getString("role")) ? "selected" : "" %>>Lab Technician</option>
        </select>

        <button type="submit">Update User</button>
    </form>
        <jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
<%
            } else {
                out.println("<p style='color:red;text-align:center;'>User not found for staff ID.</p>");
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;text-align:center;'>Invalid staff ID.</p>");
    }
%>
