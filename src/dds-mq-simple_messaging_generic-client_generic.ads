with DDS.DomainParticipant;
with DDS.Publisher;

private with DDS.Builtin_Octets_TypeSupport;
private with DDS.Builtin_Octets_DataReader;
with DDS.Builtin_Octets_DataWriter;
with DDS.Mq.Messaging_Generic.Client_Generic;

generic package Dds.Mq.Simple_Messaging_Generic.Client_Generic is

   type Ref (<>) is new Simple_Messaging_Generic.Ref with private;
   type Ref_Access is access all Ref'Class;

   function Create
     (Topic_Name  : Dds.String;
      Domain_Id   : DomainId_T := 0) return Ref_Access;
   --  Creates a participant using SHMEM transport only.
   ----------------------------------------------------

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Topic_Name  : Dds.String) return Ref_Access;
   --  Creates Topic and Writer with default QoS:es and
   --  a send queue length of 1.
   -- --------------------------------------------------------

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Topic_Name  : Dds.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos) return Ref_Access;

   function Create_With_Profile
     (Participant   : not null DDS.DomainParticipant.Ref_Access;
      Topic_Name    : Dds.String;
      Library_Name  : DDS.String;
      Profile_Name  : DDS.String) return Ref_Access;

   function Create
     (Publisher   : not null DDS.Publisher.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos) return Ref_Access;

   function Create_With_Profile
     (Publisher    : not null DDS.Publisher.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access;

   function Create (Participant : not null DDS.DomainParticipant.Ref_Access;
                    Publisher   : not null DDS.Publisher.Ref_Access;
                    Topic_Name  : DDS.String;
                    Topic_QoS   : DDS.TopicQos;
                    Writer_QoS  : DDS.DataWriterQos) return Ref_Access with
     Pre => (Publisher.Get_Participant = Participant);

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Publisher    : not null DDS.Publisher.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access with
     Pre => (Publisher.Get_Participant = Participant);

   procedure Write (Self : not null access Ref; Data : Data_Type);
   procedure Finalize (Self : in out Ref_Access);

private
   package Client_Impl is new Messaging.Client_Generic (DDS.Builtin_Octets_DataWriter);

   type Ref is new Simple_Messaging_Generic.Ref with  record
      Impl : Client_Impl.Ref_Access;
   end record;
end Dds.Mq.Simple_Messaging_Generic.Client_Generic;
