with Dds.Mq.Messaging_Generic;
with Dds.Builtin_Octets_TypeSupport;
with DDS.DomainParticipantFactory;
generic
   type Data_Type is private;
   Max_Data_Size : in DDS.Long := 2048;
package Dds.Mq.Simple_Messaging_Generic is

   package Messaging is new DDS.Mq.Messaging_Generic (Dds.Builtin_Octets_TypeSupport.Treats);
   type Ref is new Messaging.Ref with null record;
   type Ref_Access is access all Ref'Class;

   Default_Library_Name : constant DDS.String := To_DDS_String ("BuiltinQosLib");
   Default_Profile_Name : constant DDS.String := To_DDS_String ("Generic.StrictReliable.LowLatency");
   --  Base Dfault QoS To use.

   procedure Get_DomainParticipant_Qos
     (QoS : in out DDS.DomainParticipantQos);
   --
   --  Get a default DomainParticipantQos based on the default capable
   --  of handling Max_Data_Size large data_types and
   --  only ShardMemory Enabled as transport.
   --  -------------------------------------------------------------------------

   procedure Get_Topic_Qos
     (QoS : in out DDS.TopicQos; Topic_Name : DDS.String);
   --
   --  Get a default TopicQos based on the default.
   -----------------------------------------------------------------------------

   procedure Get_DataReader_Qos
     (QoS          : in out DDS.DataReaderQoS;
      Topic_Name   : DDS.String;
      Queue_Length : DDS.Long := 10);
   --
   --  Get a default DataReaderQoS based on the default with
   --   HistoryQueue length set to Queue_Length
   -----------------------------------------------------------------------------

   procedure Get_DataWriter_Qos
     (QoS        : in out DDS.DataWriterQoS;
      Topic_Name : DDS.String);
   --
   --  Get a default DataWriterQoS based on the default with
   --   HistoryQueue length set to 1.
   --  -------------------------------------------------------------------------

   pragma Compile_Time_Error (Data_Type'Size / DDS.Octet'Size > Max_Data_Size, "Size of data exceeds max size");

private
   Factory              : constant DDS.DomainParticipantFactory.Ref_Access :=
                            DDS.DomainParticipantFactory.Get_Instance;

end Dds.Mq.Simple_Messaging_Generic;
