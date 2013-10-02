Puppet::Type.newtype(:powermgmt) do
  @doc = 'Manage power management/energy saver settings. The namevar can be
  one of `charger` or `battery` if you want to apply a different policy for each
  '

  def munge_boolean(value)
    case value
    when true, "true", :true
      :true
    when false, "false", :false
      :false
    else
      fail("munge_boolean only takes booleans")
    end
  end
  
  def munge_integer(value)
      Integer(value)
  rescue ArgumentError
      fail("munge_integer only takes integers")
  end

  newparam(:source) do
    desc "The type(s) of power source to apply this setting to: charger or battery. AC power also counts as charger."

    # UPS currently unsupported
    # I removed :all as an option because it would allow you to create two resources that conflict with each other.
    newvalues(:battery, :charger)
    isnamevar
  end

  newproperty(:display_sleep) do
    desc "Display sleep time (in minutes). Set to zero to disable."

    munge do |value|
      @resource.munge_integer(value)
    end
    defaultto 10 # Mac OS X Default
  end

  newproperty(:disk_sleep) do
    desc "Disk sleep/spin down time (in minutes). Set to zero to disable."

    munge do |value|
      @resource.munge_integer(value)
    end
    defaultto 10 # Mac OS X Default
  end

  newproperty(:sleep) do
    desc "System sleep time (in minutes). Set to zero to disable."
    
    munge do |value|
      @resource.munge_integer(value)
    end
    defaultto 30 # Mac OS X Default
  end

  newproperty(:wake_on_lan, :boolean => true) do
    desc "Enable wake on lan magic packet. Allows you to wake the system from sleep using a special packet."

    newvalues(:true, :false)
    
    defaultto :true
    
    munge do |value|
      @resource.munge_boolean(value)
    end    
  end

  newproperty(:autorestart, :boolean => true) do
    desc "Automatically restart on power loss."

    newvalues(:true, :false)

    defaultto :true # Mac OS X Default

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:power_button_sleeps, :boolean => true) do
    desc "Power button causes system to sleep instead of shut down."

    newvalues(:true, :false)
    
    defaultto :true # Mac OS X Default
    
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:lidwake, :boolean => true) do
    desc "Wake the system when the laptop lid is opened."

    newvalues(:true, :false)
  end

  newproperty(:acwake, :boolean => true) do
    desc "Wake the system when the power source is changed (Battery to AC or vice versa)."

    newvalues(:true, :false)
  end

  newproperty(:lessbright, :boolean => true) do
    desc "Turn brightness down slightly when switching to this power source."

    newvalues(:true, :false)
  end

  newproperty(:halfdim, :boolean => true) do
    desc "Display sleep only dims the display to half brightness instead of shutting off the display."

    newvalues(:true, :false)
  end

  newproperty(:sms, :boolean => true) do
    desc "Use sudden motion sensor to park disk heads on sudden changes in G force."

    newvalues(:true, :false)
  end

  # not supporting hibernate mode bitmask
  # not supporting hibername file location

  newproperty(:ttyskeepawake, :boolean => true) do
    desc "Prevent system sleep when any tty (including remote logins) is active."

    newvalues(:true, :false)
  end

  # not supporting networkoversleep because you cannot change it anyway

  newproperty(:destroyfvkeyonstandby, :boolean => true) do
    desc "Destroy filevault key when going into standby. User will be prompted to re-enter filevault password on wakeup."

    newvalues(:true, :false)
  end

end