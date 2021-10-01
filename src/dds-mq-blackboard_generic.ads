with DDS.Treats_Generic;
private with DDS.Topic;
private with Dds.DomainParticipant;
private with Ada.Finalization;
generic
   with package Treats is new DDS.Treats_Generic (<>);
package Dds.Mq.BlackBoard_Generic is
   type Ref is tagged limited private;
   type Ref_Access is access all Ref'Class;
private
   type Ref is new Ada.Finalization.Limited_Controlled with record
      Participant : DDS.DomainParticipant.Ref_Access;
      Topic       : DDS.Topic.Ref_Access;
   end record;
end Dds.Mq.BlackBoard_Generic;
