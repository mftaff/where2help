module ShiftsHelper
  def label_for(shift, user)
    shift.users.include?(user) ? 'label-info' : 'label-default'
  end

  def opt_button_for(shift, user)
    if shift.users.include? user
      link_to t('shifts.opt_out'), shift_opt_out_path(shift),
        method: :delete,
        data: { confirm: t('shifts.are_you_sure'), disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
        class: 'btn btn-danger'
    else
      link_to t('shifts.opt_in'), shift_opt_in_path(shift),
        method: :post,
        data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
        class: 'btn btn-primary'
    end
  end
end