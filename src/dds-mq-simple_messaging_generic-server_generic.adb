pragma Ada_2012;
with DDS.DataReader;
with DDS.DomainParticipantFactory;
with DDS.TopicDescription;
package body Dds.Mq.Simple_Messaging_Generic.Server_Generic is
   type Data_Type_Access is access all Data_Type;
   function As_Data_Type is new Ada.Unchecked_Conversion (System.Address, Data_Type_Access);

   use type DDS.DomainParticipant.Ref_Access;
   function Create
     (Listner      : Listners.Ref_Access;
      Topic_Name   : Dds.String;
      Queue_Lenght : Long := 10;
      Domain_Id    : DomainId_T := 0) return Ref_Access
   is
      Participant : DDS.DomainParticipant.Ref_Access;
      QoS         : DDS.DomainParticipantQos;
   begin
      Get_DomainParticipant_Qos (QoS);
      Participant := Factory.Create_Participant (Domain_Id, QoS);
      return Create (Participant, Queue_Lenght, Listner, Topic_Name);
   end;

   function Create
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Queue_Lenght : Long := 10;
      Listner      : Listners.Ref_Access;
      Topic_Name   : Dds.String) return Ref_Access is
      Topic_QoS   : DDS.TopicQos;
      Reader_QoS  : DDS.DataReaderQoS;
   begin
      Get_Topic_Qos (Topic_QoS, Topic_Name);
      Get_DataReader_Qos (Reader_QoS, Topic_Name);
      return Create (Participant  => Participant,
                     Listner      => Listner,
                     Topic_Name   => Topic_Name,
                     Topic_QoS    => Topic_QoS,
                     Reader_QoS   => Reader_QoS);
   end;

   ------------
   -- Create --
   ------------

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Listner     : Listners.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Reader_QoS  : DDS.DataReaderQos)
      return Ref_Access
   is
   begin
      return Create (Participant => Participant,
                     Subscriber  => Participant.Get_Implicit_Subscriber,
                     Listner     => Listner,
                     Topic_Name  => Topic_Name,
                     Topic_QoS   => Topic_QoS,
                     Reader_QoS  => Reader_QoS);

   end Create;

   -------------------------
   -- Create_With_Profile --
   -------------------------

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access is
   begin
      return Create_With_Profile (Participant, Participant.Get_Implicit_Subscriber, Listner, Topic_Name, Library_Name, Profile_Name);
   end Create_With_Profile;

   ------------
   -- Create --
   ------------

   function Create
     (Subscriber  : not null DDS.Subscriber.Ref_Access;
      Listner     : Listners.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Reader_QoS  : DDS.DataReaderQos) return Ref_Access
   is
   begin
      return Create (Participant =>  Subscriber.Get_Participant,
                     Subscriber  =>  Subscriber,
                     Listner     =>  Listner,
                     Topic_Name  =>  Topic_Name,
                     Topic_QoS   =>  Topic_QoS,
                     Reader_QoS  =>  Reader_QoS);
   end Create;

   -------------------------
   -- Create_With_Profile --
   -------------------------

   function Create_With_Profile
     (Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
   begin
      return Create_With_Profile (Subscriber.Get_Participant, Subscriber, Listner, Topic_Name, Library_Name, Profile_Name);
   end Create_With_Profile;
   ------------
   -- Create --
   ------------

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Subscriber  : not null DDS.Subscriber.Ref_Access;
      Listner     : Listners.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Reader_QoS  : DDS.DataReaderQos)
      return Ref_Access
   is
      Ret : Ref_Access;
   begin
      Ret := new Ref;
      Ret.Impl :=  Server_Impl.Create (Participant => Participant,
                                       Subscriber  => Subscriber,
                                       Listner     => Ret.The_Local_Listner'Unchecked_Access,
                                       Topic_Name  => Topic_Name,
                                       Topic_QoS   => Topic_QoS,
                                       Reader_QoS  => Reader_QoS);
      Ret.The_Local_Listner.Listner := Listner;
      return Ret;
   end Create;

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
      Topic_Qos  : DDS.TopicQos;
      Reader_QoS : DDS.DataReaderQoS;

   begin
      Factory.Get_DataReader_Qos_From_Profile_W_Topic_Name (Reader_QoS, Library_Name, Profile_Name, Topic_Name);
      Factory.Get_Topic_Qos_From_Profile_W_Topic_Name (Topic_Qos, Library_Name, Profile_Name, Topic_Name);
      return Create (Participant, Subscriber, Listner, Topic_Name, Topic_Qos, Reader_QoS);
   end;

   procedure On_Data (Self : not null access Local_Listner;
                      Data : DDS.Octets) is
   begin
      Self.Listner.On_Data (As_Data_Type (Data.Value).all);
   end;
   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in Ref_Access) is
   begin
      Server_Impl.Finalize (Self.Impl);
   end Finalize;

end Dds.Mq.Simple_Messaging_Generic.Server_Generic;
