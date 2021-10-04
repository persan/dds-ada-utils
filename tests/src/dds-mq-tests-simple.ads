with DDS.Mq.Simple_Messaging_Generic.Client_Generic;

package DDS.Mq.Tests.Simple is

   type Message_Type is record
      Name_Last : Standard.Natural := 0;
      Name      : Standard.String (1 .. 2000);
   end record;

end DDS.Mq.Tests.Simple;
