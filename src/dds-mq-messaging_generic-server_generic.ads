with DDS.DomainParticipant;
with DDS.StatusCondition;
with DDS.Subscriber;
with DDS.Treats_Generic;
with DDS.Typed_DataReader_Generic;

private with Ada.Finalization;
private with DDS.WaitSet;
private with GNAT.Strings;
private with DDS.GuardCondition;
---
generic
   with package Reader is new DDS.Typed_DataReader_Generic (Treats);
package Dds.Mq.Messaging_Generic.Server_Generic is

   type Ref is limited new Dds.Mq.Messaging_Generic.Ref with private;
   type Ref_Access is access all Ref'Class;

   package Listners is

      type Ref is limited interface;

      type Ref_Access is access all Ref'Class;

      procedure On_Data (Self   : not null access Ref;
                         Reader : not null  Server_Generic.Ref_Access;
                         Data   : Treats.Data_Type) is abstract;

      procedure On_Sample_Lost (Self   : not null access Ref;
                                Reader : not null  Server_Generic.Ref_Access;
                                Status : DDS.SampleLostStatus) is null;
   end Listners;

   function Create
     (Participant : not null DDS.DomainParticipant.Ref_Access;
      Listner     : Listners.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Reader_QoS  : DDS.DataReaderQos) return Ref_Access;

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access;

   function Create
     (Subscriber  : not null DDS.Subscriber.Ref_Access;
      Listner     : Listners.Ref_Access;
      Topic_Name  : DDS.String;
      Topic_QoS   : DDS.TopicQos;
      Reader_QoS  : DDS.DataReaderQos) return Ref_Access;

   function Create_With_Profile
     (Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access;

   function Create
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Topic_QoS    : DDS.TopicQos;
      Reader_QoS   : DDS.DataReaderQos)
      return Ref_Access with
     Pre =>
       (Subscriber.Get_Participant = Participant);

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access with
     Pre =>
       (Subscriber.Get_Participant = Participant);

   procedure Finalize (Self : in out Ref_Access);

   procedure Initialize
     (Self         : in out Ref;
      Participant  : not null DDS.DomainParticipant.Ref_Access;
      Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Topic_QoS    : DDS.TopicQos;
      Reader_QoS   : DDS.DataReaderQos) with
     Pre =>
       (Subscriber.Get_Participant = Participant);

   function Get_Subscriber (Self : not null access Ref) return DDS.Subscriber.Ref_Access;

   function Get_DataReader (Self : not null access Ref) return Reader.Ref_Access;

   function Get_Listner (Self : not null access Ref) return Listners.Ref_Access;

private
   task type Internal_Listner (Self : Ref_Access) is
      entry Start;
   end Internal_Listner;
   type Ref is limited new Dds.Mq.Messaging_Generic.Ref with record
      Subscriber       : DDS.Subscriber.Ref_Access;
      R                : Reader.Ref_Access;
      Internal_Listner : Server_Generic.Internal_Listner (Ref'Unchecked_Access);
      Listner          : Listners.Ref_Access;
      Continue         : Boolean := True;
      StatusCondition  : DDS.StatusCondition.Ref_Access;
      Guard            : aliased DDS.GuardCondition.Ref;
      WaitSet          : aliased DDS.WaitSet.Ref;
   end record;

end Dds.Mq.Messaging_Generic.Server_Generic;
