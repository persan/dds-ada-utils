with DDS.DomainParticipant;
with DDS.Subscriber;
with DDS.Builtin_Octets_DataReader;
with Dds.Mq.Messaging_Generic.Server_Generic;

private with Ada.Unchecked_Conversion;
private with Ada.Finalization;
private with GNAT.Strings;

generic
package Dds.Mq.Simple_Messaging_Generic.Server_Generic is

   type Ref is limited new Simple_Messaging_Generic.Ref with private;
   type Ref_Access is access all Ref'Class;

   package Listners is

      type Ref is limited interface;

      type Ref_Access is access all Ref'Class;

      procedure On_Data (Self   : not null access Ref;
                         Reader : not null  Server_Generic.Ref_Access;
                         Data   : Data_Type) is abstract;
   end Listners;

   function Create
     (Listner      : Listners.Ref_Access;
      Topic_Name   : Dds.String;
      Queue_Lenght : Long := 10;
      Domain_Id    : DomainId_T := 0) return Ref_Access;

   function Create
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Queue_Lenght : Long := 10;
      Listner      : Listners.Ref_Access;
      Topic_Name   : Dds.String) return Ref_Access;

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
      return Ref_Access;

   function Create_With_Profile
     (Participant  : not null DDS.DomainParticipant.Ref_Access;
      Subscriber   : not null DDS.Subscriber.Ref_Access;
      Listner      : Listners.Ref_Access;
      Topic_Name   : DDS.String;
      Library_Name : DDS.String;
      Profile_Name : DDS.String) return Ref_Access;
   procedure Finalize (Self : in Ref_Access);
private
   package Server_Impl is new Messaging.Server_Generic (DDS.Builtin_Octets_DataReader);

   type Local_Listner is new Server_Impl.Listners.Ref with record
      Parent  : Ref_Access;
      Listner : Listners.Ref_Access;
   end record;

   overriding procedure On_Data (Self   : not null access Local_Listner;
                                 Reader : not null  Server_Impl.Ref_Access;
                                 Data   : DDS.Octets);

   type Ref is limited new Simple_Messaging_Generic.Ref with record
      Impl              : Server_Impl.Ref_Access;
      The_Local_Listner : aliased Local_Listner;
   end record;

end Dds.Mq.Simple_Messaging_Generic.Server_Generic;
