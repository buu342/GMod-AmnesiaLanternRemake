AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Oil"
ENT.Author = "Buu342"
ENT.Information = "Oil to fill your lantern with."
ENT.Category = "Lantern"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.GiveOil = 75 -- How many seconds of oil does the entity give?

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 1 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel( "models/weapons/w_oil.mdl" )

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Entity:DrawShadow(true)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

end

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		local wep
		if activator:HasWeapon("buu_lantern_oil") then
			wep = activator:GetWeapon( "buu_lantern_oil" ).LanternOil
		else
			wep = activator:GetNWFloat("LanternOil")+self.GiveOil
		end
		activator:SetNWFloat("LanternOil",math.min(wep,activator:GetNWFloat("LanternOil")+self.GiveOil))
	end
	self:EmitSound("lantern/oil.wav")
	self:Remove()
end