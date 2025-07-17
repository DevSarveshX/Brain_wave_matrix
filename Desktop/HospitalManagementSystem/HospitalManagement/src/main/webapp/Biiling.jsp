<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
    String ehrIdParam = request.getParameter("ehr_id");
    String message = "";
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    if(ehrIdParam != null && !ehrIdParam.isEmpty()) {
        int ehr_id = Integer.parseInt(ehrIdParam);
        Connection con = null;
        PreparedStatement ps = null, psInsert = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            if(isPost) {
                String amountStr = request.getParameter("amount");
                String paidAmountStr = request.getParameter("paid_amount");
                String payment_method = request.getParameter("payment_method");
                String patient_id = request.getParameter("patient_id");
                String appointment_id = request.getParameter("appointment_id");

                BigDecimal amount = new BigDecimal(amountStr);
                BigDecimal paidAmount = new BigDecimal(paidAmountStr);

                int paidFlag = (paidAmount.compareTo(amount) >= 0) ? 1 : 0;

                String insertSql = "INSERT INTO Billing(patient_id, appointment_id, amount, payment_method, paid) VALUES (?, ?, ?, ?, ?)";
                psInsert = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                psInsert.setInt(1, Integer.parseInt(patient_id));
                psInsert.setInt(2, Integer.parseInt(appointment_id));
                psInsert.setBigDecimal(3, amount);
                psInsert.setString(4, payment_method);
                psInsert.setInt(5, paidFlag);

                int inserted = psInsert.executeUpdate();

                if(inserted > 0) {
                    ResultSet generatedKeys = psInsert.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int bill_id = generatedKeys.getInt(1);
                        response.sendRedirect("PrintBill.jsp?bill_id=" + bill_id);
                        return;
                    }
                } else {
                    message = "Failed to insert billing record.";
                }
                psInsert.close();
            }

            // Fetch EHR, patient & staff info
            String sql = "SELECT e.ehr_id, e.patient_id, e.staff_id, p.first_name AS patient_first, p.last_name AS patient_last, " +
                         "s.first_name AS staff_first, s.last_name AS staff_last, a.appointment_id " +
                         "FROM EHR e " +
                         "LEFT JOIN Patient p ON e.patient_id = p.patient_id " +
                         "LEFT JOIN Staff s ON e.staff_id = s.staff_id " +
                         "LEFT JOIN Appointment a ON a.patient_id = e.patient_id " + 
                         "WHERE e.ehr_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, ehr_id);
            rs = ps.executeQuery();

            if(rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Billing</title>
    <style>
        body { margin:0; font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #d9f1ff, #f0fff4);}
        h2 { text-align:center; color:#0f8b8d; margin-top:20px;}
        form { width:60%; margin:20px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);}
        label { display:block; margin:10px 0 5px;}
        input[type="text"], select { width:100%; padding:8px; margin-bottom:10px; border:1px solid #ccc; border-radius:4px;}
        button { background-color:#0f8b8d; color:white; padding:10px 20px; border:none; border-radius:4px; font-size:16px;}
        button:hover { background-color:#136c72;}
        .readonly { background-color:#eee; }
        .message { text-align:center; color:green; margin-bottom:10px; }
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>
<h2>Generate Billing</h2>
<% if(!message.isEmpty()) { %>
    <div class="message"><%= message %></div>
<% } %>
<form method="post">
    <label>EHR ID:</label>
    <input type="text" name="ehr_id" value="<%= rs.getInt("ehr_id") %>" readonly class="readonly">
    
    <label>Patient Name:</label>
    <input type="text" value="<%= rs.getString("patient_first") %> <%= rs.getString("patient_last") %>" readonly class="readonly">
    
    <label>Staff Name:</label>
    <input type="text" value="<%= (rs.getString("staff_first") != null ? rs.getString("staff_first")+" "+rs.getString("staff_last") : "Not Assigned") %>" readonly class="readonly">
    
    <input type="hidden" name="patient_id" value="<%= rs.getInt("patient_id") %>">
    <input type="hidden" name="appointment_id" value="<%= rs.getInt("appointment_id") %>">
    
    <label>Total Amount (₹):</label>
    <input type="text" name="amount" required>
    
    <label>Paid Amount (₹):</label>
    <input type="text" name="paid_amount" required>
    
    <label>Payment Method:</label>
    <select name="payment_method" required>
        <option value="Cash">Cash</option>
        <option value="Card">Card</option>
        <option value="Online">Online</option>
        <option value="Insurance">Insurance</option>
    </select>
    
    <button type="submit">Generate Bill</button>
</form>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
<%
            } else {
                out.println("<p style='color:red;text-align:center;'>EHR record not found.</p>");
            }
            rs.close();
            ps.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;text-align:center;'>Invalid EHR ID.</p>");
    }
%>
