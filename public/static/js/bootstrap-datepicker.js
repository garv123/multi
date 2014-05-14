<html>
<head>

<link rel="stylesheet" href="/static/css/datepicker.css">
<link rel="stylesheet" href="/static/css/bootstrap.css">
       
 <script src="js/jquery-2.0.0.min.js"></script>
 <script src="js/bootstrap-datepicker.js"></script>

<script type="text/javascript">
            // When the document is ready
            $(document).ready(function () {
                
                $('#example1').datepicker({
                    format: "dd/mm/yyyy"
                });  
            
            });
        </script>












</head>
<body>
  
<div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
      <% if @charge.empty? %>
    <div>
      <p>There are no members registered in this space! Please come back when at least one member is registered.</p>
    </div>
  <% end %>
        
  <% unless @invo.empty? %>
  <% @invo.each do |invo| %>
    <% if invo['membership_id']== @user %>
    
     <h2><%= invo['created_at'] %> PAST</h2>
     <table border="1">
    
    <% invo['items'].each do |item| %>
      
      
      
      <tr>
      
      <td><%= item['description'] %></td>
      <td><%= item['amount'] %></td>
      </tr>
      <% end %>
      <tr>
      <td> Total Amount Due</td>
      <td><%= invo['payable_amount'].to_f %> </td>
      </tr>
      <tr>
      <td> Total Amount</td>
      <td><%= now %> </td>
      </tr>
      
    </table>
    <% end %>
  <% end %>
  <% end %>



  
  
    <% unless @charge.empty? %>
    <h5> Current Charges </h5>
    <table border= "1">
    <% @charge.each do |charge| %>

    
    <tr>
     <td> <%= charge['description'] %> </td>
     <td><%= charge['amount'] %> </td>
     
    </tr>
    <% end %>

  <% end %>
  
  </table>
  </div>

<%= form_tag("/spaces/#{@subdomain}/charge") do %>
<div id="addinput">
<p>
<a href="#" id="addNew">Add</a>

<%= hidden_field_tag  'membership',@user %>

</p>
</div>



      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save changes</button>
      </div>
      <% end %>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->

</p>
</div>

</body>
  </html>