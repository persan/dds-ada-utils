with DDS.DomainParticipant;
with DDS.Publisher;
with DDS.Treats_Generic;
with DDS.Typed_DataReader_Generic;
with DDS.Typed_DataWriter_Generic;

private with Ada.Finalization;

generic
   with package Writer is new DDS.Typed_DataWriter_Generic (Treats);
package Dds.Mq.Messaging_Generic.Client_Generic is

   type Ref is new Dds.Mq.Messaging_Generic.Ref with private;
   type Ref_Access is access all Ref'Class;

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
     (Publisher : not null DDS.Publisher.Ref_Access;
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
     Pre =>
       (Publisher.Get_Participant = Participant) and
       (Writer_QoS.Reliability.Kind /= DDS.RELIABLE_RELIABILITY_QOS);

   procedure Initialize
     (Self        : in out Ref;
      Participant : not null DDS.DomainParticipant.Ref_Access;
      Publisher   : not null DDS.Publisher.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Writer_QoS  : DDS.DataWriterQos) with
     Pre =>
       (Publisher.Get_Participant = Participant) and
       (Writer_QoS.Reliability.Kind /= DDS.RELIABLE_RELIABILITY_QOS);

   function Create_With_Profile
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Publisher   : not null DDS.Publisher.Ref_Access;
      Topic_Name  : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access with
     Pre =>
       (Publisher.Get_Participant = Participant);

   procedure Write (Self : not null access Ref; Data : Treats.Data_Type);
   procedure Finalize (Self : in out Ref_Access);

private
   type Ref is new Dds.Mq.Messaging_Generic.Ref with record
      W           : Writer.Ref_Access;
      Publisher   : DDS.Publisher.Ref_Access;
   end record;

end Dds.Mq.Messaging_Generic.Client_Generic;
