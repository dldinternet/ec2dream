class EC2_Server

#
#  local server  methods
#

def loc_load(server_name)
    puts "server.loc_load "+server_name
    @type = "loc"
	@terminate_button.icon = @save
    @frame1.hide()
    @frame3.hide()
	@frame4.hide()
	@frame6.hide()
	@frame7.hide()
    @frame5.show()
    @page1.width=300
    r = loc_get_local_server(server_name)
    if r['server'] != nil and r['server'] != ""
       @loc_server['server'].text = r['server']
       @loc_server['address'].text = r['address']
       @loc_server['address_port'].text = r['address_port']
       @loc_server['chef_node'].text = r['chef_node']
       @loc_server['puppet_manifest'].text = r['puppet_manifest']
	   @loc_server['puppet_roles'].text = r['puppet_roles']
       @loc_server['ssh_user'].text = r['ssh_user']
       @loc_server['ssh_password'].text = r['ssh_password']
       @loc_server['ssh_key'].text = r['ssh_key']
       @loc_server['putty_key'].text = r['putty_key']
       @loc_server['local_port'].text = r['local_port']
       @loc_server['bastion_host'].text = r['bastion_host']
       @loc_server['bastion_port'].text = r['bastion_port']
       @loc_server['bastion_user'].text = r['bastion_user']
	   @loc_server['bastion_password'].text = r['bastion_password']
       @loc_server['bastion_ssh_key'].text = r['bastion_ssh_key']
       @loc_server['bastion_putty_key'].text = r['bastion_putty_key']
       @loc_server['windows_server'].setCurrentItem(1)
       if r['windows_server'] == 'true'
          @loc_server['windows_server'].setCurrentItem(0)
       end
    end
  end 
  
  def loc_get_local_server(server)
       folder = "loc_server"
       properties = {}
       loc = EC2_Properties.new
       if loc != nil
          properties = loc.get(folder, server)
       end
       return properties
  end 

  def loc_save  
     folder = "loc_server"
     loc = EC2_Properties.new
     if loc != nil
      begin 
        properties = {}
        properties['server']=@loc_server['server'].text
        properties['address']=@loc_server['address'].text
        properties['address_port']=@loc_server['address_port'].text
        properties['chef_node']=@loc_server['chef_node'].text
        properties['puppet_manifest']=@loc_server['puppet_manifest'].text
		properties['puppet_roles']=@loc_server['puppet_roles'].text
		windows_server_value = "false"
        if @loc_server['windows_server'].itemCurrent?(0)
	       windows_server_value = true
        end
        properties['windows_server']=windows_server_value
        properties['ssh_user']=@loc_server['ssh_user'].text
        properties['ssh_password']=@loc_server['ssh_password'].text
        properties['ssh_key']=@loc_server['ssh_key'].text
        properties['putty_key']=@loc_server['putty_key'].text
        properties['local_port']=@loc_server['local_port'].text
        properties['bastion_host']=@loc_server['bastion_host'].text
        properties['bastion_port']=@loc_server['bastion_port'].text
        properties['bastion_user']=@loc_server['bastion_user'].text
		properties['bastion_password']=@loc_server['bastion_password'].text
        properties['bastion_ssh_key']=@loc_server['bastion_ssh_key'].text
        properties['bastion_putty_key']=@loc_server['bastion_putty_key'].text
        
        @saved = loc.save(folder, @loc_server['server'].text, properties)
        if @saved == false
           error_message("Update Local Server Failed","Update Local Server Failed")
           return
        end   
      rescue
        error_message("Update Local Server",$!)
        return
      end
     end
  end 
  
  def loc_delete 
    dialog = LOC_DeleteDialog.new(@ec2_main,@loc_server['server'].text)
	if dialog.success
 	   @ec2_main.list.load('Local Servers')
       @ec2_main.tabBook.setCurrent(0)
     end
  end 
    
  def loc_ssh
      if @loc_server['windows_server'].itemCurrent?(1)
          ssh(@loc_server['server'].text, @loc_server['address'].text, @loc_server['ssh_user'].text, @loc_server['ssh_key'].text, @loc_server['putty_key'].text, @loc_server['ssh_password'].text,@loc_server['local_port'].text)
      end
  end
  
  def loc_rdp
      if @loc_server['windows_server'].itemCurrent?(0)
         remote_desktop(@loc_server['server'].text, @loc_server['ssh_password'].text, @loc_server['ssh_user'].text, nil,@loc_server['local_port'])
      end
  end

  def loc_winscp  
     if @loc_server['server'].text != nil and @loc_server['server'].text != ""
        scp(@loc_server['server'].text, @loc_server['address'].text, @loc_server['ssh_user'].text, @loc_server['ssh_key'].text, @loc_server['putty_key'].text, @loc_server['ssh_password'].text,@loc_server['local_port'].text)
     end    
  end
  
  def loc_chef
     if @loc_server['server'].text != nil and @loc_server['server'].text != ""
        platform = ""
        if @loc_server['windows_server'].itemCurrent?(0) 
           platform == "windows"
        end 
        dialog = EC2_ChefEditDialog.new(@ec2_main,@loc_server['server'].text, @loc_server['address'].text, @loc_server['chef_node'].text, @loc_server['ssh_user'].text, @loc_server['ssh_key'].text, @loc_server['ssh_password'].text,platform,@loc_server['local_port'].text)
        dialog.execute
	 end
  end

  def loc_puppet
     if @loc_server['server'].text != nil and @loc_server['server'].text != ""
        platform = ""
        if @loc_server['windows_server'].itemCurrent?(0)
           platform == "windows"
        end 
        dialog = EC2_PuppetEditDialog.new(@ec2_main,@loc_server['server'].text, @loc_server['address'].text, @loc_server['puppet_manifest'].text, @loc_server['ssh_user'].text, @loc_server['ssh_key'].text, @loc_server['ssh_password'].text,platform,@loc_server['local_port'].text,@loc_server['puppet_roles'].text)
 	     dialog.execute
	 end
  end

  def loc_ssh_tunnel
     if @loc_server['server'].text != nil and @loc_server['server'].text != ""
        ssh_tunnel(@loc_server['server'].text, @loc_server['address'].text, @loc_server['ssh_user'].text, @loc_server['ssh_key'].text, @loc_server['putty_key'].text, @loc_server['ssh_password'].text, @loc_server['address_port'].text, @loc_server['local_port'].text, @loc_server['bastion_host'].text, @loc_server['bastion_port'].text, @loc_server['bastion_user'].text, @loc_server['bastion_ssh_key'].text, @loc_server['bastion_putty_key'].text,  @loc_server['bastion_password'].text)
     end
  end				  
end