$modelname "weapons\c_lantern.mdl"

$bodygroup "studio"
{
	studio "view.smd"
}

$proceduralbones c_arms_vrd.vrd

$cdmaterials "models\weapons\buu\"
$cdmaterials "models\weapons\buu\lod\"

$texturegroup "lights"
{
    { "handle" "lantern" }
    { "handle" "lantern_on" }
}

$sequence "idle" "anims\idle.smd" {
	fps 60
	"ACT_VM_IDLE" 1
	loop
}

$sequence "draw" "anims\draw.smd" {
	fps 60
	"ACT_VM_DRAW" 1
	snap
}

$sequence "holster" "anims\holster.smd" {
	fps 60
	"ACT_VM_HOLSTER" 1
	snap
}

$sequence "idle_holstered" "anims\idle_holster.smd" {
	fps 60
	"ACT_VM_IDLE_LOWERED" 1
	snap
}

$jigglebone "Lantern" {
	is_rigid {
		yaw_constraint 0 0
		// pitch_constraint -30 90 // Old
		pitch_constraint -60 89
		length 100
		tip_mass 3000
	} 
}

$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_L_Clavicle"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Wrist"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Wrist"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"

$lod 15
{
	replacemodel "view.smd" "view_lod1.smd"
}

$lod 30
{
	replacemodel "view.smd" "view_lod2.smd"
	replacematerial "handle" "handle_LOD2"
	replacematerial "lantern" "lantern_LOD2"
}

$lod 45
{
	replacemodel "view.smd" "view_lod3.smd"
	replacematerial "handle" "handle_LOD3"
	replacematerial "lantern" "lantern_LOD3"
}

$lod 60
{
	replacemodel "view.smd" "view_lod4.smd"
	replacematerial "handle" "handle_LOD3"
	replacematerial "lantern" "lantern_LOD3"
}

$shadowlod
{
	replacemodel "view.smd" "view_lod2.smd"
	replacematerial "handle" "handle_LOD2"
	replacematerial "lantern" "lantern_LOD2"
}