require 'spec_helper'

describe 'adjustments/new' do
  before(:each) do
    assign(:adjustment, stub_model(Adjustment,
                                   adjustment_type: 'MyString',
                                   amount: 1,
                                   reason: 'MyText',
                                   adjustable_id: 1,
                                   adjustable_type: 'Character'
    ).as_new_record)
  end

  it 'renders new adjustment form' do
    render


    assert_select 'form', action: adjustments_path, method: 'post' do
      assert_select 'select#adjustment_adjustable_type',
                    name: 'adjustment[adjustable_type]'
      assert_select 'input#datepicker', name: 'adjustment[adjustment_date]'
      assert_select 'select#adjustment_adjustment_type',
                    name: 'adjustment[adjustment_type]'
      assert_select 'input#adjustment_amount', name: 'adjustment[amount]'
      assert_select 'textarea#adjustment_reason', name: 'adjustment[reason]'
    end
  end
end