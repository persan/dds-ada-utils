pragma Ada_2012;
package body Dds.Mk4_Request_Response.Tests is

   --------------
   -- Copy_Key --
   --------------

   procedure Copy_Key (Target : out DDS.String; Src : DDS.KeyedString) is
   begin
      Dds.Copy (Target, Src.Key);
   end Copy_Key;

   --------------
   -- Copy_Key --
   --------------

   procedure Copy_Key (Target : out DDS.KeyedString; Src : DDS.String) is
   begin
      Dds.Copy (Target.Key, Src);
   end Copy_Key;

end Dds.Mk4_Request_Response.Tests;
