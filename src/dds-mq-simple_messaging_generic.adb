pragma Ada_2012;
package body Dds.Mq.Simple_Messaging_Generic is
   Default_Library_Name : constant DDS.String := To_DDS_String ("BuiltinQosLib");
   Default_Profile_Name : constant DDS.String := To_DDS_String ("Generic.StrictReliable.LowLatency");

   procedure Get_DomainParticipant_Qos
     (QoS  : in out DDS.DomainParticipantQos)  is
   begin
      Factory.Get_Participant_Qos_From_Profile
        (QoS          => QoS,
         Library_Name => Default_Library_Name,
         Profile_Name => Default_Profile_Name);
      Qos.Transport_Builtin.Mask := TRANSPORTBUILTIN_SHMEM;
   end;

   procedure Get_Topic_Qos (QoS  : in out DDS.TopicQos; Topic_Name : DDS.String)  is
   begin
      Factory.Get_Topic_Qos_From_Profile_W_Topic_Name
        (QoS          => QoS,
         Library_Name => Default_Library_Name,
         Profile_Name => Default_Profile_Name,
         Topic_Name   => Topic_Name);

   end;

   ------------------------
   -- Get_DataReader_Qos --
   ------------------------

   procedure Get_DataReader_Qos
     (QoS          : in out DDS.DataReaderQoS;
      Topic_Name   : DDS.String;
      Queue_Length : DDS.Long := 10)
   is
   begin
      Factory.Get_Datareader_Qos_From_Profile_W_Topic_Name
        (QoS          => QoS,
         Library_Name => Default_Library_Name,
         Profile_Name => Default_Profile_Name,
         Topic_Name   => Topic_Name);
      Qos.Reliability.Kind := DDS.RELIABLE_RELIABILITY_QOS;
      Qos.History.Kind := KEEP_ALL_HISTORY_QOS;
      Qos.History.Depth :=  Queue_Length;
      Qos.Resource_Limits.Max_Samples_Per_Instance := Queue_Length;
      Qos.Resource_Limits.Max_Samples := Queue_Length;
      Qos.Resource_Limits.Initial_Samples := Queue_Length;
   end Get_DataReader_Qos;

   procedure Get_DataWriter_Qos
     (QoS  : in out DDS.DataWriterQos; Topic_Name : DDS.String) is
   begin
      Factory.Get_Datawriter_Qos_From_Profile_W_Topic_Name
        (QoS          => QoS,
         Library_Name => Default_Library_Name,
         Profile_Name => Default_Profile_Name,
         Topic_Name   => Topic_Name);
      Qos.Reliability.Kind := DDS.RELIABLE_RELIABILITY_QOS;
      Qos.History.Depth := 1;
      Qos.Resource_Limits.Max_Samples := 2;
      Qos.Resource_Limits.Initial_Samples := 1;
      Qos.Resource_Limits.Max_Samples_Per_Instance := 2;
      QoS.Protocol.Rtps_Reliable_Writer.High_Watermark := 2;
      QoS.Protocol.Rtps_Reliable_Writer.Low_Watermark := 1;
      QoS.protocol.rtps_reliable_writer.Heartbeats_Per_Max_Samples := 1;
      QoS.Availability.Max_Data_Availability_Waiting_Time := To_Duration_T (0.1);
      QoS.Availability.Max_Endpoint_Availability_Waiting_Time := To_Duration_T (0.1);
   end;

end Dds.Mq.Simple_Messaging_Generic;
