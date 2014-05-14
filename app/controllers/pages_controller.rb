class PagesController < ApplicationController

  
  layout false

  def index
  end

  def spaces
    @spaces = session[:admin_of]
  end

  def show
    @subdomain = params[:id]
    memberships = api.get("https://#{@subdomain}.cobot.me/api/memberships")
    @members = JSON.parse(memberships.body).select{|membership|
      membership['canceled_to'].blank? || Date.parse(membership['canceled_to']) > Date.today}.sort_by{|m| m['address']['name']}
  end

  def invoices
    @subdomain = params[:id]
    invoices = api.get("https://#{@subdomain}.cobot.me/api/invoices/open")
    @invoice = JSON.parse(invoices.body)


  end

  def try
    @subdomain= params[:id]
    @user = params[:member]
    charges =  api.get("https://#{@subdomain}.cobot.me/api/memberships/#{@user}/charges/recent")
    @charge = JSON.parse(charges.body)
    now = Date.today
    sixtyminus = (now - 60)
    inv =  api.get("https://#{@subdomain}.cobot.me/api/invoices?from=#{sixtyminus}&to=#{now}")
    @invo= JSON.parse(inv.body)
    

  end
 def sendinvoice
    @subdomain =params[:membership]
    @invoice_number = params[:invoice_ids]

    @invoice_number.each do |invoice_number|
      puts "https://#{@subdomain}.cobot.me/api/invoices/#{invoice_number}/notifications"
      @invoice = api.post("https://#{@subdomain}.cobot.me/api/invoices/#{invoice_number}/notifications")
      puts @invoice.headers['status'] 
    end
    redirect_to(space_path(params[:membership]))

  end

 def recordpayments
    @subdomain =params[:id]
    @invoice_number= params[:invoice_number]

    @user= params[:member]
    now = Date.today
    sixtyminus = (now - 60)
    payments = api.get("https://#{@subdomain}.cobot.me/api/invoices/payment_records?from=#{sixtyminus}&to=#{now}")
    @payment = JSON.parse(payments.body)
    inv =  api.get("https://#{@subdomain}.cobot.me/api/invoices?from=#{sixtyminus}&to=#{now}")
    @invo= JSON.parse(inv.body)
    
  end

  def addrecordpayment
    subdomain = params[:subdomain]
    invoice_number = params[:invoice_number]
    @note = params[:des]
    @paid_at = params[:paid_at]
    @amount = params[:am]

    @note.zip(@paid_at,@amount).each do |note,paid_at,amount|
      @charge = api.post("https://#{subdomain}.cobot.me/api/invoices/#{invoice_number}/payment_records",
                       params: { 'note' => note, 'paid_at' => paid_at, 'amount' => amount })
      if @charge.headers['status'] == "422"
      flash[:error] = "All fields must be filled in."
      elsif @charge.headers['status'] == "201"
      flash[:success] = "Charges successful."
      else
      flash[:notice] = "Unrecognized server response. You may have forgotten to select a member.
                        If the problem persits, please contact cobot support."
      end
    end
    redirect_to(space_path(params[:subdomain]))
  end


  def new_release
    respond_to do |format|
      format.html
      format.js
    end
  end

  def plans
    @subdomain = params[:id]
    plans = api.get("https://#{@subdomain}.cobot.me/api/plans")
    @plan = JSON.parse(plans.body)

  end

  def memberships

    @subdomain = params[:id]
    memberships =  api.get("https://#{@subdomain}.cobot.me/api/memberships")
    @membership = JSON.parse(memberships.body)

    
      
  end

   def newtry
    @subdomain= params[:id]
    @user = params[:member]
    charges =  api.get("https://#{@subdomain}.cobot.me/api/memberships/#{@user}/charges/recent")
    @charge = JSON.parse(charges.body)
    now = Date.today
    sixtyminus = (now - 60)
    inv =  api.get("https://#{@subdomain}.cobot.me/api/invoices?from=#{sixtyminus}&to=#{now}")
    @invo= JSON.parse(inv.body)
    

  end



  def charges
    @subdomain= params[:id]
    @user = params[:uid]
    charges =  api.get("https://#{@subdomain}.cobot.me/api/memberships/#{@user}/charges/recent")
    @charge = JSON.parse(charges.body)

  end

  def abc
  end

  def charge
    subdomain = params[:id]
    member_id = params[:membership]
    @description = params[:des]
    @amount = params[:am]
    puts "hello"

    @description.zip(@amount).each do |description,amount|
      @charge = api.post("https://#{subdomain}.cobot.me/api/memberships/#{member_id}/charges",
                       params: { 'description' => description, 'amount' => amount })
      if @charge.headers['status'] == "422"
      flash[:error] = "All fields must be filled in."
      elsif @charge.headers['status'] == "201"
      flash[:success] = "Charges successful."
      else
      flash[:notice] = "Unrecognized server response. You may have forgotten to select a member.
                        If the problem persits, please contact cobot support."
      end
    end
    redirect_to(space_path(params[:id]))
  end


  def membercharge
    subdomain = params[:id]
    member_id = params[:membership]
    @description = params[:des]
    @amount = params[:am]

    @description.zip(@amount).each do |description,amount|
      @charge = api.post("https://#{subdomain}.cobot.me/api/memberships/#{member_id}/charges",
                       params: { 'description' => description, 'amount' => amount })
      if @charge.headers['status'] == "422"
      flash[:error] = "All fields must be filled in."
      elsif @charge.headers['status'] == "201"
      flash[:success] = "Charges successful."
      else
      flash[:notice] = "Unrecognized server response. You may have forgotten to select a member.
                        If the problem persits, please contact cobot support."
      end
    end
    redirect_to("/pages/memberships/#{subdomain}")
  end


  private

    def check_if_owner
      unless session[:admin_of].include?(params[:id])
        redirect_to(spaces_path, notice: "You do not have admin privileges for that subdomain.")
      end
    end

    def check_if_logged_in
      # Can't go to signin page if already signed in
      if session[:token]
        redirect_to spaces_path
      end
    end

    


end
