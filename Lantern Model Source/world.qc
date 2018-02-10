$modelname "weapons\w_lantern.mdl"

$bodygroup "studio"
{
	studio "world.smd"
}

$cdmaterials "models\weapons\buu\"

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