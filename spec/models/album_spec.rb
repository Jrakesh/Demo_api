# == Schema Information
#
# Table name: albums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Album, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
