pragma Ada_2012;
package body DDS.Mk4_Request_Response is

   function Create_Reply_Topic_Name (Self : Ref; Topic_Base_Name  : DDS.String) return DDS.String
   is
   begin
      return Ret : DDS.String do
         Copy (Ret, Topic_Base_Name);
         Append (Ret, "/reply");
      end return;
   end;

   function Create_Request_Topic_Name (Self : Ref; Topic_Base_Name  : DDS.String) return DDS.String
   is
   begin
      return Ret : DDS.String do
         Copy (Ret, Topic_Base_Name);
         Append (Ret, "/request");
      end return;
   end;

end DDS.Mk4_Request_Response;
