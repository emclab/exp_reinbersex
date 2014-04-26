// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#reinberse_request_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#reinberse_paid_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#reinberse_approved_date").datepicker({dateFormat: 'yy-mm-dd'});
});

//for search.html.erb
$(function() {
   $("#reinberse_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#reinberse_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#reinberse_request_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#reinberse_paid_date_s").datepicker({dateFormat: 'yy-mm-dd'});
   $("#reinberse_approved_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});