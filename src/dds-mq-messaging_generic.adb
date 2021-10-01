pragma Ada_2012;
package body Dds.Mq.Messaging_Generic is

   ---------------------
   -- Get_Participant --
   ---------------------

   function Get_Participant
     (Self : not null access Ref) return DDS.DomainParticipant.Ref_Access
   is
   begin
      return Self.Participant;
   end Get_Participant;

   ---------------
   -- Get_Topic --
   ---------------

   function Get_Topic (Self : not null access Ref) return DDS.Topic.Ref_Access
   is
   begin
      return Self.Topic;
   end Get_Topic;

end Dds.Mq.Messaging_Generic;
