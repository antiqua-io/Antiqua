class User
  class Subscription
    include Mongoid::Document
    include Mongoid::Timestamps

    # Embeds
    #
    embedded_in :user

    # Fields
    #
    field :stripe_customer_id , :type => String

    def subscribe!( stripe_token )
      stripe_customer = Stripe::Customer.create \
        :card  => stripe_token,
        :email => user.email,
        :plan  => CONFIG.stripe_individual_plan_id
      self.stripe_customer_id = stripe_customer.id
      save!
    end

    def unsubscribe!
      stripe_customer = Stripe::Customer.retrieve stripe_customer_id
      stripe_customer.cancel_subscription :at_period_end => true
    end
  end
end
