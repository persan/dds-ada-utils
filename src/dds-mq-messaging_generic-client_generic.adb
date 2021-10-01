pragma Ada_2012;
with DDS.DataWriter;
with DDS.TopicDescription;
with Dds.DomainParticipantFactory;
package body Dds.Mq.Messaging_Generic.Client_Generic is

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
     (Publisher : not null DDS.Publisher.Ref_Access;
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
      Ret : constant Ref_Access := new Ref;
   begin
      Ret.all.Initialize (Participant, Publisher, Topic_Name, Topic_Qos, Writer_QoS);
      return Ret;
   end Create;

   procedure Initialize
     (Self        : in out Ref;
      Participant : not null DDS.DomainParticipant.Ref_Access;
      Publisher   : not null DDS.Publisher.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos) is

      use type Dds.TopicDescription.Ref_Access;
      Td  : constant Dds.TopicDescription.Ref_Access := Participant.Lookup_Topicdescription (Topic_Name);

   begin

      Self.Participant := Participant;
      Self.Publisher := Publisher;

      Self.Topic := (if Td /= null then Topic.Ref_Access (Td) else
                       Self.Participant.Create_Topic (Topic_Name => Topic_Name, Type_Name => Treats.Get_Type_Name, Qos => Topic_QoS));
      Self.W := Writer.Ref_Access (Self.Publisher.Create_DataWriter (Self.Topic, Qos => Writer_QoS));

   end;

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Publisher    : not null DDS.Publisher.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
      Topic_Qos : DDS.TopicQos;
      Writer_QoS : DDS.DataWriterQos;
      Factory  : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;

   begin
      Factory.Get_Datawriter_Qos_From_Profile_W_Topic_Name (Writer_QoS, Library_Name, Profile_Name, Topic_Name);
      Factory.Get_Topic_Qos_From_Profile_W_Topic_Name (Topic_Qos, Library_Name, Profile_Name, Topic_Name);
      return Create (Participant, Publisher, Topic_Name, Topic_Qos, Writer_QoS);
   end;

   -----------
   -- Write --
   -----------

   procedure Write (Self : not null access Ref; Data : Treats.Data_Type) is
   begin
      Self.W.Write (Data, Dds.Null_InstanceHandle_T);
   end Write;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out Ref_Access) is
      procedure Free is new Ada.Unchecked_Deallocation (Ref'Class, Ref_Access);
   begin
      Self.Publisher.Delete_DataWriter (DDS.DataWriter.Ref_Access (Self.W));
      Free (Self);
   end Finalize;

end Dds.Mq.Messaging_Generic.Client_Generic;
