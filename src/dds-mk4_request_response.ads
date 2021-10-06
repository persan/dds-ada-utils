generic
   with package Reply_Treats is new DDS.Treats_Generic (<>);
   with package Request_Treates is new DDS.Treats_Generic (<>);

package DDS.Mk4_Request_Response is
   type Ref is tagged limited null record;
   type Ref_Access is access all Ref'Class;
   function Create_Reply_Topic_Name (Self : Ref; Topic_Base_Name  : DDS.String) return DDS.String;
   function Create_Request_Topic_Name (Self : Ref; Topic_Base_Name  : DDS.String) return DDS.String;
end DDS.Mk4_Request_Response;
