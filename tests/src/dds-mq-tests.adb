pragma Ada_2022;
with Ada.Text_IO;
package body DDS.Mq.Tests is
   use Ada.Text_IO;
   -------------
   -- On_Data --
   -------------

   procedure On_Data (Self : not null access Listner; Data : DDS.String) is
   begin
      Put_Line (To_Standard_String (Data));
   end On_Data;

end DDS.Mq.tests;
