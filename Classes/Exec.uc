class Exec extends Emitter;

//UT2004 Textures
#exec OBJ LOAD FILE=AW-2k4XP.utx
#exec OBJ LOAD FILE=AW-2004Particles.utx
#exec OBJ LOAD FILE=AW-2004Explosions.utx
#exec OBJ LOAD FILE=EmitterTextures.utx
#exec OBJ LOAD FILE=EpicParticles.utx
#exec OBJ LOAD FILE=ExplosionTex.utx
#exec OBJ LOAD FILE=XEffectMat.utx
#exec OBJ LOAD FILE=BarrensTerrain.utx
#exec OBJ LOAD FILE=VMParticleTextures.utx
#exec OBJ LOAD FILE=ONSstructureTextures.utx
#exec OBJ LOAD FILE=H_E_L_Ltx.utx
#exec OBJ LOAD FILE=AS_FX_TX.utx

//UT2004 Sounds
#exec OBJ LOAD FILE=GeneralAmbience.uax
#exec OBJ LOAD FILE=VMVehicleSounds-S.uax
#exec OBJ LOAD FILE=IndoorAmbience.uax

//DWeather
#exec OBJ LOAD FILE="..\StaticMeshes\DWeather-smesh.usx"

//fpsMonsterPack Files
#exec OBJ LOAD FILE=fpsMonTex.utx
#exec OBJ LOAD FILE=fpsMonAnim.ukx
#exec OBJ LOAD FILE=fpsMonMesh.usx

//Import Images
#exec TEXTURE IMPORT FILE="Images\FireFlare.dds" NAME="FireFlare"
#exec TEXTURE IMPORT FILE="Images\FireFlareG.dds" NAME="FireFlareG"
#exec TEXTURE IMPORT FILE="Images\InfernalBlueFire.tga" NAME="AeBlueGas"
#exec TEXTURE IMPORT FILE="Images\InfernalRedFire.tga" NAME="AeRedGas"
#exec TEXTURE IMPORT FILE="Images\blueFlare.dds" NAME="blueFlare"
#exec TEXTURE IMPORT FILE="Images\MechTitanDetail.bmp" NAME="MechTitanDetail"
#exec TEXTURE IMPORT FILE="Images\ChuckedFire.pcx" NAME="ChuckedFire"
#exec TEXTURE IMPORT FILE="Images\FireLifeMap.pcx" NAME="FireLifeMap"

//Import Sounds
#exec AUDIO IMPORT FILE="sounds\BenderShot.WAV" NAME="BenderShot"
#exec AUDIO IMPORT FILE="sounds\vaseB1.WAV" NAME="vaseB1"
#exec AUDIO IMPORT FILE="sounds\Fire.WAV" NAME="Fire"
#exec AUDIO IMPORT FILE="sounds\ds1.wav" Name="ds1"
#exec AUDIO IMPORT FILE="sounds\ds2.wav" Name="ds2"
#exec AUDIO IMPORT FILE="sounds\hs1.wav" Name="hs1"
#exec AUDIO IMPORT FILE="sounds\hs2.wav" Name="hs2"
#exec AUDIO IMPORT FILE="sounds\SoundGroup0.wav" Name="SoundGroup0"
#exec AUDIO IMPORT FILE="sounds\combolite.WAV" NAME="combolite"
#exec AUDIO IMPORT FILE="sounds\pain100.WAV" NAME="pain100"
#exec AUDIO IMPORT FILE="sounds\WraithsScream.WAV" NAME="WraithsScream"
#exec AUDIO IMPORT FILE="sounds\Wraithshitsound.WAV" NAME="Wraithshitsound"
#exec AUDIO IMPORT FILE="sounds\Wraithsfire.WAV" NAME="Wraithsfire"
#exec AUDIO IMPORT FILE="sounds\flaugh3.WAV" NAME="flaugh3"
#exec AUDIO IMPORT FILE="sounds\flaugh1.WAV" NAME="flaugh1"
#exec AUDIO IMPORT FILE="sounds\WraithFireS.WAV" NAME="WraithFireS"
#exec AUDIO IMPORT FILE="sounds\roardie.wav" Name="roardie"
#exec AUDIO IMPORT FILE="sounds\horrorfinal2.wav" Name="horrorfinal2"
#exec AUDIO IMPORT FILE="sounds\MechScreech.wav" NAME="MechScreech"
#exec AUDIO IMPORT FILE="sounds\train_coupling.wav" NAME="train_coupling"
#exec AUDIO IMPORT FILE="sounds\teleprt3.wav" NAME="teleprt3" GROUP="Oneshot"
#exec AUDIO IMPORT FILE="sounds\infgrowl04e.wav" NAME="infgrowl04e"
#exec AUDIO IMPORT FILE="sounds\infgrowl02.wav" NAME="infgrowl02"
#exec AUDIO IMPORT FILE="sounds\infgrowl05e.wav" NAME="infgrowl05e"
#exec AUDIO IMPORT FILE="sounds\infgrowl01.wav" NAME="infgrowl01"
#exec AUDIO IMPORT FILE="sounds\InfernalRoar.wav" NAME="InfernalRoar"
#exec AUDIO IMPORT FILE="sounds\RockMonsterRoarv3.wav" NAME="RockMonsterRoarv3"
#exec AUDIO IMPORT FILE="sounds\chant.wav" NAME="chant" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\idlemilkrox.wav" NAME="idlemilkrox" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\idlemooserox.wav" NAME="idlemooserox" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\idlemeow.wav" NAME="idlemeow" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\idleburp.wav" NAME="idleburp" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\ucantkillme.wav" NAME="ucantkillme" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\areutrying2killme.wav" NAME="areutrying2killme" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\die.wav" NAME="die" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\goodbye.wav" NAME="goodbye" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\usuck.wav" NAME="usuck" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\hello.wav" NAME="hello" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\plzgoaway.wav" NAME="plzgoaway" GROUP=BlueFlame
#exec AUDIO IMPORT FILE="sounds\urdeadson.wav" NAME="urdeadson" GROUP=BlueFlame

//Bender Sounds
#exec AUDIO IMPORT FILE="sounds\fuaaaaagh.wav" NAME="fuaaaaagh"
#exec AUDIO IMPORT FILE="sounds\FFGrudge.wav" NAME="FFGrudge"
#exec AUDIO IMPORT FILE="sounds\FFKilledFather.wav" NAME="FFKilledFather"
#exec AUDIO IMPORT FILE="sounds\FFKillFriends.wav" NAME="FFKillFriends"
#exec AUDIO IMPORT FILE="sounds\FFLawsuit.wav" NAME="FFLawsuit"
#exec AUDIO IMPORT FILE="sounds\FFLookBad.wav" NAME="FFLookBad"
#exec AUDIO IMPORT FILE="sounds\FFOhMyGod.wav" NAME="FFOhMyGod"
#exec AUDIO IMPORT FILE="sounds\FFOuchOhHey.wav" NAME="FFOuchOhHey"
#exec AUDIO IMPORT FILE="sounds\FFThankYou.wav" NAME="FFThankYou"
#exec AUDIO IMPORT FILE="sounds\FFWhatTheHell.wav" NAME="FFWhatTheHell"
#exec AUDIO IMPORT FILE="sounds\fumonster.wav" NAME="fumonster"
#exec AUDIO IMPORT FILE="sounds\futhepain.wav" NAME="futhepain"
#exec AUDIO IMPORT FILE="sounds\ORDWhoa.wav" NAME="ORDWhoa"
#exec AUDIO IMPORT FILE="sounds\OTHClass.wav" NAME="OTHClass"
#exec AUDIO IMPORT FILE="sounds\OTHImBoned.wav" NAME="OTHImBoned"
#exec AUDIO IMPORT FILE="sounds\OTHLiesAndSlander.wav" NAME="OTHLiesAndSlander"
#exec AUDIO IMPORT FILE="sounds\OTHPointless.wav" NAME="OTHPointless"
#exec AUDIO IMPORT FILE="sounds\OTHPrizeCash.wav" NAME="OTHPrizeCash"
#exec AUDIO IMPORT FILE="sounds\OTHSuccessful.wav" NAME="OTHSuccessful"
#exec AUDIO IMPORT FILE="sounds\OTHTerribleShame.wav" NAME="OTHTerribleShame"
#exec AUDIO IMPORT FILE="sounds\OTHTired.wav" NAME="OTHTired"
#exec AUDIO IMPORT FILE="sounds\OTHUhOh.wav" NAME="OTHUhOh"
#exec AUDIO IMPORT FILE="sounds\OTHUpToHere.wav" NAME="OTHUpToHere"
#exec AUDIO IMPORT FILE="sounds\OTHWhatGonnaDo.wav" NAME="OTHWhatGonnaDo"
#exec AUDIO IMPORT FILE="sounds\OTHWheredUGo.wav" NAME="OTHWheredUGo"
#exec AUDIO IMPORT FILE="sounds\OTHWhoaMama.wav" NAME="OTHWhoaMama"
#exec AUDIO IMPORT FILE="sounds\TTBoneHead.wav" NAME="TTBoneHead"
#exec AUDIO IMPORT FILE="sounds\TTBringItOn.wav" NAME="TTBringItOn"
#exec AUDIO IMPORT FILE="sounds\TTCantLose.wav" NAME="TTCantLose"
#exec AUDIO IMPORT FILE="sounds\TTCoffinStuffers.wav" NAME="TTCoffinStuffers"
#exec AUDIO IMPORT FILE="sounds\TTColossalAss.wav" NAME="TTColossalAss"
#exec AUDIO IMPORT FILE="sounds\TTCompareLives.wav" NAME="TTCompareLives"
#exec AUDIO IMPORT FILE="sounds\TTCorpse.wav" NAME="TTCorpse"
#exec AUDIO IMPORT FILE="sounds\TTCrowdWild.wav" NAME="TTCrowdWild"
#exec AUDIO IMPORT FILE="sounds\TTCruel.wav" NAME="TTCruel"
#exec AUDIO IMPORT FILE="sounds\TTGetLost.wav" NAME="TTGetLost"
#exec AUDIO IMPORT FILE="sounds\TTGoodNight.wav" NAME="TTGoodNight"
#exec AUDIO IMPORT FILE="sounds\TTHurtSomeone.wav" NAME="TTHurtSomeone"
#exec AUDIO IMPORT FILE="sounds\TTKillEverybody.wav" NAME="TTKillEverybody"
#exec AUDIO IMPORT FILE="sounds\TTLaughing.wav" NAME="TTLaughing"
#exec AUDIO IMPORT FILE="sounds\TTLightWeight.wav" NAME="TTLightWeight"
#exec AUDIO IMPORT FILE="sounds\TTPimple.wav" NAME="TTPimple"
#exec AUDIO IMPORT FILE="sounds\TTRadical.wav" NAME="TTRadical"
#exec AUDIO IMPORT FILE="sounds\TTYoMama.wav" NAME="TTYoMama"
#exec AUDIO IMPORT FILE="sounds\ACKTedious.wav" NAME="ACKTedious"






defaultproperties
{

}