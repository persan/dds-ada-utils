pragma Ada_2022;
with Ada.Text_IO;
package body DDS.Mq.Examples.Listners is
   use Ada.Text_IO;
   -------------
   -- On_Data --
   -------------

   procedure On_Data
     (Self   : not null access Ref;
      Reader : not null Messaging.Server.Ref_Access;
      Data   : DDS.String)
   is
   begin
      Put_Line (To_Standard_String (Data));
   end On_Data;

end DDS.Mq.Examples.Listners;
