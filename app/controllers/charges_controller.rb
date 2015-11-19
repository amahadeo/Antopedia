class ChargesController < ApplicationController
  def new
    authorize :charge, :new?
    
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Antopedia Premium Membership - #{current_user.username}",
      amount: Amount.default
    }
  end
  
  def create
    authorize :charge, :create?
    
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
      )
      
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: Amount.default,
      description: "Antopedia premium membership - #{current_user.email}",
      currency: 'usd'
      )
      
    flash[:notice] = "Thank you for payment. Welcome to Premium Membership #{current_user.username}!"
    current_user.upgrade
    redirect_to wikis_path
    
  rescue Stripe::CardError => e 
    flash[:error] = e.message
    redirect_to new_charges_path
  end
  
  # Membership downgrade actions grouped into charges controller to facilitate refund/reimbursement ability
  def edit
    authorize :charge, :edit?
  end
  
  def destroy
    authorize :charge, :destroy?
    
    current_user.downgrade
    
    flash[:alert] = "Your membership has been downgraded to 'Standard'"
    redirect_to wikis_path
  end
end
