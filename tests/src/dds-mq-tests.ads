with Dds.Builtin_String_TypeSupport;
with Dds.Builtin_String_DataReader;
with Dds.Builtin_String_DataWriter;

with DDS.Mq.Messaging_Generic;
with DDS.Mq.Messaging_Generic.Client_Generic;
with DDS.Mq.Messaging_Generic.Server_Generic;

package DDS.Mq.Tests is

   package Messaging is new DDS.Mq.Messaging_Generic (Dds.Builtin_String_TypeSupport.Treats);

   package Server is new Messaging.Server_Generic (Dds.Builtin_String_DataReader);

   package Client is new Messaging.Client_Generic (Dds.Builtin_String_DataWriter);

   type Listner is new Server.Listners.Ref with  record
      null;
   end record;

   procedure On_Data (Self :  not null access Listner; Data : DDS.String);

end DDS.Mq.Tests;
