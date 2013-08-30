# @author Craig Read
#
# NullUser is used to represent not being
# logged in.  As such, role? will always
# return false (regardless of the input)
class NullUser
  def role?(role_name)
    false
  end
end