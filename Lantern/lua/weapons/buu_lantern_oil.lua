/*---------------------------------
Created with buu342s Swep Creator
All code is in buu_lantern.lua. If
you want to see how things work, go
check there. This just adds an oil
      timer to the weapon.
---------------------------------*/

SWEP.PrintName = "Lantern (Oil)"
SWEP.Author = "Buu342"
SWEP.Instructions = "Equip to use. Fill with oil to keep using. Right Click to toggle hiding the oil."
SWEP.Category 		= "Lantern"
    
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.AdminOnly 		= false	


SWEP.Base = "buu_lantern"

SWEP.WepSelectIcon = "VGUI/entities/buu_lantern_oil"

SWEP.LanternOil = 300 -- Time in Seconds. Default 300 (5 minutes)


/*---------------------------------------------------
				  SetupDataTables
				Networked Variables
---------------------------------------------------*/

function SWEP:SetupDataTables()
    self:NetworkVar("Bool",0,"Lantern_Holstered")
	self:NetworkVar("Bool",1,"Lantern_Equipped")
	self:NetworkVar("Float",0,"Lantern_LightSize")
	self:NetworkVar("Float",1,"Lantern_EnableTime")
	self:NetworkVar("Float",2,"Lantern_HudAlpha")
end


/*---------------------------------------------------
					Deploy
---------------------------------------------------*/

function SWEP:Deploy()
	self:SetLantern_HudAlpha(CurTime())
	if self.Owner:GetNWFloat("LanternOil") < 1 then self:SetLantern_Equipped(true) self.Weapon:SendWeaponAnim( ACT_VM_IDLE_LOWERED ) return true end
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE_LOWERED )
	self:SetLantern_LightSize(CurTime())
	self:SetLantern_Equipped(true)
	self:SetLantern_EnableTime(0)
	self:SetLantern_Holstered(true)
	self.Owner:GetViewModel():SetSkin(0)
	self:SetNextPrimaryFire(CurTime()+0.1)
	return true
end


/*---------------------------------------------------
				  PrimaryAttack
			Enable/disable the lantern
---------------------------------------------------*/

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() || self.Owner:GetNWFloat("LanternOil") < 1 then return end
	if self:GetLantern_Holstered() == true then
		self:SetLantern_LightSize(CurTime())
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self:EmitSound("lantern/lantern_on.wav")
		self:SetLantern_EnableTime(CurTime()+1)
		self:SetLantern_Holstered(false)
		self.Owner:GetViewModel():SetSkin(1)
	else
		self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
		self:SetLantern_Holstered(true)
		self:SetLantern_EnableTime(0)
		self:EmitSound("lantern/lantern_off.wav")
		self.Owner:GetViewModel():SetSkin(0)
	end
	self:SetNextPrimaryFire(CurTime()+1)
end


/*---------------------------------------------------
				SecondaryAttack
			Enable/disable the HUD
---------------------------------------------------*/

function SWEP:SecondaryAttack()
	if self:GetLantern_HudAlpha() < 0 then
		self:SetLantern_HudAlpha(CurTime())
	else
		self:SetLantern_HudAlpha(-CurTime())
	end
	self:SetNextSecondaryFire(CurTime()+2)
end


/*---------------------------------------------------
						Think
		 Used to draw the light and remove oil
---------------------------------------------------*/

function SWEP:Think()
	if self:GetLantern_Holstered() == false then
		if CLIENT then
			local ent = LocalPlayer():GetShootPos()
			local pos = ent
				pos = pos + LocalPlayer():GetForward() * 30
				pos = pos + LocalPlayer():GetRight() * 5
				pos = pos + LocalPlayer():GetUp() * -20
				
			local dlight = DynamicLight( LocalPlayer():EntIndex() )
			if ( dlight ) then
				dlight.pos = pos
				dlight.r = 255
				dlight.g = 128
				dlight.b = 0
				dlight.brightness = 2
				dlight.Decay = 256
				dlight.Size = math.min	(256,(CurTime()-self:GetLantern_LightSize())*200)
				dlight.DieTime = CurTime() + 1
			end
		end
		if self:GetLantern_EnableTime() < CurTime() then
			self.Owner:SetNWFloat("LanternOil",self.Owner:GetNWFloat("LanternOil")-1)
			self:SetLantern_EnableTime(CurTime()+1)
		end
	end
	
	self.MyOwner = self.Owner
	if self.Owner != nil then
		self.WorldModel = self.WorldModelHold
	else
		self.WorldModel = self.WorldModelDrop
	end	
	
	if self:GetLantern_Holstered() == false && self.Owner:GetNWFloat("LanternOil") < 1 then
		self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
		self:SetLantern_Holstered(true)
		self:SetLantern_EnableTime(0)
		self:EmitSound("lantern/lantern_off.wav")
		self.Owner:GetViewModel():SetSkin(0)
	end
	if self.Owner:GetNWFloat("LanternOil") > self.LanternOil then
		self.Owner:SetNWFloat("LanternOil",self.LanternOil)
	end
end


/*---------------------------------------------------
					Draw HUD
---------------------------------------------------*/

function SWEP:DrawHUD()
	-- Variables for checking different screen sizes and scaling according to them
	local scale_width 	= 1600
	local scale_height 	= 900
	local MultW 		= ScrW() / scale_width
	local MultH 		= ScrH() / scale_height
	
	-- Health bar style oil bar variables
	local oil_bar = LocalPlayer():GetNWFloat("LanternOil")/self.LanternOil
	local iheight = ((256)*MultH) * oil_bar
	local icharge = (oil_bar)
	
	-- Alpha Calculation
	local alpha
	if LocalPlayer():GetActiveWeapon():GetLantern_HudAlpha() > 0 then
		alpha = math.Clamp((CurTime()-LocalPlayer():GetActiveWeapon():GetLantern_HudAlpha())*200,0,255)
	else
		alpha = math.Clamp((255-(LocalPlayer():GetActiveWeapon():GetLantern_HudAlpha()+CurTime())*200),0,255)
	end
	
	-- The Actual drawing
	surface.SetDrawColor(255,255,255,alpha) 
	surface.SetMaterial( Material( "vgui/hud_oil" )	)
	surface.DrawTexturedRectUV( ScrW()-(126*MultW), ScrH()-((224)*MultH*icharge)-(32*MultH), ((124-32)*MultW), ((224)*MultH*(oil_bar)), 0, 1-oil_bar, 1, 1 )

	surface.SetDrawColor(255,255,255,alpha) 
	surface.SetMaterial( Material( "vgui/hud_oil_border" )	)
	surface.DrawTexturedRect( ScrW()-(144*MultW), ScrH()-(272*MultH), 128*MultW, 256*MultH ) 
end


/*---------------------------------------------------
					Hooks
  Set oil on spawn and disable picking up to avoid
		exploiting HL2's holster system
---------------------------------------------------*/

hook.Add("PlayerSpawn","LanternOilSpawn",function(ply)
	ply:SetNWFloat("LanternOil",0)
end)

hook.Add("AllowPlayerPickup","LanternOilPickupProps",function(ply, ent)
	if IsValid(ply) && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "buu_lantern_oil" && ply:GetActiveWeapon():GetLantern_Holstered() == false then return false end
end)