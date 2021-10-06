with Ada.Unchecked_Deallocation;
with DDS.DomainParticipant;
with DDS.Publisher;
with DDS.Subscriber;
with DDS.Topic;
with DDS.Typed_DataReader_Generic;
with DDS.Typed_DataWriter_Generic;

-----------------------------------

generic
   type Key_Type is limited private;
   with package Request_Reader is new DDS.Typed_DataReader_Generic (<>);
   with package Reply_Writer   is new DDS.Typed_DataWriter_Generic (<>);
   with procedure Copy_Key (Target : out Key_Type; Src : Request_Reader.Treats.Data_Type) is <>;
   with procedure Copy_Key (Target : out Reply_Writer.Treats.Data_Type; Src : Key_Type) is <>;
package Dds.Mk4_Request_Response.Responder_Generic is
   type Ref is limited  new Dds.Mk4_Request_Response.Ref with private;
   type Ref_Access is access all Ref'Class;

   package Listners is
      type Ref is limited  interface;
      type Ref_Access is access all Ref'Class;
      procedure On_Request (Self    : not null access Ref;
                            Request : Request_Reader.Treats.Data_Type;
                            Replay  : Reply_Writer.Treats.Data_Type) is abstract;
   end Listners;

   function Create (Participant        : not null DDS.DomainParticipant.Ref_Access;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    Publisher          : DDS.Publisher.Ref_Access;
                    Subscriber         : DDS.Subscriber.Ref_Access;
                    Request_Topic_Qos  : Dds.TopicQos;
                    Request_Reader_QoS : DDS.DataReaderQoS;
                    Reply_Topic_Qos    : Dds.TopicQos;
                    Reply_Writer_QoS   : DDS.DataWriterQos) return Ref_Access;

   function Create (Participant        : not null DDS.DomainParticipant.Ref_Access;
                    Request_Topic_Name : DDS.String;
                    Reply_Topic_Name   : DDS.String;
                    Request_Topic_Qos  : Dds.TopicQos;
                    Request_Reader_QoS : DDS.DataReaderQoS;
                    Reply_Topic_Qos    : Dds.TopicQos;
                    Reply_Writer_QoS   : DDS.DataWriterQos) return Ref_Access;

   function Create (Participant        : not null DDS.DomainParticipant.Ref_Access;
                    Topic_Base_Name    : DDS.String;
                    Publisher          : DDS.Publisher.Ref_Access;
                    Subscriber         : DDS.Subscriber.Ref_Access;
                    Request_Topic_Qos  : Dds.TopicQos;
                    Request_Reader_QoS : DDS.DataReaderQoS;
                    Reply_Topic_Qos    : Dds.TopicQos;
                    Reply_Writer_QoS   : DDS.DataWriterQos) return Ref_Access;

   function Create (Participant        : not null DDS.DomainParticipant.Ref_Access;
                    Topic_Base_Name    : DDS.String;
                    Request_Topic_Qos  : Dds.TopicQos;
                    Request_Reader_QoS : DDS.DataReaderQoS;
                    Reply_Topic_Qos    : Dds.TopicQos;
                    Reply_Writer_QoS   : DDS.DataWriterQos) return Ref_Access;

   function Create (Participant      : not null DDS.DomainParticipant.Ref_Access;
                    Topic_Base_Name  : DDS.String;
                    Publisher        : DDS.Publisher.Ref_Access;
                    Subscriber       : DDS.Subscriber.Ref_Access;
                    Library          : DDS.String;
                    Profile          : DDS.String) return Ref_Access;

   function Create (Participant      : not null DDS.DomainParticipant.Ref_Access;
                    Topic_Base_Name  : DDS.String;
                    Library          : DDS.String;
                    Profile          : DDS.String) return Ref_Access;

   procedure Finalize (S : in out Ref_Access);

private
   type Ref is limited  new Dds.Mk4_Request_Response.Ref with record
      Participant        : DDS.DomainParticipant.Ref_Access;
      Request_Topic      : DDS.Topic.Ref_Access;
      Reply_Topic        : DDS.Topic.Ref_Access;
      Publisher          : DDS.Publisher.Ref_Access;
      Subscriber         : DDS.Subscriber.Ref_Access;
      Reader             : Request_Reader.Ref_Access;
      Writer             : Reply_Writer.Ref_Access;
      Key                : Key_Type;
      Request_Topic_Name : DDS.String;
      Reply_Topic_Name   : DDS.String;
   end record;
   procedure Free is new Ada.Unchecked_Deallocation (Ref'Class, Ref_Access);

end Dds.Mk4_Request_Response.Responder_Generic;
