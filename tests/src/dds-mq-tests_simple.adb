pragma Ada_2022;
with Ada.Text_IO;
package body DDS.Mq.Tests_Simple is
   use Ada.Text_IO;

   -------------
   -- On_Data --
   -------------

   overriding procedure On_Data
     (Self : not null access Ref; Data : Message_Type)
   is
   begin
      Put_Line (Data'Img);
      delay 2.0;
   end On_Data;

end DDS.Mq.Tests_Simple;
