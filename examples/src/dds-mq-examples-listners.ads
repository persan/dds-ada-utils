with DDS.Mq.Examples.Messaging.Server;
package DDS.Mq.Examples.Listners is

   type Ref is new Messaging.Server.Listners.Ref with record
      null;
   end record;
   type Ref_Access is access all Ref'Class;

   procedure On_Data (Self   : not null access Ref;
                      Reader : not null Messaging.Server.Ref_Access;
                      Data   : DDS.String);

end DDS.Mq.Examples.Listners;
