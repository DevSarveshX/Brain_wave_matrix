<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String ehrIdParam = request.getParameter("ehr_id");
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());
    String message = "";

    if(ehrIdParam != null && !ehrIdParam.isEmpty()) {
        int ehr_id = Integer.parseInt(ehrIdParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            if(isPost) {
                // Form submitted: update EHR
                String visit_date = request.getParameter("visit_date");
                String diagnosis = request.getParameter("diagnosis");
                String treatment = request.getParameter("treatment");
                String prescriptions = request.getParameter("prescriptions");
                String notes = request.getParameter("notes");
                String staff_id = request.getParameter("staff_id");

                String updateSql = "UPDATE EHR SET visit_date=?, diagnosis=?, treatment=?, prescriptions=?, notes=?, staff_id=? WHERE ehr_id=?";
                PreparedStatement psUpdate = con.prepareStatement(updateSql);
                psUpdate.setString(1, visit_date);
                psUpdate.setString(2, diagnosis);
                psUpdate.setString(3, treatment);
                psUpdate.setString(4, prescriptions);
                psUpdate.setString(5, notes);
                
                if(staff_id == null || staff_id.isEmpty()) {
                    psUpdate.setNull(6, java.sql.Types.INTEGER);
                } else {
                    psUpdate.setInt(6, Integer.parseInt(staff_id));
                }
                psUpdate.setInt(7, ehr_id);
                
                int updated = psUpdate.executeUpdate();
                psUpdate.close();

                if(updated > 0) {
                    // redirect to view page after update
                    response.sendRedirect("ViewEHR.jsp");
                    return;
                } else {
                    message = "Failed to update record.";
                }
            }

            // Fetch current data + staff name
            String fetchSql = "SELECT e.*, s.first_name, s.last_name FROM EHR e LEFT JOIN Staff s ON e.staff_id = s.staff_id WHERE e.ehr_id=?";
            PreparedStatement psFetch = con.prepareStatement(fetchSql);
            psFetch.setInt(1, ehr_id);
            ResultSet rs = psFetch.executeQuery();

            if(rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update EHR</title>
    <style>
        body {
            margin:0;
            font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
        }
        h2 {
            text-align: center;
            color: #0f8b8d;
            margin-top: 20px;
        }
        form {
            width: 60%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius:8px;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
        }
        label {
            display:block;
            margin:10px 0 5px;
            color:#333;
        }
        input[type="text"], input[type="datetime-local"], textarea {
            width:100%;
            padding:8px;
            margin-bottom:10px;
            border:1px solid #ccc;
            border-radius:4px;
        }
        button {
            background-color:#0f8b8d;
            color:white;
            padding:10px 20px;
            border:none;
            border-radius:4px;
            font-size:16px;
            cursor:pointer;
        }
        button:hover {
            background-color:#136c72;
        }
        .message {
            text-align:center;
            color:green;
            margin-bottom:10px;
        }
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>
<h2>Update Electronic Health Record</h2>
<% if(!message.isEmpty()) { %>
    <div class="message"><%= message %></div>
<% } %>
<form method="post">
    <label>Visit Date & Time:</label>
    <input type="datetime-local" name="visit_date" value="<%= rs.getString("visit_date").replace(" ", "T") %>" required>
    
    <label>Diagnosis:</label>
    <textarea name="diagnosis" required><%= rs.getString("diagnosis") %></textarea>
    
    <label>Treatment:</label>
    <textarea name="treatment" required><%= rs.getString("treatment") %></textarea>
    
    <label>Prescriptions:</label>
    <textarea name="prescriptions"><%= rs.getString("prescriptions") %></textarea>
    
    <label>Notes:</label>
    <textarea name="notes"><%= rs.getString("notes") %></textarea>
    
    <label>Staff:</label>
    <input type="text" value="<%= (rs.getString("first_name") != null) ? rs.getString("first_name") + " " + rs.getString("last_name") : "Not Assigned" %>" disabled>
    
    <!-- Hidden staff_id input to keep the value for update -->
    <input type="hidden" name="staff_id" value="<%= (rs.getObject("staff_id") != null) ? rs.getString("staff_id") : "" %>">
    
    <button type="submit">Update EHR</button>
</form>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
<%
            } else {
                out.println("<p style='color:red;text-align:center;'>EHR record not found.</p>");
            }
            rs.close();
            psFetch.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;text-align:center;'>Invalid EHR ID.</p>");
    }
%>
