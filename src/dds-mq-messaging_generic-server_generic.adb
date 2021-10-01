pragma Ada_2012;
with Ada.Text_IO; use Ada.Text_IO;
with DDS.DataReader;
with DDS.DomainParticipantFactory;
with DDS.TopicDescription;
with DDS.ConditionSeq;
package body Dds.Mq.Messaging_Generic.Server_Generic is

   function Get_Subscriber (Self : not null access Ref) return DDS.Subscriber.Ref_Access is
   begin
      return Self.Subscriber;
   end;
   function Get_DataReader (Self : not null access Ref) return Reader.Ref_Access is
   begin
      return Self.R;
   end;

   function Get_Listner (Self : not null access Ref) return Listners.Ref_Access is
   begin
      return Self.Listner;
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
      return Create (Participant =>  Participant,
                     Subscriber  =>  Participant.Get_Implicit_Subscriber,
                     Listner     => Listner,
                     Topic_Name  =>  Topic_Name,
                     Topic_QoS   =>  Topic_QoS,
                     Reader_QoS  =>  Reader_QoS);
   end Create;

   -------------------------
   -- Create_With_Profile --
   -------------------------

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access
   is
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
      return Create (Subscriber.Get_Participant, Subscriber,  Listner, Topic_Name, Topic_QoS, Reader_QoS);
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
      Ret : constant Ref_Access := new Ref;
   begin
      Initialize (Ret.all, Participant, Subscriber, Listner, Topic_Name, Topic_Qos, Reader_QoS);
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
      Factory    : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;

   begin
      Factory.Get_DataReader_Qos_From_Profile_W_Topic_Name (Reader_QoS, Library_Name, Profile_Name, Topic_Name);
      Factory.Get_Topic_Qos_From_Profile_W_Topic_Name (Topic_Qos, Library_Name, Profile_Name, Topic_Name);
      return Create (Participant, Subscriber, Listner, Topic_Name, Topic_Qos, Reader_QoS);
   end;

   procedure Initialize
     (Self         : in out Ref;
      Participant  : not null DDS.DomainParticipant.Ref_Access;
      Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Topic_QoS    : DDS.TopicQos;
      Reader_QoS   : DDS.DataReaderQos) is
      use type Dds.Topic.Ref_Access;
      Td  : constant Dds.Topic.Ref_Access := Participant.Find_Topic (Topic_Name, To_Duration_T (0.1));

   begin
      Self.Participant := Participant;
      Self.Subscriber := Subscriber;
      Self.Listner := Listner;
      Self.Topic := (if Td /= null then Td else
                        Self.Participant.Create_Topic (Topic_Name => Topic_Name, Type_Name => Treats.Get_Type_Name, Qos => Topic_QoS));
      Self.R := Reader.Ref_Access (Self.Subscriber.Create_DataReader (Self.Topic.As_TopicDescription, Qos => Reader_QoS));
      Self.Internal_Listner.Start;
   end;
   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out Ref_Access) is
      procedure Free is new Ada.Unchecked_Deallocation (Ref'Class, Ref_Access);
   begin
      Self.Continue := False;
      Self.Subscriber.Delete_DataReader (DDS.DataReader.Ref_Access (Self.R));
      abort Self.Internal_Listner;
      Free (Self);
   end Finalize;

   task body Internal_Listner is
      Conditions : aliased DDS.ConditionSeq.Sequence;
   begin
      accept Start;
      Self.StatusCondition := Self.R.Get_StatusCondition;
      Self.StatusCondition.Set_Enabled_Statuses (DATA_AVAILABLE_STATUS);
      Self.Waitset.Attach_Condition (Self.StatusCondition);
      while Self.Continue loop
         begin
            Self.Waitset.Wait (Conditions'Access, 1.0);
            for I of Self.R.Take (Sample_States => NOT_READ_SAMPLE_STATE) loop
               if I.Sample_Info.Valid_Data then
                  Self.Listner.On_Data (I.Data.all);
               end if;
            end loop;
         exception
            when others =>
               null;
         end;
      end loop;

   end Internal_Listner;

end Dds.Mq.Messaging_Generic.Server_Generic;
