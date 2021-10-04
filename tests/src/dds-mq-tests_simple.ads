with Dds.Builtin_String_TypeSupport;
with Dds.Builtin_String_DataReader;
with Dds.Builtin_String_DataWriter;

with DDS.Mq.Simple_Messaging_Generic;
with DDS.Mq.Simple_Messaging_Generic.Client_Generic;
with DDS.Mq.Simple_Messaging_Generic.Server_Generic;

package DDS.Mq.Tests_Simple is

   type Message_Type is record
      Name_Last : Standard.Natural := 0;
      Name      : Standard.String (1 .. 2000);
   end record;

   package Messaging is new DDS.Mq.Simple_Messaging_Generic (Message_Type);

   package Server is new Messaging.Server_Generic;

   package Client is new Messaging.Client_Generic;

   type Ref is new Server.Listners.Ref with  null record;

   overriding procedure On_Data (Self :  not null access Ref; Data : Message_Type);
   Listner      : aliased Tests_Simple.Ref;
   Writer       : Client.Ref_Access;
   Reader       : Server.Ref_Access;
   Data         : Message_Type;

end DDS.Mq.Tests_Simple;
