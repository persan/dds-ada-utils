pragma Ada_2012;
package body Dds.Mk4_Request_Response.Requester_Generic is

   ------------
   -- Create --
   ------------

   function Create
     (Topic_Base_Name : DDS.String;
      Participant     : not null DDS.DomainParticipant.Ref_Access;
      Publisher       : DDS.Publisher.Ref_Access  := null;
      Subscriber      : DDS.Subscriber.Ref_Access := null;
      Request_QoS     : access DDS.DataReaderQoS  := null;
      Reply_QoS       : access DDS.DataWriterQos  := null) return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Topic_Base_Name : DDS.String;
      Participant     : not null DDS.DomainParticipant.Ref_Access;
      Publisher       : DDS.Publisher.Ref_Access  := null;
      Subscriber      : DDS.Subscriber.Ref_Access := null;
      Library         : DDS.String;
      Profile         : DDS.String) return Ref_Access
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (S : in out Ref_Access) is
   begin
      pragma Compile_Time_Warning (Standard.True, "Finalize unimplemented");
      raise Program_Error with "Unimplemented procedure Finalize";
   end Finalize;

end Dds.Mk4_Request_Response.Requester_Generic;
