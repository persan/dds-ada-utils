pragma Ada_2012;
with DDS.DataWriter;
with DDS.TopicDescription;
with Dds.DomainParticipantFactory;
package body Dds.Mq.Simple_Messaging_Generic.Client_Generic is

   function Create
     (Topic_Name  : Dds.String;
      Domain_Id   : DomainId_T := 0) return Ref_Access
   is
      Participant : DDS.DomainParticipant.Ref_Access;
      QoS         : DDS.DomainParticipantQos;
   begin
      Get_DomainParticipant_Qos (QoS);
      Participant := Factory.Create_Participant (Domain_Id, QoS);
      return Create (Participant,  Topic_Name);
   end;

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Topic_Name  : Dds.String) return Ref_Access is
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos;
   begin
      Get_Topic_Qos (Topic_QoS, Topic_Name);
      Get_DataWriter_Qos (Writer_QoS, Topic_Name);
      return Create (Participant  => Participant,
                     Topic_Name   => Topic_Name,
                     Topic_QoS    => Topic_QoS,
                     Writer_QoS   => Writer_QoS);
   end;

   ------------
   -- Create --
   ------------
   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Topic_Name  : Dds.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos) return Ref_Access
   is
   begin
      return Create (Participant, Participant.Get_Implicit_Publisher, Topic_Name, Topic_QoS, Writer_QoS);
   end Create;

   -------------------------
   -- Create_With_Profile --
   -------------------------

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Topic_Name   : Dds.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
   begin
      return Create_With_Profile (Participant, Participant.Get_Implicit_Publisher, Topic_Name, Library_Name, Profile_Name);
   end Create_With_Profile;

   ------------
   -- Create --
   ------------

   function Create
     (Publisher   : not null DDS.Publisher.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos)
      return Ref_Access
   is
   begin
      return Create (Publisher.Get_Participant, Publisher, Topic_Name, Topic_QoS, Writer_QoS);
   end Create;

   -------------------------
   -- Create_With_Profile --
   -------------------------

   function Create_With_Profile
     (Publisher    : not null DDS.Publisher.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
   begin
      return Create_With_Profile (Publisher.Get_Participant, Publisher, Topic_Name, Library_Name, Profile_Name);
   end Create_With_Profile;

   ------------
   -- Create --
   ------------

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Publisher   : not null DDS.Publisher.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos)
      return Ref_Access
   is
      use type Dds.TopicDescription.Ref_Access;
      Ret : constant Ref_Access := new Ref;
   begin
      Ret.Impl := Client_Impl.Create (Participant, Publisher, Topic_Name, Topic_Qos, Writer_QoS);
      return Ret;
   end Create;

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Publisher    : not null DDS.Publisher.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
      Topic_Qos  : DDS.TopicQos;
      Writer_QoS : DDS.DataWriterQos;
   begin

      Get_Datawriter_Qos (Writer_QoS, Topic_Name);
      Get_Topic_Qos (Topic_Qos, Topic_Name);
      return Create (Participant, Publisher, Topic_Name, Topic_Qos, Writer_QoS);
   end;

   -----------
   -- Write --
   -----------

   procedure Write (Self : not null access Ref; Data : Data_Type) is
      D : Octets;
   begin
      D.Length := Data'Size / Dds.Octet'Size;
      D.Value  := Data'Address;
      Self.Impl.Write (D);
   end Write;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out Ref_Access) is
      procedure Free is new Ada.Unchecked_Deallocation (Ref'Class, Ref_Access);
   begin
      Client_Impl.Finalize (Self.Impl);
      Free (Self);
   end Finalize;

end Dds.Mq.Simple_Messaging_Generic.Client_Generic;
