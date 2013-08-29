require 'spec_helper'

describe 'adjustments/edit' do
  before(:each) do
    @adjustment = assign(:adjustment, stub_model(Adjustment,
                                                 adjustment_type: 'Raids',
                                                 amount: 1,
                                                 reason: 'Switch',
                                                 adjustable_id: 1,
                                                 adjustable_type: 'Character'
    ))
  end

  it 'renders the edit adjustment form' do
    render

    assert_select 'form', action: adjustments_path(@adjustment),
                  method: 'post' do
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
