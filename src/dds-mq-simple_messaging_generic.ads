with Dds.Mq.Messaging_Generic;
with Dds.Builtin_Octets_TypeSupport;
with DDS.DomainParticipantFactory;
generic
   type Data_Type is private;
package Dds.Mq.Simple_Messaging_Generic is

   package Messaging is new DDS.Mq.Messaging_Generic (Dds.Builtin_Octets_TypeSupport.Treats);
   type Ref is new Messaging.Ref with null record;
   type Ref_Access is access all Ref'Class;

   procedure Get_DomainParticipant_Qos
     (QoS : in out DDS.DomainParticipantQos);

   procedure Get_Topic_Qos
     (QoS : in out DDS.TopicQos; Topic_Name : DDS.String);

   procedure Get_DataReader_Qos
     (QoS : in out DDS.DataReaderQoS;
      Topic_Name : DDS.String;
      Queue_Length : DDS.Long := 10);

   procedure Get_DataWriter_Qos
     (QoS : in out DDS.DataWriterQoS;
      Topic_Name : DDS.String);

   Default_Library_Name : constant DDS.String := To_DDS_String ("BuiltinQosLib");
   Default_Profile_Name : constant DDS.String := To_DDS_String ("Generic.StrictReliable.LowLatency");
--  Base Dfault QoS To use.

   Max_Data_Size        : constant := 2048;

pragma Compile_Time_Error (Data_Type'Size / DDS.octet'Size > Max_Data_Size, "Size of data exceeds max size");

private
   Factory : constant DDS.DomainParticipantFactory.Ref_Access :=
     DDS.DomainParticipantFactory.Get_Instance;

end Dds.Mq.Simple_Messaging_Generic;
