$modelname "weapons\w_oil.mdl"

$bodygroup "studio"
{
	studio "reference.smd"
}

$cdmaterials "models\weapons\buu\"

$surfaceprop	"metal"

$contents "solid"

$hboxset "default"

$sequence idle	"reference.smd" loop fps 1

$collisionmodel	"reference.smd" { 
	$automass
}

$keyvalues
{
   "prop_data"
   {
       "base"  "Metal.Small"
   }
}