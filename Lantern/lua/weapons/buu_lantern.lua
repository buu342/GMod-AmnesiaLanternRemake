/*---------------------------------
Created with buu342s Swep Creator
---------------------------------*/

SWEP.PrintName 		= "Lantern"
    
SWEP.Author 		= "Buu342"
SWEP.Contact 		= "Buu342@hotmail"
SWEP.Purpose 		= "Light up dark areas"
SWEP.Instructions 	= "Equip to use."

SWEP.Category 		= "Lantern"

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.AdminOnly 		= false

SWEP.ViewModelFOV 	= 54
SWEP.ViewModel 		= "models/weapons/c_lantern.mdl" 
SWEP.WorldModel 	= "models/weapons/w_lantern.mdl"
SWEP.WorldModelHold = "models/weapons/c_lantern.mdl" 	-- Jiggly Worldmodel for when being held by player
SWEP.WorldModelDrop	= "models/weapons/w_lantern.mdl"	-- Non Jiggly Worldmodel with physics for when dropped.

SWEP.ViewModelFlip 	= false

SWEP.AutoSwitchTo 	= false
SWEP.AutoSwitchFrom = false

SWEP.Slot 			= 0
SWEP.SlotPos 		= 0

SWEP.Primary.Ammo 	= ""
SWEP.Secondary.Ammo = ""
SWEP.Primary.ClipSize 	= -1
SWEP.Secondary.ClipSize = -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Secondary.DefaultClip 	= -1
 
SWEP.UseHands 		= true

SWEP.HoldType 		= "Pistol" 

SWEP.DrawCrosshair 	= false
SWEP.DrawAmmo 		= false

SWEP.Base 			= "weapon_base"

SWEP.Primary.Automatic 		= false 
SWEP.Secondary.Automatic 	= false

SWEP.WepSelectIcon 	= "VGUI/entities/buu_lantern"	--Weapon Select Icon


/*---------------------------------------------------
				  SetupDataTables
				Networked Variables
---------------------------------------------------*/

function SWEP:SetupDataTables()
    self:NetworkVar("Bool",0,"Lantern_Holstered")	-- Has the lantern been lowered (as in not emitting light)? Used for toggling between modes.
	self:NetworkVar("Bool",1,"Lantern_Equipped")	-- Is the lantern equipped (as in selected and being used)? Used for setting the worldmodel.
	self:NetworkVar("Float",0,"Lantern_LightSize")	-- Used to give the effect of the light increasing in size when deployed
end


/*---------------------------------------------------
					Initialize
---------------------------------------------------*/

function SWEP:Initialize()
	self:SetLantern_Holstered(true)
	self:SetHoldType(self.HoldType)
	self:SetLantern_Equipped(false)
	self.WorldModel = self.WorldModelDrop
end


/*---------------------------------------------------
					Deploy
---------------------------------------------------*/
	
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE_LOWERED )
	self:SetLantern_LightSize(CurTime())
	self:SetLantern_Equipped(true)
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
	if self:GetNextPrimaryFire() > CurTime() then return end
	if self:GetLantern_Holstered() == true then
		self:SetLantern_LightSize(CurTime())
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self:EmitSound("lantern/lantern_on.wav")
		self:SetLantern_Holstered(false)
		self.Owner:GetViewModel():SetSkin(1)
	else
		self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
		self:SetLantern_Holstered(true)
		self:EmitSound("lantern/lantern_off.wav")
		self.Owner:GetViewModel():SetSkin(0)
	end
	self:SetNextPrimaryFire(CurTime()+1)
end


/*---------------------------------------------------
				Unused functions
---------------------------------------------------*/

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end


/*---------------------------------------------------
					Holster
---------------------------------------------------*/

function SWEP:Holster( wep )
	self:SetLantern_Equipped(false)
	if self:GetLantern_Holstered() == false then
		self:EmitSound("lantern/lantern_off.wav")
	end
	self.Owner:SetNWBool("Lantern_JustHolsteredIt", true)
	return true
end


/*---------------------------------------------------
						Think
				Used to draw the light
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
	end
	self.MyOwner = self.Owner
	if self.Owner != nil then
		self.WorldModel = self.WorldModelHold
	else
		self.WorldModel = self.WorldModelDrop
	end
end


/*---------------------------------------------------
				Custom Viewmodel Sway
---------------------------------------------------*/

SWEP.RunArmOffset= Vector(0, 0, 0)				-- For realism
SWEP.RunArmAngle = Vector(-5.417, -5.654, 0)	-- REELIZM

SWEP.BobScale = 0  -- Real men code their own bob
SWEP.SwayScale = 2 -- I'm too lazy to code my own sway, plus this one works just fine soooooo....

SWEP.CrouchPos = Vector(-2,-2,-1) -- Moves the gun when you crouch for realism

if CLIENT then
	local TestVector = Vector(0,0,0)
	local TestVectorAngle = Vector(0,0,0)
	local TestVector2 = Vector(0,0,0)
	local TestVectorAngle2 = Vector(0,0,0)
	local TestVectorTarget = Vector(0,0,0)
	local TestVectorAngleTarget = Vector(0,0,0)
	local CrouchAng=0
	local CrouchAng2=0
	local Current_Aim = Angle(0,0,0)
	local Last_Aim = Angle(0,0,0)
	function SWEP:GetViewModelPosition(pos, ang)
		if !IsValid(self.Owner) then return end
		local ply = LocalPlayer()
		local weapon = ply:GetActiveWeapon()
		local walkspeed = self.Owner:GetVelocity():Length() 
		
        TestVector = LerpVector(5*FrameTime(),TestVector,TestVectorTarget) 
        TestVectorAngle = LerpVector(5*FrameTime(),TestVectorAngle,TestVectorAngleTarget)
		
		ang:RotateAroundAxis(ang:Right(),TestVectorAngle.x  )
		ang:RotateAroundAxis(ang:Up(),TestVectorAngle.y )
		ang:RotateAroundAxis(ang:Forward(),TestVectorAngle.z)
		
		pos = pos + TestVector.z * ang:Up()
		pos = pos + TestVector.y * ang:Forward()
		pos = pos + TestVector.x * ang:Right()
		if !IsValid(self.Owner) then return end
		
		local walkspeed = self.Owner:GetVelocity():Length() 
		if self.Owner:KeyDown(IN_SPEED) && !self.Owner:Crouching() && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then 
            TestVectorTarget = self.RunArmOffset
            TestVectorAngleTarget = self.RunArmAngle
		elseif self.Owner:Crouching() then
			TestVectorTarget = self.CrouchPos
            TestVectorAngleTarget = Vector(0,0,0)
		else
            TestVectorTarget = Vector(0,0,0)
            TestVectorAngleTarget = Vector(0,0,0)
        end
		
		local BreatTime = RealTime() * walkspeed/200
		local MoveForce = CalcMoveForce(LocalPlayer())
		TestVectorTarget = TestVectorTarget + Vector(0 ,0 , 0- math.Clamp(self.Owner:GetVelocity().z / 100,-3,3))
        
		--	Current_Aim = LerpAngle(0.1,Current_Aim,ply:GetAngles())
		--ply:ChatPrint(tostring(Current_Aim))
		
        -- I don't like the way I made this. I REALLY need to redo this part
        -- Be wary of tears
		-- BreatheSpeed -> Bigger = Faster
		-- BreatheAmplitude -> Bigger = Smaller amplitude
		if (self.Owner:IsOnGround() && self.Owner:Crouching() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT))) then
			BreatheSpeed = 10
			BreatheAmplitude = 3
        elseif self.Owner:IsOnGround() && !self.Owner:KeyDown(IN_WALK) && !self.Owner:KeyDown(IN_SPEED) && !self.Owner:Crouching() && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			BreatheSpeed = 16
			BreatheAmplitude = 0.9
		elseif self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_WALK)|| self.Owner:Crouching())&& !self.Owner:KeyDown(IN_SPEED) && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			BreatheSpeed = 10
			BreatheAmplitude = 3
		elseif self.Owner:IsOnGround() && self.Owner:KeyDown(IN_SPEED) && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			BreatheSpeed = 20
			BreatheAmplitude = 0.3
		elseif self.Owner:IsOnGround() && walkspeed < 1 && !self.Owner:Crouching() then
			BreatheSpeed = 1
			BreatheAmplitude =  7
        else
            BreatheSpeed = 0
			BreatheAmplitude =  100000
		end
		
		local BreatTime = RealTime() * BreatheSpeed
		local MoveForce = CalcMoveForce(ply)
			
		TestVectorAngleTarget = TestVectorAngleTarget - Vector(math.cos(BreatTime) / BreatheAmplitude, (math.cos(BreatTime / 2) / BreatheAmplitude),0)
		--ang = ang + (ang - Current_Aim*-1)
		return pos, ang
	end
end

function CalcMoveForce(ply)
    if !IsValid(LocalPlayer()) then return end
    local weapon = ply:GetActiveWeapon()
    MoveForce = ply:GetFOV()
    if !ply:Crouching() then
        if IsValid(weapon) then
            MoveForce = ply:GetFOV() * 10
        else
            MoveForce = ply:GetFOV() * 50
        end
    else
        MoveForce = ply:GetFOV() * 120
    end
   
    return MoveForce
end


/*---------------------------------------------------
				Draw Weapon Selection
---------------------------------------------------*/

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
    surface.SetDrawColor( 255, 255, 255, alpha )
    surface.SetTexture( surface.GetTextureID(self.WepSelectIcon) )
    y = y + 20
    x = x + 40
    wide = wide - 30
    surface.DrawTexturedRect( x, y, wide/1.5, tall/1.5 )
end


/*---------------------------------------------------
				Draw World Model
		Handle drawing the jiggly model and skins
---------------------------------------------------*/

function SWEP:DrawWorldModel()

	if self:GetLantern_Holstered() == false then
		self:SetSkin(1)
	else
		self:SetSkin(0)
	end
	
	self:DrawModel()
end


/*---------------------------------------------------
					On Drop
		Stop using jiggly model when dropped.
  Had to make my own drop code because fuck me :))))
---------------------------------------------------*/

function SWEP:OnDrop()
	self:SetLantern_Equipped(false)
	self:SetLantern_Holstered(true)
	self.MyOwner:SetNWBool("Lantern_JustHolsteredIt", true)
	local ent = ents.Create( self:GetClass() )
	
	ent:SetPos( self:GetPos()+self:GetForward()*5 )
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent.Pickupable = false
	timer.Simple(1,function() if !IsValid(ent) then return end ent.Pickupable = true end)
	
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter(self:GetVelocity())
	ent:SetLocalAngularVelocity(self:GetLocalAngularVelocity())
	self:Remove()
end

/*---------------------------------------------------
					Hooks
Manipulate the hand bones to hold the lantern like a
			lantern and not a gun
---------------------------------------------------*/

hook.Add("PlayerSpawn","LanternHandFixSpawn",function(ply)
	ply.PModel = ply:GetModel() -- In case a player changed model, reset the bones and fix the hands again.
	ply:SetNWBool("Lantern_JustHolsteredIt", false)
end)

hook.Add("Think","LanternHandFixThink",function()
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) && IsValid(v:GetActiveWeapon()) && (v:GetActiveWeapon():GetClass() == "buu_lantern" || v:GetActiveWeapon():GetClass() == "buu_lantern_oil") then
			
			-- Only Manipulate bones if we HAVE to.
			local bonetotest = "ValveBiped.Bip01_R_Hand"
			if v:LookupBone(bonetotest) != nil && v:GetManipulateBoneAngles( v:LookupBone(bonetotest) ) != Angle(60,0,-90) then
				v:ManipulateBoneAngles( v:LookupBone(bonetotest), Angle(60,0,-90) )
			end
			
			bonetotest = "ValveBiped.Bip01_R_Finger11"
			if v:LookupBone(bonetotest) != nil && v:GetManipulateBoneAngles( v:LookupBone(bonetotest) ) != Angle(0,-65,0) then
				v:ManipulateBoneAngles( v:LookupBone(bonetotest), Angle(0,-65,0) )
			end
		else
			-- Reset the bones when the model changes. Here to fix use of the Enhanced PlayerModel Selector
			if v.PModel != v:GetModel() then
				local i
				for i=0, v:GetBoneCount() do
					v:ManipulateBoneAngles( i, Angle(0,0,0) )
				end
				v.PModel = v:GetModel()
			end
			
			-- Reset the bones when the weapon changes.
			if (IsValid(v) && IsValid(v:GetActiveWeapon()) && (v:GetActiveWeapon():GetClass() != "buu_lantern" && v:GetActiveWeapon():GetClass() != "buu_lantern_oil") && v:GetNWBool("Lantern_JustHolsteredIt") == true) then
				local bonetotest = "ValveBiped.Bip01_R_Hand"
				if v:LookupBone(bonetotest) != nil && v:GetManipulateBoneAngles( v:LookupBone(bonetotest) ) != Angle(0,0,0) then
					v:ManipulateBoneAngles( v:LookupBone(bonetotest), Angle(0,0,0) )
				end
				
				bonetotest = "ValveBiped.Bip01_R_Finger11"
				if v:LookupBone(bonetotest) != nil && v:GetManipulateBoneAngles( v:LookupBone(bonetotest) ) != Angle(0,0,0) then
					v:ManipulateBoneAngles( v:LookupBone(bonetotest), Angle(0,0,0) )
				end
				v:SetNWBool("Lantern_JustHolsteredIt", false)
			end
		end
	end
end)

hook.Add( "PlayerCanPickupWeapon", "LanternDropTimer", function( ply, wep )
	if (wep:GetClass() == "buu_lantern" || wep:GetClass() == "buu_lantern_oil") && wep.Pickupable == false then
		return false
	end
end )