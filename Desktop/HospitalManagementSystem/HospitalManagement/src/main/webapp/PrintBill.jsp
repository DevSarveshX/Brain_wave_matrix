<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String billIdParam = request.getParameter("bill_id");
    if(billIdParam != null && !billIdParam.isEmpty()) {
        int bill_id = Integer.parseInt(billIdParam);
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            String sql = "SELECT b.*, p.first_name AS patient_first, p.last_name AS patient_last, " +
                         "a.appointment_date, s.first_name AS staff_first, s.last_name AS staff_last " +
                         "FROM Billing b " +
                         "LEFT JOIN Patient p ON b.patient_id = p.patient_id " +
                         "LEFT JOIN Appointment a ON b.appointment_id = a.appointment_id " +
                         "LEFT JOIN Staff s ON a.staff_id = s.staff_id " +
                         "WHERE b.bill_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bill_id);
            rs = ps.executeQuery();

            if(rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Print Bill</title>
    <style>
        body { margin:0; font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif; background:#f7f7f7;}
        .bill-container { width:700px; margin:30px auto; background:white; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.2);}
        .header { text-align:center; border-bottom:2px solid #0f8b8d; padding-bottom:10px; margin-bottom:20px;}
        .header h2 { color:#0f8b8d; margin:0; }
        table { width:100%; border-collapse:collapse; }
        th, td { text-align:left; padding:8px; border-bottom:1px solid #ddd; }
        th { background-color:#0f8b8d; color:white; }
        .total-row td { font-weight:bold; }
        .print-btn { display:block; margin:20px auto; background-color:#0f8b8d; color:white; padding:10px 20px; border:none; border-radius:4px; font-size:16px; cursor:pointer;}
        .print-btn:hover { background-color:#136c72;}
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>
<div class="bill-container" id="billArea">
    <div class="header">
        <h2>Sarvesh's Hospital</h2>
        <p>Billing Receipt</p>
    </div>
    <table>
        <tr>
            <th>Bill ID</th>
            <td><%= rs.getInt("bill_id") %></td>
        </tr>
        <tr>
            <th>Bill Date</th>
            <td><%= rs.getTimestamp("bill_date") %></td>
        </tr>
        <tr>
            <th>Patient Name</th>
            <td><%= rs.getString("patient_first") %> <%= rs.getString("patient_last") %></td>
        </tr>
        <tr>
            <th>Appointment Date</th>
            <td><%= rs.getString("appointment_date") %></td>
        </tr>
        <tr>
            <th>Staff Name</th>
            <td><%= (rs.getString("staff_first") != null ? rs.getString("staff_first")+" "+rs.getString("staff_last") : "Not Assigned") %></td>
        </tr>
        <tr>
            <th>Payment Method</th>
            <td><%= rs.getString("payment_method") %></td>
        </tr>
        <tr>
            <th>Paid</th>
            <td><%= (rs.getInt("paid")==1 ? "Yes" : "No") %></td>
        </tr>
        <tr class="total-row">
            <th>Total Amount</th>
            <td>₹ <%= rs.getBigDecimal("amount") %></td>
        </tr>
    </table>
</div>
<button class="print-btn" onclick="printBill()">Print Bill</button>
<jsp:include page="Footer.jsp"></jsp:include>
<script>
function printBill(){
    var printContents = document.getElementById('billArea').innerHTML;
    var originalContents = document.body.innerHTML;
    document.body.innerHTML = printContents;
    window.print();
    document.body.innerHTML = originalContents;
}
</script>
</body>
</html>
<%
            } else {
                out.println("<p style='color:red;text-align:center;'>Bill not found.</p>");
            }
            rs.close(); ps.close(); con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;text-align:center;'>Error: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;text-align:center;'>Invalid Bill ID.</p>");
    }
%>
