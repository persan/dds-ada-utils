with Dds.Builtin_KeyedString_DataReader;
with Dds.Builtin_KeyedString_DataWriter;
with Dds.Mk4_Request_Response.Requester_Generic;
with Dds.Mk4_Request_Response.Responder_Generic;
package Dds.Mk4_Request_Response.Tests is

   procedure Copy_Key (Target : out DDS.String; Src : DDS.KeyedString);
   procedure Copy_Key (Target : out DDS.KeyedString; Src : DDS.String);

   package Responder is new Dds.Mk4_Request_Response.Responder_Generic
     (DDS.String,
      Request_Reader => Dds.Builtin_KeyedString_DataReader,
      Reply_Writer   => Dds.Builtin_KeyedString_DataWriter);

   package Requester is new Dds.Mk4_Request_Response.Requester_Generic
     (Key_Type       => Dds.String,
      Reply_Reader   => Dds.Builtin_KeyedString_DataReader,
      Request_Writer => Dds.Builtin_KeyedString_DataWriter);

end Dds.Mk4_Request_Response.Tests;
