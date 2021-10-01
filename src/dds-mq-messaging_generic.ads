with DDS.Treats_Generic;
with DDS.Topic;
with Dds.DomainParticipant;
private with Ada.Finalization;
generic
   with package Treats is new DDS.Treats_Generic (<>);
package Dds.Mq.Messaging_Generic is
   type Ref is tagged limited private;
   type Ref_Access is access all Ref'Class;

   function Get_Participant (Self : not null access Ref) return DDS.DomainParticipant.Ref_Access;
   function Get_Topic (Self : not null access Ref) return DDS.Topic.Ref_Access;

private
   type Ref is new Ada.Finalization.Limited_Controlled with record
      Participant : DDS.DomainParticipant.Ref_Access;
      Topic       : DDS.Topic.Ref_Access;
   end record;
end Dds.Mq.Messaging_Generic;
