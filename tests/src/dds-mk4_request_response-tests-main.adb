with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;
with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with DDS.Topic;
with GNATCOLL.Opt_Parse;    use GNATCOLL.Opt_Parse;
with Dds.Mq.Tests.Args;
procedure Dds.Mk4_Request_Response.Tests.Main is
   use Dds.Mq.Tests.Args;

   Factory     : constant not null DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;

   Participant : constant not null DDS.DomainParticipant.Ref_Access := Factory.Create_Participant_With_Profile
     (Domain_Id    => Domain_Id.Get,
      Library_Name => +Library_Name.Get,
      Profile_Name => +Profile_Name.Get);

   R : aliased Responder.Ref_Access;

begin
   R := Responder.Create (Topic_Base_Name => +Topic_Name.Get, Participant => Participant);
   delay 10.0;
   Responder.Finalize (R);
end Dds.Mk4_Request_Response.Tests.Main;
