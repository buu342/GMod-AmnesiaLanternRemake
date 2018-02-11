$modelname "weapons\w_lantern.mdl"

$bodygroup "studio"
{
	studio "world.smd"
}

$cdmaterials "models\weapons\buu\"
$cdmaterials "models\weapons\buu\lod\"

$texturegroup "lights"
{
    { "handle" "lantern" }
    { "handle" "lantern_on" }
}

$surfaceprop	"metal"

$contents "solid"

$hboxset "default"

$sequence idle	"world.smd" loop fps 1

$collisionmodel	"world.smd" { 
	$automass
}

$keyvalues
{
   "prop_data"
   {
       "base"  "Metal.Medium"
   }
}

$lod 15
{
	replacemodel "world.smd" "world_lod1.smd"
}

$lod 30
{
	replacemodel "world.smd" "world_lod2.smd"
	replacematerial "handle" "handle_LOD2"
	replacematerial "lantern" "lantern_LOD2"
	replacematerial "lantern_on" "lantern_on_LOD2"
}

$lod 45
{
	replacemodel "world.smd" "world_lod3.smd"
	replacematerial "handle" "handle_LOD3"
	replacematerial "lantern" "lantern_LOD3"
	replacematerial "lantern_on" "lantern_on_LOD3"
}

$lod 60
{
	replacemodel "world.smd" "world_lod4.smd"
	replacematerial "handle" "handle_LOD3"
	replacematerial "lantern" "lantern_LOD3"
	replacematerial "lantern_on" "lantern_on_LOD3"
}

$shadowlod
{
	replacemodel "world.smd" "world_lod2.smd"
	replacematerial "handle" "handle_LOD2"
	replacematerial "lantern" "lantern_LOD2"
	replacematerial "lantern_on" "lantern_on_LOD3"
}