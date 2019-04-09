# coreUnrealFirstPersonShooterDemo

This is a Sample project to be used with [coreDS Unreal](https://www.ds.tools/products/hla-dis-unreal-engine-4/) and the [Unreal Engine 4](https://www.unrealengine.com). You can request a free trial on https://www.ds.tools/contact-us/trial-request/

coreDS Unreal must already be installed and activated in order to use this project. The project is compatible with all UE4 releases. Please make sure the coreDS Unreal plugin is enabled.

The Sample project uses the following coreDS concepts:
* Connect
* Disconnect
* Send Update Object (send EntityStatePDU or UpdateAttributeValues, DiscoverObjectInstance)
* Send Message (send a MunitionDetonationPDU or SendInteraction)
* Receive Update Object (Receive EntityStatePDU or UpdateAttributeValues)
* Receive Message (Receive a MunitionDetonationPDU or SendInteraction)
* Delete Objects (EntityStatePDU timeout or RemoveObjectInstance)

## Getting started
The first step is to configure coreDS Unreal to know which objects, object attributes, messages and message parameters your simulator will support. Keep in mind that the name you define are not related to the distributed simulation protocol you plan on using. These names will only be used internally when using BluePrint or the Mapping interface.

You can find that configuration from Edit->Project Settings->coreDS Unreal

In this particular case, the support sending/receiving a GUN object with Location and Orientation property. The demo also supports a GunFired message, with a Location property. 

The format for Object/Message names is NAME.PROPERTY. The Object/Message name is always the part before the first dot. 

![Plugin Configuration Screenshot](/Doc/Images/pluginconfig.png)

Next step is to configure an actual connection with a Distributed Simulation protocol. coreDS supports HLA (High-Level Architecture and DIS (Distributed Interaction Simulation).

You can open the configuration window either by running the game or by click on the coreDS toolbar button.
![Plugin coreDSToolboxMenu Screenshot](/Doc/Images/coreDSToolboxMenu.png)

This sample comes with 4 pre-configured settings:
* DIS_Player1: DIS v6
* DIS_Player2: DIS v6
* HLA_Player1: HLA 1516e with RPRFOM 2.0
* HLA_Player2: HLA 1516e with RPRFOM 2.0

![Plugin ConfigurationSelection Screenshot](/Doc/Images/ConfigurationSelection.png)

Let's take a look at each configuration.

### DIS
For both configurations, it is important to configure the Configured Network Adapter. Click on the dropbox and select your active Network Adapter.

![Plugin DISConnectionConfiguration Screenshot](/Doc/Images/DISConnectionConfiguration.png)

#### Receiving
Even if DIS does not explicitly support Subscription, coreDS supports incoming filtering. First, we must let coreDS knows that we want to receive the EntityStatePDU and the FirePDU.

![Plugin DIS_Receiver_PubSub Screenshot](/Doc/Images/DIS_Receiver_PubSub.png)

Then comes the Mapping configuration. Since we are in a receiver, we care about the "Mapping In"

The first step is to Map a Local Object/Message to a Protocol Object/Message. As you see, the Names you defined during the Plugin configuration are listed in the "+" list. You can then link the Local Object/Message to a Protocol Object/Message by using the drop down m next to the Object/Message name.

![Plugin DISMappingIn_ObjectMapping Screenshot](/Doc/Images/DISMappingIn_ObjectMapping.png)

Then you must map the local properties to the protocol properties. Since we are in a receiving mode, we only care about the values we are interested in. In our case, we want to send back to Unreal the Location and the Orientation.

![Plugin DISMappingIn_WithChoice Screenshot](/Doc/Images/DISMappingIn_WithChoice.png)

Finally, we are receiving coordinations in Geocentric format, which Unreal doesn't like. We could convert the coordinates from within Unreal but by doing so, it will be harder to switch to a different Distributed Simulation Protocol. To keep all the configuration are runtime, we use the embedded Lua scripting engine to convert from Geocentric to flat coordinates centered around a given Lat/Long.

![Plugin DISMappingIn Screenshot](/Doc/Images/DISMappingIn.png)

Below is the script that convert from Geocentric to local coordinates. Scripts are located in /Config/Scripts

```lua
require("lla2ecef")  -- include functions to convert from Lat/Log to geocentric
require("ReferenceLatLongAlt") -- Include the Center Lat/Long

lastPositionX = 0 -- Last received position, used by the Orientation conversion script
lastPositionY = 0
lastPositionZ = 0

function convertPositionFromDIS()  --same function name as the filename
    lastPositionX = DSimLocal.X
    lastPositionY = DSimLocal.Y
    lastPositionZ = DSimLocal.Z

    -- Since we are working over a fairly small part of the planet, we can assume a flat surface
    --convert lat/long to geocentric
    tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

    DSimLocal.X = (tempx - DSimLocal.X)  -- offset to the local coordinates
    DSimLocal.Y = (tempy - DSimLocal.Y)
    DSimLocal.Z = (tempz - DSimLocal.Z)
end
```

#### Sending
Then, we must let coreDS knows that we want to send the EntityStatePDU and the FirePDU.

![Plugin DIS_Sender_PubSub Screenshot](/Doc/Images/DIS_Sender_PubSub.png)

Then comes the Mapping configuration. Since we are in a Sender, we care about the "Mapping Out"

The first step is to Map a Local Object/Message to a Protocol Object/Message. As you see, the Names you defined during the Plugin configuration are listed in the "+" list. You can then link the Local Object/Message to a Protocol Object/Message by using the dropbox next to the Object/Message name.

Then you must map the local properties to the protocol properties. Since we are in a Sender mode, we must fill the complete structure. Static values can be set at this point. We will map Location and Orientation to local properties.

Finally, we are sending coordinations in local format, which DIS doesn't like. We could convert the coordinates from within Unreal but by doing so, it will be harder to swith to a different Distributed Simulation Protocol. To keep all the configuration are runtime, we use the embededded Lua scripting engine to convert from flat coordinates, centered around a given Lat/Long, to Geocentric.

![Plugin DISMappingOut Screenshot](/Doc/Images/DISMappingOut.png)

As for outgoing values, you must set a conversion script to convert from the local coordinates to geocentric coordinates. Scripts are located in /Config/Scripts. 

### HLA
For both configuration, it is important to have a valid FOM File. The sample provide a RPRFOM 2.0 compliant FOM file, located in /Config. Altought this sample is configurated to use a RPRFOM based FOM file, you can load the FOM file of your choice. 

![Plugin HLAConnectionConfiguration Screenshot](/Doc/Images/HLAConnectionConfiguration.png)

coreDS supports a wide range of RTIs, from the legacy DMSO RTI (HLA 1.3) to HLA 1516e compliant RTI like the Pitch RTI or MAK RTI. The complete list of supported RTI can be found here https://www.ds.tools/products/coreds/detailed-features-list/

If you are using the default configuration, you must select a HLA Evolved compliant RTI. 

![Plugin HLAConnectionRTISettings Screenshot](/Doc/Images/HLAConnectionRTISettings.png)

#### Sending
First, we must let coreDS knows that we want to receive the Statial attribute from a LifeForm and the WeaponFire interaction.

![Plugin HLA_Receiver_PubSub Screenshot](/Doc/Images/HLA_Receiver_PubSub.png)

Then comes the Mapping configuration. Since we are in a receiver, we care about the "Mapping In"

The first step is to Map a Local Object/Message to a Protocol Object/Message. As you see, the Names you defined during the Plugin configuration are listed in the "+" list. You can then link the Local Object/Message to a Protocol Object/Message by using the dropbox next to the Object/Message name.

Then you must map the local properties to the protocol properties. Since we are in a receiving mode, we only care about the values we are interested in. In our case, we want to send back to Unreal the Location and the Orientation from the Spatial attribute.

Finally, we are receiving coordinations in Geocentric format, which Unreal doesn't like. We could convert the coordinates from within Unreal but by doing so, it will be harder to swith to a different Distributed Simulation Protocol. To keep all the configuration are runtime, we use the embededded Lua scripting engine to convert from Geocentric to flat coordinates centered around a given Lat/Long.

![Plugin HLAMappingIn_ObjectMapping Screenshot](/Doc/Images/HLAMappingIn_ObjectMapping.png)

Below is the script that convert from Geocentric to local coordinates. Scripts are located in /Config/Scripts


```lua
angleConversions = require("angleConversions")
require("ecef2lla") -- include functions to convert from Lat/Log to geocentric
require("lla2ecef") -- include functions to convert from geocentric to Lat/Log
require("ReferenceLatLongAlt") --Include the center Lat/Long

function convertPositionFromHLA()  --same function name as the filename

--convert orientation
    latTemp, lonTemp, discard = ecef2lla(DSimLocal.WorldLocation.X,DSimLocal.WorldLocation.Y,DSimLocal.WorldLocation.Z)

    local lat = math.rad(latTemp)  --converting to rad because function requires rad
    local lon = math.rad(lonTemp)

    local psi =  DSimLocal.Orientation.Psi-- roll
    local theta = DSimLocal.Orientation.Theta--pitch
    local phi = DSimLocal.Orientation.Phi --yaw

    DSimLocal.Orientation.Psi =  angleConversions.getOrientationFromEuler(lat, lon, psi, theta)
    DSimLocal.Orientation.Theta = angleConversions.getPitchFromEuler(lat, lon, psi, theta)
    DSimLocal.Orientation.Phi = angleConversions.getRollFromEuler(lat, lon, psi, theta, phi)

--- convert position
    -- Since we are working over a fairly small part of the planet, we can assume a flat surface
    --convert lat/long to geocentric
    tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

    --Offset the coordinate to the local area
    DSimLocal.WorldLocation.X = (DSimLocal.WorldLocation.X - tempx)
    DSimLocal.WorldLocation.Y = (DSimLocal.WorldLocation.Y - tempy)
    DSimLocal.WorldLocation.Z = (DSimLocal.WorldLocation.Z - tempz)
end

```

#### Receiving
First, we must let coreDS knows that we want to send the Statial attribute from a LifeForm and the WeaponFire interaction.

![Plugin DIS_Sender_PubSub Screenshot](/Doc/Images/DIS_Sender_PubSub.png)

Then comes the Mapping configuration. Since we are in a Sender, we care about the "Mapping Out"

The first step is to Map a Local Object/Message to a Protocol Object/Message. As you see, the Names you defined during the Plugin configuration are listed in the "+" list. You can then link the Local Object/Message to a Protocol Object/Message by using the dropbox next to the Object/Message name.

Then you must map the local properties to the protocol properties. Since we are in a Sender mode, we must fill the complete structure. Static values can be set at this point. We will map Location and Orientation to local properties.

Finally, we are sending coordinations in local format, which is not compliant witht the RPRFOM Spatial atttribute format. We could convert the coordinates from within Unreal but by doing so, it will be harder to swith to a different Distributed Simulation Protocol. To keep all the configuration are runtime, we use the embededded Lua scripting engine to convert from flat coordinates, centered around a given Lat/Long, to Geocentric.

![Plugin HLAMappingOut Screenshot](/Doc/Images/HLAMappingOut.png)

As for outgoing values, you must set a conversion script to convert from the local coordinates to geocentric coordinates. Scripts are located in /Config/Scripts.

## Connect
At some point, you must instruct your simulator to connect to the Distributed Simulation system (either HLA or DIS). When using DIS, a UDP socket will be created.  When using HLA, a connection to the RTI will be attemped. If supported by the HLA version you are using, a call to connect() will be made, followed with a call to createFederationExecution (this call call be disabled from the HLA configuration) and joinFederationExecution. Once we have joined the Federation, we then set the various required state like time management, publish/subscribe, etc.

From the Level Blueprint:

![Blueprint_Connect Screenshot](/Doc/Images/BlueprintConnect.png)

## Disconnect
When disconnecting, a DIS configuration will close the socket. HLA will call resignFederationExecution and destroyFederationExecution.

From the Level Blueprint:

![Blueprint_Disconnect Screenshot](/Doc/Images/BluePrintDisconnect.png)

## Send Update Object (send EntityStatePDU or UpdateAttributeValues, DiscoverObjectInstance)
Sending an Object Update is fairly simple. You first have to build an array of <Name, Value> pair then use the SendUpdateObject block. All names must match the names configured in the coreDS Unreal plugin.

When using HLA, if this is the first call using that object type, registerObjectInstance will be called, followed by UpdateObjectAttributeValues.

When using DIS, an EntityStatePDU will be sent.

![Blueprint_BluePrintSendObject Screenshot](/Doc/Images/BluePrintSendObject.png)

## Send Message (send a MunitionDetonationPDU or SendInteraction)
Sending an message is fairly simple. You first have to build an array of <Name, Value> pair then use the SendMessage block. All names must match the names configured in the coreDS Unreal plugin.

When using HLA, a call to SendInteraction will be made.

When using DIS, an FirePDU will be sent.

![Blueprint_BluePrintSendMessage Screenshot](/Doc/Images/BluePrintSendMessage.png)

## Receive Update Object (Receive EntityStatePDU or UpdateAttributeValues)
If you want to receive Object updates, you must first register a ObjectUpdateHandler. The registration must be done using object name used in the coreDS Unreal plugin configuration:

![Blueprint_RegisteringObjectUpdateHandler Screenshot](/Doc/Images/BluePrintRegisterObjectUpdateHandler.png)

Then, each time an object of the register type is received, the GunMoved event will be trigged.

In this particular case, we also added some logic to keep a list of discovered object in Unreal. We first look into a map if the discovered object name already exists in the map. If not, a new Actor is spawned, else the Actor instance is updated. That part will most likely need to be updated based on your particular requirement. 

![Blueprint_DiscoverObjectInstance Screenshot](/Doc/Images/BluePrintDiscoverObjectInstance.png)

Below is a screenshot showing how to parse received information. As you will notice, the Property names are the same then the one configurated in the "Getting started" part.

![Blueprint_ReceiveObject Screenshot](/Doc/Images/BluePrintReceiveObject.png)

## Receive Message (Receive a MunitionDetonationPDU or SendInteraction)
If you want to receive a message, you must first register a MessageReceivedHandler:

Then, each time a message of the register type is received, the DetonationReceived event will be trigged.

![Blueprint_ReceiveInteraction Screenshot](/Doc/Images/BluePrintReceiveInteraction.png)

## Delete Objects (EntityStatePDU timeout or RemoveObjectInstance)
At this point, you most likely understood how coreDS Unreal works! Let's add an handler when objects are removed from the Distributed Simulation system. When using DIS, this happen when the EntityStatePDU was not updated for the last 5 seconds (or the configuration value in DIS 7). With HLA, the handler is called when a removeObjectInstance callback is received.

![Blueprint_BlueprintRemoveObject Screenshot](/Doc/Images/BlueprintRemoveObject.png)
